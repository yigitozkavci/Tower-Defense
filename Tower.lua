local Tower = {}
Tower.__index = Tower

--ProjectileType enumeration
Tower.ProjectileType = {
	Normal = 1,
	Laser = 2
}

--Creates a new tower at x, y tile coordinates
--projectileType defines if this tower attacks with balls(yeah, balls) or laser.
--	Normal type of attack (balls type) shoots balls to target and deals damage whenever the
--		ball hits.
--	Laser type of attack focuses on the target deals damage continously. (Don't have to wait for the
--		projectile to reach the target.) It is supposed to deal smaller amounts of damage in very short
-- 		periods.
--attackSpeed is the number of projectiles that should be fired in each second. (Eg. 0.5 attack speed means
--	that the turret should attack for each 2 seconds.)
--range is calculated by pixels, which should make it easier to display on the game.
function Tower.create(x, y)
	local self = setmetatable({}, Tower)

	self.tileX = x
	self.tileY = y

	self.x = x * gridSize
	self.y = y * gridSize

	self.width = gridSize
	self.height = gridSize

	self.damage = 15
	self.projectileType = Tower.ProjectileType.Normal
	self.attackSpeed = 0.8

	self.attackTimer = 0

	self.projectiles = {}

	self.range = 100

	return self
end

--Utility method to calculate distance between a tower and a monster
--TODO: maybe we should define this as a local function?
function distance(tower, monster)
	return math.sqrt((tower.x - monster.x) * (tower.x - monster.x) + (tower.y - monster.y) * (tower.y - monster.y))
end

--Utility method to get sign of the number.
function sign(value)
	if math.abs(value) == value then
		return 1
	else
		return -1
	end
end

--Update method for tower.
function Tower:update(dt, monsters)
	self.attackTimer = self.attackTimer + dt

	if self.attackTimer > 1 / self.attackSpeed then
		self.attackTimer = 0
		local minDistance = 10000;
		local monster
		for i,v in ipairs(monsters) do
			local dist = distance(self, v)
			if dist < minDistance then
				monster = v
				minDistance = dist
			end
		end
		if minDistance < self.range then
			table.insert(self.projectiles, {
				x = self.x+self.width/2, y = self.y+self.height/2,
				target = monster, damage = self.damage
				})
		end

	end
	for i,v in ipairs(self.projectiles) do
		v.x = v.x + (v.target.x + v.target.width / 2 - v.x) / 10
		v.y = v.y + (v.target.y + v.target.height / 2 - v.y) / 10
		if math.abs(v.x - v.target.x - (v.target.width / 2)) < 10 and math.abs(v.y - v.target.y - (v.target.height / 2)) < 10 then
			v.target.health = v.target.health - v.damage
			table.remove(self.projectiles, i)
		end

	end
end

--Draw method for tower
--Draws projectiles too.
function Tower:draw()
	love.graphics.setColor({0, 255, 0})
	love.graphics.rectangle("fill", self.x + self.width/4, self.y + self.height/4, self.width/2, self.height/2)
	love.graphics.setColor({255, 255, 255})
	for i,v in ipairs(self.projectiles) do
		love.graphics.circle("fill", v.x, v.y, 5, 20)
	end
end

return Tower