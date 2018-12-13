for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes
  technologies["cargo_ships"].researched = technologies["water_transport"].researched
  recipes["boat"].enabled = technologies["water_transport"].researched
end