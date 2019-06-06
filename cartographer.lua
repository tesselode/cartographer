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

local Map = {}
Map.__index = Map

function Map:_initTilesets()
	for _, tileset in ipairs(self.tilesets) do
		setmetatable(tileset, Tileset)
	end
	setmetatable(self.tilesets, getByNameMetatable)
end

function Map:_init()
	self:_initTilesets()
	setmetatable(self.layers, getByNameMetatable)
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
