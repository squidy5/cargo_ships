
function CreateBridge(ent, player_index)
	--game.players[1].print(ent.direction)

	local pos = ent.position
	local dir = ent.direction
	local f = ent.force
	local bridge 
	local closed_bridge 
	local ver, hor, x, y
	ent.destroy()

	if dir == defines.direction.north then
		if checkBridgePlacement(pos, -4.5,-3,6.5,3, player_index) then
			bridge = game.surfaces[1].create_entity {name="bridge_north", position =  pos,  force = f} 
			closed_bridge = game.surfaces[1].create_entity {name="bridge_north_closed", position =  pos,  force = f} 
			game.surfaces[1].create_entity {name="bridge_north_clickable", position =  pos,  force = f} 
			ver = 1
			hor = 0
		end
	end
	if dir == defines.direction.east then
		if checkBridgePlacement(pos, -3,-4.5,3,6.5, player_index) then
			bridge = game.surfaces[1].create_entity {name="bridge_east", position =  pos,  force = f} 
			closed_bridge = game.surfaces[1].create_entity {name="bridge_east_closed", position =  pos,  force = f}
			game.surfaces[1].create_entity {name="bridge_east_clickable", position =  pos,  force = f} 

			ver = 0
			hor = 1
		end
	end
	if dir == defines.direction.south then
		if checkBridgePlacement(pos, -6.5,-3,4.5,3, player_index) then
			bridge = game.surfaces[1].create_entity {name="bridge_south", position =  pos,  force = f} 
			closed_bridge = game.surfaces[1].create_entity {name="bridge_south_closed", position =  pos,  force = f} 
			game.surfaces[1].create_entity {name="bridge_south_clickable", position =  pos,  force = f} 

			ver = -1
			hor = 0
		end
	end
	if dir == defines.direction.west then
		if checkBridgePlacement(pos, -3,-6.5,3,4.5, player_index) then
			bridge = game.surfaces[1].create_entity {name="bridge_west", position =  pos,  force = f} 
			closed_bridge = game.surfaces[1].create_entity {name="bridge_west_closed", position =  pos,  force = f}
			game.surfaces[1].create_entity {name="bridge_west_clickable", position =  pos,  force = f} 
 
			ver = 0
			hor = -1
		end
	end

	if(bridge and closed_bridge) then
		bridge.destructible = false
		closed_bridge.destructible = false
		local s1,s2,s3,s4, s5, s6
		s1, s2, s3, s4, s5, s6 = createSlaves(pos, dir, hor, ver, f)

		table.insert(global.bridges, {bridge, closed_bridge, nil, s1, s2,s3, s4, s5,s6 ,0})
	end	
end

function checkBridgePlacement(pos,x1,y1,x2,y2, player_index, delete)
	local valid = true
	local entities = game.surfaces[1].find_entities({{pos.x+x1, pos.y+y1},{pos.x+x2, pos.y+y2}})--{{pos.x-5, pos.y-3},{pos.x+7, pos.y+3}})--
	local counter = 0
	for _,ent in pairs(entities) do
		if (not (ent.name == "fish" or ent.name == "bridge_base")) then
			counter = counter+1
			if (ent.name ~= "straight-water-way-placed" or counter > 3) then
				valid = false
				break
			end
		end
	end
	--game.players[1].print(counter)
	if not valid then
		if player_index then
			game.players[player_index].print("Bridges must be placed along straight stretches of waterways with sufficient space to all sides!")
			game.players[player_index].insert{name="bridge_base", count=1}
		end
	else
		for _,ent in pairs(entities) do
			if (not (ent.name == "fish" or ent.name == "bridge_base")) then
				game.players[player_index].insert{name="water-way", count=1}
				ent.destroy()
			end
		end	
	end
	return valid
end

function createSlaves(pos, dir, hor, ver, f)
	local x, y, s1, s2, s3, s4, s5, s6, shift_x , shift_y
	shift_y = 0
	shift_x = 0
	-- spawn waterway part of bridge, including signals
	for s=-2,2,2 do
		x=s*hor - 2*ver
		y=s*ver - 2*hor
		p = {pos.x+x, pos.y+y}

		addEntity(p, dir, "bridge_crossing", f)
		shift_x = (x==-2 and hor~=0) and -1 or 0
		shift_y = (y==-2 and ver~=0) and -1 or 0
		if(s == -2) then
			p = {pos.x+x+1.5*ver+shift_x, pos.y+y+1.5*hor+shift_y}
			s1 = addEntity(p,(dir+4)%8, "invisible_chain_signal", f)
			p = {pos.x+x-1.5*ver+shift_x, pos.y+y-1.5*hor+shift_y}
			s5 = addEntity(p, dir, "invisible_chain_signal", f)
		end

		if(s == 2) then
			p = {pos.x+x+1.5*ver+shift_x, pos.y+y+1.5*hor+shift_y}
			s6 = addEntity(p,(dir+4)%8, "invisible_chain_signal", f)
			p = {pos.x+x-1.5*ver+shift_x, pos.y+y-1.5*hor+shift_y}
			s2 = addEntity(p, dir, "invisible_chain_signal", f)
		end
	end

	-- spawn rail part of bridge, including signals
	for l=-4,6,2 do
		x = l*ver
		y = l*hor
		p = {pos.x+x, pos.y+y}
		addEntity(p, (dir+2)%4, "invisible_rail", f)	

		if(l == -4) then
			p = {pos.x+x+1.5*hor, pos.y+y-1.5*ver}
			s3 = addEntity(p,(dir+2)%8, "invisible_chain_signal", f)
			p = {pos.x+x-1.5*hor, pos.y+y+1.5*ver}
			addEntity(p, (dir-2)%8, "invisible_chain_signal", f)
		end
		if(l == 6) then
			p = {pos.x+x+1.5*hor, pos.y+y-1.5*ver}
			addEntity(p,(dir+2)%8, "invisible_chain_signal", f)
			p = {pos.x+x-1.5*hor, pos.y+y+1.5*ver}
			s4 = addEntity(p, (dir-2)%8, "invisible_chain_signal", f)
		end
	end
	return s1,s2,s3,s4,s5,s6
