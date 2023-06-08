local car_sounds = {
  sound = {
    filename = "__base__/sound/car-engine.ogg",
    volume = 0.6,
    min_speed = 0.6,
    max_speed = 0.9,
  },
  activate_sound = {
    filename = "__base__/sound/car-engine-start.ogg",
    volume = 0.6,
    speed = 0.6,
  },
  deactivate_sound = {
    filename = "__base__/sound/car-engine-stop.ogg",
    volume = 0.6,
    speed = 0.6,
  },
  match_speed_to_activity = true
}

local tank_sounds = {
  sound = {
    filename = "__base__/sound/fight/tank-engine.ogg",
    volume = 0.3
  },
  activate_sound = {
    filename = "__base__/sound/fight/tank-engine-start.ogg",
    volume = 0.3
  },
  deactivate_sound = {
    filename = "__base__/sound/fight/tank-engine-stop.ogg",
    volume = 0.3
  },
  match_speed_to_activity = false,
}

local ships_working_sound = {
  sound =
  {
    filename = "__cargo-ships__/sound/ferry-sound.ogg",
    volume = 0.6,
    min_speed = 0.6,
    max_speed = 0.7,
  },
  match_volume_to_activity = true,
  match_speed_to_activity = true,
  use_doppler_shift = false,
  --[[aggregation = {
    max_count = 20,
    progress_threshold = 0.01,
    remove = false,
    count_already_playing = false,
  },]]
}

function ship_light(yshift, cutpicture)
  local cut = cutpicture and "-cut" or ""
  return {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = GRAPHICSPATH .. "entity/light-cone" .. cut .. ".png",
      priority = "extra-high",
      flags = { "light" },
      scale = 0.5,
      width = 800,
      height = 800,
    },
    shift = {0, yshift},
    size = 2,
    intensity = 0.8,
    color = {0.92, 0.77, 0.3}
  }
end

local function imageloop(filepath, filenumber, divider)
  local filelist = {}
  for i=0,(filenumber-1) do
    local file = filepath .. i .. ".png"
    if divider then
      if i % divider == 0 then
        table.insert(filelist, file)
      end
    else
      table.insert(filelist, file)
    end
  end
  return filelist
end

local function loopboatanimstripes(name, frame1, framelast)
  local stripes = {}
  for i=frame1,framelast do
    local stripe = {
      filename = name .. i .. ".png",
      width_in_frames = 8,
      height_in_frames = 8,
    }
    table.insert(stripes, stripe)
  end
  return stripes
end

local indep_boat_animation = {
  layers = {
    {
      slice = 4,
      priority = "low",
      width = 536,
      height = 536,
      direction_count = 256,
      stripes = loopboatanimstripes(GRAPHICSPATH .. "entity/boat/boat-", 1, 4),
      --line_length = 8,
      --lines_per_file = 8,
      shift = util.by_pixel(0, 0),
      scale = 0.5,
      max_advance = 0.2,
    },
    {
      slice = 4,
      priority = "low",
      width = 536,
      height = 536,
      direction_count = 256,
      --filenames = imageloop(GRAPHICSPATH .. "entity/boat/boat_shadow_", 256),

      stripes = loopboatanimstripes(GRAPHICSPATH .. "entity/boat/boat-shadow-", 1, 4),
      --line_length = 8,
      --lines_per_file = 8,
      shift = util.by_pixel(0, 0),
      scale = 0.5,
      max_advance = 0.2,
      draw_as_shadow = true,
    },
  }
}

local boat_pictures = {
  layers = {
    {
      slice = 4,
      priority = "low",
      width = 750,
      height = 750,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/boat/railed/boat_", 4),
      line_length = 8,
      lines_per_file = 8,
      scale = 0.5, --1.5,
      shift = util.by_pixel(0, -28),
    },
    {
      slice = 4,
      priority = "low",
      width = 750,
      height = 750,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/boat/railed/boat_shadow_", 4),
      line_length = 8,
      lines_per_file = 8,
      scale = 0.5, --1.5,
      shift = util.by_pixel(0, -28),
      draw_as_shadow = true,
    }
  }
}

