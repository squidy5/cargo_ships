function PumpVisualisation(e)
	local player = game.players[e.player_index]
	local pos = player.position
	local stack = player.cursor_stack

	-- TODO wait for 0.17, and per player rendering
	if stack and stack.valid_for_read then
		if global.ship_pump_selected[e.player_index] and stack.name ~= "ship_pump" then
			global.ship_pump_selected[e.player_index] = false
			RemoveVisuals(e.player_index)



		elseif (not global.ship_pump_selected[e.player_index]) and stack.name == "ship_pump" then
			global.ship_pump_selected[e.player_index] = true
			local a = {{pos.x-100, pos.y-100},{pos.x+100, pos.y+100}}
			local tankers = game.surfaces[1].find_entities_filtered{area = a, name == "oil_tanker"}

			for _,tanker in pairs(tankers) do
				if tanker.train ~= nil then
					if tanker.train.state == defines.train_state.wait_station then
					AddVisuals(tanker, e.player_index)
					end
				end
			end
		end
	end
end

function AddVisuals(tanker, player_index)
	local dir = (math.floor((tanker.orientation*8)+0.5))%8
	if dir == defines.direction.north or defines.direction.south then
		game.players[1].print("north or south")
		PlaceVisuals(tanker.position, 0, 1)
	end
end

function PlaceVisuals(position, horizontal, mult)
	local markers={}
	if horizontal ~= 0 then


	else
		for y = 0, 2, 2 do
			for x = -1, 1, 2 do 
				local pos = {position.x+x, position.y+y*mult}
				local m = markker game.surfaces[1].create_entity {name="pump_marker", position =  pos} 
				table.insert(markers, m)
			end
		end
	end
	return markers
end

function RemoveVisuals(player_index)	
	global.ship_pump_selected[player_index] = false
end





