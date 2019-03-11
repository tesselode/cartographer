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

-- splits a path into directory, file (with filename), and just filename
-- i really only need the directory
-- https://stackoverflow.com/a/12191225
local function splitPath(path)
    return string.match(path, '(.-)([^\\/]-%.?([^%.\\/]*))$')
end

-- joins two paths together into a reasonable path that Lua can use.
-- handles going up a directory using ..
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

-- given a grid with w items per row, return the column and row of the nth item
-- (going from left to right, top to bottom)
-- https://stackoverflow.com/a/9816217
local function getCoordinates(n, w)
	return (n - 1) % w, math.floor((n - 1) / w)
end

local Tileset = {}
Tileset.__index = Tileset

function Tileset:_init(map)
	self._map = map
	if self.image then
		local image = self._map._images[self.image]
		self._tilesPerRow = math.floor(image:getWidth() / (self.tilewidth + self.spacing))
	end
end

function Tileset:_getTile(gid)
	for _, tile in ipairs(self.tiles) do
		if self.firstgid + tile.id == gid then
			return tile
		end
	end
end

function Tileset:_getTileImageAndQuad(gid, frame)
	frame = frame or 1
	local tile = self:_getTile(gid)
	if tile and tile.animation then
		local currentFrameGid = self.firstgid + tile.animation[frame].tileid
		if currentFrameGid ~= gid then
			return self:_getTileImageAndQuad(currentFrameGid, frame)
		end
	end
	if tile and tile.image then
		return self._map._images[tile.image]
	elseif self.image then
		local image = self._map._images[self.image]
		local x, y = getCoordinates(gid - self.firstgid + 1, self._tilesPerRow)
		local quad = love.graphics.newQuad(
			x * (self.tilewidth + self.spacing),
			y * (self.tileheight + self.spacing),
			self.tilewidth, self.tileheight,
			image:getWidth(), image:getHeight())
		return image, quad
	else
		return false
	end
end

-- this metatable is applied to map.layers so that layers can be accessed
-- by name
local LayerList = {
	__index = function(self, k)
		for _, layer in ipairs(self) do
			if layer.name == k then return layer end
		end
		return rawget(self, k)
	end,
}

local Layer = {}

Layer.drawable = {}
Layer.drawable.__index = Layer.drawable

function Layer.drawable:_initAnimations()
	self._animations = {}
	for _, tileset in ipairs(self._map.tilesets) do
		self._animations[tileset] = {}
		for _, tile in ipairs(tileset.tiles) do
			if tile.animation then
				local gid = tileset.firstgid + tile.id
				self._animations[tileset][gid] = {
					frames = tile.animation,
					frame = 1,
					timer = tile.animation[1].duration,
					sprites = {},
				}
			end
		end
	end
end

function Layer.drawable:_createSpriteBatches()
	self._spriteBatches = {}
	for _, tileset in ipairs(self._map.tilesets) do
		if tileset.image then
			local image = self._map._images[tileset.image]
			self._spriteBatches[image] = love.graphics.newSpriteBatch(image)
		end
	end
end

function Layer.drawable:_fillSpriteBatches() end

function Layer.drawable:_init(map)
	self._map = map
	self:_initAnimations()
	self:_createSpriteBatches()
	self:_fillSpriteBatches()
end

function Layer.drawable:_updateAnimations(dt)
	for tileset, tilesetAnimations in pairs(self._animations) do
		for gid, animation in pairs(tilesetAnimations) do
			animation.timer = animation.timer - 1000 * dt
			while animation.timer <= 0 do
				animation.frame = animation.frame + 1
				if animation.frame > #animation.frames then
					animation.frame = 1
				end
				animation.timer = animation.timer + animation.frames[animation.frame].duration
				if tileset.image then
					local image, quad = tileset:_getTileImageAndQuad(gid, animation.frame)
					for _, sprite in ipairs(animation.sprites) do
						self._spriteBatches[image]:set(sprite.id, quad, sprite.x, sprite.y)
					end
				end
			end
		end
	end
end

function Layer.drawable:update(dt)
	self:_updateAnimations(dt)
end

function Layer.drawable:_drawSpriteBatches()
	for _, spriteBatch in pairs(self._spriteBatches) do
		love.graphics.draw(spriteBatch)
	end
end

function Layer.drawable:draw() end

Layer.tilelayer = setmetatable({}, {__index = Layer.drawable})
Layer.tilelayer.__index = Layer.tilelayer

function Layer.tilelayer:_getTilePosition(n)
	local x, y = getCoordinates(n, self.width)
	x, y = x * self._map.tilewidth, y * self._map.tileheight
	x, y = x + self.offsetx, y + self.offsety
	return x, y
end

function Layer.tilelayer:_fillSpriteBatches()
	for n, gid in ipairs(self.data) do
		if gid ~= 0 then
			local tileset = self._map:_getTileset(gid)
			if tileset.image then
				local image, quad = tileset:_getTileImageAndQuad(gid)
				local x, y = self:_getTilePosition(n)
				local id = self._spriteBatches[image]:add(quad, x, y)
				if self._animations[tileset][gid] then
					table.insert(self._animations[tileset][gid].sprites, {
						id = id,
						x = x,
						y = y,
					})
				end
			end
		end
	end
