local cartographer = require 'cartographer'

local testMap = cartographer.load 'test.lua'

local cullX = 50
local cullY = 50

function love.update(dt)
	if love.keyboard.isDown 'left' then cullX = cullX - 50 * dt end
	if love.keyboard.isDown 'right' then cullX = cullX + 50 * dt end
	if love.keyboard.isDown 'up' then cullY = cullY - 50 * dt end
	if love.keyboard.isDown 'down' then cullY = cullY + 50 * dt end
end

function love.draw()
	testMap.layers['Back tiles']:draw(cullX, cullY, 50, 25)
	testMap.layers['Main tiles']:draw(cullX, cullY, 50, 25)
	testMap.layers['Sun']:draw()
	testMap.layers['Front tiles']:draw(cullX, cullY, 50, 25)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle('line', cullX, cullY, 50, 25)
end