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
	testMap.layers.Back.layers.Background:draw(cullX, cullY, 50, 50)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle('line', cullX, cullY, 50, 50)
end