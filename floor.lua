local digutils2 = require 'digutils2'

local item = digutils2.item()

local a, b

local function place()
	item:select(true)
	digutils2.replaceDown(false)
end

local function measure()
	local n = 1
	while turtle.forward() do
		n = n + 1
		place()
	end
	return n
end

local function line(n)
	for _ = 1, n do
		digutils2.forward(1)
		place()
	end
end

place()

b = measure()
turtle.turnRight()
a = measure()
turtle.turnRight()

local needed = (a-1) * (b-1)

local count = item:count()
if count < needed then
	digutils2.printf("Not enough items, need %i but only found %i", needed, count)
	print("Press [ENTER] to continue")
	local _ = io.read()
end

while b > 1 do
	a, b = b - 1, a
	line(a)
end
