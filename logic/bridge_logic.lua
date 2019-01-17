
function CreateBridge(ent)
	game.players[1].print(ent.direction)

	local pos = ent.position
	local dir = ent.direction
	local bridge
	local closed_bridge

	if (dir==defines.direction.south) then
--		game.players[1].print("blubb")
		bridge = ent.surface.create_entity {name="bridge_south", position =  pos,  force = ent.force} 
		closed_bridge = ent.surface.create_entity {name="bridge_south_closed", position =  pos,  force = ent.force} 
		for x=-6,4,2 do
			ent.surface.create_entity{name="invisible_rail" , position = {pos.x+x, pos.y}, 
				direction = defines.direction.east, force = ent.force}
		end

	end
	--[[
	if (dir==defines.direction.south or dir==defines.direction.south) then
		for y=-2,2,1 do
			ent.surface.create_entity{name="straight-water-way", position =  {pos.x,pos.y + y}, direction = dir, force = ent.force} 
		end

	else 
		for x=-2,2,1 do
			ent.surface.create_entity{name="straight-water-way", position = {pos.x+x,pos.y}, direction = dir, force = ent.force} 
		end 
	end
	]]
	table.insert(global.bridges, {bridge, bridge.power_switch_state,0,closed_bridge})

	ent.destroy()
end


animation_time = 8

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