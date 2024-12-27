local digutils2 = require 'digutils2'

local item = digutils2.item()

--- Whether the turtle is at the top or bottom of the column
--- @type boolean
local up = false

local width = digutils2.ask("Width", "number")
local depth = digutils2.ask("Depth", "number", width)
local height = digutils2.ask("Height", "number", "auto")

local function itemCount(items)
	local stacks, rem = math.floor(items / 64), items % 64
	if stacks < 1 then
		return tostring(items)
	elseif rem == 0 then
		return string.format("%i (%i stack(s))", items, stacks)
	else
		return string.format("%i (%i stack(s) and %i items)", items, stacks, rem)
	end
end

local function checkBlocks(targetHeight, descend)
	local needed = (targetHeight * 2 * (width + depth - 2))

	if item:count() < needed then
		if descend then
			digutils2.down(targetHeight - 1)
		end
		error("Not enouhg blocks: need at least " .. itemCount(needed))
	end

	checkBlocks = function() end
end

if height ~= "auto" then
	checkBlocks(height)
end

local function column()
	if height == "auto" then
		height = 1
		while turtle.up() do
			height = height + 1
			if height >= 100 then
				break
			end
		end

		up = true
		checkBlocks(height, true)
	end

	for _ = 2, height do
		item:select()
		if up then
			turtle.down()
			turtle.placeUp()
		else
			turtle.up()
			turtle.placeDown()
		end
		up = not up
	end

	turtle.back()
	item:select()
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

if (width > 1) and (depth > 1) then
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	turtle.turnLeft()

	wall(depth - 1, turtle.turnRight)
	wall(width - 1, turtle.turnRight)
	wall(depth - 1, turtle.turnRight)
	wall(width - 1, turtle.turnLeft)

	if up then
		digutils2.down(height - 1)
	end
else
	error("NYI: Both dimensions must be > 1")
end
