
function localize_engine(ent, ship_name)
  local dir = (math.floor((ent.orientation*8)+0.5))%8
  local ship_data = global.ship_bodies[ship_name or ent.name]
  local pos = {x = ent.position.x + ship_data.engine_offset[dir].x,
               y = ent.position.y + ship_data.engine_offset[dir].y}
  local orient = ship_data.engine_orientation[dir]
  return pos, orient
end

local function has_connected_stock(wagon)
  local train = wagon.train
  local wagon_pos = 0
  for i=1, #train.carriages do
    if train.carriages[i].unit_number == wagon.unit_number then
      wagon_pos = i
      break
    end
  end
  if wagon_pos > 0 then
    local ship_data = global.ship_bodies[wagon.name]
    if ship_data then
      if ship_data.engine then
        local engine_pos = wagon_pos + global.ship_bodies[wagon.name].coupled_engine
        if engine_pos >= 1 and engine_pos <= #train.carriages then
          --game.print("found "..train.carriages[wagon_pos+1].name.." in back of "..wagon.name)
          return true
        end
      else
        return true -- no engine required, so it has everything it needs
      end
    elseif global.ship_engines[wagon.name] then
      local ship_pos = wagon_pos + global.ship_engines[wagon.name].coupled_ship
      if ship_pos >= 1 and ship_pos <= #train.carriages then
        --game.print("found "..train.carriages[wagon_pos+1].name.." in back of "..wagon.name)
        return true
      end
    end
  end
  --game.print("didn't find matching entity for "..wagon.name.." in train of "..#train.carriages.." wagons")
  return false
end

local function cancelPlacement(entity, player, robot)
  if not global.ship_engines[entity.name] then
    if player and player.valid then
      player.insert{name=entity.name, count=1}
      if global.ship_bodies[entity.name] then
        player.print{"cargo-ship-message.error-ship-no-space", entity.localised_name}
      else
        player.print{"cargo-ship-message.error-train-on-waterway", entity.localised_name}
      end
    elseif robot and robot.valid then
      -- Give the robot back the thing
      local return_item = entity.name
      if global.ship_bodies[entity.name] then
        return_item = global.ship_bodies[entity.name].placing_item
      end
      robot.get_inventory(defines.inventory.robot_cargo).insert{name=return_item, count=1}
      if global.ship_bodies[entity.name] then
        game.print{"cargo-ship-message.error-ship-no-space", entity.localised_name}
      else
        game.print{"cargo-ship-message.error-train-on-waterway", entity.localised_name}
      end
    else
      game.print{"cargo-ship-message.error-canceled", entity.localised_name}
    end
  end
  entity.destroy()
end


function CheckBoatPlacement(entity, player, robot)
  -- check if waterways present
  local pos = entity.position
  local surface = entity.surface
  local local_name = entity.localised_name
  local boat_data = global.boat_bodies[entity.name]
  local ww = nil
  if boat_data and boat_data.rail_version then
    ww = surface.find_entities_filtered{area={{pos.x-1, pos.y-1}, {pos.x+1, pos.y+1}}, name="straight-water-way"}
  end

  -- if so place waterway bound version of boat
  if ww and #ww >= 1 then
    local ship_name = boat_data.rail_version
    local ship_data = global.ship_bodies[ship_name]
    local force = entity.force
    local eng_pos
    local dir
    eng_pos, dir = localize_engine(entity, ship_name)
    entity.destroy()
    local boat = surface.create_entity{name=ship_name, position=pos, direction=dir, force=force}
    if boat then
      if player then
        player.print{"cargo-ship-message.place-on-waterway", local_name}
      else
        game.print{"cargo-ship-message.place-on-waterway", local_name}
      end
      eng_pos, dir = localize_engine(boat)  -- Get better position for engine now that boat is on rails
      local engine = surface.create_entity{name=ship_data.engine, position=eng_pos, direction=dir, force=force}
      table.insert(global.check_entity_placement, {boat, engine, player})
    else
      if player then
        player.insert{name=ship_data.placing_item, count=1}
        player.print{"cargo-ship-message.error-place-on-waterway", local_name}
      else
        if robot then
          robot.get_inventory(defines.inventory.robot_cargo).insert{name=ship_data.placing_item, count=1}
        end
        game.print{"cargo-ship-message.error-place-on-waterway", local_name}
      end
    end
  else
    if player then
      player.print{"cargo-ship-message.place-independent", local_name}
    else
      game.print{"cargo-ship-message.place-independent", local_name}
    end
  end
end

-- checks placement of rolling stock, and returns the placed entities to the player if necessary
function checkPlacement()
  global.connection_counter = 0
  for _, entry in pairs(global.check_entity_placement) do
    local entity = entry[1]
    local engine = entry[2]
    local player = entry[3]
    local robot = entry[4]

    if entity and entity.valid then
      if global.ship_bodies[entity.name] then
        local ship_data = global.ship_bodies[entity.name]
        -- check for too many connections
        -- check for correct engine placement
        if ship_data.engine and not engine then
          -- See if there is already an engine connected to this ship
          if not has_connected_stock(entity) then
            cancelPlacement(entity, player, robot)
          end
        elseif ship_data.engine and entity.orientation ~= engine.orientation then
          cancelPlacement(entity, player, robot)
          cancelPlacement(engine, player)
        elseif entity.train then
          -- check if connected to too many carriages
          if ((ship_data.engine and #entity.train.carriages > 2) or
              (not ship_data.engine and #entity.train.carriages > 1)) then
            cancelPlacement(entity, player, robot)
            cancelPlacement(engine, player)
          -- check if on rails
          elseif entity.train.front_rail then
            if entity.train.front_rail.name ~= "straight-water-way" and entity.train.front_rail.name ~= "curved-water-way" then
              cancelPlacement(entity, player, robot)
              cancelPlacement(engine, player)
            end
          elseif entity.train.back_rail then
            if entity.train.back_rail.name ~= "straight-water-way" and entity.train.back_rail.name ~= "curved-water-way" then
              cancelPlacement(entity, player, robot)
              cancelPlacement(engine, player)
            end
          end
        end

      elseif global.ship_engines[entity.name] then
        if not has_connected_stock(entity) then
          game.print{"cargo-ship-message.error-unlinked-engine", entity.localised_name}
          cancelPlacement(entity, player)
        end

      -- else: trains
      elseif entity.train then
        -- check if on waterways
        if entity.train.front_rail then
          if entity.train.front_rail.name == "straight-water-way" or entity.train.front_rail.name == "curved-water-way" then
            cancelPlacement(entity, player, robot)
          end
        elseif entity.train.back_rail then
          if entity.train.back_rail.name == "straight-water-way" or entity.train.back_rail.name == "curved-water-way" then
            cancelPlacement(entity, player, robot)
          end
        end
      end
    end
  end
  global.check_entity_placement = {}
end

-- Disconnects/reconnects rolling stocks if they get wrongly connected/disconnected
function On_Train_Created(e)
  -- hacky guardian to make sure we don't ge caught in endless loop of connecting and disconnecting
  global.connection_counter = global.connection_counter + 1
  if global.connection_counter > 5 then return end

  local contains_ship_engine = false
  local parts = e.train.carriages

  -- check if rolling stock contains any ships (engines)
  for i = 1, #parts do
    if global.ship_engines[parts[i].name] then
      contains_ship_engine = true
      break
    end
  end
  --if no ships involved return
  if contains_ship_engine then
    -- if ship  has been split reconnect
    if #parts == 1 then
      -- reconnect!
      local engine = parts[1]
      local dir = engine.direction
      if global.ship_engines[engine.name].coupled_ship == 1 then
        dir = (dir + 1) %2
      end
      engine.connect_rolling_stock(dir)

    -- else if ship has been overconnected split again
    elseif #parts > 2 then
      for i = 1, #parts do
        local check = false
        -- if front of ship-tuple, disconnect towards front (in direction)
        if ((global.ship_bodies[parts[i].name] and global.ship_bodies[parts[i].name].coupled_engine == 1) or
            (global.ship_engines[parts[i].name] and global.ship_engines[parts[i].name].coupled_ship == 1)) then
          check = parts[i].disconnect_rolling_stock(parts[i].direction)

        -- if back of ship-tuple, disconnect towards back (in reverse direction)
        elseif ((global.ship_bodies[parts[i].name] and global.ship_bodies[parts[i].name].coupled_engine == -1) or
                (global.ship_engines[parts[i].name] and global.ship_engines[parts[i].name].coupled_ship == -1)) then
          check = parts[i].disconnect_rolling_stock((parts[i].direction+1)%2)
        end
        -- stop when successful (new train will be created)
        if check then
          break
        end
      end
    end
  end
end
