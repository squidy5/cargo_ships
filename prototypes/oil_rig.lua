local empty_pic = "__cargo-ships__/graphics/blank.png"

----------------------------------------------------------------
-------------------------DEEP SEA OIL --------------------------
----------------------------------------------------------------

local deep_oil = table.deepcopy(data.raw["resource"]["crude-oil"])
if mods["angelspetrochem"] then
  deep_oil.minable = {
    hardness = 1,
    mining_time = 1,
    results =
    {
      {
        type = "fluid",
        name = "liquid-multi-phase-oil",
        amount_min = 10,
        amount_max = 10,
        probability = 1
      }
    }
  }
end
deep_oil.name = "deep_oil"
deep_oil.infinite_depletion_amount = 40
deep_oil.autoplace = nil
deep_oil.collision_mask = {'ground-tile','resource-layer'}
deep_oil.resource_patch_search_radius = 32
deep_oil.stages = {
  sheet = {
    filename = "__cargo-ships__/graphics/entity/crude-oil/water-crude-oil.png",
    priority = "extra-high",
    width = 74,
    height = 60,
    frame_count = 4,
    variation_count = 1,
    shift = util.by_pixel(0, -2),
    scale = 1.4,
    hr_version =
    {
      filename = "__cargo-ships__/graphics/entity/crude-oil/hr-water-crude-oil.png",
      priority = "extra-high",
      width = 148,
      height = 120,
      frame_count = 4,
      variation_count = 1,
      shift = util.by_pixel(0, -2),
      scale = 0.7
    }
  }
}
deep_oil.water_reflection = nil
--[[{
  pictures = {
    sheet = {
      filename = "__cargo-ships__/graphics/entity/crude-oil/hr-water-crude-oil-water-reflection.png",
      width = 22,
      height = 24,
      --shift = util.by_pixel(0, 5),
      variation_count = 1,
      repeat_count = 4,
      scale = 5,

    }
  },
  rotate = false,
  orientation_to_variation = false
}]] -- FACTORIO dev confirms water_reflection only works for entities with health

local function oilrig_layer(orientation)
  return {
    layers = {
      {
        filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-pipe-" .. orientation .. ".png",
        width = 352,
        height = 448,
        scale = 1,
        hr_version = {
          filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-pipe-" .. orientation .. ".png",
          width = 704,
          height = 896,
          scale = 0.5,
        }
      },
      {
        filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base.png",
        width = 352,
        height = 448,
        scale = 1,
        hr_version = {
          filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base.png",
          width = 704,
          height = 896,
          scale = 0.5,
        }
      },
      {
        filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base-shadow.png",
        width = 352,
        height = 448,
        scale = 1,
        draw_as_shadow = true,
        hr_version = {
          filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base-shadow.png",
          width = 704,
          height = 896,
          scale = 0.5,
          draw_as_shadow = true,
        }
      },
      {
        filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base-light.png",
        width = 352,
        height = 448,
        scale = 1,
        draw_as_light = true,
        hr_version = {
          filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-base-light.png",
          width = 704,
          height = 896,
          scale = 0.5,
          draw_as_light = true,
        }
      },
    }
  }
end

----------------------------------------------------------------
------------------------ OIL PLATFORM --------------------------
----------------------------------------------------------------
local oil_rig_capacity = settings.startup["oil_rig_capacity"].value

local oil_rig = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
oil_rig.name = "oil_rig"
oil_rig.collision_mask = {'object-layer', "train-layer"}
oil_rig.minable = {mining_time = 3, result = "oil_rig"}
oil_rig.dying_explosion = "big-explosion"
oil_rig.max_health = 1000
oil_rig.energy_usage = "750kW"
oil_rig.mining_speed = 2
oil_rig.resource_searching_radius = 1.49
oil_rig.collision_box = {{-3.2, -3.2}, {3.2, 3.2}}
oil_rig.selection_box = {{-3.5, -3.5}, {3.5, 3.5}}
oil_rig.drawing_box =   {{-3.3, -3.3}, {3.3, 3.3}}
oil_rig.module_specification.module_slots = 3
oil_rig.energy_source =
{
  type = "electric",
  -- will produce this much * energy pollution units per tick
  emissions = 0.2/60,
  usage_priority = "secondary-input"
}
oil_rig.output_fluid_box =
{
  base_area = 10,
  base_level = 10,
  height = 2*oil_rig_capacity,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {0, -4}}
  },
}
oil_rig.base_picture =
{
  north = oilrig_layer("n"),
  east = oilrig_layer("e"),
  south = oilrig_layer("s"),
  west = oilrig_layer("w"),
}