local cargo_ship_pictures = {
  layers = {
    {
      slice = 4,
      priority = "low",
      width = 1000,
      height = 1000,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/cargo_ship/cs_", 16),
      line_length = 4,
      lines_per_file = 4,
      scale = 0.85,--3,
      shift = util.by_pixel(0, -54.5),
    },
    {
      slice = 4,
      priority = "low",
      width = 1000,
      height = 1000,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/cargo_ship/cs_shadow_", 16),
      line_length = 4,
      lines_per_file = 4,
      scale = 0.85,--3,
      shift = util.by_pixel(0, -54.5),
      draw_as_shadow = true,
    }
  }
}

local oil_tanker_pictures = {
  layers = {
    {
      slice = 4,
      priority = "low",
      width = 890,
      height = 912,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/tanker/tanker_unit_", 16),
      line_length = 4,
      lines_per_file = 4,
      scale = 0.85,
      shift = util.by_pixel(0, -22.5),
    },
    {
      slice = 4,
      priority = "low",
      width = 1000,
      height = 1000,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames = imageloop(GRAPHICSPATH .. "entity/tanker/tanker_shadow_", 16),
      line_length = 4,
      lines_per_file = 4,
      scale = 0.85,
      shift = util.by_pixel(0, -22.5),
      draw_as_shadow = true,
    },
  }
}

local function water_reflection(name, size, yshift, rotate, variation_count)
  return {
    pictures = {
      filename = GRAPHICSPATH .. "entity/" .. name .. "_water_reflection.png",
      width = size,
      height = size,
      shift = util.by_pixel(0, yshift), --adjust with base shift
      variation_count = variation_count or 1,
      scale = 5
    },
    rotate = rotate or false,
    orientation_to_variation = false
  }
end

local wave = table.deepcopy(data.raw["trivial-smoke"]["light-smoke"])
wave.name = "wave"
wave.cyclic = false
wave.affected_by_wind = false
wave.animation = {
  filename = GRAPHICSPATH .. "entity/wave/water-splash.png",
  priority = "extra-high",
  width = 184,
  height = 132,
  frame_count = 15,
  line_length = 5,
  shift = util.by_pixel(-14,-16),
  animation_speed = 0.20,
}
--wave.start_scale = 1.3
wave.start_scale = 0.65
wave.color = { r = 1, g = 1, b = 1 }
wave.render_layer = "water-tile"

data:extend({wave})

local wave_circle = table.deepcopy(data.raw["trivial-smoke"]["wave"])
wave_circle.name = "wave_circle"
wave_circle.cyclic = true
wave_circle.affected_by_wind = false
wave_circle.animation = {
  filename = GRAPHICSPATH .. "entity/wave/wave_circle.png",
  priority = "extra-high",
  width = 612,
  height = 612,
  frame_count = 1,
  line_length = 1,
  shift = util.by_pixel(-14,-16),
  animation_speed = 0.1,
}
wave_circle.start_scale = 0.01
wave_circle.end_scale = 0.8
wave_circle.color = { r = 1, g = 1, b = 1 }
wave_circle.render_layer = "water-tile"
wave_circle.duration = 500
wave_circle.fade_away_duration = 500
wave_circle.movement_slow_down_factor = 0
wave_circle.show_when_smoke_off = true

data:extend({wave_circle})

----------------------------------------------------------------
------   BOAT independant (when placed outside rails)   --------
----------------------------------------------------------------

local speed_modifier = settings.startup["speed_modifier"].value
local fuel_modifier = settings.startup["fuel_modifier"].value
local indep_boat_power = 300 + (speed_modifier -1) * 150

