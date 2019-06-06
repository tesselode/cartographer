local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'
testMap:setTileProperty(400, 'asdf', true)
print(testMap:getTile(400).properties)
