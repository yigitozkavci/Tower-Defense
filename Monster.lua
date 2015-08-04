local Monster = {}
Monster.__index = Monster

function Monster.create(health)
	local self = setmetatable({}, Monster)
	self.x = gridSize
	self.y = gridSize
	self.health = health
	return self
end
function Monster:followRoad(road)
	local x = math.floor(self.x/gridSize)
	local y = math.floor(self.y/gridSize)

	for i, coordinates in ipairs(road) do
		
		if coordinates[1] == x and coordinates[2] == y then
			if coordinates[3] == 1 then
				self.x = self.x - 1
			elseif coordinates[3] == 2 then
				self.x = self.x + 1
			elseif coordinates[3] == 4 then
				self.y = self.y - 1
			elseif coordinates[3] == 8 then
				self.y = self.y + 1
			end
		end
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