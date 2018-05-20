local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/test.lua'

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw(0, 0, 800, 600)
	love.graphics.print(love.timer.getFPS())
end