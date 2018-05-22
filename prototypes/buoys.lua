


local buoy=table.deepcopy(data.raw["rail-signal"]["rail-signal"])
buoy.name = "buoy"
buoy.collision_mask = {'ground-tile', 'object-layer'}
buoy.fast_replaceable_group = "buoy"
buoy.minable = {mining_time = 0.5, result = "buoy"}
buoy.animation =
{
  filename = "__cargo-ships__/graphics/entity/buoy/buoys.png",
  priority = "high",
  width = 144,
  height = 144,
  frame_count = 3,
  direction_count = 8,
  scale = 0.8
}
buoy.rail_piece = nil


local chain_buoy=table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
chain_buoy.name = "chain_buoy"
chain_buoy.collision_mask = {'ground-tile', 'object-layer'}
chain_buoy.fast_replaceable_group = "buoy"
chain_buoy.minable = {mining_time = 0.5, result = "chain_buoy"}
chain_buoy.animation =
{
  filename = "__cargo-ships__/graphics/entity/chain_buoy/chain_buoys.png",
  priority = "high",
  width = 256,
  height = 256,
  frame_count = 5,
  direction_count = 8,
  scale = 0.8,
  shift = {0.5,0.3}

}
chain_buoy.rail_piece = nil





----------------------------------------------------------------
--------------------------- PORT -------------------------------
----------------------------------------------------------------

local port=table.deepcopy(data.raw["train-stop"]["train-stop"])
port.name = "port"
port.icon = "__cargo-ships__/graphics/blank.png"
port.minable = {mining_time = 1, result = "port"}
port.rail_overlay_animations = nil
port.collision_mask = {'ground-tile', 'object-layer'}
port.animations = make_4way_animation_from_spritesheet({ layers =
  {
    {
      filename = "__cargo-ships__/graphics/entity/port/port.png",
      line_length = 4,
      width = 140,
      height = 291,
      direction_count = 4,
      shift = util.by_pixel(-0.5, -26.75),
      scale = 0.8
    }
  }
})
port.top_animations = nil
port.light1 =
{
  light = {intensity = 0.5, size = 5, color = {r = 1.0, g = 1.0, b = 1.0}},
  picture =
  {
    north =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(19, -67.5),
    },
    west =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-2, -88.3),
    },
    south =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-22.5, -66),
    },
    east =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-2.7, -43.3),
    },
  },
  red_picture =
   {
    north =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(21, -69),
    },
    west =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-1, -91),
    },
    south =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-21, -68),
    },
    east =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-1, -47),
    },
  }
}
port.light2 = nil
port.working_sound = nil

local port_lb=table.deepcopy(data.raw["train-stop"]["train-stop"])
port_lb.name = "port_lb"
port_lb.icon = "__cargo-ships__/graphics/blank.png"
port_lb.minable = {mining_time = 1, result = "port_lb"}
port_lb.rail_overlay_animations = nil
port_lb.animations = make_4way_animation_from_spritesheet({ layers =
  {
    {
      filename = "__cargo-ships__/graphics/entity/port/port_lb.png",
      line_length = 4,
      width = 140,
      height = 291,
      direction_count = 4,
      shift = util.by_pixel(-0.5, -26.75),
      scale = 0.8
    }
  }
})
port_lb.top_animations = nil
port_lb.light1 =
{
  light = {intensity = 0.5, size = 5, color = {r = 1.0, g = 1.0, b = 1.0}},
  picture =
  {
    north =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(19, -67.5),
    },
    west =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-2, -88.3),
    },
    south =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-22.5, -66),
    },
    east =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-light-1.png",
      width =14,
      height = 7,
      scale = 0.7,
      shift = util.by_pixel(-2.7, -43.3),
    },
  },
  red_picture =
   {
    north =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(21, -69),
    },
    west =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-1, -91),
    },
    south =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-21, -68),
    },
    east =
    {
      filename = "__cargo-ships__/graphics/entity/port/port-red-light-1.png",
      width = 17,
      height = 10,
      frame_count = 1,
      shift = util.by_pixel(-1, -47),
    },
  }
}
port_lb.light2 = nil
port_lb.working_sound = nil


data:extend({buoy, chain_buoy, port,port_lb})

