local cartographer = require 'cartographer'

local testMap = cartographer.load 'demos/platformer/platformer.lua'
local layer = testMap:getLayer('foreground', 'terrain', 'terrainMain')
local l, t, r, b = layer:getBounds()
for x = l, r do
	for y = t, b do
		print(layer:getTileAt(x, y))
	end
end

function love.update(dt)
	testMap:update(dt)
end

function love.draw()
	testMap:draw()
	love.graphics.print('FPS: ' .. love.timer.getFPS())
	love.graphics.print('Memory: ' .. math.floor(collectgarbage 'count') .. ' kb', 0, 16)
end
