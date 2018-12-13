local bridge=table.deepcopy(data.raw["straight-rail"]["straight-water-way"])
bridge.name = "bridge_base"
bridge.flags={"placeable-neutral", "player-creation"}

local bridge_east=table.deepcopy(data.raw["gate"]["gate"])
bridge_east.name = "bridge_east"
bridge_east.horizontal_animation =
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }
bridge_east.vertical_animation =
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }
bridge_east.vertical_rail_animation_right = 
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }
bridge_east.vertical_rail_animation_left = 
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }

bridge_east.horizontal_rail_animation_right = 
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }
bridge_east.horizontal_rail_animation_left = 
    {
      filename = "__cargo-ships__/graphics/entity/bridge/east.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0.1, 0.1},
      scale = 0.92,
      render_layer = "resource"
    }
bridge_east.collision_box = {{-1, -1}, {1, 1}}
bridge_east.selection_box =  {{-1, -1}, {1, 1}}
bridge_east.collison_mask = {}
bridge_east.corpse = "big-remnants",

data:extend({bridge, bridge_east})






local invisible_rail=table.deepcopy(data.raw["straight-rail"]["straight-rail"])
invisible_rail.name = "invisible_rail"

local invisible_signal=table.deepcopy(data.raw["rail-signal"]["rail-signal"])
invisible_signal.name = "invisible_signal"

local invisible_chain_signal=table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"

data:extend({invisible_rail, invisible_signal, invisible_chain_signal})