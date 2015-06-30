local Monster = {}
Monster.__index = Monster
function Monster.create(health)
	local self = setmetatable({}, Monster)
	self.health = health
	return self
end
function Monster:getShout()
	return "hrr"
end
return Monster