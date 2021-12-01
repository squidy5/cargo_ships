-- Migrate global.check_entity_placement[n][3] from player_index to player handle
if global.check_entity_placement then
  for i, d in pairs(global.check_entity_placement) do
    d[3] = (d[3] and game.players[d[3]]) or nil
  end
end
