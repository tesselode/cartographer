# Cartographer

Cartographer is a small library for loading Tiled maps in LÖVE. It provides simple functionality for drawing layers, and it provides a couple of generally useful shortcuts for using Tiled maps.

## Installation

To use Cartographer, place cartographer.lua in your project, and then add this code to your main.lua:

```lua
cartographer = require 'cartographer' -- if your cartographer.lua is in the root directory
cartographer = require 'path.to.cartographer' -- if it's in subfolders
```

## Usage

### Loading a map

```lua
map = cartographer.load(path)
```

Loads a Tiled map in Lua format.
- `path` - the path to the map to load.

### Drawing the entire map

```lua
map:draw()
```

### Updating the map

```lua
map:update(dt)
```

You only need to do this if your map has animated tiles.

### Accessing layers by name

```lua
map.layers[name]
```

While you can access layers by numerical index as usual, Cartographer allows you to access layers by name as well.

### Drawing individual layers

```lua
map.layers[name]:draw()
```

### Getting the size of the map in pixels

```lua
local width = map:getPixelWidth()
local height = map:getPixelHeight()
```

### Iterating over every object in the map

```lua
for layer, object, ... in map:getObjects(fields) do
	...
end
```

Cartographer lets you iterate through every object in the map using a for loop. The optional `fields` argument lets you specify properties to return for each object. For example, if you wanted to iterate over each object and also easily access its name and position, you could do this:

```lua
for layer, object, n, x, y in map:getObjects {'name', 'x', 'y'} do
	print(layer, object, n, x, y)
end
```