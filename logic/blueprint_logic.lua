function FixBlueprints(e)
  -- Handle both Copy and Blueprint operations
  local player = game.get_player(e.player_index)
  local stack = player.blueprint_to_setup
  if not (stack and stack.valid_for_read) then
    stack = player.cursor_stack
    if not (stack and stack.valid_for_read and stack.is_blueprint) then
      return
    end
	end

	local blues = stack.get_blueprint_entities()
	if blues and next(blues) then
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
