# Cartographer
Cartographer is a small library for loading, reading, and drawing Tiled maps in LÖVE. It draws tile layers and tile objects, and it has various utilities to make parsing Tiled maps easier.

### [Documentation](https://tesselode.github.io/cartographer/)

## Usage example
```lua
local cartographer = require 'cartographer'

-- load a map
local map = cartographer.load 'path/to/exported/map.lua'
-- get a layer by name
local terrain = map.layers.terrain
-- get a tile at a position
local gid = terrain:getTileAtGridPosition(32, 32)
-- check a tile property
local solid = map:getTileProperty(gid, 'solid')

function love.update(dt)
	-- update animations
	map:update(dt)
end

function love.draw()
	-- draw the whole map
	map:draw()
	-- draw an individual layer
	map.layers.terrain:draw()
end

```

## Installation
To use Cartographer, place cartographer.lua in your project, and then add this code to your main.lua:
```lua
cartographer = require 'cartographer' -- if your cartographer.lua is in the root directory
cartographer = require 'path.to.cartographer' -- if it's in subfolders
```

## Feature support
Supported:
- Drawing CSV and Base64-formatted tile layers
- Drawing tile objects
- Animated tiles
- Layer offsets
- Infinite maps

Not supported:
- Drawing Zstandard-compressed tile layers
- Isometic and hexagonal maps

## Contributing
Feel free to open issues and send pull requests. I'm open to bug fixes and new features!
