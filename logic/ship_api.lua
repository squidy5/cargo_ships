-- Make the global variables and remote interface to add new ships

local default_offset = {    -- Relative position to place engine for each straight rail direction
      [0] = {x = 0, y = 9.5},   -- North-facing
      [1] = {x = -7, y = 7},    -- Northeast-facing
      [2] = {x = -9.5, y = 0},  -- East-facing
      [3] = {x = -7, y = -7},   -- Southeast-facing
      [4] = {x = 0, y = -9.5},  -- South-facing
      [5] = {x = 7, y = -7},    -- Southwest-facing
      [6] = {x = 9.5, y = 0},   -- West-facing
      [7] = {x = 7, y = 7}      -- Northwest-facing
    }
local default_orientation = {
      [0] = 0,
      [1] = 5,  -- NE is weird for some reason
      [2] = 2,
      [3] = 3,
      [4] = 4,
      [5] = 1,  -- SW is weird for some reason
      [6] = 6,
      [7] = 7
    }

function create_globals()
  global.boat_bodies = global.boat_bodies or {}
  global.ship_engines = global.ship_engines or {}
  global.ship_bodies = global.ship_bodies or {}
  global.enter_ship_entities = global.enter_ship_entities or {}
end

local function add_to_list(list, name)
  local found = false
  for _,v in pairs(list) do
    if v == name then
      found = true
      break
    end
  end
  if found == false then
    table.insert(list, name)
  end
end


--[[
    add_ship:  Adds definition for a new ship and ship engine (rolling-stock types)
    parameters:
      name (string, mandatory): Name of the ship body entity
      placing_item (string, optional): Name of item that places this ship, if different from prototype data.
      engine (string, optional): Name of engine entity
      engine_offset (table of Position, optional): Table of relative positions to place the engine. [0]=N, [1]=NE, etc.
      engine_scale (float, optional): Ignored if engine_offset is present. Defaults to 1 if not specified. Scales the standard cargo ship offset table.
      engine_at_front (boolean, optional): Ignored if engine_offset is present. If true, the engine is placed in front of the ship body rather than behind. Applies negative sign to engine_scale.
      engine_orientation (table of Integer, optional): Lookup table for engine direction, if different from default. Usually don't need to specify this.
      recover_fuel (boolean, optional): Whether fuel items in this ship's engine should be collected when mining the ship. If not specified, will use the engine's prototype data.
--]]
function add_ship(params)
  local ship_data = {}
  log("Adding ship '"..tostring(params.name).."':")
  create_globals()
  
  -- Check ship name
  if not (params.name and game.entity_prototypes[params.name]) then
    log("Error adding ship data: Cannot find entity named '"..tostring(params.name).."'")
    return
  end
  if global.ship_bodies[params.name] then
    log("Warning: Ship '"..params.name.."' already added")
  end
  ship_data.name = params.name

  -- Find the item to refund if building fails
  if params.placing_item then
    if game.item_prototypes[params.placing_item] then
      ship_data.placing_item = params.placing_item
    else
      log("Error adding ship data: Cannot find item named '"..tostring(params.placing_item).."'")
      return
    end
  else
    ship_data.placing_item = game.entity_prototypes[params.name].items_to_place_this and game.entity_prototypes[params.name].items_to_place_this[1].name
  end

  -- Process engine data, if any
  if params.engine and game.entity_prototypes[params.engine] then
    ship_data.engine = params.engine
    if params.engine_offset then
      -- Engine offset coordinates specified explicitly
      for i=0,7 do
        if not (params.engine_offset[i] and params.engine_offset[i].x and params.engine_offset[i].y) then
          log("Error adding ship data: engine_offset must have array indicies 0 through 7")
          return
        end
      end
      ship_data.engine_offset = table.deepcopy(params.engine_offset)
      if ship_data.engine_offset[0][y] > 0 then
        ship_data.coupled_engine = 1  -- Engine is behind body
      else
        ship_data.coupled_engine = -1  -- Engine is in front of body
      end
    else
      -- Engine offset coordinates specified by scale and/or direction
      local offset_scale = 1
      if params.engine_scale then
        if type(params.engine_scale) == "number" and params.engine_scale > 0 then
          offset_scale = params.engine_scale
        else
          log("Error adding ship data: engine_scale must be a number greater than 0")
          return
        end
      end
      -- Record coupling direction
      ship_data.coupled_engine = 1  -- Engine is behind body by default
      if params.engine_at_front then
        offset_scale = offset_scale * -1
        ship_data.coupled_engine = -1  -- Engine is in front of body
      end
      -- Apply scaling to default offset table
      ship_data.engine_offset = table.deepcopy(default_offset)
      for i=0,7 do
        ship_data.engine_offset[i].x = ship_data.engine_offset[i].x * offset_scale
        ship_data.engine_offset[i].y = ship_data.engine_offset[i].y * offset_scale
      end
    end

    if params.engine_orientation then
      -- Engine orientation specified in a custom table
      for i=0,7 do
        if not (params.engine_orientation[i] and type(params.engine_orientation[i]) == "number" and params.engine_orientation[i] >= 0 and params.engine_orientation[i] <= 7) then
          log("Error adding ship data: engine_orientation must have array indices 0 through 7 and contain integers valued 0 through 7")
          return
        end
      end
      ship_data.engine_orientation = table.deepcopy(params.engine_orientation)
    else
      -- Use default orientation
      ship_data.engine_orientation = default_orientation
    end

    -- Add data on this engine
    if not global.ship_engines[ship_data.engine] then
      global.ship_engines[ship_data.engine] = {
        name = ship_data.engine,
        coupled_ship = -1 * ship_data.coupled_engine,
        compatible_ships = {ship_data.name},
      }

      -- Check if fuel should be recovered when mining the ship
      if params.engine_recover_fuel ~= nil then
        global.ship_engines[ship_data.engine].recover_fuel = params.engine_recover_fuel  -- Use specified value
      elseif ( game.entity_prototypes[ship_data.engine] and game.entity_prototypes[ship_data.engine].burner_prototype and
               ( game.entity_prototypes[ship_data.engine].burner_prototype.fuel_inventory_size > 0 or
                 game.entity_prototypes[ship_data.engine].burner_prototype.burnt_inventory_size > 0 ) ) then
        global.ship_engines[ship_data.engine].recover_fuel = true  -- Engine prototype has burner inventories
      else
        global.ship_engines[ship_data.engine].recover_fuel = false  -- Not specified, and no burner inventories
      end

      -- Add to list of enterable ships
      if game.entity_prototypes[ship_data.engine].allow_passengers then
        add_to_list(global.enter_ship_entities, ship_data.engine)
      end

    else
      -- Engine already exists, make sure things match
      if global.ship_engines[ship_data.engine].coupled_ship ~= (-1 * ship_data.coupled_engine) then
        log("Error adding ship data: Engine '"..ship_data.engine.."' has already been added by another ship with the wrong coupling direction")
        return
      end

      -- Add this ship to list of compatible ships
      add_to_list(global.ship_engines[ship_data.engine].compatible_ships, ship_data.name)
    end

  end

  global.ship_bodies[ship_data.name] = ship_data

  -- Add to list of enterable ships
  if game.entity_prototypes[ship_data.name].allow_passengers then
    add_to_list(global.enter_ship_entities, ship_data.name)
  end

  log("Added ship specification:\n"..serpent.block(ship_data))

