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
	local ts = self:_getTileset(gid)
	local x, y = getCoordinates(gid - ts.firstgid + 1,
		ts._image:getWidth() / ts.tilewidth)
	local q = love.graphics.newQuad(x * ts.tilewidth, y * ts.tileheight,
		ts.tilewidth, ts.tileheight,
		ts._image:getWidth(), ts._image:getHeight())
	return ts._image, q
end

function Map:_renderTileLayer(layer)
	layer._canvas = love.graphics.newCanvas(layer.width * self.tilewidth,
		layer.height * self.tileheight)
	layer._canvas:renderTo(function()
		love.graphics.setColor(255, 255, 255)
		for n, gid in ipairs(layer.data) do
			if gid ~= 0 then
				local x, y = getCoordinates(n, layer.width)
				local image, q = self:_getTile(gid)
				love.graphics.draw(image, q,
					x * self.tilewidth, y * self.tileheight)
			end
		end
	end)
end

function Map:getLayer(name)
	for _, layer in ipairs(self.layers) do
		if layer.name == name then return layer end
	end
	return false
end

function Map:drawTileLayer(layer, ...)
	layer = type(layer) == 'string' and self:getLayer(layer) or layer
	assert(layer, 'layer does not exist')
	assert(layer.type == 'tilelayer', 'not a tile layer')
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(layer._canvas, ...)
end

function cartographer.load(options)
	local map = options.map
	setmetatable(map, {__index = Map})
	map:init(options)
	return map
end

return cartographer