local cartographer = require 'cartographer'

local testMap = cartographer.load {
	map = require 'test',
	tilesets = {
		sheet = love.graphics.newImage 'sheet.png',
		characters = love.graphics.newImage 'characters.png'
	},
}

function love.draw()
	testMap:drawTileLayer 'Back tiles'
	testMap:drawTileLayer 'Main tiles'
	testMap:drawTileLayer 'Front tiles'
end