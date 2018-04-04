local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/test.lua'

function love.draw()
	testMap:draw()
	love.graphics.print(love.timer.getFPS())
end