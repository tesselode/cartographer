local cartographer = {}

local function getCoordinates(n, w)
	return (n - 1) % w, math.floor((n - 1) / w)
end

local Map = {}
Map.__index = Map

function Map:init(options)
	for _, tileset in ipairs(self.tilesets) do
		tileset._image = options.tilesets[tileset.name]
		assert(tileset._image)
	end
	for _, layer in ipairs(self.layers) do
		if layer.type == 'tilelayer' then
			self:_renderTileLayer(layer)
		end
	end
end

function Map:_getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		if gid >= self.tilesets[i].firstgid then
			return self.tilesets[i]
		end
	end
end

function Map:_getTile(gid)
	local tileset = self:_getTileset(gid)
	local x, y = getCoordinates(gid - tileset.firstgid + 1,
		tileset._image:getWidth() / tileset.tilewidth)
	return love.graphics.newQuad(x * tileset.tilewidth,
		y * tileset.tileheight, tileset.tilewidth, tileset.tileheight,
		tileset._image:getWidth(), tileset._image:getHeight())
end

function Map:_renderTileLayer(layer)
	layer._canvas = love.graphics.newCanvas(layer.width * self.tilewidth,
		layer.height * self.tileheight)
	layer._canvas:renderTo(function()
		love.graphics.setColor(255, 255, 255)
		for n, gid in ipairs(layer.data) do
			if gid ~= 0 then
				local x, y = getCoordinates(n, layer.width)
				local tileset = self:_getTileset(gid)
				love.graphics.draw(tileset._image, self:_getTile(gid),
					x * self.tilewidth, y * self.tileheight)
			end
		end
	end)
end

function Map:getLayer(name)
	for _, layer in ipairs(self.layers) do
		if layer.name == name then
			return layer
		end
	end
	return false
end

function Map:getTileLayers()
	local i = 0
	return function()
		while i < #self.layers do
			i = i + 1
			if self.layers[i].type == 'tilelayer' then
				return self.layers[i]
			end
		end
	end
end

function Map:getObjectLayers()
	local i = 0
	return function()
		while i < #self.layers do
			i = i + 1
			if self.layers[i].type == 'objectgroup' then
				return self.layers[i]
			end
		end
	end
end

function Map:drawTileLayer(layer, x, y)
	layer = type(layer) == 'string' and self:getLayer(layer) or layer
	assert(layer, 'layer does not exist')
	assert(layer.type == 'tilelayer', 'not a tile layer')
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(layer._canvas, x, y)
end

function cartographer.load(options)
	local map = options.map
	setmetatable(map, {__index = Map})
	map:init(options)
	return map
end

return cartographer