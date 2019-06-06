local cartographer = {}

-- given a grid with w items per row, return the column and row of the nth item
-- (going from left to right, top to bottom)
-- https://stackoverflow.com/a/9816217
local function indexToCoordinates(n, w)
	return (n - 1) % w, math.floor((n - 1) / w)
end

local function coordinatesToIndex(x, y, w)
	return x + w * y + 1
end


local getByNameMetatable = {
	__index = function(self, key)
		for _, item in ipairs(self) do
			if item.name == key then return item end
		end
		return rawget(self, key)
	end,
}

local function getLayer(self, ...)
	local numberOfArguments = select('#', ...)
	if numberOfArguments == 0 then
		error('must specify at least one layer name', 2)
	end
	local layer
	local layerName = select(1, ...)
	if not self.layers[layerName] then return end
	layer = self.layers[layerName]
	for i = 2, numberOfArguments do
		layerName = select(i, ...)
		if not (layer.layers and layer.layers[layerName]) then return end
		layer = layer.layers[layerName]
	end
	return layer
end

-- Represents a tileset in an exported Tiled map.
local Tileset = {}
Tileset.__index = Tileset

-- Gets the info table for a tile with the given local ID, if it exists.
function Tileset:getTile(id)
	for _, tile in ipairs(self.tiles) do
		if tile.id == id then return tile end
	end
end

-- Gets the value of the specified property on the tile
-- with the given local ID, if it exists.
function Tileset:getTileProperty(id, propertyName)
	local tile = self:getTile(id)
	if not tile then return end
	if not tile.properties then return end
	return tile.properties[propertyName]
end

-- Sets the value of the specified property on the tile
-- with the given local ID.
function Tileset:setTileProperty(id, propertyName, propertyValue)
	local tile = self:getTile(id)
	if not tile then
		tile = {id = id}
		table.insert(self.tiles, tile)
	end
	tile.properties = tile.properties or {}
	tile.properties[propertyName] = propertyValue
end

local Layer = {}

-- A common class for all layer types.
Layer.base = {}
Layer.base.__index = Layer.base

function Layer.base:_init(map)
	self.map = map
end

-- Converts grid coordinates to pixel coordinates for this layer.
function Layer.base:gridToPixel(x, y)
	x, y = x * self.map.tilewidth, y * self.map.tileheight
	x, y = x + self.offsetx, y + self.offsety
	return x, y
end

-- Converts pixel coordinates for this layer to grid coordinates.
function Layer.base:pixelToGrid(x, y)
	x, y = x - self.offsetx, y - self.offsety
	x, y = x / self.map.tilewidth, y / self.map.tileheight
	x, y = math.floor(x), math.floor(y)
	return x, y
end

-- Represents a tile layer in an exported Tiled map.
Layer.tilelayer = setmetatable({}, Layer.base)
Layer.tilelayer.__index = Layer.tilelayer

function Layer.tilelayer:getGridBounds()
	if self.chunks then
		local left, top, right, bottom
		for _, chunk in ipairs(self.chunks) do
			local chunkLeft = chunk.x
			local chunkTop = chunk.y
			local chunkRight = chunk.x + chunk.width - 1
			local chunkBottom = chunk.y + chunk.height - 1
			if not left or chunkLeft < left then left = chunkLeft end
			if not top or chunkTop < top then top = chunkTop end
			if not right or chunkRight > right then right = chunkRight end
			if not bottom or chunkBottom > bottom then bottom = chunkBottom end
		end
		return left, top, right, bottom
	end
	return self.x, self.y, self.x + self.width - 1, self.y + self.height - 1
end

function Layer.tilelayer:getPixelBounds()
	local left, top, right, bottom = self:getGridBounds()
	left, top = self:gridToPixel(left, top)
	right, bottom = self:gridToPixel(right, bottom)
	return left, top, right, bottom
end

