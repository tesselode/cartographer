local cartographer = require 'cartographer'

local testMap = cartographer.load {
	map = require 'test',
	tilesets = {
		sheet = love.graphics.newImage 'sheet.png',
		characters = love.graphics.newImage 'characters.png'
	},
}

for object in testMap:getObjects 'Geometry' do
	print(object)
end

function love.draw()
	testMap:drawTileLayer 'Back tiles'
	testMap:drawTileLayer 'Main tiles'
	testMap:drawTileLayer 'Front tiles'
end