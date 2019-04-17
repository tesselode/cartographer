# Cartographer
Cartographer is a small library for loading and drawing Tiled maps in LÖVE. It's geared towards drawing tile layers and cosmetic object layers.

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
Loads a Tiled map exported as a Lua file from the specified `path`. The returned map object is the same as the table you'd get from loading the .lua file normally, just wrapped with some extra features.

### Drawing the entire map
```lua
map:draw()
```

### Drawing just the map's background color
```lua
map:drawBackground()
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
While you can access layers by numerical index as usual, Cartographer allows you to access layers by name as well. This also works for layer groups; for example:
```lua
map.layers.myGroup.layers.myLayer
```

### Updating and drawing individual layers
```lua
map.layers[name]:update(dt)
map.layers[name]:draw()
```

### Getting tile properties
```lua
map:getTileProperty(gid, propertyName)
```
Gets the value of the property called `propertyName` on the tile with the global id `gid`, if it exists.

## Tiled map feature support
Things that are supported:
- Drawing CSV-formatted tile layers
- Drawing tile objects
- Animated tiles
- Layer offsets
- Infinite maps

Things that aren't supported:
- Drawing Base64 tile layers
- Non-orthogonal maps
- Changing map data after loading it (you can do this, but the draw functions may not reflect the changes)

## Contributing
Feel free to open issues and send pull requests. I'm open to bug fixes and new features!
