local cartographer = require 'cartographer'

local testMap = cartographer.load {
	map = require 'test',
	tilesets = {
		sheet = love.graphics.newImage 'sheet.png',
		characters = love.graphics.newImage 'characters.png'
	},
}

function love.draw()
	for layer in testMap:getTileLayers() do
		testMap:drawTileLayer(layer)
	end
end