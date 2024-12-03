local digutils2 = require 'digutils2'
local junk = require 'junk'

local direction = ...

local left = turtle.turnLeft
local right = turtle.turnRight

if direction == "left" then
	left, right = right, left
end

local length = digutils2.ask("Length", "number")
local width = digutils2.ask("Width", "number")
local depth = digutils2.ask("Depth", "number")

local forward = {
	digutils2.forward,
	digutils2.forward2d,
	digutils2.forward3
}

local inventory = digutils2.everyPersistent(64, function()
	junk:drop()
	digutils2.compact()
end)

local function layer(n)
	if n < 1 then return end
	digutils2.down(n==3 and 2 or 1)
	for y=1, width do
		forward[n](length-1, inventory)
		if y < width then
			local turn = (y % 2 == 1) and right or left
			turn()
			forward[n]()
			turn()
		end
	end
	if n > 1 then
		digutils2.down()
	end
end

for _ = 3, depth, 3 do
	layer(3)
	right()
	if width % 2 == 0 then
		forward[1](width-1)
	end
	right()
end

layer(depth % 3)

digutils2.up(depth)
