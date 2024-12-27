local digutils2 = require 'digutils2'

local select = digutils2.rememberItem()

local function column()
	local height = 0

	while turtle.up() do
		height = height + 1
		if height >= 100 then
			break
		end
	end

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

local width = digutils2.ask("Width", "number")
local length = digutils2.ask("Length", "number", width)

if (width > 2) and (length > 2) then
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	turtle.turnLeft()

	wall(length - 1, turtle.turnRight)
	wall(width - 1, turtle.turnRight)
	wall(length - 1, turtle.turnRight)
	wall(width -1, turtle.turnLeft)
else
	error("NYI: Both dimensions must be > 2")
end
