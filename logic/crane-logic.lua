

function OnCraneCreated(entity)

	game.players[1].print("plpacing crane in direction: " .. entity.direction)

	table.insert(global.cranes, {entity, true})   --(crane, hand-position, at_pickup = true)
end

function ManageCranes(e)
	if e.tick % 20 == 0 then
		--game.players[1].print("managing " .. #global.cranes .. "cranes")

		for i=#global.cranes, 1, -1 do
			crane = global.cranes[i]

			if not crane[1].valid then
				table.remove(global.cranes, i)
			else
				ent = crane[1]
				dropping_off = crane[2]

				if dropping_off then -- moving towards drop
					if CheckReached(ent.held_stack_position, ent.drop_position, 0.5) then
						--game.players[1].print("passed drop off")
						dropping_off = false
					end
				else -- moving towards pickup 
					if CheckReached(ent.held_stack_position, ent.pickup_position, 0.5) then
						--game.players[1].print("passed pick up")
						dropping_off =true
					end
				end
					
				-- writing stuff back
				crane[2] = dropping_off
				global.cranes[i] = crane
			end
		end
	end
end

function CheckReached(pos1, pos2, thresh)
	--d = math.abs(pos1.x-pos2.x) + math.abs(pos1.y-pos2.y)
	--game.players[1].print("cheging: " .. d)

	if math.abs(pos1.x-pos2.x) + math.abs(pos1.y-pos2.y) <= thresh then
		return true
	else
		return false
	end
end