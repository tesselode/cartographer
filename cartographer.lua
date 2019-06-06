local cartographer = {}

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
