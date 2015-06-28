function drawGrids()
	love.graphics.setColor({255, 0, 0})
	for i = 0, width do
		love.graphics.rectangle("line", i*gridSize, -1, gridSize, gridSize*height+1)
	end
	for j = 0, height do
		love.graphics.rectangle("line", -1, j*gridSize, gridSize*width+2, gridSize)
	end
end
function paintGrid(x, y, color)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", x*gridSize, y*gridSize, gridSize, gridSize)
end
function paintCircle(x, y, radiusRatio, color)
	love.graphics.setColor(color)
	love.graphics.circle("fill", x*gridSize+gridSize/2, y*gridSize+gridSize/2, gridSize*radiusRatio/2, 100)
end
function drawRoad(road)
	love.graphics.setColor(255, 255, 255)
	for key, coordinates in pairs(road) do
		love.graphics.draw(dirtImage, coordinates[1]*gridSize, coordinates[2]*gridSize)
	end
end
function setGrass()
	-- Filling everywhere with grasses.
	love.graphics.setColor(255, 255, 255)
	for i=0, width do
		for j=0, height do
			love.graphics.draw(grassImage, i*gridSize, j*gridSize)
		end
	end
end
function drawLevel(level)
	road = {}
	road.color = {255, 255, 255}
	if level == 1 then
		for i=1, 20 do
			table.insert(road, {i, 1})
			table.insert(road, {i, 5})
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
		drawRoad(road)

	end
end