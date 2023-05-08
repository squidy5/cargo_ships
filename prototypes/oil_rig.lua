if settings.startup["deep_oil"].value then

local function oilrig_layer(orientation, animated)
  local returned_value = {
    layers = {
      {
        filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-pipe-" .. orientation .. ".png",
        width = 352,
        height = 448,
        scale = 1,
        frame_count = 1,
        repeat_count = 20,
        animation_speed = 0.25,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-pipe-" .. orientation .. ".png",
          width = 704,
          height = 896,
          scale = 0.5,
          frame_count = 1,
          repeat_count = 20,
        animation_speed = 0.25,
        }
      },
      {
        filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-base.png",
        width = 352,
        height = 448,
        scale = 1,
        frame_count = 1,
        repeat_count = 20,
        animation_speed = 0.25,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-base.png",
          width = 704,
          height = 896,
          scale = 0.5,
          frame_count = 1,
          repeat_count = 20,
          animation_speed = 0.25,
        }
      },
      {
        filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-base-shadow.png",
        width = 352,
        height = 448,
        scale = 1,
        draw_as_shadow = true,
        frame_count = 1,
        repeat_count = 20,
        animation_speed = 0.25,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-base-shadow.png",
          width = 704,
          height = 896,
          scale = 0.5,
          draw_as_shadow = true,
          frame_count = 1,
          repeat_count = 20,
          animation_speed = 0.25,
        }
      },
      {
        filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-base-light.png",
        width = 352,
        height = 448,
        scale = 1,
        draw_as_light = true,
        frame_count = 1,
        repeat_count = 20,
        animation_speed = 0.25,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-base-light.png",
          width = 704,
          height = 896,
          scale = 0.5,
          draw_as_light = true,
          frame_count = 1,
          repeat_count = 20,
          animation_speed = 0.25,
        }
      },

    }
  }

  if animated then
    table.insert(returned_value.layers, {
      filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-anim.png",
      width = 179,
      height = 243,
      scale = 1,
      line_length = 5,
      frame_count = 20,
      animation_speed = 0.25,
      hr_version = {
        filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-anim.png",
        width = 358,
        height = 486,
        scale = 0.5,
        line_length = 5,
        frame_count = 20,
        animation_speed = 0.25,
      }
    })
  else
    table.insert(returned_value.layers, {
      filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-anim.png",
      width = 179,
      height = 243,
      scale = 1,
      line_length = 1,
      frame_count = 1,
      repeat_count = 20,
      animation_speed = 0.25,
      hr_version = {
        filename = GRAPHICSPATH .. "entity/oil_rig/hr-oil-rig-anim.png",
        width = 358,
        height = 486,
        scale = 0.5,
        line_length = 1,
        frame_count = 1,
        repeat_count = 20,
        animation_speed = 0.25,
      }
    })
  end

  return returned_value
end

----------------------------------------------------------------
--------------------------- OIL RIG ----------------------------
----------------------------------------------------------------
local oil_rig_capacity = settings.startup["oil_rig_capacity"].value

circuit_connector_definitions["oil_rig"] = circuit_connector_definitions.create
(
  universal_connector_template,
  {
    { variation = 26, main_offset = util.by_pixel(-96, 76), shadow_offset = util.by_pixel(-72, 104), show_shadow = true },
    { variation = 26, main_offset = util.by_pixel(-96, 76), shadow_offset = util.by_pixel(-72, 104), show_shadow = true },
    { variation = 26, main_offset = util.by_pixel(-96, 76), shadow_offset = util.by_pixel(-72, 104), show_shadow = true },
    { variation = 26, main_offset = util.by_pixel(-96, 76), shadow_offset = util.by_pixel(-72, 104), show_shadow = true }
  }
)

