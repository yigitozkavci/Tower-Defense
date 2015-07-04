local Platform = {}
Platform.__index = Platform

currentRoad = {}
function Platform.create()
	local self = setmetatable({}, Platform)

	local cursor = {}
	cursor.x = 2
	cursor.y = 0
	cursor.color = { 0, 0, 200 }
	self.cursor = cursor
	return self
end
function Platform:drawGrids()
	love.graphics.setColor({255, 0, 0})
	for i = 0, width do
		love.graphics.rectangle("line", i*gridSize, -1, gridSize, gridSize*height+1)
	end
	for j = 0, height do
		love.graphics.rectangle("line", -1, j*gridSize, gridSize*width+2, gridSize)
	end
end
function Platform:paintGrid(x, y, color)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", x*gridSize, y*gridSize, gridSize, gridSize)
end
function Platform:paintCircle(x, y, radiusRatio, color)
	love.graphics.setColor(color)
	love.graphics.circle("fill", x*gridSize+gridSize/2, y*gridSize+gridSize/2, gridSize*radiusRatio/2, 100)
end
function Platform:drawRoad(road)
	love.graphics.setColor(255, 255, 255)
	for key, coordinates in pairs(road) do
		love.graphics.draw(dirtImage, coordinates[1]*gridSize, coordinates[2]*gridSize)
	end
end
function Platform:setGrass()
	-- Filling everywhere with grasses.
	love.graphics.setColor(255, 255, 255)
	for i=0, width do
		for j=0, height do
			love.graphics.draw(grassImage, i*gridSize, j*gridSize)
		end
	end
end
function Platform:drawLevel(level)
	road = {}
	road.color = {255, 255, 255}
	if level == 1 then
		for i=1, 20 do
			table.insert(road, {i, 1})
		end
		for i=1, 20 do
			table.insert(road, {i, 5})
		end
		for i=1, 20 do
			table.insert(road, {i, 11})
		end
		table.insert(road, {20, 2})
		table.insert(road, {20, 3})
		table.insert(road, {20, 4})
		table.insert(road, {1, 6})
		table.insert(road, {1, 7})
		table.insert(road, {1, 8})
		table.insert(road, {1, 9})
		table.insert(road, {1, 10})
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(house96x128, gridSize*19, gridSize*7)
		self:drawRoad(road)
		currentRoad = road
	end
end
function Platform:getRoad()
	return currentRoad
end
function Platform:drawMonster(monster)
	love.graphics.setColor(monster.color)
	love.graphics.circle("fill", monster.x+gridSize/2, monster.y+gridSize/2, gridSize/4, 100)
end
function Platform:drawCursor()
	love.graphics.setColor(self.cursor.color)
	love.graphics.rectangle("line", self.cursor.x*gridSize, self.cursor.y*gridSize, gridSize, gridSize)
end
function Platform:getCursor()
	return { x = self.cursor.x, y = self.cursor.y }
end
function Platform:setCursor(x, y)
	self.cursor.x = x
	self.cursor.y = y
end
return Platform