
-- change collision mask of boat if it was changed by hovercraft mod:
if mods["Hovercraft"] then
	data.raw["car"]["indep-boat"].collision_mask = {"ground-tile", "train-layer"}
end
