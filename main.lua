local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'
print(testMap.layers.background:gridToPixel(1, 1))
