local cartographer = require 'cartographer'

local testMap = cartographer.load 'test.lua'

for _, object in ipairs(testMap.layers['Geometry'].objects) do
	print(object)
end

function love.draw()
	testMap.layers['Back tiles']:draw()
	testMap.layers['Main tiles']:draw()
	testMap.layers['Front tiles']:draw()
end