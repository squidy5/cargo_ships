----------------------------------------------------------------
--------------------------- PUMP -------------------------------
----------------------------------------------------------------

local ship_pump=table.deepcopy(data.raw["pump"]["pump"])

ship_pump.name = "ship_pump"
ship_pump.minable = {mining_time = 1, result = "ship_pump"}
ship_pump.collision_mask = {}
ship_pump.pumping_speed = 400
ship_pump.energy_usage = "50kW"


----------------------------------------------------------------
-------------------------DEEP SEA OIL --------------------------
----------------------------------------------------------------


local deep_oil=table.deepcopy(data.raw["resource"]["crude-oil"])
deep_oil.name = "deep_oil"
deep_oil.infinite_depletion_amount = 40
--  deep_oil.collision_mask = {'ground-tile'}




----------------------------------------------------------------
------------------------ OIL PLATFORM --------------------------
----------------------------------------------------------------

local oil_rig=table.deepcopy(data.raw["mining-drill"]["pumpjack"])
oil_rig.name = "oil_rig"
oil_rig.collision_mask = {'ground-tile', 'object-layer', "player-layer"}
oil_rig.minable = {mining_time = 3, result = "oil_rig"}
oil_rig.dying_explosion = "big-explosion"
oil_rig.max_health = 1000
oil_rig.energy_usage = "850kW"
oil_rig.mining_speed = 2
oil_rig.resource_searching_radius = 1.49
oil_rig.collision_box = {{ -3.2, -3.2}, {3.2, 3.2}}
oil_rig.selection_box = {{ -3.3, -3.3}, {3.3, 3.3}}
oil_rig.drawing_box = {{-3.3, -3.3}, {3.3, 8}}
oil_rig.energy_source = 
{
  type = "electric",
  -- will produce this much * energy pollution units per tick
  emissions = 0.2,
  usage_priority = "secondary-input"
}
oil_rig.output_fluid_box =
{
  base_area = 10,
  base_level = 10,
  pipe_covers = pipecoverspictures(),
  pipe_connections =
  {
    { position = {0, -4}}
  },
}
oil_rig.base_picture =
{
  sheets =
  {
    {
      filename = "__cargo-ships__/graphics/entity/oil_rig/oil_rig.png",
      priority = "very-low",
      width = 300,
      height = 471,
      shift = util.by_pixel(-2.5, -29),
      scale = 0.9,
    }
  }
}
oil_rig.animations = 
{
  north =
  {
    layers = 
    {
      {
        priority = "high",
        filename = "__cargo-ships__/graphics/blank.png",
        line_length = 8,
        width = 1,
        height = 1,
        frame_count = 40,
        shift = util.by_pixel(-4, -24),
        animation_speed = 0.5,
      }
    }
  }
}




----------------------------------------------------------------
----------- OIL PLATFORM SLAVE ENTITES--------------------------
----------------------------------------------------------------

local or_power=table.deepcopy(data.raw["generator"]["steam-engine"])
or_power.name = "or_power"
or_power.collision_box= nil
or_power.selection_box= nil
or_power.collision_mask= {}
or_power.fast_replaceable_group = nil
or_power.fluid_usage_per_tick = 1
or_power.fluid_box =
    {
      base_area = 1,
      height = 1,
      base_level = -1,
      pipe_covers = nil,
      pipe_connections = {},
      production_type = "input-output",
      filter = "steam",
      minimum_temperature = 100.0
    }
or_power.horizontal_animation = 
{
  layers =
        {
          {
            filename = "__cargo-ships__/graphics/blank.png",
            width = 1,
            height = 1,
            frame_count = 32,
            line_length = 8,
          }
        }
}
or_power.vertical_animation = 
{
  layers =
  {
    {
      filename = "__cargo-ships__/graphics/blank.png",
      width = 1,
      height = 1,
      frame_count = 32,
      line_length = 8,
    }
  }
}
or_power.smoke =
{
  {
    name = "light-smoke",
    north_position = {-3.2, -4.5},
    frequency = 0.5,
    starting_vertical_speed = 0.08,
    slow_down_factor = 1,
    starting_frame_deviation = 60
  },
  {
    name = "smoke",
    north_position = {1.4, -4.5},
    frequency = 1,
    starting_vertical_speed = 0.12,
    slow_down_factor = 1,
    starting_frame_deviation = 60
  }
}



local or_pole=table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
or_pole.name = "or_pole"
or_pole.collision_box= nil
or_pole.selection_box= nil
or_pole.collision_mask= {}
or_pole.fast_replaceable_group = nil
or_pole.maximum_wire_distance = 0
or_pole.pictures =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 1,
  height = 1,
  direction_count = 4,
  line_length = 4,
}
or_pole.supply_area_distance = 4.5



local or_lamp=table.deepcopy(data.raw["lamp"]["small-lamp"])
or_lamp.name = "or_lamp"
or_lamp.collision_mask= {}
or_lamp.picture_off = 
{  
  filename = "__cargo-ships__/graphics/blank.png",
  width = 1,
  height = 1,
}
or_lamp.pciture_on = {}


data:extend({ship_pump, oil_rig, or_power, or_pole, or_lamp, deep_oil})
--[[
data:extend({
  {
  type = "autoplace-control",
  name = "deep_oil",
  localised_name = {"entity-name.deep_oil"},
  richness = true,
  order = "b-e",
  category = "resource"
    }
})
]]