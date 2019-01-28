
function CreateBridge(ent)
	game.players[1].print(ent.direction)


	local pos = ent.position
	local dir = ent.direction
	local bridge
	local closed_bridge
	local ver, hor, x, y
	if dir == defines.direction.north then
		bridge = ent.surface.create_entity {name="bridge_north", position =  pos,  force = ent.force} 
		closed_bridge = ent.surface.create_entity {name="bridge_north_closed", position =  pos,  force = ent.force} 
		ver = 1
		hor = 0
	end
	if dir == defines.direction.east then
		bridge = ent.surface.create_entity {name="bridge_east", position =  pos,  force = ent.force} 
		closed_bridge = ent.surface.create_entity {name="bridge_east_closed", position =  pos,  force = ent.force}
		ver = 0
		hor = 1
	end
	if dir == defines.direction.south then
		bridge = ent.surface.create_entity {name="bridge_south", position =  pos,  force = ent.force} 
		closed_bridge = ent.surface.create_entity {name="bridge_south_closed", position =  pos,  force = ent.force} 
		ver = -1
		hor = 0
	end
	if dir == defines.direction.west then
		bridge = ent.surface.create_entity {name="bridge_west", position =  pos,  force = ent.force} 
		closed_bridge = ent.surface.create_entity {name="bridge_west_closed", position =  pos,  force = ent.force} 
		ver = 0
		hor = -1
	end
	createSlaves(pos, dir, hor, ver, ent.force)
	
	if(bridge and closed_bridge) then
		table.insert(global.bridges, {bridge, bridge.power_switch_state,0,closed_bridge})
	end

	-- destroy bridge dummy
	ent.destroy()
end

function createSlaves(pos, dir, hor, ver, f)
	local x, y
	for l=-4,6,2 do
		x = l*ver
		y = l*hor
		p = {pos.x+x, pos.y+y}
		addRail(p, (dir+2)%4, "invisible_rail")
	end
	for s=-2,2,2 do
		x=s*hor - 2*ver
		y=s*ver - 2*hor
		p = {pos.x+x, pos.y+y}
		addRail(p, dir, "bridge_crossing")

	end
end

function addRail(pos, dir, n, f)
	tokill = game.surfaces[1].find_entities_filtered{position = pos, name ={"straight-water-way","curved-water-way", "straight-rail", "curved-rail"}}
	for _,k in pairs(tokill) do
		k.destroy()
	end
	local slave = game.surfaces[1].create_entity{name=n , position = pos, direction = dir, force = f}
	if(slave) then
		slave.destructible = false
	end
end









local animation_time = 8

function ManageBridges(e)
	if e.tick % 8 == 0 then
		for i, entry in pairs(global.bridges) do
			if entry ~= nil then
				if(entry[1].power_switch_state ~= entry[2]) then --  state has switched
					entry[2] = not entry[2] -- save new state
					entry[3] = animation_time - entry[3] -- start countdown
					game.players[1].print(entry[2])
				end
				if entry[3]>0 then  -- active countdown
					entry[3] = entry[3]-1 -- count down coundown
					if entry[2] and entry[3]<animation_time-1 and entry[4] then -- opening...
						entry[4].destroy()
						entry[4] = nil
					elseif not entry[2] and entry[3]<=0 and not entry[4] then -- closing
						-- create closed version of bridge
						entry[4] =  entry[1].surface.create_entity{name=entry[1].name .. "_closed",
						 							position =  entry[1].position,  force = entry[1].force} 
					end
					
				end
			end
		end
	end
end