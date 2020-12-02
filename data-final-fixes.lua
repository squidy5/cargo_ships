
-- change collision mask of boat if it was changed by hovercraft mod:

data.raw["car"]["indep-boat"].collision_mask = {"ground-tile", "train-layer"}

data.raw.fish["fish"].collision_mask = {"ground-tile", "colliding-with-tiles-only"}

if settings.startup["no_oil_for_oil_rig"].value then
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




