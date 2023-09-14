for _, surface in pairs(game.surfaces) do
  for _, entity in pairs(surface.find_entities_filtered{name="entity-ghost", ghost_name={"straight-water-way", "curved-water-way"}}) do
    entity.silent_revive{raise_revive = true}
  end
end