end

function addEntity(pos, dir, n, f)
	tokill = game.surfaces[1].find_entities_filtered{position = pos, name ={"straight-water-way-placed","curved-water-way-placed", "straight-rail", "curved-rail"}}
	for _,k in pairs(tokill) do
		k.destroy()
	end
	
	local slave = game.surfaces[1].create_entity{name=n , position = pos, direction = dir, force = f}
	if(slave) then
		slave.destructible = false
	end
	return slave
end


function DeleteBridge(ent)
	local pos = ent.position
	local name = ent.name
	if name == "bridge_north_clickable" then
		deleteSlaves(pos, -5,-3,7,3, "north")
	end
	if name == "bridge_east_clickable"then
		deleteSlaves(pos, -3,-5,3,7, "east")
	end
	if name == "bridge_south_clickable" then
		deleteSlaves(pos, -7,-3,5,3, "south")
	end
	if name == "bridge_west_clickable" then
		deleteSlaves(pos, -3,-7,3,5, "west")
	end	

end

function deleteSlaves(pos, x1, y1, x2, y2, dirname)
	local entities = game.surfaces[1].find_entities({{pos.x+x1, pos.y+y1},{pos.x+x2, pos.y+y2}})
	for _,ent in pairs(entities) do
		n = ent.name
		if n== "invisible_chain_signal" or 
		n== "invisible_signal" or 
		n == "invisible_rail" or
		n == "bridge_" .. dirname or
		n == "bridge_" .. dirname .. "_closed" or
		n == "bridge_" .. dirname .. "_open" then
			ent.destroy()
		elseif n == "bridge_crossing" then
			local p = ent.position
			local d = ent.direction
			local f = ent.force
			ent.destroy()
			game.surfaces[1].create_entity{name = "straight-water-way-placed", direction = d, position = p, force = f}
		end

	end
end

local animation_time = 7


function ManageBridges(e)
	if e.tick % 6 == 0 then
		for i=#global.bridges, 1, -1 do
			local entry = global.bridges[i]
			if not entry[1].valid then
				table.remove(global.bridges, i)
			else

				----------------------------------------------
				-------------process slow change 
				----------------------------------------------
				if entry[10] > 0 then
					entry[10] = entry[10]-1

					if entry[1].power_switch_state == false and entry[10]==0 then--closing?
						entry[2] = game.surfaces[1].create_entity{name=entry[1].name .. "_closed", position = entry[1].position, force = entry[1].force}
						entry[2].destructible = false
					elseif entry[1].power_switch_state == true and entry[10] == animation_time -1 then
						if entry[2].valid then
							entry[2].destroy()
						end
					end
				

				----------------------------------------------
				-------------check signal reservations
				----------------------------------------------
				else
					if entry[1].power_switch_state == false then -- bridge closed ? 
						--game.players[1].print("bridge " .. i .. "is closed")
						if entry[4].signal_state == defines.signal_state.reserved or
						entry[5].signal_state == defines.signal_state.reserved then -- reserved by ship?
							-- open bridge --
							entry[1].power_switch_state = true
							entry[10] = animation_time - entry[10]	
							--entry[3] = game.surfaces[1].create_entity{name=entry[1].name .. "_open", position = entry[1].position, force = entry[1].force}
							--entry[3].destructible = false
						end
					else  										-- bridge open?
						if	((entry[8].signal_state == defines.signal_state.open or entry[9].signal_state == defines.signal_state.open)
							and entry[4].signal_state ~= defines.signal_state.reserved and entry[5].signal_state ~= defines.signal_state.reserved) or 
							entry[6].signal_state == defines.signal_state.reserved or
							entry[7].signal_state == defines.signal_state.reserved then -- no ships or reserved by train?
							-- close bridge --
							entry[1].power_switch_state = false
							entry[10] = animation_time - entry[10]
							--[[if entry[3].valid then
								entry[3].destroy()
							end
							]]
						end
					end
				end
			end
		end
	end
end
