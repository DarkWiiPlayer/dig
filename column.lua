local digutils2 = require 'digutils2'

local select = digutils2.rememberItem()
local count = digutils2.itemCounter()

local width = digutils2.ask("Width", "number")
local depth = digutils2.ask("Depth", "number", width)

local function checkBlocks(height)
	local needed = (height * 2 * (width + depth - 1))

	if count() < needed then
		digutils2.down(height)
		error("Not enouhg blocks: need at least " .. tostring(needed))
	end

	checkBlocks = function() end
end

local function column()
	local height = 0

	while turtle.up() do
		height = height + 1
		if height >= 100 then
			break
		end
	end

	checkBlocks(height)

	for _ = 1, height do
		turtle.down()
		select()
		turtle.placeUp()
	end

	turtle.back()
	select()
	turtle.place()
end

local function wall(length, turn)
	for i = 1, length do
		if turn and (i == length) then
			turn()
		end
		column()
	end
end

if (width > 2) and (depth > 2) then
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	turtle.turnLeft()

	wall(depth - 1, turtle.turnRight)
	wall(width - 1, turtle.turnRight)
	wall(depth - 1, turtle.turnRight)
	wall(width -1, turtle.turnLeft)
else
	error("NYI: Both dimensions must be > 2")
end