end


--[[
    add_boat:  Adds definition for a new boat (car-type vehicle)
    parameters:
      name (string, mandatory): Name of the boat entity
      placing_item (string, optional): Name of item that places this boat, if different from prototype data.
      rail_version (string, optional): Name of the ship entity to be placed instead, if this boat is placed on a waterway. (Ship definition must be added first)
--]]
function add_boat(params)
  local boat_data = {}
  log("Adding boat '"..tostring(params.name).."':")
  create_globals()
  
  -- Check boat name
  if not (params.name and game.entity_prototypes[params.name]) then
    log("Error adding boat data: Cannot find entity named '"..tostring(params.name).."'")
    return
  end
  if global.boat_bodies[params.name] then
    log("Warning: Boat '"..params.name.."' already added")
  end
  boat_data.name = params.name

  -- Find the item to refund if building fails
  if params.placing_item then
    if game.item_prototypes[params.placing_item] then
      boat_data.placing_item = params.placing_item
    else
      log("Error adding boat data: Cannot find item named '"..tostring(params.placing_item).."'")
      return
    end
  else
    boat_data.placing_item = game.entity_prototypes[params.name].items_to_place_this and game.entity_prototypes[params.name].items_to_place_this[1].name
  end

  -- Add rail-version of this boat, if any
  if params.rail_version then
    if global.ship_bodies[params.rail_version] then
      boat_data.rail_version = params.rail_version
    else
      log("Error adding boat data: Cannot find ship defintion named '"..tostring(params.rail_version).."'")
      return
    end
  end

  -- Add to list of enterable ships
  if game.entity_prototypes[boat_data.name].allow_passengers then
    add_to_list(global.enter_ship_entities, boat_data.name)
  end

  global.boat_bodies[boat_data.name] = boat_data
  log("Added boat specification:\n"..serpent.block(boat_data))

end


function init_ship_globals()
  -- Create the built-in ships and boat
  add_ship({
    name = "cargo_ship",
    engine = "cargo_ship_engine",
    engine_scale = 1,
    engine_at_front = false,
  })

  add_ship({
    name = "oil_tanker",
    engine = "cargo_ship_engine",
    engine_scale = 1,
    engine_at_front = false,
  })

  add_ship({
    name = "boat",
    placing_item = "boat",
    engine = "boat_engine",
    engine_scale = 0.3,
    engine_at_front = true,
  })

  add_boat({
    name = "indep-boat",
    placing_item = "boat",
    rail_version = "boat",
  })

  log("Ship Engines Defined:\n"..serpent.block(global.ship_engines))

  -- List of entities to use the "Enter Ship" command with (any of the above that accepts passengers)
  log("Enterable ships:\n"..serpent.block(global.enter_ship_entities))

end


remote.add_interface("cargo-ships", {
    
    add_ship = function(params)
      add_ship(params)
      init_events()
    end,
    
    add_boat = function(params)
      add_boat(params)
      init_events()
    end,
    
  }
)
