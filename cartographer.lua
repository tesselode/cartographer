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
end

function Map:_init(path)
	self.dir = splitPath(path)
	self:_loadImages()
end

function Map:update(dt) end

function Map:draw() end

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
