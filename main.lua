local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'
local terrainMain = testMap:getLayer('foreground', 'terrain', 'terrainMain')
for _, gid, gridX, gridY, pixelX, pixelY in terrainMain:getTiles() do
	print(gid, gridX, gridY, pixelX, pixelY)
end
