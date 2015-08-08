local Monster = {}
Monster.__index = Monster

function Monster.create(health)
	local self = setmetatable({}, Monster)
	self.x = gridSize
	self.y = gridSize

	self.width = 32
	self.height = 32

	self.currentCoords = {x=0, y=0}

	self.speed = 64

	self.health = health
	self.maxHealth = health

	self.damageModifiers = {physical = 1, fire = 1, frost = 1, lightning = 1}

	self.reward = 10

	self.dead = false

	return self
end

function Monster.getPreset(name)
	local file = love.filesystem.load("MonsterPresets/"..name..".lua")
	local monster = file()
	return monster
end

function Monster:update(dt, road) 

	if self.health <= 0 then
		money = money + self.reward
		self.dead = true
	end

	self:followRoad(dt, road)
end

function Monster:followRoad(dt, road)
	if not self.dead then
		local x = math.floor((self.x)/gridSize)
		local y = math.floor((self.y)/gridSize)

		local coordinates = road["x"..x.."y"..y]

		if self.x % gridSize < 4 and self.y % gridSize < 4 then
			self.currentCoords.x = x
			self.currentCoords.y = y
		end
		if self.currentCoords.x == platform.level.endPoint.x and self.currentCoords.y == platform.level.endPoint.y then
			lives = lives - 1
			self.dead = true
		end
		if coordinates ~= nil then
			if coordinates[1] == x and coordinates[2] == y then
				if x == self.currentCoords.x and y == self.currentCoords.y then
					if coordinates[3] == Platform.Direction.Left then
						self.x = self.x - dt*self.speed
					elseif coordinates[3] == Platform.Direction.Right then
						self.x = self.x + dt*self.speed
					elseif coordinates[3] == Platform.Direction.Up then
						self.y = self.y - dt*self.speed
					elseif coordinates[3] == Platform.Direction.Down then
						self.y = self.y + dt*self.speed
					end
				else
					if coordinates[4] == Platform.Direction.Left then
						self.x = self.x - dt*self.speed
					elseif coordinates[4] == Platform.Direction.Right then
						self.x = self.x + dt*self.speed
					elseif coordinates[4] == Platform.Direction.Up then
						self.y = self.y - dt*self.speed
					elseif coordinates[4] == Platform.Direction.Down then
						self.y = self.y + dt*self.speed
					end
				end
			end
		end
	end
end

function Monster:takeDamage(projectile)
	local dmgMod = {
		[Tower.DamageType.Physical] = function() return self.damageModifiers.physical end,
		[Tower.DamageType.Fire] = function() return self.damageModifiers.fire end,
		[Tower.DamageType.Frost] = function() return self.damageModifiers.frost end,
		[Tower.DamageType.Lightning] = function() return self.damageModifiers.lightning end
	}
	self.health = self.health - projectile.damage * dmgMod[projectile.damageType]()
end

function hasPassed(coordinates)
	return false
	--for i, value in ipairs(passedCoordinates) do 
	--	if coordinates == value then
	--		return true
	--	end
	--end
	--return false
end
function Monster:shout()
	print "wow"
end
return Monster