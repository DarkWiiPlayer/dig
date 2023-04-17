local digutils2 = require 'digutils2'
local junk = require 'junk'

local direction = ...

local left = turtle.turnLeft
local right = turtle.turnRight

if direction == "left" then
	left, right = right, left
end

local branches = digutils2.ask("Branches", "number")
local length = digutils2.ask("Length", "number")

if turtle.detectDown() then
	digutils2.up(1)
end

for i=1, branches do
	local fuel = turtle.getFuelLevel()
	if i%2==1 and fuel < length*4 then
		digutils2.refuel(length*4)
	end
	digutils2.forward3(length, digutils2.every(6, digutils2.torchDown), digutils2.every(16, digutils2.compact))
	junk:drop()
	if i < branches then
		if i%2 == 1 then
			right()
			digutils2.forward3(3)
			right()
		else
			left()
			digutils2.forward3(3)
			left()
		end
	elseif branches%2 == 1 then
		left()
		left()
		digutils2.forward(length)
	end
end

right()
digutils2.forward3(3 * (branches - 1))

junk:drop()
digutils2.compact()
