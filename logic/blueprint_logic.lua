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

function FixPipette(e)
	-- Pipetting engine or rail boat doesn't work
	local item = e.item
	if item and item.valid then
		local player = game.players[e.player_index]
		local cursor = player.cursor_stack
		if item.name == "cargo_ship_engine" then
			-- not allowed to get these, from inventory or otherwise
			cursor.clear()
		elseif item.name == "indep-boat" or item.name == "boat_engine" then
			-- The following logic copied from Robot256Lib.
			if cursor.valid_for_read == true and e.used_cheat_mode == false then
				-- Give boat to replace boat parts that player accidentally had in inventory (when not in cheat mode)
				cursor.set_stack{name="boat", count=cursor.count}
			else
				-- Check for boat in inventory
				local inventory = player.get_main_inventory()
				local new_stack = inventory.find_item_stack("boat")
				cursor.set_stack(new_stack)  -- Set cursor with inventory contents OR clear it if none available
				if not cursor.valid_for_read then
					if player.cheat_mode==true then
						-- If none in inventory and cheat mode enabled, give stack of correct items
						cursor.set_stack{name="boat", count=game.item_prototypes["boat"].stack_size}
					end
				else
					-- Found items in inventory. Remove it from inventory now that it is in the cursor.
					inventory.remove(new_stack)
				end
			end
		elseif item.name == "bridge_north_clickable" or item.name == "bridge_east_clickable" or 
		       item.name == "bridge_south_clickable" or item.name == "bridge_west_clickable" then
			if cursor.valid_for_read == true and e.used_cheat_mode == false then
				-- Give bridge to replace bridge parts that player accidentally had in inventory (when not in cheat mode)
				cursor.set_stack{name="bridge_base", count=cursor.count}
			else
				-- Check for boat in inventory
				local inventory = player.get_main_inventory()
				local new_stack = inventory.find_item_stack("bridge_base")
				cursor.set_stack(new_stack)  -- Set cursor with inventory contents OR clear it if none available
				if not cursor.valid_for_read then
					if player.cheat_mode==true then
						-- If none in inventory and cheat mode enabled, give stack of correct items
						cursor.set_stack{name="bridge_base", count=game.item_prototypes["bridge_base"].stack_size}
					end
				else
					-- Found items in inventory. Remove it from inventory now that it is in the cursor.
					inventory.remove(new_stack)
				end
			end
		end
	end
end
