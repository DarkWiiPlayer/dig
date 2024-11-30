local height = 0

while turtle.up() do
	height = height + 1
	if height >= 100 then
		break
	end
end

for _ = 1, height do
	turtle.down()
	turtle.placeUp()
end

turtle.back()
turtle.place()
