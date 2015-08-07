
Platform = require("Platform")
platform = Platform.create()
Monster = require("Monster")
Tower = require("Tower")

monsterCreateTimer = 0
monsterCreateTimerMax = 1000

monsterMoveTimer = 0
monsterMoveTimerMax = 30
currentWave = {}
local waveNumber = 1

debug = {}

local towers = {}

local state = "loading"

local waitTimer = 0

decorations = {}

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
	local tower = Tower.create(platform:getCursor().x, platform:getCursor().y)
	table.insert(towers, tower)
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

function wait(seconds)
	state = "waiting"
	waitTimer = seconds
end

function love.load()

	grassImage = love.graphics.newImage('assets/img/grass32x.png')
	dirtImage = love.graphics.newImage('assets/img/dirt32x.png')
	house96x128 = love.graphics.newImage('assets/img/house96x128.png')
	
	decorations["house"] = house96x128

	platform:loadLevel(1)

	state = "running"
end
function love.update(dt)
	if state == "running" then
		monsterCreateTimer = monsterCreateTimer + dt*1000
		monsterMoveTimer = monsterMoveTimer + dt*1000
		if(monsterCreateTimer > monsterCreateTimerMax) and table.getn(platform.level.waves[waveNumber]) > 0 then
			monsterCreateTimer = 0
			local monster = table.remove(platform.level.waves[waveNumber])
			monster.x = platform.level.spawn.x * gridSize
			monster.y = platform.level.spawn.y * gridSize
			table.insert(currentWave, monster)
		end
		if(monsterMoveTimer > monsterMoveTimerMax) then
			for i, monster in ipairs(currentWave) do
				if monster.dead then
					table.remove(currentWave, i)
				end
				monster:update(dt, platform:getRoad())
			end
		end

		for i,v in ipairs(towers) do
			v:update(dt, currentWave)
		end

		if table.getn(platform.level.waves[waveNumber]) == 0 and table.getn(currentWave) == 0 then
			wait(5)
			waveNumber = waveNumber + 1
			print("Wave "..waveNumber)
			if waveNumber > platform.level.waveCount then
				print("Level finished")
				print("YOU WIN")
				state = "endgame"
			end
		end
	elseif state == "waiting" then
		waitTimer = waitTimer - dt
		if waitTimer < 0 then
			state = "running"
		end
	elseif state == "endgame" then
		--TODO fireworks and shit goes here
	end
	local x, y = love.mouse.getPosition()
	platform:setCursor(math.floor(x/32), math.floor(y/32))
end
function love.draw()
	platform:setGrass()
	platform:drawLevel()
	platform:drawCursor()

	for i,v in ipairs(towers) do
		v:draw()
	end

	drawDebug()
	for i, monster in ipairs(currentWave) do
		platform:drawMonster(monster)
	end
	if state == "endgame" then
		love.graphics.setColor({0, 0, 255})
		love.graphics.print("YOU'RE WINNER", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 4, 4)
	end
end