local function loopriganimstripes(frame1, framelast)
  local stripes = {}
  for i=frame1,framelast do
    local stripe = {
      filename = "__cargo-ships__/graphics/entity/oil_rig/hr-oil-rig-anim-" .. i .. ".png",
      width_in_frames = 1,
      height_in_frames = 1,
    }
    table.insert(stripes, stripe)
  end
  return stripes
end

oil_rig.animations = {
  stripes = loopriganimstripes(1, 20),
  width = 358,
  height = 486,
  scale = 0.5,
  frame_count = 20,
  animation_speed = 0.25,
}
--[[oil_rig.animations = nil
oil_rig.graphics_set = {
  working_visualisations = {
    animation = {
      stripes = loopriganimstripes(1, 20),
      width = 358,
      height = 486,
      scale = 0.5,
      frame_count = 20,
      animation_speed = 0.25,
    }
  }
}]]
oil_rig.water_reflection = {
  pictures = {
    filename = "__cargo-ships__/graphics/entity/oil_rig/oil-rig-water-reflection.png",
    width = 70,
    height = 89,
    shift = util.by_pixel(0, 0),
    variation_count = 1,
    scale = 5
  },
  rotate = false,
  orientation_to_variation = false
}

----------------------------------------------------------------
----------- OIL PLATFORM SLAVE ENTITES--------------------------
----------------------------------------------------------------

local or_power = table.deepcopy(data.raw["generator"]["steam-engine"])
or_power.flags = {"not-blueprintable", "not-deconstructable"}
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
or_power.horizontal_animation = { filename = empty_pic, size = 1 }
or_power.vertical_animation = { filename = empty_pic, size = 1 }
local smoke1shift = util.by_pixel(-85 -14, -115 -14)
local smoke2shift = util.by_pixel(53 -14, -167 -14)
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
or_pole.flags = {"not-blueprintable", "not-deconstructable"}
or_pole.selectable_in_game = false
or_pole.allow_copy_paste = false
or_pole.collision_box = nil
or_pole.selection_box = nil
or_pole.collision_mask = {}
or_pole.fast_replaceable_group = nil
or_pole.next_upgrade = nil
or_pole.maximum_wire_distance = 0
or_pole.pictures = {
  filename = empty_pic,
  width = 2,
  height = 2,
  direction_count = 4,
  line_length = 4,
}
or_pole.supply_area_distance = 4.5
or_pole.water_reflection = nil

--[[
local or_lamp = table.deepcopy(data.raw["lamp"]["small-lamp"])
or_lamp.name = "or_lamp"
or_lamp.flags = {"not-blueprintable", "not-deconstructable"}
or_lamp.selectable_in_game = false
or_lamp.allow_copy_paste = false
or_lamp.collision_box = nil
or_lamp.selection_box = nil
or_lamp.collision_mask = {}
or_lamp.picture_off = {
  filename = empty_pic,
  width = 2,
  height = 2,
}
or_lamp.pciture_on = {}
]]

local or_radar = table.deepcopy(data.raw["radar"]["radar"])
or_radar.name = "or_radar"
or_radar.flags = {"not-blueprintable", "not-deconstructable"}
or_radar.selectable_in_game = false
or_radar.allow_copy_paste = false
or_radar.collision_mask = {}
or_radar.collision_box = nil
or_radar.selection_box = nil
or_radar.pictures = {
  filename = empty_pic,
  width = 2,
  height = 2,
  direction_count = 4,
  line_length = 4,
}
or_radar.max_distance_of_sector_revealed = 0
or_radar.energy_usage = "50kW"
or_radar.water_reflection = nil
or_radar.working_sound = nil

data:extend({oil_rig, or_power, or_pole, or_radar, deep_oil})
