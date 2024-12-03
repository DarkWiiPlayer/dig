local digutils2 = require 'digutils2'
local junk = require 'junk'

local direction = ...

--- Turns 90 degrees to the left
--- @type fun()
local left = turtle.turnLeft

--- Turns 90 degrees to the right
--- @type fun()
local right = turtle.turnRight

if direction == "left" then
	left, right = right, left
end

--- @param a boolean
--- @param b boolean
--- @return boolean
local function xor(a, b)
	return (a or b) and not (a and b)
end

--- @type number
local length = digutils2.ask("Length", "number")
--- @type number
local width = digutils2.ask("Width", "number")
--- @type number
local height = digutils2.ask("Height", "number")

--- @type fun(distance: number, callback: fun())[]
local forward = {
	digutils2.forward,
	digutils2.forward2d,
	digutils2.forward3
}

--- What height the turtle will be at after finishing a layer
--- @type number
local stopheight = (height % 3) == 0 and height-1 or height

local inventory = digutils2.everyPersistent(64, function()
	junk:drop()
	digutils2.compact()
end)

local function wall()
	for z=3, height, 3 do
		digutils2.up()
		forward[3](width-1, inventory)
		if z < height then
			digutils2.up(2, inventory)
		end
		if z < height then
			right() right()
		end
	end
	local rem = height % 3
	if rem > 0 then
		digutils2.up(rem-1)
		forward[rem](width-1, inventory)
	end
	digutils2.down(stopheight-1)
end

digutils2.forward()

-- Optimisation to reduce turns
if length > width then
	left, right = right, left
	width, length = length, width
else
	right()
end

--- Digging a wall leaves you above starting point
--- @type boolean
local even_height = math.ceil(height/3) % 2 == 0

--- The number of walls to dig is even
--- @type boolean
local even_length = length % 2 == 0

--- @type boolean
local same_final_side = xor(even_height, even_length)

for x = 1, length do
	wall()
	local turn = (even_height or x % 2 == 0) and right or left
	if x < length then
		turn()
		digutils2.forward()
		turn()
	else
		if not same_final_side then
			left()
			left()
			digutils2.forward(width)
		end
		left()
		digutils2.forward(length)
	end
end
