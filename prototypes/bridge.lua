local bridge=table.deepcopy(data.raw["train-stop"]["port"])
bridge.name = "bridge_base"


local bridge_east=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_east.name = "bridge_east"
bridge_east.power_on_animation =
{
  layers =
  {
    {
      filename = "__cargo-ships__/graphics/entity/bridge/south.png",
      animation_speed = 0.3,
      line_length = 4,
      width = 512,
      height = 256,
      frame_count = 24,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {-0.2, 0.1},
      scale = 0.92,
    },
  }
}

bridge_east.collision_box = {{-1, -1}, {1, 1}}
bridge_east.selection_box =  {{-1, -1}, {1, 1}}
bridge_east.collison_mask = {}
bridge_east.corpse = "big-remnants"


local bridge_south=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_south.name = "bridge_south"
bridge_south.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/south/bridge.png",
          animation_speed = 0.3,
          line_length = 4,
          width = 512,
          height = 256,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {-0.2, 0.1},
          scale = 0.909,
        },
        {
          filename = "__cargo-ships__/graphics/entity/bridge/south/shadows_r.png",
          animation_speed = 0.3,
          line_length = 4,
          width = 512,
          height = 256,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow=true,
          shift = {-0.2, 0.1},
          scale = 0.909,
        },
    }
}
bridge_south.collision_box = {{-1, -1}, {1, 1}}
bridge_south.selection_box =  {{-1, -1}, {1, 1}}
bridge_south.collison_mask = {"train-layer"}

local bridge_south_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_south_closed.name = "bridge_south_closed"
bridge_south_closed.selection_box = nil
bridge_south_closed.render_layer = "floor-mechanics"
bridge_south_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/south/closed.png",
      priority = "extra-high",
      width = 512,
      height = 256,
      shift = {-0.7, -0.4},
      scale = 0.909
    }


data:extend({bridge, bridge_south, bridge_south_closed, bridge_east})



local invisible_rail=table.deepcopy(data.raw["straight-rail"]["straight-rail"])
invisible_rail.name = "invisible_rail"

--[[
local invisible_signal=table.deepcopy(data.raw["rail-signal"]["rail-signal"])
invisible_signal.name = "invisible_signal"

local invisible_chain_signal=table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"
]]
data:extend({invisible_rail})


