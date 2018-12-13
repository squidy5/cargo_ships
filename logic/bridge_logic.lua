
function CreateBridge(ent)
	pos = ent.position
	dir = ent.direction
	if (dir==defines.direction.east) then
		bridge = ent.surface.create_entity {name="bridge_east", position =  pos,  force = ent.force} 
		for x=-6,6,2 do
			ent.surface.create_entity{name="invisible_rail" , position = {pos.x+x, pos.y}, 
				direction = dir, force = ent.force}
		end
		for y = -4,4,2 do
			ent.surface.create_entity{name="invisible_rail" , position = {pos.x+2, pos.y + y}, 
				direction = defines.direction.north, force = ent.force}
		end
		local sig1, sig2, sig3, sig4
--[[
		-- create waterway ship signals
		sig1 = ent.surface.create_entity{name="invisible_signal" , position = {pos.x+3.5, pos.y - 1.5},
				direction = defines.direction.south, force = ent.force} 
		sig2 = ent.surface.create_entity{name="invisible_signal" , position = {pos.x+0.5, pos.y + 2.5},
				direction = defines.direction.north, force = ent.force}
		ent.surface.create_entity{name="invisible_chain_signal" , position = {pos.x+0.5, pos.y - 1.5},
				direction = defines.direction.north, force = ent.force} 
		ent.surface.create_entity{name="invisible_chain_signal" , position = {pos.x+3.5, pos.y + 2.5},
				direction = defines.direction.south, force = ent.force}

		-- create bridge train signals
		sig3 = ent.surface.create_entity{name="invisible_signal" , position = {pos.x-5, pos.y - 2},
				direction = defines.direction.east, force = ent.force} 
		sig4 = ent.surface.create_entity{name="invisible_signal" , position = {pos.x+5, pos.y + 1},
				direction = defines.direction.west, force = ent.force}
		ent.surface.create_entity{name="invisible_chain_signal" , position = {pos.x-5, pos.y +1},
				direction = defines.direction.west, force = ent.force} 
		ent.surface.create_entity{name="invisible_chain_signal" , position = {pos.x+5, pos.y -2},
				direction = defines.direction.east, force = ent.force}

		table.insert(global.bridges, {bridge, sig1, sig2, sig3, sig4})
]]
	end
	--[[
	if (dir==defines.direction.north or dir==defines.direction.south) then
		for y=-2,2,1 do
			ent.surface.create_entity{name="straight-water-way", position =  {pos.x,pos.y + y}, direction = dir, force = ent.force} 
		end

	else 
		for x=-2,2,1 do
			ent.surface.create_entity{name="straight-water-way", position = {pos.x+x,pos.y}, direction = dir, force = ent.force} 
		end 
	end
	]]
end


function ManageBridges(e)
--[[	if e.tick % 10 == 0 then
		for i, entry in pairs(global.bridges) do
			if entry ~= nil then
				local bridge = entry[1]
				local sig1 = entry[2]
				local sig2 = entry[3]
				local sig3 = entry[4]
				local sig4 = entry[5]
				if bridge == nil then table.remove(global.bridges, i)break end

				if sig1.signal_state == defines.signal_state.reserved or sig2.signal_state == defines.signal_state.reserved then
					bridge.power_switch_state=true

				elseif sig3.signal_state == defines.signal_state.reserved or sig3.signal_state == defines.signal_state.open 
					or sig4.signal_state == defines.signal_state.reserved or sig4.signal_state == defines.signal_state.open then
					bridge.power_switch_state=false
				end
			end
		end
	end
]]
end