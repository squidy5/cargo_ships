non_standard_wheels =
{
  priority = "very-low",
  width = 2,
  height = 2,
  direction_count = 256,
  filenames =
  {
      "__cargo-ships__/graphics/blank.png",
      "__cargo-ships__/graphics/blank.png"
  },
  line_length = 8,
  lines_per_file = 16
}
function ship_light()
return
{
  {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = "__cargo-ships__/graphics/light-cone.png",
      priority = "extra-high",
      flags = { "light" },
      scale = 2,
      width = 200,
      height = 200
    },
    shift = {0, -3},
    size = 2,
    intensity = 0.8,
    color = {r = 0.92, g = 0.77, b = 0.3}
  },
}
end

local wave = table.deepcopy(data.raw["trivial-smoke"]["light-smoke"])
wave.name = "wave"
wave.cyclic = false
wave.affected_by_wind = false
wave.animation =
    {
      filename = "__base__/graphics/entity/water-splash/water-splash.png",
      priority = "extra-high",
      width = 92,
      height = 66,
      frame_count = 15,
      line_length = 5,
      shift = {-0.437, -0.5},
      animation_speed = 0.15,
    }
wave.start_scale = 1.3
wave.color = { r = 0.9, g = 0.9, b = 0.9 }
wave.render_layer = "lower-object"

data:extend({wave})






----------------------------------------------------------------
------------------------ BOAT indep ---------------------------
----------------------------------------------------------------

local indep_boat=table.deepcopy(data.raw["car"]["car"])
indep_boat.name = "indep-boat"
indep_boat.collision_mask = {"ground-tile", "train-layer"}
indep_boat.collision_box = {{-1.2, -3}, {1.2, 3}}
indep_boat.selection_box = {{-1.2, -3}, {1.2, 3}}
indep_boat.max_health = 600
indep_boat.icon = "__cargo-ships__/graphics/icons/boat.png"
indep_boat.icon_size = 64
indep_boat.guns= nil
indep_boat.braking_power = "150kW"
indep_boat.weight = 10000
indep_boat.consumption = "300kW"
indep_boat.minable = {mining_time = 1,result = "boat"}
indep_boat.rotation_speed = 0.008
indep_boat.inventory_size = 80

