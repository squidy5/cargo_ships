-- creat deep sea oil

function placeDeepOil(e)
	local deep_tiles = 0
	local surface = e.surface
	if game.active_mods["omnimatter"] then
		return
	end
	if game.active_mods["SeaBlock"] or game.active_mods["ctg"] then
		deep_tiles = surface.count_tiles_filtered{area=e.area,name={"water","water-green","deepwater","deepwater-green"}}
	else
		deep_tiles = surface.count_tiles_filtered{area=e.area, name = "deepwater"}
	end
	--game.players[1].print("number of deep tiles: " .. deep_tiles)

	if deep_tiles == 1024 then

		freq = 0.03
		if settings.global["oil_frequency"].value == "none" then
			freq = 0		
		elseif settings.global["oil_frequency"].value == "minimal" then
			freq = 0.0008
		elseif settings.global["oil_frequency"].value == "very-very-low" then
			freq = 0.0025
		elseif settings.global["oil_frequency"].value == "very-low" then
			freq = 0.0075
		elseif settings.global["oil_frequency"].value == "low" then
			freq = 0.015
		elseif settings.global["oil_frequency"].value == "high" then
			freq = 0.06
		elseif settings.global["oil_frequency"].value == "very-high" then
			freq = 0.12
		end

		mult = 1
		if settings.global["oil_richness"].value == "very-poor" then
			mult = 0.25
		elseif settings.global["oil_richness"].value == "poor" then
			mult = 0.5
		elseif settings.global["oil_richness"].value == "good" then
			mult = 2
		elseif settings.global["oil_richness"].value == "very-good" then
			mult = 4
		end


		local m_x = e.area.left_top.x +16
		local m_y = e.area.left_top.y + 16
		local distance = math.sqrt(m_x*m_x + m_y*m_y)
		distance_mult = 1 + distance/4000 + distance*math.sqrt(distance)/200000

		r = math.random()
		if r < freq then
			-- create oil in inner part of tile to avoid deep oil too close to land
			local x = math.random(-10,10)
			local y = math.random(-10,10)
			local pos = {m_x+x, m_y+y}
			randomizer = math.random()
			randomizer = 3/(1+2*randomizer)
			local a = 500000* mult *distance_mult * randomizer 

			surface.create_entity{name="deep_oil", amount=a, position=pos}

		end
	end
end
