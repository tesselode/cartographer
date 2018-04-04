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

## License

MIT License

Copyright (c) 2018 Andrew Minnich

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.