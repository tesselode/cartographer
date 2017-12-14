local cartographer = require 'cartographer'

local testMap = cartographer.load 'test.lua'

function love.draw()
	testMap.layers['Back tiles']:draw()
	testMap.layers['Main tiles']:draw()
	testMap.layers['Sun']:draw()
	testMap.layers['Front tiles']:draw()
end