local indep_boat = table.deepcopy(data.raw["car"]["car"])
indep_boat.name = "indep-boat"
--indep_boat.order = "no-aai" -- This prevents AAI Programmable Vehicles from copying the Boat
indep_boat.collision_mask = {"ground-tile", "train-layer"}
indep_boat.collision_box = {{-1.2, -3}, {1.2, 3}}
indep_boat.selection_box = {{-1.2, -3}, {1.2, 3}}
indep_boat.selection_priority = 51
indep_boat.max_health = 600
indep_boat.icon = GRAPHICSPATH .. "icons/boat.png"
indep_boat.icon_size = 64
indep_boat.guns = nil
indep_boat.braking_power = "150kW"
indep_boat.weight = 10000
indep_boat.max_health = 1500
indep_boat.consumption = indep_boat_power.."kW"
indep_boat.friction = 0.002/speed_modifier
indep_boat.terrain_friction_modifier = 0
indep_boat.minable = {mining_time = 1, result = "boat"}
indep_boat.rotation_speed = 0.008
indep_boat.inventory_size = 80
indep_boat.localised_description = {'entity-description.boat'}
indep_boat.burner = {
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 3 * fuel_modifier,
  smoke = {
    {
      name = "light-smoke",
      deviation = {0.2, 0.4},
      frequency = 60,
      position = {0.4, 0.6},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 1.9,
      --height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      --starting_vertical_speed_deviation = 0.02,
    },
    {
      name = "wave",
      deviation = {0.3, 0.3},
      frequency = 45,
      position = {0, 3},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    },
    {
      name = "wave_circle",
      deviation = {0.8, 0.8},
      frequency = 15,
      position = {0, 3},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    }
  }
}
indep_boat.working_sound = car_sounds
indep_boat.sound_minimum_speed = 0.1
indep_boat.sound_scaling_ratio = 0.4
indep_boat.animation = indep_boat_animation
indep_boat.water_reflection = water_reflection("boat/boat", 60, 25, true)
indep_boat.turret_animation = {
  layers = {
    {
      animation_speed = 1,
      direction_count = 1,
      frame_count = 1,
      height = 1,
      width = 1,
      max_advance = 0.2,
      stripes = {
        {
          filename = "__core__/graphics/empty.png",
          height_in_frames = 1,
          width_in_frames = 1
        }
      }
    }
  }
}
indep_boat.light = ship_light(-13, true)
indep_boat.light_animation = nil
indep_boat.corpse = nil

----------------------------------------------------------------
------------------------ BOAT  ----------------------------
----------------------------------------------------------------

local boat_max_speed = 0.27*speed_modifier

local boat = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
boat.name = "boat"
boat.icon = GRAPHICSPATH .. "icons/boat.png"
boat.icon_size = 64
boat.flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-on-map"}
boat.allow_copy_paste = true
boat.minable = {mining_time = 1, result = "boat"}
boat.placeable_by = {{item="boat", count=1}, {item="indep-boat", count=1}}
boat.max_health = 1500
boat.selection_box = {{-1.2, -1.5}, {1.2, 1.5}}
boat.collision_box = {{-1.3, -1.5}, {1.3, 1.5}}
boat.selection_priority = 51
--boat.vertical_selection_shift = 5
boat.connection_distance = 1
boat.joint_distance = 2.5
boat.water_reflection = water_reflection("boat/railed/boat", 60, 15, true)
boat.weight = 5000
boat.inventory_size = 60
boat.max_speed = boat_max_speed
boat.pictures = boat_pictures
boat.back_light = ship_light(-15, true)
boat.stand_by_light = nil
boat.horizontal_doors = nil
boat.vertical_doors = nil
boat.wheels = nil
boat.working_sound = nil
boat.drive_over_tie_trigger = nil
boat.corpse = nil

----------------------------------------------------------------
------------------------ BOAT ENGINE ---------------------------
----------------------------------------------------------------

local boat_engine_power = 300 + (speed_modifier -1) * 150

local boat_engine = table.deepcopy(data.raw["locomotive"]["locomotive"])
boat_engine.name = "boat_engine"
boat_engine.flags = {"not-deconstructable", "placeable-neutral", "player-creation"}
boat_engine.allow_copy_paste = true
boat_engine.minable = nil
boat_engine.icon = GRAPHICSPATH .. "icons/boat.png"
boat_engine.icon_size = 64
boat_engine.weight = 5000
boat_engine.max_speed = boat_max_speed
boat_engine.max_power = boat_engine_power .. "kW"
boat_engine.air_resistance = 0.02
boat_engine.collision_box = {{-1.1, -1.2}, {1.1, 1.2}}
boat_engine.selection_box = {{-1.3, -1.2}, {1.3, 1.2}}
boat_engine.selection_priority = 51
boat_engine.connection_distance = 1
boat_engine.joint_distance = 1.7
boat_engine.burner = {
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 3 * fuel_modifier,
  smoke = {
    {
      name = "light-smoke",
      deviation = {0.3, 0.3},
      frequency = 60,
      position = {0.5, 2.5},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 2.5,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0.02,
    },
    {
      name = "wave",
      deviation = {0.3, 0.3},
      frequency = 45,
      position = {0, 5},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    },
    {
      name = "wave_circle",
      deviation = {0.8, 0.8},
      frequency = 15,
      position = {0, 5},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    }
  }
}
boat_engine.pictures = emptypic
boat_engine.water_reflection = nil
boat_engine.wheels = nil
boat_engine.working_sound = car_sounds
boat_engine.front_light = nil
boat_engine.front_light_pictures = nil
boat_engine.back_light = nil
boat_engine.stand_by_light = nil
boat_engine.stop_trigger = nil
boat_engine.drive_over_tie_trigger = nil
boat_engine.corpse = nil

