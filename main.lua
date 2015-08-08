
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

local tutorialKeyWanted
local tutorialText

local waitTimer = 0

decorations = {}

hudIcons = {}

money = 200

local buildMode = false
local buildModeAnimTimer = 0.4
local upgradeMode = false

local upgradeTower
local upgradeTowerIndex

local towerToBuild
local towerCost = 100

lives = 10

local moneyFont = love.graphics.newFont("assets/fonts/zorque.ttf", 18)
local smallFont = love.graphics.newFont("assets/fonts/zorque.ttf", 12)

local damageTypeToString = {
	[Tower.DamageType.Physical] = "Standard",
	[Tower.DamageType.Fire] = "Fire",
	[Tower.DamageType.Frost] = "Frost",
	[Tower.DamageType.Lightning] = "Lightning"
}

local pTypeToString = {
	[Tower.ProjectileType.Normal] = "Standard",
	[Tower.ProjectileType.Laser] = "Laser"
}

local upgradeCosts = {
	damage = 20,
	attackRate = 20,
	range = 20
}

function love.keypressed(key)
	local x, y = platform:getCursor()
	if state == "running" or state == "waiting" then

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
		elseif key == "q" then
			if buildMode then
				towerToBuild.damageType = Tower.DamageType.Physical
				towerToBuild.sellPrice = 50
				towerCost = 100
			end
		elseif key == "w" then
			if buildMode then
				towerToBuild.damageType = Tower.DamageType.Fire
				towerToBuild.sellPrice = 75
				towerCost = 150
			end
		elseif key == "e" then
			if buildMode then
				towerToBuild.damageType = Tower.DamageType.Frost
				towerToBuild.sellPrice = 75
				towerCost = 150
			end
		elseif key == "r" then
			if buildMode then
				towerToBuild.damageType = Tower.DamageType.Lightning
				towerToBuild.sellPrice = 75
				towerCost = 150
			end
		elseif key == "a" then
			if buildMode then
				towerToBuild.projectileType = Tower.ProjectileType.Normal
				towerToBuild.damage = 15
				towerToBuild.attackSpeed = 0.8
			elseif upgradeMode then
				if money >= upgradeCosts.damage then
					upgradeTower.damage = upgradeTower.damage + 2
					money = money - upgradeCosts.damage
					towerToBuild.sellPrice = towerToBuild.sellPrice + upgradeCosts.damage / 2
					upgradeCosts.damage = upgradeCosts.damage + 5
				end
			end
		elseif key == "s" then
			if buildMode then
				towerToBuild.projectileType = Tower.ProjectileType.Laser
				towerToBuild.damage = 1
				towerToBuild.attackSpeed = 4
			elseif upgradeMode then
				if money >= upgradeCosts.attackRate then
					upgradeTower.attackSpeed = upgradeTower.attackSpeed + 0.2
					money = money - upgradeCosts.attackRate
					towerToBuild.sellPrice = towerToBuild.sellPrice + upgradeCosts.attackRate / 2
					upgradeCosts.attackRate = upgradeCosts.attackRate + 5
				end
			end
		elseif key == "d" then
			if upgradeMode then
				if money >= upgradeCosts.range then
					upgradeTower.range = upgradeTower.range + 15
					money = money - upgradeCosts.range
					towerToBuild.sellPrice = towerToBuild.sellPrice + upgradeCosts.range / 2
					upgradeCosts.range = upgradeCosts.range + 5
				end
			end
		elseif key == "l" then
			if upgradeMode then
				money = money + upgradeTower.sellPrice
				towers[upgradeTowerIndex] = nil
			end
		elseif key == "b" then
			buildMode = not buildMode
			if buildMode then
				towerToBuild = Tower.create(0, 0)
				upgradeMode = false
			end
		end
	elseif state == "tutorial" then

	end
end
function love.mousepressed(x, y, button)
	local mouseTileX, mouseTileY = platform:getCursor().x, platform:getCursor().y
	debug[1] = "Mouse clicked to x: " .. mouseTileX .. ", y: " .. mouseTileY
	local tIndex = "x"..mouseTileX.."y"..mouseTileY
	if buildMode and money >= towerCost then
		
		if towers[tIndex] == nil and platform:getRoad()[tIndex] == nil then
			towerToBuild.tileX = mouseTileX
			towerToBuild.x = mouseTileX * gridSize

			towerToBuild.tileY = mouseTileY
			towerToBuild.y = mouseTileY * gridSize
			
			towers[tIndex] = towerToBuild
			money = money - towerCost
			buildMode = false
		end
	elseif upgradeMode then
		upgradeMode = false
	else
		if towers[tIndex] ~= nil then
			upgradeTower = towers[tIndex]
			upgradeTowerIndex = tIndex
			upgradeMode = true
		end

	end
