local bridge=table.deepcopy(data.raw["train-stop"]["port"])
bridge.name = "bridge_base"
bridge.animations = make_4way_animation_from_spritesheet({layers = {
{
    filename = "__cargo-ships__/graphics/entity/bridge/base.png",
    --line_length = 4,
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
---------------------------------NORTH -------------------------------------------
----------------------------------------------------------------------------------

local bridge_north=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_north.name = "bridge_north"
bridge_north.led_on={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_north.led_off={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_north.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/north/bridge.png",
          animation_speed = 0.4,
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
          animation_speed = 0.4,
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
bridge_north.minable = nil
bridge_north.collision_box = {{-1, -1}, {1, 1}}
bridge_north.selection_box = nil
bridge_north.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north.selectable_in_game = false
bridge_north.allow_copy_paste = false
bridge_north.collision_mask = nil

local bridge_north_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_closed.name = "bridge_north_closed"
bridge_north_closed.created_smoke = nil
bridge_north_closed.minable = nil
bridge_north_closed.selection_box = nil
bridge_north_closed.collision_box = {{-4,-2},{6,2}}
bridge_north_closed.collision_mask = {"layer-14"} --collision with boats
bridge_north_closed.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_closed.selectable_in_game = false
bridge_north_closed.allow_copy_paste = false
bridge_north_closed.render_layer = "floor-mechanics"
bridge_north_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/north/closed.png",
      priority = "extra-high",
      width = 512,
      height = 256,
      shift = {1.66, -0.55},
      --shift = {1.16, -1.05},
      scale = 0.852
}

----------------------------------------------------------------------------------
---------------------------------east -------------------------------------------
----------------------------------------------------------------------------------

local bridge_east=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_east.name = "bridge_east"
bridge_east.led_on={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_east.led_off={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_east.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/east/bridge.png",
          animation_speed = 0.4,
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
          animation_speed = 0.4,
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
bridge_east.minable = nil
bridge_east.collision_box = {{-1, -1}, {1, 1}}
bridge_east.selection_box = nil
bridge_east.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_east.selectable_in_game = false
bridge_east.allow_copy_paste = false
bridge_east.collision_mask = nil

local bridge_east_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_east_closed.name = "bridge_east_closed"
bridge_east_closed.created_smoke = nil
bridge_east_closed.minable = nil
bridge_east_closed.selection_box = nil
bridge_east_closed.collision_box = {{-2,-4},{2,6}}
bridge_east_closed.collision_mask = {"layer-14"} --collision with boats
bridge_east_closed.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_east_closed.selectable_in_game = false
bridge_east_closed.allow_copy_paste = false
bridge_east_closed.render_layer = "floor-mechanics"
bridge_east_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/east/closed.png",
      priority = "extra-high",
      width = 256,
      height = 546,
      shift = {0.75, 0.7},
--      shift = {0.25, 0.2},
      scale = 0.84
}


----------------------------------------------------------------------------------
---------------------------------SOUTH -------------------------------------------
----------------------------------------------------------------------------------

local bridge_south=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_south.name = "bridge_south"
bridge_south.led_on={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_south.led_off={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_south.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/south/bridge.png",
          animation_speed = 0.4,
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
          animation_speed = 0.4,
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
bridge_south.minable = nil
bridge_south.collision_box = {{-1, -1}, {1, 1}}
bridge_south.selection_box = nil
bridge_south.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_south.selectable_in_game = false
bridge_south.allow_copy_paste = false
bridge_south.collision_mask = nil

local bridge_south_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_south_closed.name = "bridge_south_closed"
bridge_south_closed.created_smoke = nil
bridge_south_closed.minable = nil
bridge_south_closed.selection_box = nil
bridge_south_closed.collision_box = {{-6,-2},{4,2}}
bridge_south_closed.collision_mask = {"layer-14"} --collision with boats
bridge_south_closed.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_south_closed.selectable_in_game = false
bridge_south_closed.allow_copy_paste = false
bridge_south_closed.render_layer = "floor-mechanics"
bridge_south_closed.picture = {
      filename = "__cargo-ships__/graphics/entity/bridge/south/closed.png",
      priority = "extra-high",
      width = 512,
      height = 256,
      shift = {-0.2, -0.6},
      --shift = {-0.7, -1.1},
      scale = 0.852
    }


----------------------------------------------------------------------------------
---------------------------------west -------------------------------------------
----------------------------------------------------------------------------------

local bridge_west=table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_west.name = "bridge_west"
bridge_west.led_on={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_west.led_off={
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_west.power_on_animation =
 {
 layers =
      {
        {
          filename = "__cargo-ships__/graphics/entity/bridge/west/bridge.png",
          animation_speed = 0.4,
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
          animation_speed = 0.4,
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
bridge_west.minable = nil
bridge_west.collision_box = {{-1, -1}, {1, 1}}
bridge_west.selection_box = nil
bridge_west.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_west.selectable_in_game = false
bridge_west.allow_copy_paste = false
bridge_west.collision_mask = nil

local bridge_west_closed=table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_west_closed.name = "bridge_west_closed"
bridge_west_closed.created_smoke = nil
bridge_west_closed.minable = nil
bridge_west_closed.selection_box = nil
bridge_west_closed.collision_box = {{-2,-6},{2,4}}
bridge_west_closed.collision_mask = {"layer-14"} --collision with boats
bridge_west_closed.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_west_closed.selectable_in_game = false
bridge_west_closed.allow_copy_paste = false
bridge_west_closed.render_layer = "floor-mechanics"
bridge_west_closed.picture = {
    filename = "__cargo-ships__/graphics/entity/bridge/west/closed.png",
    priority = "extra-high",
    width = 256,
    height = 546,
    shift = {0.75, -1.65},
    --shift = {0.25, -2.15},
    scale = 0.84
}

data:extend({bridge, bridge_north, bridge_north_closed, bridge_south, bridge_south_closed, bridge_east, bridge_east_closed, bridge_west, bridge_west_closed})

local invisible_chain_signal=table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"
invisible_chain_signal.selection_box = nil
invisible_chain_signal.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
invisible_chain_signal.selectable_in_game = false
invisible_chain_signal.allow_copy_paste = false
invisible_chain_signal.minable = nil
invisible_chain_signal.animation =
{
  filename = "__cargo-ships__/graphics/blank.png",
  priority = "high",
  width = 2,
  height = 2,
  frame_count = 3,
  direction_count = 8,
}

invisible_chain_signal.rail_piece = nil
invisible_chain_signal.green_light = nil
invisible_chain_signal.orange_light = nil
invisible_chain_signal.red_light = nil
invisible_chain_signal.blue_light = nil
data:extend({invisible_chain_signal})




local bridge_north_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])

bridge_north_clickable.name = "bridge_north_clickable"
bridge_north_clickable.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_clickable.minable = {mining_time = 1, result = "bridge_base"}
bridge_north_clickable.selection_box = {{-5,-3},{7,3}}
bridge_north_clickable.collision_box = {{-5,-3},{7,3}}
bridge_north_clickable.collision_mask = {"object-layer"}
bridge_north_clickable.max_health = 500
bridge_north_clickable.picture =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}

data:extend({bridge_north_clickable})



local bridge_east_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
local bridge_south_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
local bridge_west_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])

bridge_east_clickable.name = "bridge_east_clickable"
bridge_south_clickable.name = "bridge_south_clickable"
bridge_west_clickable.name = "bridge_west_clickable"

bridge_east_clickable.collision_box = {{-3,-5},{3,7}}
bridge_south_clickable.collision_box = {{-7,-3},{5,3}}
bridge_west_clickable.collision_box = {{-3,-7},{3,5}}

bridge_east_clickable.selection_box = {{-3,-5},{3,7}}
bridge_south_clickable.selection_box = {{-7,-3},{5,3}}
bridge_west_clickable.selection_box = {{-3,-7},{3,5}}

data:extend({bridge_south_clickable, bridge_east_clickable, bridge_west_clickable})


local bridge_north_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
local bridge_east_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_east_closed"])
local bridge_south_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_south_closed"])
local bridge_west_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_west_closed"])

bridge_north_open.name = "bridge_north_open"
bridge_east_open.name = "bridge_east_open"
bridge_south_open.name = "bridge_south_open"
bridge_west_open.name = "bridge_west_open"

bridge_north_open.minable = nil
bridge_east_open.minable = nil
bridge_south_open.minable = nil
bridge_west_open.minable = nil

bridge_north_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_open.selectable_in_game = false
bridge_north_open.allow_copy_paste = false
bridge_east_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_east_open.selectable_in_game = false
bridge_east_open.allow_copy_paste = false
bridge_south_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_south_open.selectable_in_game = false
bridge_south_open.allow_copy_paste = false
bridge_west_open.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_west_open.selectable_in_game = false
bridge_west_open.allow_copy_paste = false

bridge_north_open.collision_mask = {"layer-13"} --collision with trains
bridge_east_open.collision_mask = {"layer-13"} --collision with trains
bridge_south_open.collision_mask = {"layer-13"} --collision with trains
bridge_west_open.collision_mask = {"layer-13"} --collision with trains

bridge_north_open.picture =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_east_open.picture =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_south_open.picture =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
bridge_west_open.picture =
{
  filename = "__cargo-ships__/graphics/blank.png",
  width = 2,
  height = 2,
}
data:extend({bridge_north_open,bridge_south_open, bridge_east_open, bridge_west_open})
