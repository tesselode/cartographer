local cartographer = {}

-- https://stackoverflow.com/a/12191225
local function splitPath(path)
    return string.match(path, '(.-)([^\\/]-%.?([^%.\\/]*))$')
end

-- https://github.com/karai17/Simple-Tiled-Implementation/blob/master/sti/utils.lua#L5
local function formatPath(path)
	local npGen1, npGen2 = '[^SEP]+SEP%.%.SEP?', 'SEP+%.?SEP'
	local npPat1, npPat2 = npGen1:gsub('SEP', '/'), npGen2:gsub('SEP', '/')
	local k
	repeat path, k = path:gsub(npPat2, '/') until k == 0
	repeat path, k = path:gsub(npPat1, '') until k == 0
	if path == '' then path = '.' end
	return path
end

-- https://stackoverflow.com/a/9816217
local function getCoordinates(n, w)
	return (n - 1) % w, math.floor((n - 1) / w)
end

local Layer = {}

Layer.tilelayer = {}
Layer.tilelayer.__index = Layer.tilelayer

function Layer.tilelayer:init()
	self._map:_renderTileLayer(self)
end

function Layer.tilelayer:draw(...)
	love.graphics.draw(self._canvas, ...)
end

Layer.imagelayer = {}
Layer.imagelayer.__index = Layer.imagelayer

function Layer.imagelayer:init()
	local path = formatPath(self._map.dir .. self.image)
	self._image = love.graphics.newImage(path)
end

function Layer.imagelayer:draw(...)
	love.graphics.draw(self._image, ...)
end

Layer.objectgroup = {}
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:init() end

function Layer.objectgroup:draw() end

local Map = {}
Map.__index = Map

function Map:init(path)
	self.dir = splitPath(path)
	self:_loadTilesetImages()
	self:_initLayers()
end

function Map:_loadTilesetImages()
	for _, tileset in ipairs(self.tilesets) do
		local path = formatPath(self.dir .. tileset.image)
		tileset._image = love.graphics.newImage(path)
	end
end

function Map:_initLayers()
	for _, layer in ipairs(self.layers) do
		self.layers[layer.name] = layer
		setmetatable(layer, Layer[layer.type])
		layer._map = self
		layer:init()
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

function cartographer.load(path)
	local map = love.filesystem.load(path)()
	setmetatable(map, Map)
	map:init(path)
	return map
end

return cartographer