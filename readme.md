# Cartographer <!-- omit in toc -->
Cartographer is a small library for loading, reading, and drawing Tiled maps in LÖVE. It draws tile layers and tile objects, and it has various utilities to make parsing Tiled maps easier.

## Table of contents <!-- omit in toc -->
- [Installation](#installation)
- [Feature support](#feature-support)
- [API](#api)
	- [cartographer](#cartographer)
		- [`local map = cartographer.load(filename)`](#local-map--cartographerloadfilename)
	- [Map](#map)
		- [`local tileset = Map:getTileset(gid)`](#local-tileset--mapgettilesetgid)
		- [`local tile = Map:getTile(gid)`](#local-tile--mapgettilegid)
		- [`local type = Map:getTileType(gid)`](#local-type--mapgettiletypegid)
		- [`local value = Map:getTileProperty(gid, propertyName)`](#local-value--mapgettilepropertygid-propertyname)
		- [`Map:setTileProperty(gid, propertyName, propertyValue)`](#mapsettilepropertygid-propertyname-propertyvalue)
		- [`local layer = Map:getLayer(...)`](#local-layer--mapgetlayer)
		- [`Map:update(dt)`](#mapupdatedt)
		- [`Map:drawBackground()`](#mapdrawbackground)
		- [`Map:draw()`](#mapdraw)
	- [Layer](#layer)
		- [`local pixelX, pixelY = Layer:gridToPixel(gridX, gridY)`](#local-pixelx-pixely--layergridtopixelgridx-gridy)
		- [`local gridX, gridY = Layer:pixelToGrid(pixelX, pixelY)`](#local-gridx-gridy--layerpixeltogridpixelx-pixely)
	- [TileLayer](#tilelayer)
		- [`local left, top, right, bottom = TileLayer:getGridBounds()`](#local-left-top-right-bottom--tilelayergetgridbounds)
		- [`local left, top, right, bottom = TileLayer:getPixelBounds()`](#local-left-top-right-bottom--tilelayergetpixelbounds)
		- [`local gid = TileLayer:getTileAtGridPosition(x, y)`](#local-gid--tilelayergettileatgridpositionx-y)
		- [`TileLayer:setTileAtGridPosition(x, y, gid)`](#tilelayersettileatgridpositionx-y-gid)
		- [`local gid = TileLayer:getTileAtPixelPosition(x, y)`](#local-gid--tilelayergettileatpixelpositionx-y)
		- [`TileLayer:setTileAtPixelPosition(gridX, gridY, gid)`](#tilelayersettileatpixelpositiongridx-gridy-gid)
		- [`local iterator = TileLayer:getTiles()`](#local-iterator--tilelayergettiles)
		- [`TileLayer:update(dt)`](#tilelayerupdatedt)
		- [`TileLayer:draw()`](#tilelayerdraw)
	- [ObjectGroup](#objectgroup)
		- [`ObjectGroup:update(dt)`](#objectgroupupdatedt)
		- [`ObjectGroup:draw()`](#objectgroupdraw)
	- [ImageLayer](#imagelayer)
		- [`ImageLayer:draw()`](#imagelayerdraw)
	- [Group](#group)
		- [`local layer = Group:getLayer(...)`](#local-layer--groupgetlayer)
		- [`Group:update(dt)`](#groupupdatedt)
		- [`Group:draw()`](#groupdraw)
- [Contributing](#contributing)

## Installation
To use Cartographer, place cartographer.lua in your project, and then add this code to your main.lua:
```lua
cartographer = require 'cartographer' -- if your cartographer.lua is in the root directory
cartographer = require 'path.to.cartographer' -- if it's in subfolders
```

## Feature support
Supported:
- Drawing CSV-formatted tile layers
- Drawing tile objects
- Animated tiles
- Layer offsets
- Infinite maps

Not supported:
- Drawing Base64 tile layers
- Isometic and hexagonal maps

## API

### cartographer

#### `local map = cartographer.load(filename)`
Loads a [map](#map) from an exported Lua file.

### Map

#### `local tileset = Map:getTileset(gid)`
Gets the tileset that has the tile with the given global ID.

#### `local tile = Map:getTile(gid)`
Gets the data table for the tile with the given global ID, if it exists.

#### `local type = Map:getTileType(gid)`
Gets the type of the tile with the given global ID, if it exists.

#### `local value = Map:getTileProperty(gid, propertyName)`
Gets the value of the specified property on the tile with the given global ID, if it exists.

#### `Map:setTileProperty(gid, propertyName, propertyValue)`
Sets the value of the specified property on the tile with the given global ID.

#### `local layer = Map:getLayer(...)`
Gets the [layer](#layer) with the specified name. If multiple names are passed, then the map will look for nested layers.

Example:
```lua
-- equivalent to map.layers.a.layers.b.layers.c,
-- except there won't be indexing issues if one of those
-- layers doesn't exist
local layer = map:getLayer('a', 'b', 'c')
```

#### `Map:update(dt)`
Updates all the layers in the map.

Parameters:
- `dt` (`number`) - the time passed since the last update

#### `Map:drawBackground()`
Draws the background color of the map (if it's set).

#### `Map:draw()`
Draws the map.

### Layer

#### `local pixelX, pixelY = Layer:gridToPixel(gridX, gridY)`
Converts grid coordinates to pixel coordinates for this layer.

#### `local gridX, gridY = Layer:pixelToGrid(pixelX, pixelY)`
Converts pixel coordinates for this layer to grid coordinates.

### TileLayer

#### `local left, top, right, bottom = TileLayer:getGridBounds()`
Gets the left, top, right, and bottom bounds of the layer in grid tiles.

#### `local left, top, right, bottom = TileLayer:getPixelBounds()`
Gets the left, top, right, and bottom bounds of the layer in pixels.

#### `local gid = TileLayer:getTileAtGridPosition(x, y)`
Gets the unique ID of the tile at the specified position in grid tiles. 0 represents an empty tile.

#### `TileLayer:setTileAtGridPosition(x, y, gid)`
Sets the tile at the specified grid position to the specified unique ID. 0 represents an empty tile.

#### `local gid = TileLayer:getTileAtPixelPosition(x, y)`
Gets the unique ID of the tile at the specified position in pixels. 0 represents an empty tile.

#### `TileLayer:setTileAtPixelPosition(gridX, gridY, gid)`
Sets the tile at the specified pixel position to the specified unique ID. 0 represents an empty tile.

#### `local iterator = TileLayer:getTiles()`
Returns an iterator that allows you to loop over all of the non-empty tiles in the layer. The iterator returns the following values:
- `i` (`number`) - the index of the tile
- `gid` (`number`) - the unique ID of the tile
- `gridX` (`number`)
- `gridY` (`number`)
- `pixelX` (`number`)
- `pixelY` (`number`)

#### `TileLayer:update(dt)`
Updates the layer's animations.

Parameters:
- `dt` (`number`) - the time passed since the last update

#### `TileLayer:draw()`
Draws the layer.

### ObjectGroup

#### `ObjectGroup:update(dt)`
Updates the layer's animations.

Parameters:
- `dt` (`number`) - the time passed since the last update

#### `ObjectGroup:draw()`
Draws the layer.

### ImageLayer

#### `ImageLayer:draw()`
Draws the layer.

### Group

#### `local layer = Group:getLayer(...)`
Gets the child layer with the specified name. Works like [`Map.getLayer`](#local-layer--mapgetlayer).

#### `Group:update(dt)`
Updates all of the layers contained in this group.

Parameters:
- `dt` (`number`) - the time passed since the last update

#### `Group:draw()`
Draws the layer.

## Contributing
Feel free to open issues and send pull requests. I'm open to bug fixes and new features!
