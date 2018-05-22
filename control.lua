require("logic.ship_directions")
require("logic.long_reach")
local choices = require("choices")

-- spawn additioanl invisible enties
function spawnInvisibles(e)
	if e.created_entity.name == "cargo_ship" or e.created_entity.name == "oil_tanker"  then
		local ent = e.created_entity
		local pos, dir = localize_engine(ent)
		game.players[1].print("position: " .. ent.position.x .. "," ..  ent.position.y)
		local new ent.surface.create_entity{name = "cargo_ship_engine", position = pos, direction = dir, force = ent.force}
	end

	if e.created_entity.name == "oil_rig" then
		local pos =  e.created_entity.position
		local new e.created_entity.surface.create_entity{name = "or_power", position = pos, force = e.created_entity.force}
		local new e.created_entity.surface.create_entity{name = "or_pole", position = pos, force = e.created_entity.force}
		local new e.created_entity.surface.create_entity{name = "or_lamp", position = {pos.x - 3, pos.y -3}, force = e.created_entity.force}
		local new e.created_entity.surface.create_entity{name = "or_lamp", position = {pos.x + 3, pos.y -3}, force = e.created_entity.force}
		local new e.created_entity.surface.create_entity{name = "or_lamp", position = {pos.x + 3, pos.y + 3}, force = e.created_entity.force}
		local new e.created_entity.surface.create_entity{name = "or_lamp", position = {pos.x - 3, pos.y + 3}, force = e.created_entity.force}

	end
end

-- enter or leave ship
function OnEnterShip(e)
	local X = game.players[1].position.x
	local Y = game.players[1].position.y

	if game.players[1].vehicle == nil then
		for dis = 1,5 do
			local ship = game.players[1].surface.find_entities_filtered{area={{X-dis, Y-dis}, {X+dis, Y+dis}}, name="cargo_ship", limit=1}
			if ship[1] ~= nil then	
				ship[1].set_driver(game.players[1])
				break
			end
			local tanker = game.players[1].surface.find_entities_filtered{area={{X-dis, Y-dis}, {X+dis, Y+dis}}, name="oil_tanker", limit=1}
			if tanker[1] ~= nil then	
				tanker[1].set_driver(game.players[1])
				break
			end
		end
	else
		for dis = 1,7 do
			local land = game.players[1].surface.find_tiles_filtered{area={{X-dis, Y-dis}, {X+dis, Y+dis}}, collision_mask ="ground-tile"}
 			if land[1] ~= nil then
	 			game.players[1].vehicle.set_driver(nil)
	 			game.players[1].driving = false
	 			game.players[1].teleport(land[1].position)
	 			break
			end
		end
	end
end

-- delete invisible entities if master entity is destroyed
function OnDeleted(e)
	if(e.entity) then
		local ent = e.entity	--game.players[1].print("destroying" .. ent.name)
		if ent.name == "cargo_ship" or ent.name == "oil_tanker" then
			if ent.train ~= nil then
				if ent.train.back_stock ~= nil then
					if ent.train.back_stock.name == "cargo_ship_engine" then
						ent.train.back_stock.destroy()
					end
				end
				if ent.train.front_stock ~= nil then
					if ent.train.front_stock.name == "cargo_ship_engine" then
						ent.train.front_stock.destroy()
					end
				end
			end
		elseif ent.name == "cargo_ship_engine" then
			if ent.train ~= nil then
				if ent.train.front_stock ~= nil then
					if ent.train.front_stock.name == "cargo_ship" then
						ent.train.back_stock.destroy()
					end
				end
			end
		elseif ent.name == "oil_rig" then
			local pos = ent.position
			or_inv = game.surfaces[1].find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_power"}
			for i = 1, #or_inv do
				or_inv[i].destroy()
			end
			or_inv = game.surfaces[1].find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_lamp"}
			for i = 1, #or_inv do
				or_inv[i].destroy()
			end
			or_inv = game.surfaces[1].find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_pole"}
			for i = 1, #or_inv do
				or_inv[i].destroy()
			end
		end
	end
end

-- creat deep sea oil
function placeDeepOil(e)
	deep_tiles  = game.surfaces[1].count_tiles_filtered{area=e.area, name = "deepwater"}
	math.randomseed(e.tick)
	if deep_tiles == 1024 then

		freq = 0.03
		if settings.global["oil_frequency"].value == choices.oil_freq.none then
			freq = 0
		elseif settings.global["oil_frequency"].value == choices.oil_freq.v_low then
			freq = 0.0075
		elseif settings.global["oil_frequency"].value == choices.oil_freq.low then
			freq = 0.015
		elseif settings.global["oil_frequency"].value == choices.oil_freq.high then
			freq = 0.06
		elseif settings.global["oil_frequency"].value == choices.oil_freq.v_high then
			freq = 0.12
		end
		--freq = freq * 1.25
		mult = 1
		if settings.global["oil_richness"].value == choices.oil_rich.v_poor then
			mult = 0.3
		elseif settings.global["oil_richness"].value == choices.oil_rich.poor then
			mult = 0.7
		elseif settings.global["oil_richness"].value == choices.oil_rich.good then
			mult = 1.8
		elseif settings.global["oil_richness"].value == choices.oil_rich.v_good then
			mult = 3
		end

		r = math.random()
		if r < freq then
			-- create oil in inner part of tile to avoid deep oil too close to land
			local x = math.random(-10,10)
			local y = math.random(-10,10)
			local pos = {e.area.left_top.x+16+x, e.area.left_top.y+16+y}
			local a = (1+freq/(r+(freq/50)))*750000*mult
			game.surfaces[1].create_entity{name="deep_oil", amount=a, position=pos}
		end
	end
end

function powerOilRig(e)
	if e.tick % 60 == 0 then
		for _, generator in pairs(game.surfaces[1].find_entities_filtered{name="or_power"}) do
			generator.fluidbox[1] = {name="steam", amount = 100, temperature=165}
		end
	end
end






script.on_event("enter_ship", OnEnterShip)
script.on_event(defines.events.on_entity_died, OnDeleted)
script.on_event(defines.events.on_player_mined_entity, OnDeleted)
script.on_event(defines.events.on_robot_mined_entity, OnDeleted)
script.on_event(defines.events.on_chunk_generated, placeDeepOil)
script.on_event(defines.events.on_built_entity, spawnInvisibles)
script.on_event(defines.events.on_tick, powerOilRig)
-- long reach
script.on_event(defines.events.on_runtime_mod_setting_changed, applyChanges)
script.on_event(defines.events.on_player_cursor_stack_changed, increaseReach)
script.on_event(defines.events.on_player_died, deadReach)
