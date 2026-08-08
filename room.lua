local digutils2 = require 'digutils2'
local junk = require 'junk'

--- Turns 90 degrees to the left
--- @type fun()
local left = turtle.turnLeft

--- Turns 90 degrees to the right
--- @type fun()
local right = turtle.turnRight

local up = digutils2.up
local down = digutils2.down

local args = {...}

for _, arg in ipairs(args) do
	if arg == "left" then
		left, right = right, left
	end

	if arg == "down" then
		up, down = down, up
	end
end

--- @type number
local length = tonumber(digutils2.ask("Length", "number")) or error("Number expected")
--- @type number
local width = tonumber(digutils2.ask("Width", "number")) or error("Number expected")
--- @type number
local height = tonumber(digutils2.ask("Height", "number")) or error("Number expected")

--- @type fun(distance: number|nil, callback: fun()|nil)[]
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
		up()
		forward[3](width-1, inventory)
		if z < height then
			up(2, inventory)
		end
		if z < height then
			right() right()
		end
	end
	local rem = height % 3
	if rem > 0 then
		up(rem-1)
		forward[rem](width-1, inventory)
	end
	down(stopheight-1)
end

digutils2.forward()

--- Whether the room layout has been mirrored to save turns
--- @type boolean
local inverted = false

-- Optimisation to reduce turns
if length > width then
	left, right = right, left
	width, length = length, width
	inverted = true
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
local same_final_side = even_height or even_length
-- Note: This isn't an xor:
-- When the height is "even", the turtle is back at x=0 after
-- every wall.

for x = 1, length do
	wall()
	local turn = (even_height or x % 2 == 0) and right or left
	if x < length then
		turn()
		forward[1]()
		turn()
	else
		if not same_final_side then
			left()
			left()
			forward[1](width-1)
		end
		left()
		forward[1](length-1)
		if inverted then right() end
		forward[1]()
	end
end
