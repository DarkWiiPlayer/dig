local digutils2 = {}

local function match(detail, pattern, exact)
	if type(pattern) == "table" then
		return pattern[detail.name] and true or false
	elseif exact then
		return pattern == detail.name
	else
		return detail.name:match(pattern) and true or false
	end
end

--- Applies a function to all items matching a pattern.
-- @paam pattern A pattern or exact string to match item names against. Can also be a set of exact item names.
-- @tparam function func A function to run on every matching item.
-- @tparam[opt=false] bool exact Disable pattern matching and require exact item name match.
function digutils2.match(pattern, func, exact)
	for i=1, 16 do
		local detail = turtle.getItemDetail(i)
		if detail then
			if match(detail, pattern, exact) then
				turtle.select(i)
				func(i, detail)
			end
		end
	end
end

--- Applies a function to all items matching a pattern.
-- Selects the first matching slot and returns its index and item information.
-- When a function is provided, it is tail-called with these values instead.
-- @param pattern A pattern or exact string to match item names against. Can also be a set of exact item names.
-- @tparam[opt] function func A function to run on every matching item.
-- @tparam[opt=false] bool exact Disable pattern matching and require exact item name match.
function digutils2.first(pattern, func, exact)
	for i=1, 16 do
		local detail = turtle.getItemDetail(i)
		if detail then
			if match(detail, pattern, exact) then
				turtle.select(i)
				if func then
					return func(i, detail)
				else
					return i, detail
				end
			end
		end
	end
end

--- Runs a function for every filled slot in the turtle's inventory.
-- @tparam function func A function that gets called with the slot index and item detail.
function digutils2.each(func)
	for i=1, 16 do
		local detail = turtle.getItemDetail(i)
		if detail then
			turtle.select(i)
			func(i, detail)
		end
	end
end

function digutils2.forward(distance, ...)
	for i=1, distance or 1 do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.up(distance, ...)
	for i=1, distance or 1 do
		while not turtle.up() do
			turtle.digUp()
			turtle.attackUp()
		end
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.down(distance, ...)
	for i=1, distance or 1 do
		while not turtle.down() do
			turtle.digDown()
			turtle.attackDown()
		end
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.forward2u(distance, ...)
	turtle.digUp()
	for i=1, distance or 1 do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
		turtle.digUp()
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.forward2d(distance, ...)
	turtle.digDown()
	for i=1, distance or 1 do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
		turtle.digDown()
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.forward3(distance, ...)
	turtle.digUp()
	turtle.digDown()
	for i=1, distance or 1 do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
		turtle.digUp()
		turtle.digDown()
		for _, func in ipairs{...} do
			func(i, distance)
		end
	end
end

function digutils2.refuel()
	-- TODO: Write actual refuelling routine
	error("Not enough fuel!")
end

--- Tries placing down a torch at the current position.
-- If there are no torches in the inventory, nothing happens.
function digutils2.torchDown()
	for i=1,16 do
		local info = turtle.getItemDetail(i)
		if info and info.name == "minecraft:torch" then
			turtle.select(i)
			turtle.placeDown()
			return
		end
	end
end

function digutils2.every(n, func)
	if func==nil then
		error("Argument #2 missing: Expected function or callable", 2)
	end
	return function(i)
		if i % n == 0 then
			func()
		end
	end
end

local function compact(i)
	local current = turtle.getItemDetail(i)
	turtle.select(i)
	if current then
		for j=1, i do
			local target = turtle.getItemDetail(j)
			if target and target.name == current.name then
				turtle.transferTo(j)
			end
		end
	end
end

function digutils2.compact()
	digutils2.each(compact)
end

function digutils2.ask(prompt, t)
	io.write(prompt, ": ")
	local input = io.read()
	if t == nil then
		return input
	elseif t == "string" then
		return input
	elseif t == "number" then
		local num = tonumber(input)
		if num then
			return num
		else
			print "Please enter a valid number!"
			return digutils2.ask(prompt, t)
		end
	end
end

return digutils2
