function FixBlueprints(e)
	local stack = game.players[e.player_index].cursor_stack
	if not(stack and stack.valid_for_read and stack.is_blueprint) then
		return
	end

	local blues = stack.get_blueprint_entities()
	if blues ~= nil then
		local ww = false
		for i,blue in pairs(blues) do
			if blue.name == "straight-water-way-placed" then
				blue.name = "straight-water-way"
				ww=true
			elseif blue.name == "curved-water-way-placed" then
				blue.name = "curved-water-way"
				ww=true
			end
		end
		if(ww) then
			stack.set_blueprint_entities(blues)  
		end
	end
end