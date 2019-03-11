local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/groups.lua'

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw()
	love.graphics.print('FPS: ' .. love.timer.getFPS())
	love.graphics.print('Memory: ' .. math.floor(collectgarbage 'count') .. ' kb', 0, 16)
end
