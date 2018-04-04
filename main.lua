local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/test.lua'

function love.draw()
	testMap.layers.Back:draw()
end