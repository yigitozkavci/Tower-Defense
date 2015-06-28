Triangle = {}
Triangle.__index = Triangle
function Triangle.create(center, radius)
	triangle = {}
	triangle.center = center
	triangle.radius = radius
	return triangle
end
function Triangle:draw()
	love.graphics.polygon("fill", self.center.x, self.center.y+self.radius, self.center.x - self.radius*math.sqrt(3)/2, self.center.y - self.radius/2, self.center.x + self.radius*math.sqrt(3)/2, self.center.y - self.radius/2)
end