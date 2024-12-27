local digutils2 = {}

--- @class Item
--- @field name string
--- @overload fun(init: string|{name: string}|nil):Item
local Item = setmetatable({}, {__call = function(self, init)
	if type(init) == "table" then
		if not init.name then
			error("Item must have a name")
		end
	elseif type(init) == "string" then
		init = {name = init}
	elseif type(init) == "number" and (1 <= init) and (init <= 16) then
		init = turtle.getItemDetail(init)
		if not init then
			error("No item in current slot")
		end
	else
		init = turtle.getItemDetail()
		if not init then
			error("No item in current slot")
		end
	end
	init.count = nil

	--- @cast self table
	return setmetatable(init, self)
end})
Item.__index = Item

function Item:match(detail)
	return detail and (self.name == detail.name)
end

--- Counts how many items of this type are in the inventory
--- @return number
function Item:count()
	local count = 0
	for i = 1, 16 do
		local detail = turtle.getItemDetail(i)
		if detail and self:match(detail) then
			count = count + detail.count
		end
	end
	return count
end

--- Tries to select this type of item in the inventory
function Item:select()
	local item = turtle.getItemDetail()
	if item and item.name == self.name then
		return true
	else
		for number = 1, 16 do
			local current = turtle.getItemDetail(number)
			if current and current.name == self.name then
				turtle.select(number)
				return true
			end
		end
		return nil, "Could not find item in inventory: " .. self.name
	end
end

digutils2.item = Item

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

local torch = Item("minecraft:torch")

--- Tries placing down a torch at the current position.
-- If there are no torches in the inventory, nothing happens.
function digutils2.torchDown()
	if torch:select() then
		turtle.placeDown()
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

function digutils2.everyPersistent(n, func)
	if func==nil then
		error("Argument #2 missing: Expected function or callable", 2)
	end
	local counter = 0
	return function()
		counter = counter + 1
		if counter % n == 0 then
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

function digutils2.ask(prompt, t, default)
	if default then
		io.write(("%s [%s]: "):format(prompt, tostring(default)))
	else
		io.write(prompt, ": ")
	end
	local input = io.read()

	if default and input == "" then
		return default
	end

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
