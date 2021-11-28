--[[

		for i=#global.new_cranes, 1, -1 do
			if global.new_cranes[i][4] > 0 then
				global.new_cranes[i][4] = global.new_cranes[i][4] -1
			else
				game.players[1].print("insertin: " .. #global.cranes .. "cranes")
				table.insert(global.cranes, global.new_cranes[i])
				table.remove(global.new_cranes, i)
			end
		end
		--game.players[1].print("managing " .. #global.cranes .. "cranes")
				--game.players[1].print("state is: " .. state)
				if state == 1 then
					if not AtPosition(ent.held_stack_position, ent.pickup_position, 0.2) then
						state = 2
						id = UpdateAnimation(ent, state, id)
						tracker = 12
					end

				elseif state == 2 then
					tracker = tracker-1
					if tracker <= 0 then
						id = UpdateAnimation(ent, 3, id) --stop anim
						state = 5 -- wati til reached
					end

				elseif state == 3 then
					if not AtPosition(ent.held_stack_position, ent.drop_position, 0.2) then
						state = 4
						id = UpdateAnimation(ent, state, id)
						tracker = 12
					end

				elseif state == 4 then
					tracker = tracker-1
					if tracker <= 0 then
						id = UpdateAnimation(ent, 1, id) --stop anim
						state = 6 -- wati til reached
					end
				end
				if state == 5 then  -- animation finished, stil moving towards target
					if  AtPosition(ent.held_stack_position, ent.drop_position, 0.2) then
						state = 3  -- really change state
					end
				elseif state == 6 then  -- animation finished, stil moving towards pickup
					if  AtPosition(ent.held_stack_position, ent.drop_position, 0.2) then
						state = 1  -- really change state
					end
				end

				-- writing state back
				global.cranes[i][2] = state
				global.cranes[i][3] = id
				global.cranes[i][4] = tracker
			end
		]]

--[[
function UpdateAnimation(ent, state, id)
	rendering.destroy(id)
	local new_id = nil
	if (ent.direction == defines.direction.west and state == 2) or (ent.direction == defines.direction.east and state == 4) then
		new_id = rendering.draw_animation{
			animation="crane_animation_east",
			target=ent,
			surface=ent.surface}

	elseif (ent.direction == defines.direction.west and state == 3) or (ent.direction == defines.direction.east and state == 1) then
		new_id = rendering.draw_sprite{
		sprite="crane_east",
		target=ent,
		surface=ent.surface}

	elseif (ent.direction == defines.direction.west and state == 4) or (ent.direction == defines.direction.east and state == 2) then
		new_id = rendering.draw_animation{
			animation="crane_animation_west",
			target=ent,
			surface=ent.surface}

	elseif (ent.direction == defines.direction.west and state == 1) or (ent.direction == defines.direction.east and state == 3) then
		new_id = rendering.draw_sprite{
			sprite="crane_west",
			target=ent,
			surface=ent.surface}
	end
	return new_id
end
]]