local digutils2 = require "digutils2"

local direction = digutils2.ask("Direction?", "string", "forward")
local length = digutils2.ask("Length", "number")
local spacing = digutils2.ask("Spacing", "number", 6)

local forward, back, place

if direction == "up" then
	forward, back, place = digutils2.up, turtle.down, turtle.placeUp
elseif direction == "down" then
	forward, back, place = digutils2.down, turtle.up, turtle.placeDown
elseif direction == "forward" then
	forward, back, place = digutils2.forward, turtle.back, turtle.place
else
	error("unknown direction: " .. direction)
end

local tnt = digutils2.item("minecraft:tnt")
forward(length)
for i = 1, length do
	back()
	if (i % spacing) == 1 then
		tnt:select()
		place()
	end
end
