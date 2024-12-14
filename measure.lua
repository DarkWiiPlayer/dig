local direction, length = ...

if tonumber(direction) then
	length, direction = tonumber(direction), length
else
	length = tonumber(length)
end

local forward, back, dig
if direction == "up" then
	forward, back, dig = turtle.up, turtle.down, turtle.digUp
elseif direction == "down" then
	forward, back, dig = turtle.down, turtle.up, turtle.digDown
elseif direction == nil or direction == "forward" then
	forward, back, dig = turtle.forward, turtle.back, turtle.dig
else
	error("unknown direction: " .. direction)
end

if length then
	for _ = 1, length - 1 do
		dig()
		forward()
	end
else
	length = 1
	while forward() do
		length = length + 1
	end
	print("Measured " .. length .. " blocks.")
	for _ = 1, length - 1 do
		back()
	end
end
