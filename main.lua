local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/groups.lua'

for layer, object, type, x, y in testMap:getObjects {'type', 'x', 'y'} do
	print(layer, object, type, x, y)
end

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw()
	love.graphics.print(love.timer.getFPS())
end