local oil_rig = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
oil_rig.name = "oil_rig"
oil_rig.icon = GRAPHICSPATH .. "icons/oil_rig.png"
oil_rig.icon_size = 64
oil_rig.collision_mask = {'object-layer', "train-layer"}
oil_rig.minable = {mining_time = 3, result = "oil_rig"}
oil_rig.dying_explosion = "big-explosion"
oil_rig.max_health = 1000
oil_rig.energy_usage = "750kW"
oil_rig.mining_speed = 2
oil_rig.resource_searching_radius = 1.49
oil_rig.collision_box = {{-3.2, -3.2}, {3.2, 3.2}}
oil_rig.selection_box = {{-3.5, -3.5}, {3.5, 3.5}}
oil_rig.drawing_box = {{-3.3, -3.3}, {3.3, 3.3}}
oil_rig.fast_replaceable_group  = nil
oil_rig.next_upgrade = nil
oil_rig.module_specification.module_slots = 3
oil_rig.energy_source = {
  type = "electric",
  emissions_per_minute = 25,
  usage_priority = "secondary-input"
}
oil_rig.output_fluid_box = {
  base_area = 10,
  base_level = 10,
  height = 2*oil_rig_capacity,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {0, -4}}
  },
}
oil_rig.graphics_set = {
  idle_animation = {
    north = oilrig_layer("n"),
    east = oilrig_layer("e"),
    south = oilrig_layer("s"),
    west = oilrig_layer("w"),
  },
  --always_draw_idle_animation = true,
  animation = {
    north = oilrig_layer("n", true),
    east = oilrig_layer("e", true),
    south = oilrig_layer("s", true),
    west = oilrig_layer("w", true),
  },
}
oil_rig.animations = nil
oil_rig.base_picture = nil
oil_rig.integration_patch = nil
oil_rig.water_reflection = {
  pictures = {
    filename = GRAPHICSPATH .. "entity/oil_rig/oil-rig-water-reflection.png",
    width = 70,
    height = 89,
    shift = util.by_pixel(0, 0),
    variation_count = 1,
    scale = 5
  },
  rotate = false,
  orientation_to_variation = false
}
oil_rig.circuit_wire_connection_points = circuit_connector_definitions["oil_rig"].points
oil_rig.circuit_connector_sprites = circuit_connector_definitions["oil_rig"].sprites

----------------------------------------------------------------
----------- OIL PLATFORM SLAVE ENTITES--------------------------
----------------------------------------------------------------

local or_power = table.deepcopy(data.raw["generator"]["steam-engine"])
or_power.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}
or_power.selectable_in_game = false
or_power.allow_copy_paste = false
or_power.name = "or_power"
or_power.collision_box = nil
or_power.selection_box = nil
or_power.collision_mask = {}
or_power.fast_replaceable_group = nil
or_power.next_upgrade = nil
or_power.fluid_usage_per_tick = 1
or_power.fluid_box = {
  base_area = 1,
  height = 1,
  base_level = -1,
  pipe_covers = nil,
  pipe_connections = {},
  production_type = "input-output",
  filter = "steam",
  minimum_temperature = 100.0
}
or_power.horizontal_animation = emptypic
or_power.vertical_animation = emptypic
local smoke1shift = util.by_pixel(-85 + 2, -115 + 2)
local smoke2shift = util.by_pixel(53 + 2, -167 + 2)
or_power.smoke = {
  {
    name = "light-smoke",
    north_position = smoke1shift,
    east_position = smoke1shift,
    south_position = smoke1shift,
    west_position = smoke1shift,
    frequency = 0.5,
    starting_vertical_speed = 0.05,
    slow_down_factor = 1,
    starting_frame_deviation = 60
  },
  {
    name = "smoke",
    north_position = smoke2shift,
    east_position = smoke2shift,
    south_position = smoke2shift,
    west_position = smoke2shift,
    frequency = 1,
    starting_vertical_speed = 0.05,
    slow_down_factor = 1,
    starting_frame_deviation = 60
  }
}
or_power.water_reflection = nil
or_power.working_sound = nil

local or_pole = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
or_pole.name = "or_pole"
or_pole.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}
or_pole.selectable_in_game = false
or_pole.allow_copy_paste = false
or_pole.collision_box = nil
or_pole.selection_box = nil
or_pole.collision_mask = {}
or_pole.fast_replaceable_group = nil
or_pole.next_upgrade = nil
or_pole.maximum_wire_distance = 0
or_pole.pictures = emptypic
or_pole.supply_area_distance = 4.5
or_pole.water_reflection = nil
or_pole.connection_points = { data.raw["electric-pole"]["medium-electric-pole"].connection_points[1] }

local or_radar = table.deepcopy(data.raw["radar"]["radar"])
or_radar.name = "or_radar"
or_radar.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}
or_radar.selectable_in_game = false
or_radar.allow_copy_paste = false
or_radar.collision_mask = {}
or_radar.collision_box = nil
or_radar.selection_box = nil
or_radar.fast_replaceable_group = nil
or_radar.next_upgrade = nil
or_radar.pictures = emptypic
or_radar.max_distance_of_sector_revealed = 0
or_radar.energy_usage = "50kW"
or_radar.water_reflection = nil
or_radar.working_sound = nil

data:extend{oil_rig, or_power, or_pole, or_radar}

end
