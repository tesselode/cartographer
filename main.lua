local cartographer = require 'cartographer'

local testMap = cartographer.load 'demo/groups.lua'

local triggers = testMap.layers['Group 1'].layers['Group 2'].layers.Triggers
for layer, object, type, x, y in triggers:getObjects {'type', 'x', 'y'} do
	print(layer, object, type, x, y)
end

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw()
	love.graphics.print(love.timer.getFPS())
end