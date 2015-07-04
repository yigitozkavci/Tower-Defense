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
	self.x = self.x+1
	wow = { x+1, y }
	debug[1] = wow[1]
	for i, coordinates in ipairs(road) do
		if { x+1, y } == coordinates then
			self.x = self.x+1
		elseif { x-1, y } == coordinates then
			self.x = self.x-1
		elseif { x, y+1 } == coordinates then
			self.y = self.y+1
		elseif { x, y-1 } == coordinates then	
			self.y = self.y-1
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