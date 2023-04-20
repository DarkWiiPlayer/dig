while true do
	for i=1, 16 do
		turtle.select(i)
		turtle.refuel()
	end
	os.sleep(.5)
end
