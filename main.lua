
Platform = require("Platform")
platform = Platform.create()
Monster = require("Monster")

monsterCreateTimer = 0
monsterCreateTimerMax = 1000

monsterMoveTimer = 0
monsterMoveTimerMax = 30
currentWave = {}
debug = {}
function love.keypressed(key)
	local x, y = platform:getCursor()
	if key == "down" then
		platform:setCursor(x, y+1)
	elseif key == "up" then
		platform:setCursor(x, y-1)
	elseif key == "right" then
		platform:setCursor(x+1, y)
	elseif key == "left" then
		platform:setCursor(x-1, y)
	elseif key == "escape" then
		love.event.push('quit')
	end
end
function love.mousepressed(x, y, button)
	debug[1] = "Mouse clicked to x: " .. platform:getCursor().x .. ", y: " .. platform:getCursor().y
end
function drawDebug()
	love.graphics.print(#debug)
	for i = 1, 2 do
		if(debug[i]) then
			love.graphics.print(debug[i], 5, i*gridSize)
		end
	end
end
function getRandomColor()
	return { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
end
function love.load()

	grassImage = love.graphics.newImage('assets/img/grass32x.png')
	dirtImage = love.graphics.newImage('assets/img/dirt32x.png')
	house96x128 = love.graphics.newImage('assets/img/house96x128.png')
	
end
function love.update(dt)
	monsterCreateTimer = monsterCreateTimer + dt*1000
	monsterMoveTimer = monsterMoveTimer + dt*1000
	if(monsterCreateTimer > monsterCreateTimerMax) then
		monsterCreateTimer = 0
		local monster = Monster.create(math.random(50, 100))
		monster.color = getRandomColor()
		table.insert(currentWave, monster)
	end
	if(monsterMoveTimer > monsterMoveTimerMax) then
		for i, monster in ipairs(currentWave) do

			monster:followRoad(platform:getRoad())

		end
	end
	local x, y = love.mouse.getPosition()
	platform:setCursor(math.floor(x/32), math.floor(y/32))
end
function love.draw()
	platform:setGrass()
	platform:drawLevel(1)
	platform:drawCursor()

	drawDebug()
	for i, monster in ipairs(currentWave) do
		platform:drawMonster(monster)
	end
end