end
function drawDebug()
	love.graphics.print(#debug)
	for i = 1, 2 do
		if(debug[i]) then
			love.graphics.print(debug[i], 5, i*gridSize)
		end
	end
end

function drawHUD()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(hudIcons.dmgTypePhysical, 10, love.graphics.getHeight() - (56 - (56 * buildModeAnimTimer/0.4)))
	love.graphics.draw(hudIcons.dmgTypeFire, 10 + (10 + 48), love.graphics.getHeight() - (56 - (56 * buildModeAnimTimer/0.4)))
	love.graphics.draw(hudIcons.dmgTypeFrost, 10 + (10 + 48) * 2, love.graphics.getHeight() - (56 - (56 * buildModeAnimTimer/0.4)))
	love.graphics.draw(hudIcons.dmgTypeLightning, 10 + (10 + 48) * 3, love.graphics.getHeight() - (56 - (56 * buildModeAnimTimer/0.4)))


	love.graphics.draw(hudIcons.moneyDisplay, love.graphics.getWidth() - 120, love.graphics.getHeight() - 50)

	love.graphics.draw(hudIcons.lifeDisplay, love.graphics.getWidth() - 120, 10)

	love.graphics.draw(hudIcons.frame, love.graphics.getWidth() - 200, 100)

	--DrawText

	--http://www.1001fonts.com/zorque-font.html
	
	love.graphics.setFont(moneyFont)
	love.graphics.printf(money, love.graphics.getWidth() - 120, love.graphics.getHeight() - 30, 120, "center")
	
	love.graphics.printf(lives, love.graphics.getWidth() - 120, 20, 64, "center")

	love.graphics.setColor(255, 255, 120)
	love.graphics.setFont(smallFont)
	if buildMode then
		love.graphics.printf("Building tower:\n"..
			"Damage Type: "..damageTypeToString[towerToBuild.damageType].."\n"..
			"Projectile Type: "..pTypeToString[towerToBuild.projectileType].."\n"..
			"Damage: "..towerToBuild.damage.."\n"..
			"Attack rate: "..towerToBuild.attackSpeed.."\n"..
			"Range: "..towerToBuild.range.."\n"..
			"Tower Cost:"..towerCost.."\n"..
			"Q, W, E, R to change Damage Type\n"..
			"A, S to change Projectile Type",  love.graphics.getWidth() - 170, 120, 170, "left")
	else
		if upgradeMode then
			love.graphics.printf("Tower stats:\n"..
				"Damage: "..upgradeTower.damage.."\n"..
				"Attack Rate: "..upgradeTower.attackSpeed.."\n"..
				"Range: "..upgradeTower.range.."\n"..
				"A, S, D to upgrade stats.(Costs:"..upgradeCosts.damage..","..upgradeCosts.attackRate..","..upgradeCosts.range..")\n"..
				"L to sell the tower.(Take "..upgradeTower.sellPrice.." back)",  love.graphics.getWidth() - 170, 120, 170, "left")
		else
			love.graphics.printf("Press B to go into buy mode. Click on a tower to see upgrade options.",  love.graphics.getWidth() - 170, 120, 170, "left")
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
	
	hudIcons = {
		dmgTypePhysical = love.graphics.newImage('assets/img/hud_dmg_physical.png'),
		dmgTypePhysicalSelected = love.graphics.newImage('assets/img/hud_dmg_physical_selected.png'),
		dmgTypeFire = love.graphics.newImage('assets/img/hud_dmg_fire.png'),
		dmgTypeFireSelected = love.graphics.newImage('assets/img/hud_dmg_fire_selected.png'),
		dmgTypeFrost = love.graphics.newImage('assets/img/hud_dmg_frost.png'),
		dmgTypeFrostSelected = love.graphics.newImage('assets/img/hud_dmg_frost_selected.png'),
		dmgTypeLightning = love.graphics.newImage('assets/img/hud_dmg_lightning.png'),
		dmgTypeLightningSelected = love.graphics.newImage('assets/img/hud_dmg_lightning_selected.png'),
		
		moneyDisplay = love.graphics.newImage('assets/img/hud_money.png'),
		lifeDisplay = love.graphics.newImage('assets/img/hud_heart.png'),

		frame = love.graphics.newImage('assets/img/hud_frame.png')
	}

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

		for i,v in pairs(towers) do
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
		if buildMode then
			buildModeAnimTimer = math.max(buildModeAnimTimer - dt, 0)
		else
			buildModeAnimTimer = math.min(buildModeAnimTimer + dt, 0.4)
		end
		if lives <= 0 then
			state = "lose"
		end
	elseif state == "waiting" then
		waitTimer = waitTimer - dt
		if waitTimer < 0 then
			state = "running"
		end
		if buildMode then
			buildModeAnimTimer = math.max(buildModeAnimTimer - dt, 0)
		else
			buildModeAnimTimer = math.min(buildModeAnimTimer + dt, 0.4)
		end
	elseif state == "tutorial" then

	elseif state == "lose" then
		--You're a  fuckin' loser. Press r to restart you dumbass.
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

	for i,v in pairs(towers) do
		v:draw()
	end

	--drawDebug()
	for i, monster in ipairs(currentWave) do
		platform:drawMonster(monster)
	end
	drawHUD()
	if state == "endgame" then
		love.graphics.setColor({0, 0, 255})
		love.graphics.printf("YOU'RE WINNER", 0, love.graphics.getHeight() / 2, love.graphics.getWidth() / 2, "center", 0, 2, 2)
	end
	if state == "lose" then
		love.graphics.setColor({255, 0, 0})
		love.graphics.printf("You're a loser.", 0, love.graphics.getHeight() / 2, love.graphics.getWidth() / 2, "center", 0, 2, 2)
	end
end