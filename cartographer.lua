local cartographer = {
	_VERSION = 'Cartographer v2.0',
	_DESCRIPTION = 'Simple Tiled map loading for LÖVE.',
	_URL = 'https://github.com/tesselode/cartographer',
	_LICENSE = [[
		MIT License

		Copyright (c) 2019 Andrew Minnich

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

-- Represents a tileset in an exported Tiled map.
local Tileset = {}
Tileset.__index = Tileset

function Tileset:_init(map)
	self._map = map
	if self.image then
		local image = self._map._images[self.image]
		-- save the number of tiles per row so we don't have to calculate it later
		self._tilesPerRow = math.floor(image:getWidth() / (self.tilewidth + self.spacing))
	end
end

-- Gets the tile with the specified global id.
function Tileset:_getTile(gid)
	for _, tile in ipairs(self.tiles) do
		if self.firstgid + tile.id == gid then
			return tile
		end
	end
end

--[[
	Gets the image and optionally quad of the tile with the specified global id.
	If the tileset is a collection of images, then each tile has its own image,
	so it'll just return the image. If the tileset is one image with a grid
	that defines the individual tiles, then it'll also return the quad for the
	specific tile.

	If the tile is animated, then it'll return the correct tile for the current
	animation frame (defaults to 1).
]]
function Tileset:_getTileImageAndQuad(gid, frame)
	frame = frame or 1
	local tile = self:_getTile(gid)
	if tile and tile.animation then
		-- get the appropriate frame for animated tiles
		local currentFrameGid = self.firstgid + tile.animation[frame].tileid
		if currentFrameGid ~= gid then
			return self:_getTileImageAndQuad(currentFrameGid, frame)
		end
	end
	if tile and tile.image then
		-- if each tile has its own image, just return that image
		return self._map._images[tile.image]
	elseif self.image then
		-- return the tileset image and the quad representing the specific tile
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

--[[
	Represents any layer type that can contain tiles
	(currently tile layers and object layers).
	There's no layer type in Tiled called "item layers",
	it's just a parent class to share code between
	tile layers and object layers.
]]
Layer.itemlayer = {}
Layer.itemlayer.__index = Layer.itemlayer

-- Starts timers for each animated tile in the map.
function Layer.itemlayer:_initAnimations()
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

-- Creates sprite batches for each single-image tileset.
function Layer.itemlayer:_createSpriteBatches()
	self._spriteBatches = {}
	for _, tileset in ipairs(self._map.tilesets) do
		if tileset.image then
			local image = self._map._images[tileset.image]
			self._spriteBatches[image] = love.graphics.newSpriteBatch(image)
		end
	end
end

-- Gets the number of items to draw. This is a placeholder, since the behavior
-- is specific to tile and object layers.
function Layer.itemlayer:_getNumberOfItems() end

-- Gets the global id, x position, and y position of a tile.
-- This is a placeholder, since the behavior is specific to tile and object layers.
-- Can return false if there's no item to draw at this index.
function Layer.itemlayer:_getItem(i) end

-- Renders the layer to sprite batches. Only tiles that are part
-- of a single-image tileset are batched.
function Layer.itemlayer:_fillSpriteBatches()
	for i = 1, self:_getNumberOfItems() do
		local gid, x, y = self:_getItem(i)
		if gid and x and y then
			local tileset = self._map:_getTileset(gid)
			if tileset.image then
				local image, quad = tileset:_getTileImageAndQuad(gid)
				local id = self._spriteBatches[image]:add(quad, x, y)
				-- save information about sprites that will be affected by animations,
				-- since we'll have to update them later
				if self._animations[tileset][gid] then
					table.insert(self._animations[tileset][gid].sprites, {
						id = id,
						x = x,
						y = y,
					})
				end
			else
				-- remember which items aren't part of a sprite batch
				-- so we can iterate through them in layer.draw
				table.insert(self._unbatchedItems, {
					gid = gid,
					x = x,
					y = y,
				})
			end
		end
	end
end

function Layer.itemlayer:_init(map)
	self._map = map
	self._unbatchedItems = {}
	self:_initAnimations()
	self:_createSpriteBatches()
	self:_fillSpriteBatches()
end

-- Updates the animation timers and changes sprites in the sprite batches as needed.
function Layer.itemlayer:_updateAnimations(dt)
	for tileset, tilesetAnimations in pairs(self._animations) do
		for gid, animation in pairs(tilesetAnimations) do
			-- decrement the animation timer
			animation.timer = animation.timer - 1000 * dt
			while animation.timer <= 0 do
				-- move to then next frame of animation
				animation.frame = animation.frame + 1
				if animation.frame > #animation.frames then
					animation.frame = 1
				end
				-- increment the animation timer by the duration of the new frame
				animation.timer = animation.timer + animation.frames[animation.frame].duration
				-- update sprites
				if tileset.image then
					local image, quad = tileset:_getTileImageAndQuad(gid, animation.frame)
					--[[
						in _fillSpriteBatches we save the id, x position, and y position of sprites
						in the sprite batch that need to be updated because of animations.
						here we iterate through them and change the quad.
					]]
					for _, sprite in ipairs(animation.sprites) do
						self._spriteBatches[image]:set(sprite.id, quad, sprite.x, sprite.y)
					end
				end
			end
		end
	end
end

function Layer.itemlayer:update(dt)
	self:_updateAnimations(dt)
end

function Layer.itemlayer:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
	-- draw the sprite batches
	for _, spriteBatch in pairs(self._spriteBatches) do
		love.graphics.draw(spriteBatch)
	end
	-- draw the items that aren't part of a sprite batch
	for _, item in ipairs(self._unbatchedItems) do
		local tileset = self._map:_getTileset(item.gid)
		local frame = 1
		if self._animations[tileset][item.gid] then
			frame = self._animations[tileset][item.gid].frame
		end
		local image = tileset:_getTileImageAndQuad(item.gid, frame)
		love.graphics.draw(image, item.x, item.y)
	end
	love.graphics.pop()
end

-- Represents a tile layer in an exported Tiled map.
Layer.tilelayer = setmetatable({}, {__index = Layer.itemlayer})
Layer.tilelayer.__index = Layer.tilelayer

-- Gets the x and y position of the nth tile in the layer's tile data.
function Layer.tilelayer:_getTilePosition(n, width, offsetX, offsetY)
	width = width or self.width
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local x, y = getCoordinates(n, width)
	x, y = x + offsetX, y + offsetY
	x, y = x * self._map.tilewidth, y * self._map.tileheight
	x, y = x + self.offsetx, y + self.offsety
	return x, y
end

function Layer.tilelayer:_getNumberOfItems()
	-- for infinite maps, get the total number of items split up among all the chunks
	if self.chunks then
		local items = 0
		for _, chunk in ipairs(self.chunks) do
			items = items + #chunk.data
		end
		return items
	end
	-- otherwise, just get the length of the data
	return #self.data
end

function Layer.tilelayer:_getItem(i)
	--[[
		for infinite maps, treat all the chunk data like one big array
		each chunk has its own row width and x/y offset, which we factor
		into the position of each sprite on the screen
	]]
	if self.chunks then
		for _, chunk in ipairs(self.chunks) do
			if i <= #chunk.data then
				local gid = chunk.data[i]
				if gid ~= 0 then
					local x, y = self:_getTilePosition(i, chunk.width, chunk.x, chunk.y)
					return gid, x, y
				end
				return false
			end
			i = i - #chunk.data
		end
	end
	local gid = self.data[i]
	if gid ~= 0 then
		local x, y = self:_getTilePosition(i)
		return gid, x, y
	end
	return false
end

-- Represents an object layer in an exported Tiled map.
Layer.objectgroup = setmetatable({}, {__index = Layer.itemlayer})
Layer.objectgroup.__index = Layer.objectgroup

function Layer.objectgroup:_getNumberOfItems()
	return #self.objects
end

function Layer.objectgroup:_getItem(i)
	local object = self.objects[i]
	-- tile objects are anchored at the bottom
	return object.gid, object.x, object.y - object.height
end

-- Represents an image layer in an exported Tiled map.
Layer.imagelayer = {}
Layer.imagelayer.__index = Layer.imagelayer

function Layer.imagelayer:_init(map)
	self._map = map
end

function Layer.imagelayer:draw()
	love.graphics.draw(self._map._images[self.image], self.offsetx, self.offsety)
end

-- Represents a layer group in an exported Tiled map.
Layer.group = {}
Layer.group.__index = Layer.group

function Layer.group:_init(map)
	for _, layer in ipairs(self.layers) do
		setmetatable(layer, Layer[layer.type])
		layer:_init(map)
	end
	setmetatable(self.layers, LayerList)
end

function Layer.group:update(dt)
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

-- Represents an exported Tiled map.
local Map = {}
Map.__index = Map

-- Loads an image if it hasn't already been loaded yet.
-- Images are stored in map._images, and the key is the relative
-- path to the image.
function Map:_loadImage(relativeImagePath)
	if self._images[relativeImagePath] then return end
	local imagePath = formatPath(self.dir .. relativeImagePath)
	self._images[relativeImagePath] = love.graphics.newImage(imagePath)
end

-- Loads all of the images used by the map.
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

-- Gets the tileset the tile with the specified global id belongs to.
function Map:_getTileset(gid)
	for i = #self.tilesets, 1, -1 do
		if gid >= self.tilesets[i].firstgid then
			return self.tilesets[i]
		end
	end
end

-- Gets the tile with the specified global id.
function Map:_getTile(gid)
	return self:_getTileset(gid):_getTile(gid)
end

-- Gets the type of the specified tile, if it exists.
function Map:getTileType(gid)
	local tile = self:_getTile(gid)
	return tile and tile.type
end

-- Gets the value of the specified property on the specified tile, if it exists.
function Map:getTileProperty(gid, propertyName)
	local tile = self:_getTile(gid)
	return tile and tile.properties and tile.properties[propertyName] or false
end

function Map:update(dt)
	for _, layer in ipairs(self.layers) do
		if layer.update then layer:update(dt) end
	end
end

function Map:drawBackground()
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
	self:drawBackground()
	for _, layer in ipairs(self.layers) do
		if layer.visible and layer.draw then layer:draw() end
	end
end

-- Loads a Tiled map from a lua file.
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
