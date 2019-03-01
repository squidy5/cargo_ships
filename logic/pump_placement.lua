function PumpVisualisation(e)
	local player = game.players[e.player_index]
	local stack = player.cursor_stack

	if global.pump_markers == nil then
		global.pump_markers = {}
	end

	-- if stack valid
	if stack and stack.valid_for_read then
		-- if last was pump, current is not
		if global.ship_pump_selected[e.player_index] and stack.name ~= "ship_pump" then
			RemoveVisuals(e.player_index)
			global.ship_pump_selected[e.player_index] = false

		-- if current is pump and last was not
		elseif (not global.ship_pump_selected[e.player_index]) and stack.name == "ship_pump" then
				-- initalize marker array if necessarry
			if(not global.pump_markers[e.player_index]) then
				global.pump_markers[e.player_index] = {}
			end
			AddVisuals(player.position, e.player_index)
			global.ship_pump_selected[e.player_index] = true
		end

	-- if stack empty
	elseif global.ship_pump_selected[e.player_index] then 
		RemoveVisuals(e.player_index)
		global.ship_pump_selected[e.player_index] = false
	end
end

function AddVisuals(pos, player_index)
	local new_markers = {}
	local a = {{pos.x-100, pos.y-100},{pos.x+100, pos.y+100}}
	local ports = game.surfaces[1].find_entities_filtered{area = a, name="port"}

	for _,port in pairs(ports) do
		local dir = port.direction
		if dir == defines.direction.north then
			new_markers = PlaceVisuals(port.position, 0, 1,player_index)
		elseif dir == defines.direction.south then
			new_markers = PlaceVisuals(port.position, 0, -1,player_index)
		elseif dir == defines.direction.east then
			new_markers = PlaceVisuals(port.position, 1, -1,player_index)
		elseif dir == defines.direction.west then
			new_markers = PlaceVisuals(port.position, 1, 1,player_index)
		end
		table.insert(global.pump_markers[player_index], new_markers)
	end
end

function PlaceVisuals(position, horizontal, mult, player_index)
	local markers={}
	if horizontal ~= 0 then
		for x = 5, 9, 2 do
			for y = -5, 1, 6 do 
				local pos = {position.x+x*mult, position.y-y*mult}
				local m = game.surfaces[1].create_entity {name="pump_marker", position =  pos} 
				m.render_player = game.players[player_index]
				table.insert(markers, m)
			end
		end
	else
		for y = 5, 9, 2 do
			for x = -5, 1, 6 do 
				local pos = {position.x+x*mult, position.y+y*mult}
				local m = game.surfaces[1].create_entity {name="pump_marker", position =  pos}
				m.render_player = game.players[player_index]
				table.insert(markers, m)
			end
		end
	end
	return markers
end

function RemoveVisuals(player_index)

	for _, marker_set in pairs(global.pump_markers[player_index]) do
		for _, marker in pairs(marker_set) do
			marker.destroy()
		end
	end
	-- reset gloabl to remove remenant empty marker sets
	global.pump_markers[player_index] = {}
	-- indicate selection
end


function UpdateVisuals(e)
	if e.tick % 120 == 0 then
		for _, p in pairs(game.players) do
			if global.ship_pump_selected[p.index] then
				RemoveVisuals(p.index)
				AddVisuals(p.position, p.index)
			end
		end
	end
end





