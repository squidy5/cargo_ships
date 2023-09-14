-- match recipe status to research
for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  if recipes["oil_rig"] then
    recipes["oil_rig"].enabled = technologies["deep_sea_oil_extraction"].researched
  end
end

-- add radar sight to all existing oil_rigs
local oil_rigs = game.surfaces[1].find_entities_filtered{name = "oil_rig"}
for i = 1, #oil_rigs do
	pos = oil_rigs[i].position
	radar = game.surfaces[1].find_entities_filtered{area = {{pos.x-4, pos.y-4}, {pos.x+4, pos.y+4}}, name = "or_radar"}
	if #radar==0 then
		game.surfaces[1].create_entity{name = "or_radar", position = pos, force = oil_rigs[i].force}
	end
end