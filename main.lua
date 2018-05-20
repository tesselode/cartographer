local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/infinite.lua'

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw()
	love.graphics.print(love.timer.getFPS())
end