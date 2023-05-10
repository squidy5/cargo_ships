if global.or_generators ~= nil then
  for i, generator in pairs(global.or_generators) do
    if generator.valid then
      -- Teleport power entities to center of oil rigs since previously they didn't have
      -- placeable-off-grid flag so weren't centered
      local surface = generator.surface
      local oil_rig = surface.find_entity("oil_rig", generator.position)
      local position = oil_rig.position
      generator.teleport(position)

      -- Add new power entity
      surface.create_entity{name = "or_power_electric", position = position, force = oil_rig.force}
    end
  end
end