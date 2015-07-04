local Entity = {}
Entity.__index = Entity
function Entity.create()
	local self = setmetatable({}, Entity)
	return self
end
function Entity:getShout()
	return "hrr"
end
return Entity