function Layer.tilelayer:getTileAtGridPosition(x, y)
	if self.chunks then
		for _, chunk in ipairs(self.chunks) do
			local pointInChunk = x >= chunk.x
							 and x < chunk.x + chunk.width
							 and y >= chunk.y
							 and y < chunk.y + chunk.height
			if pointInChunk then
				return chunk.data[coordinatesToIndex(x - chunk.x, y - chunk.y, chunk.width)]
			end
		end
	else
		return self.data[coordinatesToIndex(x, y, self.width)]
	end
end

function Layer.tilelayer:getTileAtPixelPosition(x, y)
	return self:getTileAtGridPosition(self:pixelToGrid(x, y))
end

function Layer.tilelayer:_getTileAtIndex(index)
	-- for infinite maps, treat all the chunk data like one big array
	if self.chunks then
		for _, chunk in ipairs(self.chunks) do
			if index <= #chunk.data then
				local gid = chunk.data[index]
				local gridX, gridY = indexToCoordinates(index, self.width)
				gridX, gridY = gridX + chunk.x, gridY + chunk.y
				local pixelX, pixelY = self:gridToPixel(gridX, gridY)
				return gid, gridX, gridY, pixelX, pixelY
			else
				index = index - #chunk.data
			end
		end
	elseif self.data[index] then
		local gid = self.data[index]
		local gridX, gridY = indexToCoordinates(index, self.width)
		local pixelX, pixelY = self:gridToPixel(gridX, gridY)
		return gid, gridX, gridY, pixelX, pixelY
	end
end

function Layer.tilelayer:_tileIterator(i)
	while true do
		i = i + 1
		local gid, gridX, gridY, pixelX, pixelY = self:_getTileAtIndex(i)
		if not gid then break end
		if gid ~= 0 then return i, gid, gridX, gridY, pixelX, pixelY end
	end
end

function Layer.tilelayer:getTiles()
	return self._tileIterator, self, 0
end

-- Represents an object layer in an exported Tiled map.
Layer.objectgroup = setmetatable({}, Layer.base)
Layer.objectgroup.__index = Layer.objectgroup

-- Represents an image layer in an exported Tiled map.
Layer.imagelayer = setmetatable({}, Layer.base)
Layer.imagelayer.__index = Layer.imagelayer

-- Represents a layer group in an exported Tiled map.
Layer.group = setmetatable({}, Layer.base)
Layer.group.__index = Layer.group

function Layer.group:_init(map)
	Layer.base._init(self, map)
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer:_init(map)
	end
	setmetatable(self.layers, getByNameMetatable)
end

Layer.group.getLayer = getLayer

local Map = {}
Map.__index = Map

function Map:_initTilesets()
	for _, tileset in ipairs(self.tilesets) do
		setmetatable(tileset, Tileset)
	end
	setmetatable(self.tilesets, getByNameMetatable)
end

function Map:_initLayers()
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer:_init(self)
	end
	setmetatable(self.layers, getByNameMetatable)
end

function Map:_init()
	self:_initTilesets()
	self:_initLayers()
end

-- Gets the tileset that has the tile with the given global ID.
function Map:getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		local tileset = self.tilesets[i]
		if tileset.firstgid <= gid then
			return tileset
		end
	end
end

-- Gets the data table for the tile with the given global ID, if it exists.
function Map:getTile(gid)
	local tileset = self:getTileset(gid)
	return tileset:getTile(gid - tileset.firstgid)
end

-- Gets the value of the specified property on the tile
-- with the given global ID, if it exists.
function Map:getTileProperty(gid, propertyName)
	local tileset = self:getTileset(gid)
	return tileset:getTileProperty(gid - tileset.firstgid, propertyName)
end

-- Sets the value of the specified property on the tile
-- with the given global ID.
function Map:setTileProperty(gid, propertyName, propertyValue)
	local tileset = self:getTileset(gid)
	return tileset:setTileProperty(gid - tileset.firstgid, propertyName, propertyValue)
end

Map.getLayer = getLayer

-- Loads a Tiled map from a lua file.
function cartographer.load(path)
	if not path then error('No map path provided', 2) end
	local map = setmetatable(love.filesystem.load(path)(), Map)
	map:_init()
	return map
end

return cartographer
