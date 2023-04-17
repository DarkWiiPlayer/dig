local files = {
	-- Libraries
	"digutils2",
	"junk",
	-- Executables
	"branch",
	"install",
	"quarry",
	"room",
}

local function moduleuri(module)
	return "https://darkwiiplayer.github.io/dig/"..module..".lua"
end

local function get(uri, file)
	print("Installing "..file..".lua")
	local response, reason = http.get(uri)
	if response then
		local out = assert(io.open(file, "w"))
		out:write(response:readAll())
		out:close()
	else
		error("Error downloading file: " .. reason)
	end
end

if not os.getComputerLabel() then
	print "Computer has no label!"
	io.write "Set label (empty to abort): "
	local label = io.read()
	if #label > 0 then
		os.setComputerLabel(label)
	else
		print("Aborting...")
		return 1
	end
end

if not fs.isDir("/dig") then
	fs.makeDir("/dig")
end

for _, file in ipairs(files) do
	get(moduleuri(file), "/dig/"..file..".lua")
end
