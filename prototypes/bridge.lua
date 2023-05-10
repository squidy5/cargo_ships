--bridge.collision_box = {{-6,-3},{6,3}}

local invincible =
   {
     {
       type = "physical",
       percent = 100
     },
     {
       type = "explosion",
       percent = 100
     },
     {
       type = "acid",
       percent = 100
     },
     {
       type = "fire",
       percent = 100
     }
   }


local function build_bridge_anim(ori, shiftx, shifty, picture)
  local width = 436
  local height = 930
  local line_length = 7
  if ori == "n" or ori == "s" then
    width = 872
    height = 436
    line_length = 3
  end

  if not picture then
    local anim_speed = 0.38
    return {
      layers = {
        {
          filename = GRAPHICSPATH .. "entity/bridge/bridge-" .. ori .. "-shadow.png",
          line_length = line_length,
          animation_speed = anim_speed,
          width = width/2,
          height = height/2,
          frame_count = 21,
          frame_sequence = {1, 1, 1, 4, 5, 6, 7, 8,9,10,11,12,13,14,15,16,17,18,19,20,21},
          axially_symmetrical = false,
          direction_count = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(shiftx, shifty),
          scale = 1,
          hr_version = {
            filename = GRAPHICSPATH .. "entity/bridge/hr-bridge-" .. ori .. "-shadow.png",
            line_length = line_length,
            animation_speed = anim_speed,
            width = width,
            height = height,
            frame_count = 21,
            frame_sequence = {1, 1, 1, 4, 5, 6, 7, 8,9,10,11,12,13,14,15,16,17,18,19,20,21},
            axially_symmetrical = false,
            direction_count = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(shiftx, shifty),
            scale = 0.5,
          }
        },
        {
          filename = GRAPHICSPATH .. "entity/bridge/bridge-" .. ori .. ".png",
          line_length = line_length,
          animation_speed = anim_speed,
          width = width/2,
          height = height/2,
          frame_count = 21,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(shiftx, shifty),
          scale = 1,
          hr_version = {
            filename = GRAPHICSPATH .. "entity/bridge/hr-bridge-" .. ori .. ".png",
            line_length = line_length,
            animation_speed = anim_speed,
            width = width,
            height = height,
            frame_count = 21,
            axially_symmetrical = false,
            direction_count = 1,
            shift = util.by_pixel(shiftx, shifty),
            scale = 0.5,
          }
        },

      }
    }
  elseif picture then
    return {
      layers = {
        {
          filename = GRAPHICSPATH .. "entity/bridge/bridge-" .. ori .. "-shadow.png",
          width = width/2,
          height = height/2,
          x = width/2,
          shift = util.by_pixel(shiftx, shifty),
          scale = 1,
          --draw_as_shadow = true,
          tint = {0,0,0,0.5}, --because else shadow gets over entity with render layer lower than "object"
          hr_version = {
            filename = GRAPHICSPATH .. "entity/bridge/hr-bridge-" .. ori .. "-shadow.png",
            width = width,
            height = height,
            x = width,
            shift = util.by_pixel(shiftx, shifty),
            scale = 0.5,
            --draw_as_shadow = true,
            tint = {0,0,0,0.5},
          }
        },
        {
          filename = GRAPHICSPATH .. "entity/bridge/bridge-" .. ori .. ".png",
          width = width/2,
          height = height/2,
          x = width/2,
          shift = util.by_pixel(shiftx, shifty),
          scale = 1,
          hr_version = {
            filename = GRAPHICSPATH .. "entity/bridge/hr-bridge-" .. ori .. ".png",
            width = width,
            height = height,
            x = width,
            shift = util.by_pixel(shiftx, shifty),
            scale = 0.5,
          }
        },
      }
    }
  end
end

local function water_reflection(dir, num, x, y, shiftx, shifty)
  return {
    pictures = {
      filename = GRAPHICSPATH .. "entity/bridge/bridge-" .. dir .. "-" .. num .."-water-reflection.png",
      width = x,
      height = y,
      shift = util.by_pixel(shiftx, shifty),
      variation_count = 1,
      scale = 5
    },
    rotate = false,
    orientation_to_variation = false
  }
end

data:extend({
  {
    type = "sound",
    name = "cs_bridge",
    filename = "__cargo-ships__/sound/bridge.ogg",
    audible_distance_modifier = 5,
    volume = 0.2,
  },
})


-----------------------------------------------------------------------------------------

