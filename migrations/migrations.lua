for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  recipes["port_lb"].enabled = technologies["automated_water_transport"].researched
end