----------------------------------------------------------------
------------------------ CARGO SHIP ----------------------------
----------------------------------------------------------------

local ship_max_speed = 0.15 * speed_modifier

local cargo_ship = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
cargo_ship.name = "cargo_ship"
cargo_ship.icon = GRAPHICSPATH .. "icons/cargoship_icon.png"
cargo_ship.icon_size = 64
cargo_ship.flags = {"placeable-neutral", "player-creation", "placeable-off-grid"}
cargo_ship.allow_copy_paste = true
cargo_ship.minable = {mining_time = 1, result = "cargo_ship"}
cargo_ship.max_health = 5000
cargo_ship.selection_box = {{-1.5, -8.5}, {1.5, 8.5}}
cargo_ship.collision_box = {{-1.5, -7.5}, {1.5, 7.5}}
cargo_ship.selection_priority = 51
cargo_ship.drawing_box = {{-1, -8}, {1, 8}}
cargo_ship.connection_distance = 3
cargo_ship.joint_distance = 12
cargo_ship.weight = 100000
cargo_ship.inventory_size = 1000
cargo_ship.max_speed = ship_max_speed
cargo_ship.air_resistance = 0.40
cargo_ship.water_reflection = water_reflection("cargo_ship/cargo_ship", 170, 25, true) --nil
cargo_ship.pictures = cargo_ship_pictures
cargo_ship.stand_by_light = {ship_light(-3, true)}
cargo_ship.back_light = nil
cargo_ship.vertical_doors = {
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/cargo_ship/vertical_doors.png",
      line_length = 12,
      width = 176,
      height = 480,
      frame_count = 12,
      scale = 0.85,
      shift = util.by_pixel(0,-32.5),
    }
  }
}
cargo_ship.horizontal_doors = {
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/cargo_ship/horizontal_doors.png",
      line_length = 1,
      width = 504,
      height = 142,
      frame_count = 12,
      scale = 0.85,
      shift = util.by_pixel(2,-32.5),
    }
  }
}
cargo_ship.wheels = nil
cargo_ship.working_sound = ships_working_sound
cargo_ship.drive_over_tie_trigger = nil
cargo_ship.minimap_representation = {
  filename = GRAPHICSPATH .. "entity/cargo_ship/cargo_ship-minimap-representation.png",
  flags = {"icon"},
  size = {26, 160},
  scale = 0.5
}
cargo_ship.selected_minimap_representation = {
  filename = GRAPHICSPATH .. "entity/cargo_ship/cargo_ship-selected-minimap-representation.png",
  flags = {"icon"},
  size = {26, 160},
  scale = 0.5
}
cargo_ship.corpse = nil

----------------------------------------------------------------
------------------------ OIL TANKER ----------------------------
----------------------------------------------------------------

local tanker_capacity = settings.startup["tanker_capacity"].value

