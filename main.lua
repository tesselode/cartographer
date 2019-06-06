local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'
print(testMap:getLayer('foreground'))
print(testMap.tilesets.objects)
