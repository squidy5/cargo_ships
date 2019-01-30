local bridge=table.deepcopy(data.raw["train-stop"]["port"])
bridge.name = "bridge_base"
bridge.animations = make_4way_animation_from_spritesheet({layers = {
{
    filename = "__cargo-ships__/graphics/entity/bridge/base.png",
    line_length = 4,
    width = 275,
    height = 275,
    direction_count = 4,
    scale = 1.7,
    shift = util.by_pixel(-0.5, 0),
  }
  }
})

--bridge.collision_box = {{-6,-3},{6,3}}



----------------------------------------------------------------------------------
---------------------------------SOUTH -------------------------------------------
----------------------------------------------------------------------------------

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
          shift = {-0.2, -0.6},
          scale = 0.852,
        },
        {
          filename = "__cargo-ships__/graphics/entity/bridge/south/shadows.png",
          animation_speed = 0.3,
          line_length = 4,
          width = 512,
          height = 256,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow=true,
          shift = {-0.2, -0.6},
          scale = 0.852,
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
      shift = {-0.7, -1.1},
      scale = 0.852
    }


----------------------------------------------------------------------------------
---------------------------------NORTH -------------------------------------------
----------------------------------------------------------------------------------

local bridge_north=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_north.name = "bridge_north"
bridge_north.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/north/bridge.png",
          animation_speed = 0.3,
          line_length = 4,
          width = 512,
          height = 256,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {1.66, -0.55},
          scale = 0.852,
        },
        {
          filename = "__cargo-ships__/graphics/entity/bridge/north/shadows.png",
          animation_speed = 0.3,
          line_length = 4,
          width = 512,
          height = 256,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow=true,
          shift = {1.66, -0.55},
          scale = 0.852,
        },
    }
}
bridge_north.collision_box = {{-1, -1}, {1, 1}}
bridge_north.selection_box =  {{-1, -1}, {1, 1}}
bridge_north.collison_mask = {"train-layer"}

local bridge_north_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_closed.name = "bridge_north_closed"
bridge_north_closed.selection_box = nil
bridge_north_closed.render_layer = "floor-mechanics"
bridge_north_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/north/closed.png",
      priority = "extra-high",
      width = 512,
      height = 256,
      shift = {1.16, -1.05},
      scale = 0.852
}

----------------------------------------------------------------------------------
---------------------------------east -------------------------------------------
----------------------------------------------------------------------------------

local bridge_east=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_east.name = "bridge_east"
bridge_east.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/east/bridge.png",
          animation_speed = 0.3,
          line_length = 8,
          width = 256,
          height = 546,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {0.75, 0.7},
          scale = 0.84,
        },
        {
          filename = "__cargo-ships__/graphics/entity/bridge/east/shadows.png",
          animation_speed = 0.3,
          line_length = 8,
          width = 256,
          height = 546,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow=true,
          shift = {0.75, 0.7},
          scale = 0.84,
        },
    }
}
bridge_east.collision_box = {{-1, -1}, {1, 1}}
bridge_east.selection_box =  {{-1, -1}, {1, 1}}
bridge_east.collison_mask = {"train-layer"}

local bridge_east_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_east_closed.name = "bridge_east_closed"
bridge_east_closed.selection_box = nil
bridge_east_closed.render_layer = "floor-mechanics"
bridge_east_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/east/closed.png",
      priority = "extra-high",
      width = 256,
      height = 546,
      shift = {0.25, 0.2},
      scale = 0.84
}

----------------------------------------------------------------------------------
---------------------------------west -------------------------------------------
----------------------------------------------------------------------------------

local bridge_west=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_west.name = "bridge_west"
bridge_west.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/west/bridge.png",
          animation_speed = 0.3,
          line_length = 8,
          width = 256,
          height = 546,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          shift = {0.75, -1.65},
          scale = 0.84,
        },
        {
          filename = "__cargo-ships__/graphics/entity/bridge/west/shadows.png",
          animation_speed = 0.3,
          line_length = 8,
          width = 256,
          height = 546,
          frame_count = 23,
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow=true,
          shift = {0.75, -1.65},
          scale = 0.84,
        },
    }
}
bridge_west.collision_box = {{-1, -1}, {1, 1}}
bridge_west.selection_box =  {{-1, -1}, {1, 1}}
bridge_west.collison_mask = {"train-layer"}

local bridge_west_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_west_closed.name = "bridge_west_closed"
bridge_west_closed.selection_box = nil
bridge_west_closed.render_layer = "floor-mechanics"
bridge_west_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/west/closed.png",
      priority = "extra-high",
      width = 256,
      height = 546,
      shift = {0.25, -2.15},
      scale = 0.84
}




local invisible_chain_signal=table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"

data:extend({bridge, bridge_north, bridge_north_closed, bridge_south, bridge_south_closed, bridge_east, bridge_east_closed, bridge_west, bridge_west_closed, invisible_chain_signal})



