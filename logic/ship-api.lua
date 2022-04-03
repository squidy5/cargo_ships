-- Make the global variables and remote interface to add new ships



function init_ship_globals()
  
  -- Independent boats to use for Enter Ship command
  global.boat_bodies = {}
  
  -- Add the independent boat
  global.boat_bodies["indep_boat"] = {
    rail_version = "boat",    -- Name of ship_body to place on rails OR nil
  }
  
  -- Placeable ship bodies
  global.ship_bodies = {}
  
  global.ship_bodies["cargo_ship"] = {
    engine = "cargo_ship_engine",  -- Name of engine entity OR nil
    engine_offset = {    -- Relative position to place engine for each straight rail direction
      [0] = {x = 0, y = 9.5},   -- North-facing
      [1] = {x = -7, y = 7},    -- Northeast-facing
      [2] = {x = -9.5, y = 0},  -- East-facing
      [3] = {x = -7, y = -7},   -- Southeast-facing
      [4] = {x = 0, y = -9.5},  -- South-facing
      [5] = {x = 7, y = -7},    -- Southwest-facing
      [6] = {x = 9.5, y = 0},   -- West-facing
      [7] = {x = 7, y = 7}      -- Northwest-facing
    },
    engine_orientation = {
      [0] = 0,
      [1] = 5,  -- NE is weird for some reason
      [2] = 2,
      [3] = 3,
      [4] = 4,
      [5] = 1,  -- SW is weird for some reason
      [6] = 6,
      [7] = 7
    },
    coupled_engine = 1,
    placing_item = "cargo_ship",
  }
  
  global.ship_bodies["oil_tanker"] = {
    engine = "cargo_ship_engine",  -- Name of engine entity OR nil
    engine_offset = {    -- Relative position to place engine for each straight rail direction
      [0] = {x = 0, y = 9.5},   -- North-facing
      [1] = {x = -7, y = 7},    -- Northeast-facing
      [2] = {x = -9.5, y = 0},  -- East-facing
      [3] = {x = -7, y = -7},   -- Southeast-facing
      [4] = {x = 0, y = -9.5},  -- South-facing
      [5] = {x = 7, y = -7},    -- Southwest-facing
      [6] = {x = 9.5, y = 0},   -- West-facing
      [7] = {x = 7, y = 7}      -- Northwest-facing
    },
    engine_orientation = {
      [0] = 0,
      [1] = 5,  -- NE is weird for some reason
      [2] = 2,
      [3] = 3,
      [4] = 4,
      [5] = 1,  -- SW is weird for some reason
      [6] = 6,
      [7] = 7
    },
    coupled_engine = 1,
    placing_item = "oil_tanker",
  }
  
  global.ship_bodies["boat"] = {
    engine = "boat_engine",
    engine_offset = {
      [0] = {x = 0, y = -2.85},   -- North-facing
      [1] = {x = 2.1, y = -2.1},    -- Northeast-facing
      [2] = {x = 2.85, y = 0},  -- East-facing
      [3] = {x = 2.1, y = 2.1},   -- Southeast-facing
      [4] = {x = 0, y = 2.85},  -- South-facing
      [5] = {x = -2.1, y = 2.1},    -- Southwest-facing
      [6] = {x = -2.85, y = 0},   -- West-facing
      [7] = {x = -2.1, y = -2.1}      -- Northwest-facing
    },
    engine_orientation = {
      [0] = 0,
      [1] = 5,  -- NE is weird for some reason
      [2] = 2,
      [3] = 3,
      [4] = 4,
      [5] = 1,  -- SW is weird for some reason
      [6] = 6,
      [7] = 7
    },
    coupled_engine = -1,
    placing_item = "boat",
  }
  
  -- Invisible ship engines to be built along with ship bodies
  global.ship_engines = {}
  
  global.ship_engines["cargo_ship_engine"] = {
    recover_fuel = true,
    compatible_ships = {
      ["cargo_ship"] = true,
      ["oil_tanker"] = true,
    },
    coupled_ship = -1,
  }
  
  global.ship_engines["boat_engine"] = {
    recover_fuel = true,
    compatible_ships = {
      ["boat"] = true,
    },
    coupled_ship = 1,
  }
  
  -- List of 
  global.enter_ship_entities = {}
  for name,_ in pairs(global.boat_bodies) do
    table.insert(global.enter_ship_entities, name)
  end
  for name,_ in pairs(global.ship_bodies) do
    table.insert(global.enter_ship_entities, name)
  end
  for name,_ in pairs(global.ship_engines) do
    table.insert(global.enter_ship_entities, name)
  end

end

