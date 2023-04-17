local junk = {
	"minecraft:andesite",
	"minecraft:cobbled_deepslate",
	"minecraft:cobblestone",
	"minecraft:diorite",
	"minecraft:dirt",
	"minecraft:flint",
	"minecraft:granite",
	"minecraft:gravel",
	"minecraft:sand",
	"minecraft:tuff",
}

for key, value in ipairs(junk) do
	junk[value] = key
end

function junk:drop()
	for i=1, 16 do
		local detail = turtle.getItemDetail(i)
		if detail and self[detail.name] then
			turtle.select(i)
			turtle.dropDown()
		end
	end
end

return junk
