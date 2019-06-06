local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'

function love.draw()
	testMap:draw()
end