local oil_tanker = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"])
oil_tanker.name = "oil_tanker"
oil_tanker.icon = GRAPHICSPATH .. "icons/tanker.png"
oil_tanker.icon_size = 64
oil_tanker.flags = {"placeable-neutral", "player-creation", "placeable-off-grid"}
oil_tanker.allow_copy_paste = true
oil_tanker.minable = {mining_time = 1, result = "oil_tanker"}
oil_tanker.max_health = 5000
oil_tanker.selection_box = {{-1.5, -8.5}, {1.5, 8.5}}
oil_tanker.selection_priority = 51
oil_tanker.collision_box = {{-1.5, -7.5}, {1.5, 7.5}}
oil_tanker.drawing_box = {{-1, -8}, {1, 8}}
oil_tanker.connection_distance = 3
oil_tanker.joint_distance = 12
oil_tanker.weight = 120000
oil_tanker.capacity = tanker_capacity * 1000
oil_tanker.max_speed = ship_max_speed
oil_tanker.air_resistance = 0.40
oil_tanker.water_reflection = water_reflection("tanker/tanker", 170, 25, true)
oil_tanker.pictures = oil_tanker_pictures
oil_tanker.stand_by_light = {ship_light(-3, true)}
oil_tanker.back_light = nil
oil_tanker.wheels = nil
oil_tanker.working_sound = ships_working_sound
oil_tanker.drive_over_tie_trigger = nil
oil_tanker.minimap_representation = {
  filename = GRAPHICSPATH .. "entity/tanker/tanker-minimap-representation.png",
  flags = {"icon"},
  size = {26, 160},
  scale = 0.5
}
oil_tanker.selected_minimap_representation = {
  filename = GRAPHICSPATH .. "entity/tanker/tanker-selected-minimap-representation.png",
  flags = {"icon"},
  size = {26, 160},
  scale = 0.5
}
oil_tanker.corpse = nil

----------------------------------------------------------------
------------------------ CARGO SHIP ENGINE ---------------------
----------------------------------------------------------------

local cargo_ship_engine_power = 2000 + (speed_modifier-1)*1200

local cargo_ship_engine = table.deepcopy(data.raw["locomotive"]["locomotive"])
cargo_ship_engine.name = "cargo_ship_engine"
cargo_ship_engine.minable = nil
cargo_ship_engine.flags =  {"not-deconstructable", "placeable-neutral", "player-creation"}
cargo_ship_engine.allow_copy_paste = true
cargo_ship_engine.icon = "__base__/graphics/icons/engine-unit.png"
cargo_ship_engine.icon_size = 64
cargo_ship_engine.icon_mipmaps = 4
cargo_ship_engine.weight = 100000
cargo_ship_engine.max_speed = ship_max_speed
cargo_ship_engine.max_power = cargo_ship_engine_power.."kW"
cargo_ship_engine.air_resistance = 0.40
cargo_ship_engine.collision_box = {{-1.1, -1.2}, {1.1, 1.2}}
cargo_ship_engine.selection_box = {{-1.3, -1.2}, {1.3, 1.2}}
cargo_ship_engine.selection_priority = 51
cargo_ship_engine.connection_distance = 3
cargo_ship_engine.joint_distance = 1.7
cargo_ship_engine.burner = {
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 5 * fuel_modifier,
  smoke = {
    {
      name = "tank-smoke",
      deviation = {0.3, 1.5},
      frequency = 200,
      position = {0, 1},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 3,
      height_deviation = 0.5,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0.1,
    },
    {
      name = "wave",
      deviation = {0.3, 0.3},
      frequency = 30,
      position = {-0.8, 1},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    },
    {
      name = "wave",
      deviation = {0.3, 0.3},
      frequency = 30,
      position = {0.8, 1},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    },
    {
      name = "wave_circle",
      deviation = {0.8, 0.8},
      frequency = 15,
      position = {0, 1},
      starting_frame = 0,
      starting_frame_deviation = 60,
      height = 0,
      height_deviation = 0.2,
      starting_vertical_speed = 0.0,
      starting_vertical_speed_deviation = 0,
    },

  }
}
cargo_ship_engine.pictures = emptypic
cargo_ship_engine.minimap_representation = nil
cargo_ship_engine.selected_minimap_representation = nil
cargo_ship_engine.water_reflection = nil
cargo_ship_engine.wheels = nil
cargo_ship_engine.working_sound = tank_sounds
cargo_ship_engine.front_light = nil
cargo_ship_engine.front_light_pictures = nil
cargo_ship_engine.back_light = nil
cargo_ship_engine.stand_by_light = nil
cargo_ship_engine.stop_trigger = nil
cargo_ship_engine.drive_over_tie_trigger = nil
cargo_ship_engine.corpse = nil

data:extend{cargo_ship_engine, cargo_ship, oil_tanker, indep_boat, boat, boat_engine}
