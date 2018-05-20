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
				changed = false,
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
		animation.changed = false
		animation.timer = animation.timer - 1000 * dt
		while animation.timer <= 0 do
			animation.currentFrame = animation.currentFrame + 1
			if animation.currentFrame > #animation.frames then
				animation.currentFrame = 1
			end
			animation.timer = animation.timer + animation.frames[animation.currentFrame].duration
			animation.changed = true
		end
	end
end

function Tileset:_getQuad(gid)
	if self._animations[gid] then
		local a = self._animations[gid]
		gid = a.frames[a.currentFrame].tileid + 1
	end
	local x, y = getCoordinates(gid - self.firstgid + 1,
		self._image:getWidth() / self.tilewidth)
	local quad = love.graphics.newQuad(x * self.tilewidth, y * self.tileheight,
		self.tilewidth, self.tileheight,
		self._image:getWidth(), self._image:getHeight())
	return quad
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

function Layer.tilelayer:_createSpriteBatches()
	self._spriteBatches = {}
	self._animatedTiles = {}
	for _, tileset in pairs(self._map.tilesets) do
		self._spriteBatches[tileset] = love.graphics.newSpriteBatch(tileset._image)
		self._animatedTiles[tileset] = {}
	end
end

function Layer.tilelayer:_rememberAnimatedTile(tileset, gid, sprite, x, y)
	self._animatedTiles[tileset][gid] = self._animatedTiles[tileset][gid] or {}
	table.insert(self._animatedTiles[tileset][gid], {
		sprite = sprite,
		x = x,
		y = y,
	})
end

function Layer.tilelayer:_fillSpriteBatches(data, ox, oy, width)
	data = data or self.data
	ox = ox or 0
	oy = oy or 0
	width = width or self.width
	if data then
		for n, gid in ipairs(data) do
			if gid ~= 0 then
				local tileset = self._map:_getTileset(gid)
				local q = tileset:_getQuad(gid)
				local x, y = getCoordinates(n, width)
				x, y = x + ox, y + oy
				x, y = x * self._map.tilewidth, y * self._map.tileheight
				local sprite = self._spriteBatches[tileset]:add(q, x, y)
				if tileset._animations[gid] then
					self:_rememberAnimatedTile(tileset, gid, sprite, x, y)
				end
			end
		end
	elseif self.chunks then
		for _, chunk in ipairs(self.chunks) do
			self:_fillSpriteBatches(chunk.data, chunk.x, chunk.y, chunk.width)
		end
	end
end

function Layer.tilelayer:_init()
	self:_createSpriteBatches()
	self:_fillSpriteBatches()
end

function Layer.tilelayer:_updateAnimatedTiles()
	for tileset, spriteBatch in pairs(self._spriteBatches) do
		for gid, animation in pairs(tileset._animations) do
			if self._animatedTiles[tileset][gid] and animation.changed then
				for _, tile in pairs(self._animatedTiles[tileset][gid]) do
					local q = tileset:_getQuad(gid)
					spriteBatch:set(tile.sprite, q, tile.x, tile.y)
				end
			end
		end
	end
end

function Layer.tilelayer:_update(dt)
	self:_updateAnimatedTiles()
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

function Layer.imagelayer:_update(dt) end

function Layer.imagelayer:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self._image)
end

Layer.objectgroup = {}
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:_init() end

function Layer.objectgroup:_update(dt) end

function Layer.objectgroup:draw() end

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

function Layer.group:_update(dt) end

function Layer.group:draw()
	for _, layer in ipairs(self.layers) do
		if layer.visible then
			layer:draw()
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
	for _, layer in ipairs(self.layers) do
		layer:_update(dt)
	end
end

function Map:draw()
	self:_drawBackground()
	for _, layer in ipairs(self.layers) do
		if layer.visible then
			layer:draw()
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