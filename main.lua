local cartographer = require 'cartographer'

local testMap = cartographer.load 'test.lua'

function love.draw()
	testMap:draw()
end