indep_boat.burner =
{
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 3,
  smoke =
    {
      {
        name = "light-smoke",
        deviation = {0.3, 0.3},
        frequency = 60,
        position = {0.5, 1},
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
indep_boat.working_sound =
{
  sound =
  {
    filename = "__base__/sound/car-engine.ogg",
    volume = 1.3
  },
  activate_sound =
  {
    filename = "__base__/sound/car-engine-start.ogg",
    volume = 1.3
  },
  deactivate_sound =
  {
    filename = "__base__/sound/car-engine-stop.ogg",
    volume = 1.3
  },
  match_speed =true
}
indep_boat.animation =
    {
      layers =
      {
        {
          priority = "low",
          width = 250,
          height = 250,
          frame_count = 1,
          direction_count = 64,
          shift = {0, 0.15},
          scale = 1.19,
          animation_speed = 8,
          max_advance = 0.2,
          stripes =
          {
            {
             filename = "__cargo-ships__/graphics/entity/boat/indep/boat.png",
             width_in_frames = 8,
             height_in_frames = 8,            
            }
          }          
      }
    }
  }

indep_boat.turret_animation = {
    layers = {
          {
            animation_speed = 8,
            direction_count = 1,
            frame_count = 1,
            height = 1,
      width = 1,
            max_advance = 0.2,
            priority = "low",
            shift = {0,0},
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

indep_boat.light =  {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = "__cargo-ships__/graphics/light-cone-boat.png",
      priority = "extra-high",
      flags = { "light" },
      scale = 2,
      width = 200,
      height = 200
    },
    shift = {0, -13},
    size = 2,
    intensity = 0.8,
    color = {r = 0.92, g = 0.77, b = 0.3}
  }

----------------------------------------------------------------
------------------------ BOAT  ----------------------------
----------------------------------------------------------------


local boat=table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
boat.name = "boat"
boat.icon = "__cargo-ships__/graphics/icons/boat.png"
boat.flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-on-map"}
boat.minable = {mining_time = 1, result = "boat"}

boat.selection_box = {{-1.2, -1.5}, {1.2, 1.5}}
boat.collision_box = {{-1.3, -1.5}, {1.3, 1.5}}
boat.connection_distance = 1
boat.joint_distance = 2.5

boat.weight = 5000
boat.inventory_size = 60
boat.max_speed = 0.3

boat.pictures =
{
  layers =
  {
    {
      slice = 4,
      priority = "low",
      width = 250,
      height = 250,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames =
      {
        "__cargo-ships__/graphics/entity/boat/boat-0.png",
        "__cargo-ships__/graphics/entity/boat/boat-1.png",
        "__cargo-ships__/graphics/entity/boat/boat-2.png",
        "__cargo-ships__/graphics/entity/boat/boat-3.png",
      },
      line_length = 8,
      lines_per_file = 8,
      scale = 1.5,--3,
      shift = {0.0, -0.7}
    }
  }
}
boat.back_light =  {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = "__cargo-ships__/graphics/light-cone-boat.png",
      priority = "extra-high",
      flags = { "light" },
      scale = 2,
      width = 200,
      height = 200
    },
    shift = {0, -15},
    size = 2,
    intensity = 0.8,
    color = {r = 0.92, g = 0.77, b = 0.3}
  }
boat.stand_by_light = nil
boat.horizontal_doors = nil
boat.vertical_doors = nil
boat.wheels = non_standard_wheels
boat.working_sound = nil
boat.drive_over_tie_trigger = nil


----------------------------------------------------------------
------------------------ BOAT ENGINE ---------------------------
----------------------------------------------------------------

local boat_engine = table.deepcopy(data.raw["locomotive"]["locomotive"])
boat_engine.name = "boat_engine"
boat_engine.minable = nil
boat_engine.weigt = 5000
boat_engine.max_speed = 0.27
boat_engine.max_power = "300kW"
boat_engine.air_resistance = 0.02
boat_engine.collision_box = {{-1.1, -1.2}, {1.1, 1.2}}
boat_engine.selection_box = {{-1.3, -1.2}, {1.3, 1.2}}
boat_engine.connection_distance = 1
boat_engine.joint_distance = 1.7
boat_engine.burner =
{
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 4,
  smoke =
  {
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
    }
  }
}
boat_engine.pictures =
{
  layers =
  {
    {
      slice = 4,
      priority = "very-low",
      width = 1,
      height = 1,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames =
      {
        "__cargo-ships__/graphics/blank.png",
      },
      line_length = 16,
      lines_per_file = 16,
      scale = 3,
      shift = {0.0, -0.7}
    }
  }
}
boat_engine.wheels = non_standard_wheels
boat_engine.working_sound =
    {
      sound =
      {
        filename = "__base__/sound/car-engine.ogg",
        volume = 1.3
      },
      activate_sound =
      {
        filename = "__base__/sound/car-engine-start.ogg",
        volume = 1.3
      },
      deactivate_sound =
      {
        filename = "__base__/sound/car-engine-stop.ogg",
        volume = 1.3
      },
      match_speed_to_activity = true
    }
boat_engine.front_light = nil
boat_engine.back_light = nil
boat_engine.stand_by_light = nil
boat_engine.stop_trigger = nil
boat_engine.drive_over_tie_trigger = nil


----------------------------------------------------------------
------------------------ CARGO SHIP ----------------------------
----------------------------------------------------------------


local cargo_ship=table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
cargo_ship.name = "cargo_ship"
cargo_ship.icon = "__cargo-ships__/graphics/icons/cargoship_icon.png"
cargo_ship.flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-on-map"}
cargo_ship.minable = {mining_time = 1, result = "cargo_ship"}

cargo_ship.selection_box = {{-1.5, -8.5}, {1.5, 8.5}}
cargo_ship.collision_box = {{-1.5, -7.5}, {1.5, 7.5}}
cargo_ship.drawing_box = {{-1, -8}, {1, 8}}
cargo_ship.connection_distance = 3
cargo_ship.joint_distance = 12


cargo_ship.weight = 100000
cargo_ship.inventory_size = 1000
cargo_ship.max_speed = 0.15
cargo_ship.air_resistance = 0.40


cargo_ship.pictures =
{
	layers =
	{
		{
			slice = 4,
			priority = "low",
			width = 500,
			height = 500,
			direction_count = 256,
  		allow_low_quality_rotation = true,
			filenames =
			{
        "__cargo-ships__/graphics/entity/cargo_ship/cs_0.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_1.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_2.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_3.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_4.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_5.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_6.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_7.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_8.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_9.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_10.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_11.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_12.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_13.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_14.png",
        "__cargo-ships__/graphics/entity/cargo_ship/cs_15.png",
      },
			line_length = 4,
  		lines_per_file = 4,
  		scale = 1.7,--3,
  		shift = {0.0, -1.7}
		}
	}
}
cargo_ship.stand_by_light = ship_light()
--cargo_ship.back_light = ship_light()

cargo_ship.vertical_doors = 
{
  layers =
  {

    {
      filename = "__cargo-ships__/graphics/entity/cargo_ship/vertical_doors.png",
      line_length = 12,
      width = 88,
      height = 240,
      frame_count = 12,
      scale = 1.7,
      shift = {0.0, -1.01563},
    }
  }
}
cargo_ship.horizontal_doors = 
{
  layers =
  {

    {
      filename = "__cargo-ships__/graphics/entity/cargo_ship/horizontal_doors.png",
      line_length = 1,
      width = 252,
      height = 71,
      frame_count = 12,
      scale = 1.7,
      shift = {0.055625, -1.01563},
    }
  }
}

cargo_ship.wheels = non_standard_wheels
cargo_ship.working_sound = nil
cargo_ship.drive_over_tie_trigger = nil




----------------------------------------------------------------
------------------------ OIL TANKER ----------------------------
----------------------------------------------------------------

local oil_tanker=table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"])
oil_tanker.name = "oil_tanker"
oil_tanker.icon =  "__cargo-ships__/graphics/icons/cargoship_icon.png"
oil_tanker.flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-on-map"}
oil_tanker.minable = {mining_time = 1, result = "oil_tanker"}

oil_tanker.selection_box = {{-1.5, -8.5}, {1.5, 8.5}}
oil_tanker.collision_box = {{-1.5, -7.5}, {1.5, 7.5}}
oil_tanker.drawing_box = {{-1, -8}, {1, 8}}
oil_tanker.connection_distance = 3
oil_tanker.joint_distance = 12


oil_tanker.weight = 120000
oil_tanker.capacity = 150000
oil_tanker.max_speed = 0.12
oil_tanker.air_resistance = 0.40


oil_tanker.pictures =
{

  layers =
  {
    {
      slice = 4,
      priority = "very-low",
      width = 500,
      height = 500,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames =
      {
        "__cargo-ships__/graphics/entity/tanker/tanker_0.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_1.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_2.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_3.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_4.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_5.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_6.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_7.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_8.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_9.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_10.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_11.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_12.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_13.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_14.png",
        "__cargo-ships__/graphics/entity/tanker/tanker_15.png",
      },
      line_length = 4,
      lines_per_file = 4,
      scale = 1.7,
      shift = {0.0, -0.7}
    }
  }
} 
oil_tanker.stand_by_light = ship_light() 
oil_tanker.back_light = nil

oil_tanker.wheels = non_standard_wheels
oil_tanker.working_sound = nil
oil_tanker.drive_over_tie_trigger = nil



----------------------------------------------------------------
------------------------ CARGO SHIP ENGINE ---------------------
----------------------------------------------------------------


local cargo_ship_engine=table.deepcopy(data.raw["locomotive"]["locomotive"])
cargo_ship_engine.name = "cargo_ship_engine"
cargo_ship_engine.minable = nil
cargo_ship_engine.weight = 100000
cargo_ship_engine.max_speed = 0.15
cargo_ship_engine.max_power = "2000kW"
cargo_ship_engine.air_resistance = 0.40
cargo_ship_engine.collision_box = {{-1.1, -1.2}, {1.1, 1.2}}
cargo_ship_engine.selection_box = {{-1.3, -1.2}, {1.3, 1.2}}
cargo_ship_engine.connection_distance = 3
cargo_ship_engine.joint_distance = 1.7
cargo_ship_engine.burner =
{
  fuel_category = "chemical",
  effectivity = 1,
  fuel_inventory_size = 6,
  smoke =
  {
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
    }

  }
}
cargo_ship_engine.pictures =
{
  layers =
  {
    {
      slice = 4,
      priority = "very-low",
      width = 1,
      height = 1,
      direction_count = 256,
      allow_low_quality_rotation = true,
      filenames =
      {
        "__cargo-ships__/graphics/blank.png",
      },
      line_length = 16,
      lines_per_file = 16,
      scale = 3,
      shift = {0.0, -0.7}
    }
  }
}

cargo_ship_engine.wheels = non_standard_wheels
cargo_ship_engine.working_sound =
  {
    sound =
    {
      filename = "__base__/sound/fight/tank-engine.ogg",
      volume = 1.1
    },
    activate_sound =
    {
      filename = "__base__/sound/fight/tank-engine-start.ogg",
      volume = 1.1
    },
    deactivate_sound =
    {
      filename = "__base__/sound/fight/tank-engine-stop.ogg",
      volume = 1.1  
    },
    match_speed_to_activity=true
  }
cargo_ship_engine.front_light = nil
cargo_ship_engine.back_light = nil
cargo_ship_engine.stand_by_light = nil
cargo_ship_engine.stop_trigger = nil
cargo_ship_engine.drive_over_tie_trigger = nil




data:extend({cargo_ship_engine,cargo_ship, oil_tanker, indep_boat, boat, boat_engine})