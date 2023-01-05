-- Regenerate oil on each surface if RSO allowed crude-oil to generate in water
require("__cargo-ships__/logic/oil_placement")
log("Offshore Oil Migration Started")
for _, surface in pairs(game.surfaces) do
  local vanilla_deposits = surface.find_entities_filtered{name="crude-oil"}
  if vanilla_deposits and #vanilla_deposits > 0 then
    for _, deposit in pairs(vanilla_deposits) do
      -- If there is any vanilla oil deposit placed on top of a water tile, regenerate the oil deposits on the entire surface
      if surface.count_tiles_filtered{position=deposit.position, radius=deposit.get_radius(), collision_mask="water-tile"} > 0 then
        regenerateSurface(surface)
        break
      end
    end
  end
end
log("Offshore Oil Migration Finished")
