local digutils2 = require 'digutils2'
--local junk = require 'junk'

local direction = ...

local left = turtle.turnLeft
local right = turtle.turnRight

if direction == "left" then
	left, right = right, left
end

local length = digutils2.ask("Length", "number")
local width = digutils2.ask("Width", "number")
local height = digutils2.ask("Height", "number")

digutils2.forward()

-- Optimisation to reduce turns
if length > width then
	right()
	left, right = right, left
	width, length = length, width
end

local forward = {
	digutils2.forward,
	digutils2.forward2d,
	digutils2.forward3
}

local stopheight = (height % 3) == 0 and height-1 or height

local function wall()
	for z=3, height, 3 do
		digutils2.up()
		forward[3](width-1)
		if z < height then
			digutils2.up(2)
		end
		if z < height then
			right() right()
		end
	end
	local rem = height % 3
	if rem > 0 then
		digutils2.up(rem-1)
		forward[rem](width-1)
	end
	digutils2.down(stopheight-1)
end

local even = math.ceil(height/3) % 2 == 0

right()

for x=1, length do
	wall()
	local turn = (even or x%2==0) and right or left
	if x < length then
		turn()
		digutils2.forward()
		turn()
	else
		((even or x%2==0) and left or right)()
		digutils2.forward(length)
	end
end
