local cartographer = {
	_VERSION = 'Cartographer',
	_DESCRIPTION = 'Simple Tiled map loading for LÖVE.',
	_URL = 'https://github.com/tesselode/cartographer',
	_LICENSE = [[
		MIT License

		Copyright (c) 2017 Andrew Minnich

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	]]
}

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

function Layer.tilelayer:_init()
	self._spriteBatches = {}
	for _, tileset in ipairs(self._map.tilesets) do
		self._spriteBatches[tileset._image] = love.graphics.newSpriteBatch(tileset._image, #self.data)
	end
	for n, gid in ipairs(self.data) do
		if gid ~= 0 then
			local x, y = getCoordinates(n, self.width)
			local image, q = self._map:_getTile(gid)
			self._spriteBatches[image]:add(q,
				x * self._map.tilewidth, y * self._map.tileheight)
		end
	end
end

function Layer.tilelayer:draw()
	love.graphics.setColor(1, 1, 1)
	for _, spriteBatch in pairs(self._spriteBatches) do
		love.graphics.draw(spriteBatch)
	end
end

Layer.imagelayer = {}
Layer.imagelayer.__index = Layer.imagelayer

function Layer.imagelayer:_init()
	local path = formatPath(self._map.dir .. self.image)
	self._image = love.graphics.newImage(path)
end

function Layer.imagelayer:draw()
	love.graphics.draw(self._image)
end

Layer.objectgroup = {}
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:_init() end

function Layer.objectgroup:draw() end

Layer.group = {}
Layer.group.__index = Layer.group

function Layer.group:_init()
	for _, layer in ipairs(self.layers) do
		self.layers[layer.name] = layer
		setmetatable(layer, Layer[layer.type])
		layer._map = self._map
		layer:_init()
	end
end

function Layer.group:draw()
	for _, layer in ipairs(self.layers) do
		layer:draw()
	end
end

local Map = {}
Map.__index = Map

function Map:_init(path)
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
		layer:_init()
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

function Map:draw()
	if self.backgroundcolor then
		love.graphics.setColor(self.backgroundcolor)
		love.graphics.rectangle('fill', 0, 0,
			self.width * self.tilewidth, self.height * self.tileheight)
	end
	for _, layer in ipairs(self.layers) do
		layer:draw()
	end
end

function cartographer.load(path)
	local map = love.filesystem.load(path)()
	setmetatable(map, Map)
	map:_init(path)
	return map
end

return cartographer