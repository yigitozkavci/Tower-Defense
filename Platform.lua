local Platform = {}
Platform.__index = Platform

Platform.Direction = {Left = 1, Right = 2, Up = 4, Down = 8}

function Platform.create()
	local self = setmetatable({}, Platform)

	local cursor = {}
	cursor.x = 2
	cursor.y = 0
	cursor.color = { 0, 0, 200 }
	self.cursor = cursor

	self.level = {loaded = false}

	return self
end

function str_split(input, delimiter)
	local t = {}
	local i = 1
	for str in string.gmatch(input, "([^"..delimiter.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function letterToDirection(letter)
	if letter == "L" then
		return Platform.Direction.Left
	elseif letter == "R" then
		return Platform.Direction.Right
	elseif letter == "U" then
		return Platform.Direction.Up
	elseif letter == "D" then
		return Platform.Direction.Down
	end
end

function Platform:loadLevel(level)
	local contents, size = love.filesystem.read("assets/levels/level"..level..".tdl")

	local level = {}

	if string.match(contents, "^TDLevelFile V1.0\r\n") then
		local metadataStr = string.match(contents, "Start Metadata\r\n(.*)End Metadata")

		local roadStr = string.match(contents, "Start Road\r\n(.*)End Road")

		local name = string.match(metadataStr, "name%s+(.-)\r\n")
		local spawnX, spawnY = string.match(metadataStr, "spawn%s+(%d-),(%d-)\r\n")
		local endX, endY = string.match(metadataStr, "end%s+(%d-),(%d-)\r\n")
		local waveCount = string.match(metadataStr, "waveCount%s+(%d-)\r\n")

		level.name = name
		level.spawn = {x = spawnX, y = spawnY}
		level.endPoint = {x = endX, y = endY}
		level.waveCount = waveCount
		level.road = {}

		print("Level Name: "..name)
		print("spawn at x: "..spawnX.." y: "..spawnY)
		print("end at x: "..endX.." y: "..endY)

		local roadTiles = str_split(roadStr, "\r\n")

		for i,v in ipairs(roadTiles) do
			local tileX, tileY, d1, d2 = string.match(v, "T%s+(%d-),(%d-),(.)(.)")
			if tileX == nil then
				print("Tile skipped. Wrong format")
			else
				table.insert(level.road, {tonumber(tileX), tonumber(tileY), letterToDirection(d2), letterToDirection(d1)})
			end
		end

		print(level.road[1][3])

		level.loaded = true

		self.level = level

	else
		print("Level file corrupted")
	end

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
function Platform:drawLevel()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(house96x128, gridSize*19, gridSize*7)
	self:drawRoad(self.level.road)
end
function Platform:getRoad()
	return self.level.road
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