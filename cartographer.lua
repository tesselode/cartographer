local cartographer = {
	_VERSION = 'Cartographer',
	_DESCRIPTION = 'Simple Tiled map loading for LÖVE.',
	_URL = 'https://github.com/tesselode/cartographer',
	_LICENSE = [[
		MIT License

		Copyright (c) 2018 Andrew Minnich

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

local Tileset = {}
Tileset.__index = Tileset

function Tileset:_initAnimations()
	self._animations = {}
	for _, tile in ipairs(self.tiles) do
		if tile.animation then
			self._animations[tile.id + 1] = {
				frames = tile.animation,
				currentFrame = 1,
				timer = tile.animation[1].duration,
			}
		end
	end
end

function Tileset:_init()
	local path = formatPath(self._map.dir .. self.image)
	self._image = love.graphics.newImage(path)
	self:_initAnimations()
end

function Tileset:_update(dt)
	for _, animation in pairs(self._animations) do
		animation.timer = animation.timer - 1000 * dt
		while animation.timer <= 0 do
			animation.currentFrame = animation.currentFrame + 1
			if animation.currentFrame > #animation.frames then
				animation.currentFrame = 1
			end
			animation.timer = animation.timer + animation.frames[animation.currentFrame].duration
		end
	end
end

function Tileset:_getTile(gid)
	if self._animations[gid] then
		local a = self._animations[gid]
		gid = a.frames[a.currentFrame].tileid + 1
	end
	local x, y = getCoordinates(gid - self.firstgid + 1,
		self._image:getWidth() / self.tilewidth)
	local q = love.graphics.newQuad(x * self.tilewidth, y * self.tileheight,
		self.tilewidth, self.tileheight,
		self._image:getWidth(), self._image:getHeight())
	return self._image, q
end

local LayerList = {
	__index = function(self, k)
		for _, layer in ipairs(self) do
			if layer.name == k then return layer end
		end
		return rawget(self, k)
	end,
}

local Layer = {}

Layer.tilelayer = {}
Layer.tilelayer.__index = Layer.tilelayer

function Layer.tilelayer:_init() end

function Layer.tilelayer:_isTileVisible(tileX, tileY, x, y, w, h)
	if not (x and y and w and h) then return true end
	local tw, th = self._map.tilewidth, self._map.tileheight
	local tx, ty = tileX * tw, tileY * th
	return tx + tw > x
	   and ty + th > y
	   and tx < x + w
	   and ty < y + h
end

function Layer.tilelayer:draw(x, y, w, h)
	love.graphics.setColor(1, 1, 1)
	for n, gid in ipairs(self.data) do
		if gid ~= 0 then
			local tileX, tileY = getCoordinates(n, self.width)
			if self:_isTileVisible(tileX, tileY, x, y, w, h) then
				local image, q = self._map:_getTile(gid)
				love.graphics.draw(image, q, tileX * self._map.tilewidth,
					tileY * self._map.tileheight)
			end
		end
	end
end

Layer.imagelayer = {}
Layer.imagelayer.__index = Layer.imagelayer

function Layer.imagelayer:_init()
	local path = formatPath(self._map.dir .. self.image)
	self._image = love.graphics.newImage(path)
end

function Layer.imagelayer:draw(x, y, w, h)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self._image)
end

Layer.objectgroup = {}
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:_init() end

function Layer.objectgroup:draw(x, y, w, h) end

Layer.group = {}
Layer.group.__index = Layer.group

function Layer.group:_init()
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer._map = self._map
		layer:_init()
	end
	setmetatable(self.layers, LayerList)
end

function Layer.group:draw(x, y, w, h)
	for _, layer in ipairs(self.layers) do
		if layer.visible then
			layer:draw(x, y, w, h)
		end
	end
end

local Map = {}
Map.__index = Map

function Map:_init(path)
	self.dir = splitPath(path)
	self:_initTilesets()
	self:_initLayers()
end

function Map:_initTilesets()
	for _, tileset in ipairs(self.tilesets) do
		setmetatable(tileset, Tileset)
		tileset._map = self
		tileset:_init()
	end
end

function Map:_initLayers()
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer._map = self
		layer:_init()
	end
	setmetatable(self.layers, LayerList)
end

function Map:_getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		if gid >= self.tilesets[i].firstgid then
			return self.tilesets[i]
		end
	end
end

function Map:_getTile(gid)
	return self:_getTileset(gid):_getTile(gid)
end

function Map:_drawBackground()
	if self.backgroundcolor then
		local r = self.backgroundcolor[1] / 255
		local g = self.backgroundcolor[2] / 255
		local b = self.backgroundcolor[3] / 255
		love.graphics.setColor(r, g, b)
		love.graphics.rectangle('fill', 0, 0,
			self:getPixelWidth(), self:getPixelHeight())
	end
end

function Map:getPixelWidth()
	return self.width * self.tilewidth
end

function Map:getPixelHeight()
	return self.height * self.tileheight
end

function Map:update(dt)
	for _, tileset in ipairs(self.tilesets) do
		tileset:_update(dt)
	end
end

function Map:draw(x, y, w, h)
	self:_drawBackground()
	for _, layer in ipairs(self.layers) do
		if layer.visible then
			layer:draw(x, y, w, h)
		end
	end
end

function cartographer.load(path)
	local map = love.filesystem.load(path)()
	setmetatable(map, Map)
	map:_init(path)
	return map
end

return cartographer