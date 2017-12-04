local cartographer = require 'cartographer'

local testMap = cartographer.load 'test.lua'

for object in testMap:getObjects 'Geometry' do
	print(object)
end

function love.draw()
	testMap:drawTileLayer 'Back tiles'
	testMap:drawTileLayer 'Main tiles'
	testMap:drawTileLayer 'Front tiles'
end