end

function Layer.tilelayer:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
	self:_drawSpriteBatches()
	for n, gid in ipairs(self.data) do
		if gid ~= 0 then
			local tileset = self._map:_getTileset(gid)
			if not tileset.image then
				local frame = 1
				if self._animations[tileset][gid] then
					frame = self._animations[tileset][gid].frame
				end
				local image = tileset:_getTileImageAndQuad(gid, frame)
				love.graphics.draw(image, self:_getTilePosition(n))
			end
		end
	end
	love.graphics.pop()
end

Layer.objectgroup = setmetatable({}, {__index = Layer.drawable})
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:_fillSpriteBatches()
	for _, object in ipairs(self.objects) do
		if object.gid and object.visible then
			local tileset = self._map:_getTileset(object.gid)
			if tileset.image then
				local image, quad = tileset:_getTileImageAndQuad(object.gid)
				local x, y = object.x, object.y - object.height
				local id = self._spriteBatches[image]:add(quad, x, y)
				if self._animations[tileset][object.gid] then
					table.insert(self._animations[tileset][object.gid].sprites, {
						id = id,
						x = x,
						y = y,
					})
				end
			end
		end
	end
end

function Layer.objectgroup:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
	self:_drawSpriteBatches()
	for _, object in ipairs(self.objects) do
		if object.gid and object.visible then
			local tileset = self._map:_getTileset(object.gid)
			if not tileset.image then
				local frame = 1
				if self._animations[tileset][object.gid] then
					frame = self._animations[tileset][object.gid].frame
				end
				local image = tileset:_getTileImageAndQuad(object.gid, frame)
				love.graphics.draw(image, object.x, object.y - object.height)
			end
		end
	end
	love.graphics.pop()
end

Layer.imagelayer = {}
Layer.imagelayer.__index = Layer.imagelayer

function Layer.imagelayer:_init(map)
	self._map = map
end

function Layer.imagelayer:draw()
	love.graphics.draw(self._map._images[self.image], self.offsetx, self.offsety)
end

Layer.group = {}
Layer.group.__index = Layer.group

function Layer.group:_init(map)
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer:_init(map)
	end
	setmetatable(self.layers, LayerList)
end

function Layer.group:_update(dt)
	for _, layer in ipairs(self.layers) do
		if layer.update then layer:update(dt) end
	end
end

function Layer.group:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
	for _, layer in ipairs(self.layers) do
		if layer.visible and layer.draw then layer:draw() end
	end
	love.graphics.pop()
end

local Map = {}
Map.__index = Map

function Map:_loadImage(relativeImagePath)
	if self._images[relativeImagePath] then return end
	local imagePath = formatPath(self.dir .. relativeImagePath)
	self._images[relativeImagePath] = love.graphics.newImage(imagePath)
end

function Map:_loadImages()
	self._images = {}
	for _, tileset in ipairs(self.tilesets) do
		if tileset.image then self:_loadImage(tileset.image) end
		for _, tile in ipairs(tileset.tiles) do
			if tile.image then self:_loadImage(tile.image) end
		end
	end
	for _, layer in ipairs(self.layers) do
		if layer.type == 'imagelayer' then
			self:_loadImage(layer.image)
		end
	end
end

function Map:_initTilesets()
	for _, tileset in ipairs(self.tilesets) do
		setmetatable(tileset, Tileset)
		tileset:_init(self)
	end
end

function Map:_initLayers()
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		if layer._init then layer:_init(self) end
	end
	setmetatable(self.layers, LayerList)
end

function Map:_init(path)
	self.dir = splitPath(path)
	self:_loadImages()
	self:_initTilesets()
	self:_initLayers()
end

function Map:_getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		if gid >= self.tilesets[i].firstgid then
			return self.tilesets[i]
		end
	end
end

function Map:update(dt)
	for _, layer in ipairs(self.layers) do
		if layer.update then layer:update(dt) end
	end
end

function Map:_drawBackground()
	if self.backgroundcolor then
		local r = self.backgroundcolor[1] / 255
		local g = self.backgroundcolor[2] / 255
		local b = self.backgroundcolor[3] / 255
		love.graphics.setColor(r, g, b)
		love.graphics.rectangle('fill', 0, 0,
			self.width * self.tilewidth,
			self.height * self.tileheight)
	end
end

function Map:draw()
	self:_drawBackground()
	for _, layer in ipairs(self.layers) do
		if layer.visible and layer.draw then layer:draw() end
	end
end

function cartographer.load(path)
	if not path then
		error('No map path provided', 2)
	end
	local ok, chunk = pcall(love.filesystem.load, path)
	if not ok then
		error('Error loading map from path: ' .. tostring(chunk), 2)
	end
	if not chunk then
		error('Could not find path: ' .. path, 2)
	end
	local map = chunk()
	setmetatable(map, Map)
	map:_init(path)
	return map
end

return cartographer
