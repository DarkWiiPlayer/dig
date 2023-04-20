function f(t)
	t.fields = {}
	for _, name in ipairs(t) do
		t.fields[name] = {}
	end
	return t
end

stds.computercraft = {
	read_globals = {
		turtle = f{
			'attack',
			'attackDown',
			'attackUp',
			'detectDown',
			'dig',
			'digDown',
			'digUp',
			'down',
			'dropDown',
			'forward',
			'getFuelLevel',
			'getItemDetail',
			'placeDown',
			'refuel',
			'select',
			'transferTo',
			'turnLeft',
			'turnRight',
			'up',
		},
		http = f{
			'get',
		},
		os = f{
			'getComputerLabel',
			'setComputerLabel',
			'sleep',
		},
		fs = f{
			'isDir',
			'makeDir',
		},
	}
}

std = "min+computercraft"
