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

local function layer(n)
	digutils2.down(n==3 and 2 or 1)
	for y=1, width do
		forward[n](length-1)
		if y < width then
			local turn = y%2==1 and right or left
			turn()
			forward[n]()
			turn()
		end
	end
	junk:drop()
	digutils2.compact()
	digutils2.down()
end

for _=3, depth, 3 do
	layer(3)
	right()
	if width % 2 == 1 then
		right()
	end
end

local rem = depth % 3
if rem > 0 then
	layer(depth % 3)
end

digutils2.up(depth+1)
