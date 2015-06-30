require("assets/scripts/platform/platform")
Monster = require("Monster")
debug = ""
function drawCursor()
	love.graphics.setColor(cursor.color)
	love.graphics.rectangle("line", cursor.x*gridSize, cursor.y*gridSize, gridSize, gridSize)
end
function love.keypressed(key)
	if key == "down" then
		cursor.y = cursor.y + 1
	elseif key == "up" then
		cursor.y = cursor.y - 1
	elseif key == "right" then
		cursor.x = cursor.x + 1
	elseif key == "left" then
		cursor.x = cursor.x - 1
	end
end
function love.mousepressed(x, y, button)
	debug = "Mouse clicked to x: " .. cursor.x .. ", y: " .. cursor.y
end
function drawDebug(string)
	love.graphics.print(string, 5, 5)
end
function love.load()
	cursor = {}
	cursor.x = 2
	cursor.y = 0
	cursor.color = { 0, 0, 200 }

	grassImage = love.graphics.newImage('assets/img/grass32x.png')
	dirtImage = love.graphics.newImage('assets/img/dirt32x.png')
	house96x128 = love.graphics.newImage('assets/img/house96x128.png')
	monster = Monster.create(100)
end
function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end
function love.draw()
	setGrass()
	drawLevel(1)
	drawCursor()
	drawDebug(debug)
	local x, y = love.mouse.getPosition()
	cursor.x, cursor.y = math.floor(x/32), math.floor(y/32)
end