local bridge = table.deepcopy(data.raw["train-stop"]["port"])
bridge.name = "bridge_base"
bridge.icon = GRAPHICSPATH .. "icons/bridge.png"
bridge.icon_size = 64
bridge.localised_description = {"description-template.bridge_base", {"entity-description.bridge_north_clickable"}}
bridge.fast_replaceable_group  = nil
bridge.next_upgrade = nil
bridge.animations = make_4way_animation_from_spritesheet({
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/bridge/bridge-base.png",
      --line_length = 4,
      width = 275,
      height = 275,
      direction_count = 4,
      scale = 1.7,
      shift = util.by_pixel(-0.5, 0),
    }
  }
})
data:extend{bridge}

----------------------------------------------------------------------------------
--------------------------------- NORTH ------------------------------------------
----------------------------------------------------------------------------------

local shiftX = 53
local shiftY = -17.5

local bridge_north = table.deepcopy(data.raw["power-switch"]["power-switch"])
bridge_north.name = "bridge_north"
bridge_north.icon = GRAPHICSPATH .. "icons/bridge.png"
bridge_north.icon_size = 64
bridge_north.led_on = emptypic
bridge_north.led_off = emptypic
bridge_north.power_on_animation = build_bridge_anim("n", shiftX, shiftY)
bridge_north.minable = nil
bridge_north.resistances = invincible
bridge_north.selection_box = nil
bridge_north.fast_replaceable_group  = nil
bridge_north.collision_box = {{-1,-1},{1,1}}
bridge_north.collision_mask = {}
bridge_north.next_upgrade = nil
bridge_north.flags = {"not-blueprintable", "not-deconstructable", "placeable-neutral", "player-creation"}
bridge_north.selectable_in_game = false
bridge_north.allow_copy_paste = false
bridge_north.created_smoke = nil
bridge_north.water_reflection = water_reflection("n", 20, 87, 44, shiftX, shiftY)

local bridge_north_closed = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_closed.name = "bridge_north_closed"
bridge_north_closed.icon = GRAPHICSPATH .. "icons/bridge.png"
bridge_north_closed.icon_size = 64
bridge_north_closed.minable = nil
bridge_north_closed.resistances = invincible
bridge_north_closed.fast_replaceable_group  = nil
bridge_north_closed.next_upgrade = nil
bridge_north_closed.selection_box = nil
bridge_north_closed.collision_box = {{-4,-2}, {6,2}}
bridge_north_closed.collision_mask = {} --collision with boats
bridge_north_closed.flags = {"not-blueprintable", "not-deconstructable", "placeable-neutral", "player-creation"}
bridge_north_closed.selectable_in_game = false
bridge_north_closed.allow_copy_paste = false
bridge_north_closed.render_layer = "floor-mechanics-under-corpse"
bridge_north_closed.created_smoke = nil
bridge_north_closed.picture = build_bridge_anim("n", shiftX, shiftY, true)
bridge_north_closed.water_reflection = water_reflection("n", 1, 87, 44, shiftX, shiftY)

data:extend{bridge_north, bridge_north_closed}

----------------------------------------------------------------------------------
--------------------------------- SOUTH ------------------------------------------
----------------------------------------------------------------------------------

shiftX = -6.5
shiftY = -19

local bridge_south = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_south.name = "bridge_south"
bridge_south.power_on_animation = build_bridge_anim("s", shiftX, shiftY)
bridge_south.water_reflection = water_reflection("s", 20, 87, 44, shiftX, shiftY)

local bridge_south_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_south_closed.name = "bridge_south_closed"
bridge_south_closed.collision_box = {{-6,-2}, {4,2}}
bridge_south_closed.picture = build_bridge_anim("s", shiftX, shiftY, true)
bridge_south_closed.water_reflection = water_reflection("s", 1, 87, 44, shiftX, shiftY)

----------------------------------------------------------------------------------
--------------------------------- east -------------------------------------------
----------------------------------------------------------------------------------

shiftX = 24
shiftY = 22.5

local bridge_east = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_east.name = "bridge_east"
bridge_east.power_on_animation = build_bridge_anim("e", shiftX, shiftY)
bridge_east.water_reflection = water_reflection("e", 20, 44, 94, shiftX, shiftY+32)

local bridge_east_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_east_closed.name = "bridge_east_closed"
bridge_east_closed.collision_box = {{-2,-4}, {2,6}}
bridge_east_closed.picture = build_bridge_anim("e", shiftX, shiftY, true)
bridge_east_closed.water_reflection = water_reflection("e", 1, 44, 94, shiftX, shiftY+32)

----------------------------------------------------------------------------------
--------------------------------- west -------------------------------------------
----------------------------------------------------------------------------------

shiftX = 24
shiftY = -53

local bridge_west = table.deepcopy(data.raw["power-switch"]["bridge_north"])
bridge_west.name = "bridge_west"
bridge_west.power_on_animation = build_bridge_anim("w", shiftX, shiftY)
bridge_west.water_reflection = water_reflection("w", 20, 44, 94, shiftX, shiftY)

