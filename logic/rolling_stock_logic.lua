
function On_Train_Created(e)

  local contains_ship_engine = false
  local parts = e.train.carriages


  if   not next(global.check_entity_placement) == nil then
    game.players[1].print("full ")

    return
  end
      game.players[1].print("empty ")

  -- check if roling stock contains any ships (engines)
  for i = 1,  # parts do
    if parts[i].name == "boat_engine" or parts[i].name == "cargo_ship_engine" then
      contains_ship_engine = true
      break
    end
  end

  --if no ships involved return
  if not contains_ship_engine then
    return
  end

  -- if ship  has been split reconnect
  if # parts == 1 then
    -- reconnect!
    local engine = parts[1]
    local dir = engine.direction
    if engine.name == "boat_engine" then
      dir = (dir + 1) %2
    end
    engine.connect_rolling_stock(dir)

    game.players[1].print("reconnected!" .. engine.name)


  -- else if ship has been overconnected split again
  elseif # parts > 2 then
  --  game.players[1].print("needs disconnection!")

    for i = 1, #parts do
      game.players[1].print(parts[i].name)
      -- if front of ship-tuple, disconnect towards front (in direction)
--      if parts[i].name == "cargo_ship" or parts[i].name == "oil_tanker" or parts[i].name == "boat_engine" then
      if  parts[i].name == "boat_engine" then
        local check = parts[i].disconnect_rolling_stock(parts[i].direction)

        game.players[1].print("DISCONNECTED at 1: ")
        game.players[1].print(check)
        -- stop when succseful
        if check then break end
      -- if back of ship-tuple, disconnect towards back (in reverse direction)
--      elseif parts[i].name == "boat" or parts[i].name == "cargo_ship_engine" then
      elseif parts[i].name == "cargo_ship_engine" then
        local check = parts[i].disconnect_rolling_stock((parts[i].direction+1)%2)

        game.players[1].print("DISCONNECTED at 2: ")
        game.players[1].print(check)


        -- stop when succseful
        if check then break end
      end
    end
  end
end
