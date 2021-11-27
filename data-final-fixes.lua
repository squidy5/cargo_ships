local collision_mask_util = require("collision-mask-util")

-- change collision mask of boat if it was changed by hovercraft mod:

data.raw["car"]["indep-boat"].collision_mask = {"ground-tile", "train-layer"}

data.raw.fish["fish"].collision_mask = {"ground-tile", "colliding-with-tiles-only"}

if settings.startup["deep_oil"].value and settings.startup["no_oil_for_oil_rig"].value then
	data.raw.technology["deep_sea_oil_extraction"].unit =
	{
	    count = 300,
	    ingredients =
	    {
	      {"automation-science-pack", 1},
	      {"logistic-science-pack", 1},
	    },
	    time = 30
	 }
end

if settings.startup["no_catching_fish"].value then
	for _, inserter in pairs(data.raw.inserter) do
		inserter.use_easter_egg = false
	end
end

-----------------------------
-- DEEP OIL GENERATION
-----------------------------

-- Disable sea oil generation and extraction if Omnimatter or Seablock are installed
if data.raw.resource.deep_oil then
	-- Remove 'resource-layer' from the collision masks of water tiles where oil can go
	if mods["ctg"] or mods["alien-biomes"] then
		valid_oil_tiles = {"water","water-green","deepwater","deepwater-green"}
	else
		valid_oil_tiles = {"deepwater"}
	end

	for _, name in pairs(valid_oil_tiles) do
		if data.raw.tile[name] then
			for i=1, #data.raw.tile[name].collision_mask do
				if data.raw.tile[name].collision_mask[i] == "resource-layer" then
					log("Removing collision layer 'resource-layer' from tile '"..name.."'")
					table.remove(data.raw.tile[name].collision_mask, i)
					break
				end
			end
		end
	end

	-- Add "water-tile" to collision masks of land resources
	for name, _ in pairs(data.raw.resource) do
		if name ~= "crude-oil" then
			log("Adding collision layer 'water-tile' to resource '"..name.."'")
			if data.raw.resource[name].collision_mask then
				table.insert(data.raw.resource[name].collision_mask, "water-tile")
			else
				data.raw.resource[name].collision_mask = {"resource-layer", "water-tile"}
			end
		end
	end
	
end