local bridge_west_closed = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_west_closed.name = "bridge_west_closed"
bridge_west_closed.collision_box = {{-2,-6}, {2,4}}
bridge_west_closed.picture = build_bridge_anim("w", shiftX, shiftY, true)
bridge_west_closed.water_reflection = water_reflection("w", 1, 44, 94, shiftX, shiftY+32)

data:extend{bridge_south, bridge_south_closed, bridge_east,
            bridge_east_closed, bridge_west, bridge_west_closed}

----------------------------------------------------------------------------------------------------------------------------------

local invisible_chain_signal = table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
invisible_chain_signal.name = "invisible_chain_signal"
invisible_chain_signal.icon = GRAPHICSPATH .. "icons/chain_buoy.png"
invisible_chain_signal.icon_size = 64
invisible_chain_signal.selection_box = nil
invisible_chain_signal.resistances = invincible
invisible_chain_signal.flags = {"not-blueprintable", "not-deconstructable", "placeable-neutral", "player-creation", "hidden"}
invisible_chain_signal.selectable_in_game = false
invisible_chain_signal.collision_mask = {"object-layer", "rail-layer"}  -- waterway_layer added in data-final-fixes
invisible_chain_signal.allow_copy_paste = false
invisible_chain_signal.minable = nil
invisible_chain_signal.animation = {
  filename = GRAPHICSPATH .. "blank.png",
  size = 1,
  frame_count = 3,
  direction_count = 8,
}
invisible_chain_signal.rail_piece = nil
invisible_chain_signal.green_light = nil
invisible_chain_signal.orange_light = nil
invisible_chain_signal.red_light = nil
invisible_chain_signal.blue_light = nil
invisible_chain_signal.fast_replaceable_group = nil
invisible_chain_signal.created_smoke = nil

data:extend{invisible_chain_signal}

-------------------------------------------------------------------------------------------------------------------

local WID = 1.7 --selection box short side/2

local bridge_north_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
bridge_north_clickable.name = "bridge_north_clickable"
bridge_north_clickable.icon = GRAPHICSPATH .. "icons/bridge.png"
bridge_north_clickable.icon_size = 64
bridge_north_clickable.localised_description = {"entity-description.bridge_north_clickable"}
bridge_north_clickable.flags = {"not-blueprintable", "placeable-neutral", "player-creation"}
bridge_north_clickable.minable = {mining_time = 1, result = "bridge_base"}
bridge_north_clickable.placeable_by = {item = "bridge_base", count = 1}  -- For pipette (Q)
bridge_north_clickable.selection_box = {{-5,-WID}, {7,WID}}
bridge_north_clickable.collision_box = {{-5,-WID}, {7,WID}}
bridge_north_clickable.collision_mask = {"object-layer", "layer-14"}
bridge_north_clickable.max_health = 1000
bridge_north_clickable.picture = emptypic
--bridge_north_clickable.created_smoke = nil
bridge_north_clickable.selection_priority = 49
bridge_north_clickable.create_ghost_on_death = false

data:extend{bridge_north_clickable}

local bridge_south_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
bridge_south_clickable.name = "bridge_south_clickable"
bridge_south_clickable.collision_box = {{-7,-WID}, {5,WID}}
bridge_south_clickable.selection_box = {{-7,-WID}, {5,WID}}

local bridge_east_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
bridge_east_clickable.name = "bridge_east_clickable"
bridge_east_clickable.collision_box = {{-WID,-5}, {WID,7}}
bridge_east_clickable.selection_box = {{-WID,-5}, {WID,7}}

local bridge_west_clickable = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_clickable"])
bridge_west_clickable.name = "bridge_west_clickable"
bridge_west_clickable.collision_box = {{-WID,-7}, {WID,5}}
bridge_west_clickable.selection_box = {{-WID,-7}, {WID,5}}

data:extend{bridge_south_clickable, bridge_east_clickable, bridge_west_clickable}

-------------------------------------------------------------------------------------------------------------------

local bridge_north_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_north_closed"])
bridge_north_open.name = "bridge_north_open"
bridge_north_open.picture = emptypic
bridge_north_open.water_reflection = nil

local bridge_south_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_south_closed"])
bridge_south_open.name = "bridge_south_open"
bridge_south_open.picture = emptypic
bridge_south_open.water_reflection = nil

local bridge_east_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_east_closed"])
bridge_east_open.name = "bridge_east_open"
bridge_east_open.picture = emptypic
bridge_east_open.water_reflection = nil

local bridge_west_open = table.deepcopy(data.raw["simple-entity-with-force"]["bridge_west_closed"])
bridge_west_open.name = "bridge_west_open"
bridge_west_open.picture = emptypic
bridge_west_open.water_reflection = nil

data:extend{bridge_north_open, bridge_south_open, bridge_east_open, bridge_west_open}
