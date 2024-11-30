local direction, length = ...

if tonumber(direction) then
	length, direction = tonumber(direction), length
else
	length = tonumber(length)
end

local forward, back
if direction == "up" then
	forward, back = turtle.up, turtle.down
elseif direction == "down" then
	forward, back = turtle.down, turtle.up
elseif direction == nil or direction == "forward" then
	forward, back = turtle.forward, turtle.back
else
	error("unknown direction: " .. direction)
end

if length then
	for _ = 1, length do
		forward()
	end
else
	length = 0
	while forward() do
		length = length + 1
	end
	print("Measured " .. length .. " blocks.")
	for _ = 1, length do
		back()
	end
end
