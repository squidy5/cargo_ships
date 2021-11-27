-- creat deep sea oil

function placeDeepOil(e)
	local surface = e.surface
	local area = e.area
	
	-- Check if there is any water at all in this chunk
	if (global.no_oil_on_land or 
			surface.count_tiles_filtered{area=area, collision_mask = "water-tile"} > 0) then

		-- Check if this chunk is entirely ocean
		local deep_tiles = 0
		if game.active_mods["ctg"] or game.active_mods["alien-biomes"] then
			deep_tiles = surface.count_tiles_filtered{area=area,name={"water","water-green","deepwater","deepwater-green"}}
		else
			deep_tiles = surface.count_tiles_filtered{area=area, name = "deepwater"}
		end
		
		-- Find all the crude oil generated on land or sea
		local vanilla_deposits = surface.find_entities_filtered{area=area, name="crude-oil"}
		if vanilla_deposits and #vanilla_deposits > 0 then
			local num_deposits = #vanilla_deposits
			
			if deep_tiles == 1024 then
				-- This is a water chunk, consolidate the vanilla deposits into one offshore deposit
				-- create oil in inner part of tile to avoid deep oil too close to land
				local x = 0
				local y = 0
				local a = 0
				for _, deposit in pairs(vanilla_deposits) do
					x = x + deposit.position.x
					y = y + deposit.position.y
					a = a + deposit.amount
					deposit.destroy()
				end
				x = x / num_deposits
				y = y / num_deposits
				a = a * global.oil_bonus
				surface.create_entity{name="deep_oil", amount=a, position={x=x, y=y}}
				log("Consolidated "..tostring(num_deposits).." into deep_oil amount="..tostring(a).." at ("..tostring(x)..","..tostring(y)..")")
				
			else
				-- Did not consolidate anything, but there is both water and oil in this chunk.
				-- If land deposits are disabled, delete all crude-oil deposits.
				-- Otherwise, delete all crude-oil deposits that are on water
				local count = 0
				for _, deposit in pairs(vanilla_deposits) do
					if (global.no_oil_on_land or 
							surface.count_tiles_filtered{position=deposit.position, radius=deposit.get_radius(), collision_mask="water-tile"} > 0) then
						deposit.destroy()
						count = count + 1
					end
				end
				log("Deleted "..tostring(count).." of "..tostring(num_deposits).." crude-oil in chunk "..tostring(e.position.x)..","..tostring(e.position.y)..")")
			end
		end	
	end
end
