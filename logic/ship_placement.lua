local offset = {}
offset[0] = {x = 0, y = 9.5}
offset[1] = {x = -7, y = 7}
offset[2] = {x = -9.5, y = 0}
offset[3] = {x = -7, y = -7}
offset[4] = {x = 0, y = -9.5}
offset[5] = {x = 7, y = -7}
offset[6] = {x = 9.5, y = 0}
offset[7] = {x = 7, y = 7}

function localize_engine(ent)
  local i = (math.floor((ent.orientation*8)+0.5))%8

  local mult =(ent.name == "indep-boat" or ent.name == "boat") and -0.3 or 1
  local pos = {x = ent.position.x + offset[i].x*mult, y = ent.position.y + offset[i].y*mult}
  --game.players[1].print("x_off: " .. offset[i].x*mult .. " y_off: " .. offset[i].y*mult)

  -- switch ne and sw (messed up factorio directions)
  if i == 1 then
    i = 5
  elseif i == 5 then
    i = 1
  end
  return pos, i
end

function CheckBoatPlacement(ent, p_i)
  -- check if waterways present
  local pos = ent.position
  local ww = ent.surface.find_entities_filtered{area={{pos.x-1, pos.y-1}, {pos.x+1, pos.y+1}}, name="straight-water-way-placed"}
  -- if so place waterway bound version of boat
  if #ww >= 1 then
    game.players[p_i].print("Placing boat on water-ways")

    local eng_pos, dir = localize_engine(ent)
    local fo = ent.force
    ent.destroy()
    local boat = game.players[p_i].surface.create_entity{name = "boat", position=pos, direction=dir, force = fo}
    local engine = game.players[p_i].surface.create_entity{name = "boat_engine", position = eng_pos, direction = dir, force = fo}
    if(boat ~= nil) then
      table.insert(global.check_entity_placement, {boat, engine, p_i})
    else
      game.players[p_i].insert{name="boat", count=1}
      if(engine) then
        engine.destroy()
      end
    end
  else
    game.players[p_i].print("Placing boat independently from water-ways")
  end
end

-- checks placement of rollingstock, and returns the placed entites to the player if neccesary
function checkPlacement()
  global.connection_counter = 0
  for _, entry in pairs(global.check_entity_placement) do

    local entity = entry[1]
    local engine = entry[2]
    local player_index = entry[3]
    if entity and entity.valid then
      if entity.name == "cargo_ship" or entity.name == "oil_tanker" or entity.name == "boat" then
        -- check for too many connections
        -- check for correct engine placement
        if engine == nil then
          cancelPlacement(entity, player_index)
        elseif entity.orientation ~= engine.orientation then
            cancelPlacement(entity, player_index)
            cancelPlacement(engine, player_index)
        elseif entity.train ~= nil then
          -- check if connected to too many carriages
          if #entity.train.carriages > 2 then
            cancelPlacement(entity, player_index)
            cancelPlacement(engine, player_index)
          -- check if on rails
          elseif entity.train.front_rail ~=nil then
            if entity.train.front_rail.name ~= "straight-water-way-placed" and entity.train.front_rail.name ~= "curved-water-way-placed" then
              cancelPlacement(entity, player_index)
              cancelPlacement(engine, player_index)
            end
          elseif entity.train.back_rail ~=nil then
            if entity.train.back_rail.name ~= "straight-water-way-placed" and entity.train.back_rail.name ~= "curved-water-way-placed" then
              cancelPlacement(entity, player_index)
              cancelPlacement(engine, player_index)
            end
          end
        end
      -- else: trains
      elseif entity.train ~= nil then
        -- check if on waterways
        if entity.train.front_rail ~=nil then
          if entity.train.front_rail.name == "straight-water-way-placed" or entity.train.front_rail.name == "curved-water-way-placed" then
            cancelPlacement(entity, player_index)
          end
        elseif entity.train.back_rail ~=nil then
          if entity.train.back_rail.name == "straight-water-way-placed" or entity.train.back_rail.name == "curved-water-way-placed" then
            cancelPlacement(entity, player_index)
          end
        end
      end
    end
  end
  global.check_entity_placement = {}
end

function cancelPlacement(entity, player_index)
  if entity.name ~= "cargo_ship_engine" and entity.name ~= "boat_engine" then
    game.players[player_index].insert{name=entity.name, count=1}
    if entity.name == "cargo_ship" or entity.name == "oil_tanker" or entity.name =="boat" then
      game.players[player_index].print("Ships need to be placed on straight water ways and with sufficient space to both sides!")
    else
      game.players[player_index].print("Trains can not be placed on water ways!")
    end
  end
  entity.destroy()
end





-- disconnects/reconnects rolling stocks if they get wrongly connetcted/disconnected
function On_Train_Created(e)

  -- hacky guardian to make sure we dont ge caught in endless loop of connecting and disconnectnig
  global.connection_counter = global.connection_counter + 1
  if global.connection_counter > 5 then return end

  local contains_ship_engine = false
  local parts = e.train.carriages


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


  -- else if ship has been overconnected split again
  elseif # parts > 2 then
    for i = 1, #parts do
      -- if front of ship-tuple, disconnect towards front (in direction)
      if parts[i].name == "cargo_ship" or parts[i].name == "oil_tanker" or parts[i].name == "boat_engine" then
        local check = parts[i].disconnect_rolling_stock(parts[i].direction)

        -- stop when succseful
        if check then break end
      -- if back of ship-tuple, disconnect towards back (in reverse direction)
      elseif parts[i].name == "boat" or parts[i].name == "cargo_ship_engine" then
        local check = parts[i].disconnect_rolling_stock((parts[i].direction+1)%2)

        -- stop when succseful
        if check then break end
      end
    end
  end
end
