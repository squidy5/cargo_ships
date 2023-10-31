-- Do not add any of the oil rig entities if offshore oil has been disabled
if not settings.startup["deep_oil"].value then
  return
end

local external_power = settings.startup["oil_rigs_require_external_power"].value

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
if external_power == "disabled" then
  oil_rig.energy_source = {
    type = "void",
    emissions_per_minute = 25,
  }
else
  oil_rig.energy_source = {
    type = "electric",
    emissions_per_minute = 25,
    usage_priority = "secondary-input",
  }
end

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
local smoke1shift = util.by_pixel(-85 + 2, -115 + 2)
local smoke2shift = util.by_pixel(53 + 2, -167 + 2)

-- loop from 0 to 1 in increments of 0.1
for i = 0, 10 do
  local frequency = i / 10
  data:extend{
    {
      type = "particle-source",
      name = "or-smoke-" .. i,
      subgroup = "particles",
      flags = {"placeable-off-grid"},
      time_to_live = 30,
      time_before_start = 0,
      height = 0,
      vertical_speed = 0,
      horizontal_speed = 0,
      smoke = {
        {
          name = "light-smoke",
          north_position = smoke1shift,
          east_position = smoke1shift,
          south_position = smoke1shift,
          west_position = smoke1shift,
          frequency = 0.25 * frequency,
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
          frequency = 0.5 * frequency,
          starting_vertical_speed = 0.05,
          slow_down_factor = 1,
          starting_frame_deviation = 60
        },
      },
    },
  }
end

local or_power_electric = table.deepcopy(data.raw["electric-energy-interface"]["hidden-electric-energy-interface"])
or_power_electric.name = "or_power_electric"
or_power_electric.icon = oil_rig.icon
or_power_electric.icon_size = oil_rig.icon_size
or_power_electric.localised_name = nil
if external_power == "disabled" then
  or_power_electric.energy_production = "100kW"  -- Just enough for surrounding pumps
  or_power_electric.energy_source.output_flow_limit = "100kW"
elseif external_power == "enabled" then
  or_power_electric.energy_production = "0kW"
  or_power_electric.energy_source.output_flow_limit = "0kW"
elseif external_power == "only-when-moduled" then
  or_power_electric.energy_production = "850kW"  -- 750kW for the rig, 100kW for surrounding pumps
  or_power_electric.energy_source.output_flow_limit = "850kW"
end
or_power_electric.energy_source.render_no_power_icon = false
or_power_electric.energy_source.usage_priority = "secondary-output"
or_power_electric.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}

local or_pole = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
or_pole.name = "or_pole"
or_pole.icon = oil_rig.icon
or_pole.icon_size = oil_rig.icon_size
or_pole.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid"}
or_pole.selectable_in_game = true
or_pole.allow_copy_paste = false
or_pole.minable = nil
or_pole.collision_box = nil
or_pole.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
or_pole.selection_priority = 56
or_pole.collision_mask = {}
or_pole.fast_replaceable_group = nil
or_pole.next_upgrade = nil
if external_power == "disabled" then
  or_pole.maximum_wire_distance = 0
else
  or_pole.maximum_wire_distance = 20
end
or_pole.pictures = emptypic
or_pole.supply_area_distance = 4.5
or_pole.water_reflection = nil
or_pole.connection_points = {
  {
    shadow =
    {
      copper = util.by_pixel_hr(0, 0),  -- TODO
    },
    wire =
    {
      copper = util.by_pixel_hr(0, 0),  -- TODO
    }
  },
}
local or_radar = table.deepcopy(data.raw["radar"]["radar"])
or_radar.name = "or_radar"
or_radar.icon = oil_rig.icon
or_radar.icon_size = oil_rig.icon_size
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
or_radar.energy_usage = "30kW"
or_radar.energy_source = {
  type = "void",
  emissions_per_minute = 0,
}
or_radar.water_reflection = nil
or_radar.working_sound = nil

data:extend{oil_rig, or_power_electric, or_pole, or_radar}
