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
	self.speedModifier = 1

	self.health = health
	self.maxHealth = health

	self.damageModifiers = {physical = 1, fire = 1, frost = 1, lightning = 1}

	self.reward = 10

	self.status = {
		onFire = false, --takes damage over time for a short amount of time
		onFireTimer = 0,
		fireTickTimer = 0,
		slowed = false, --slowed movement
		slowedTimer = 0,
		shocked = false, --takes more damage from lightning attacks
		shockedTimer = 0,
		shockStack = 0
	}

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

	if self.status.onFire then
		self.status.onFireTimer = self.status.onFireTimer - dt
		if self.status.onFireTimer > 0 then
			self.status.fireTickTimer = self.status.fireTickTimer - dt
			if self.status.fireTickTimer <= 0 then
				self.status.fireTickTimer = TowerParams.onFireDOTTickTimer
				self:takeDamage(TowerParams.onFireDOTDamage, Tower.DamageType.Fire)
			end
		else
			self.status.onFire = false
		end
	end

	if self.status.slowed then
		self.status.slowedTimer = self.status.slowedTimer - dt
		if self.status.slowedTimer > 0 then
			self.speedModifier = TowerParams.slowDebuffSlowAmount
		else
			self.status.slowed = false
			self.speedModifier = 1
		end
	end

	if self.status.shocked then
		self.status.shockedTimer = self.status.shockedTimer - dt
		if self.status.shockedTimer <= 0 then
			self.status.shocked = false
			self.status.shockStack = 0
		end
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
						self.x = self.x - dt*self.speed*self.speedModifier
					elseif coordinates[3] == Platform.Direction.Right then
						self.x = self.x + dt*self.speed*self.speedModifier
					elseif coordinates[3] == Platform.Direction.Up then
						self.y = self.y - dt*self.speed*self.speedModifier
					elseif coordinates[3] == Platform.Direction.Down then
						self.y = self.y + dt*self.speed*self.speedModifier
					end
				else
					if coordinates[4] == Platform.Direction.Left then
						self.x = self.x - dt*self.speed*self.speedModifier
					elseif coordinates[4] == Platform.Direction.Right then
						self.x = self.x + dt*self.speed*self.speedModifier
					elseif coordinates[4] == Platform.Direction.Up then
						self.y = self.y - dt*self.speed*self.speedModifier
					elseif coordinates[4] == Platform.Direction.Down then
						self.y = self.y + dt*self.speed*self.speedModifier
					end
				end
			end
		end
	end
end

function Monster:takeDamage(projectile, damageType)
	local dmgMod = {
			[Tower.DamageType.Physical] = function() return self.damageModifiers.physical end,
			[Tower.DamageType.Fire] = function() return self.damageModifiers.fire end,
			[Tower.DamageType.Frost] = function() return self.damageModifiers.frost end,
			[Tower.DamageType.Lightning] = function() return self.damageModifiers.lightning end
		}
	if projectile and damageType then
		if self.status.shocked and damageType == Tower.DamageType.Lightning then
			projectile = projectile + projectile * self.status.shockStack * TowerParams.shockDamageAmplifier
		end
		self.health = self.health - projectile * dmgMod[damageType]()
	elseif projectile then
		if self.status.shocked and projectile.damageType == Tower.DamageType.Lightning then
			projectile.damage = projectile.damage + projectile.damage * self.status.shockStack * TowerParams.shockDamageAmplifier
		end	
		self.health = self.health - projectile.damage * dmgMod[projectile.damageType]()
		self:applyStatus(projectile.damageType)
	end

	
end

function Monster:applyStatus(effect)
	if effect == Tower.DamageType.Fire then
		self.status.onFire = true
		self.status.onFireTimer = TowerParams.onFireTimer
	elseif effect == Tower.DamageType.Frost then
		self.status.slowed = true
		self.status.slowedTimer = TowerParams.slowDebuffTime
	elseif effect == Tower.DamageType.Lightning then
		self.status.shocked = true
		self.status.shockedTimer = TowerParams.shockTimer
		self.status.shockStack = math.min(self.status.shockStack + 1, TowerParams.shockDamageMaxStack)
	end
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