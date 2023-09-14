local floating_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
floating_pole.name = "floating-electric-pole"
floating_pole.icon = GRAPHICSPATH .. "icons/floating_pole.png"
floating_pole.icon_size = 64
floating_pole.icon_mipmaps = 0
floating_pole.minable = {mining_time = 0.5, result = "floating-electric-pole"}
floating_pole.collision_mask = {'ground-tile', 'object-layer'}
floating_pole.maximum_wire_distance = 48
floating_pole.supply_area_distance = 0
floating_pole.fast_replaceable_group = nil
floating_pole.next_upgrade = nil
floating_pole.pictures = {
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole.png",
      priority = "high",
      width = 168,
      height = 165,
      scale = 1,
      direction_count = 4,
      shift = util.by_pixel(51, -58),
      hr_version = {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/hr-floating-electric-pole.png",
        priority = "high",
        width = 336,
        height = 330,
        scale = 0.5,
        direction_count = 4,
        shift = util.by_pixel(51, -58),
      }
    },
    {
      filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole-shadows.png",
      priority = "high",
      width = 168,
      height = 165,
      scale = 1,
      direction_count = 4,
      shift = util.by_pixel(51, -58),
      draw_as_shadow = true,
      hr_version = {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/hr-floating-electric-pole-shadows.png",
        priority = "high",
        width = 336,
        height = 330,
        scale = 0.5,
        direction_count = 4,
        shift = util.by_pixel(51, -58),
        draw_as_shadow = true,
      }
    },
  }
}
floating_pole.water_reflection =
  {
    pictures = {
      {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole_water_reflection.png",
        width = 34,
        height = 33,
        shift = util.by_pixel(0, 58),
        variation_count = 1,
        scale = 5
      },
      {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole_water_reflection.png",
        width = 34,
        height = 33,
        x = 34,
        shift = util.by_pixel(0, 58),
        variation_count = 1,
        scale = 5
      },
      {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole_water_reflection.png",
        width = 34,
        height = 33,
        x = 68,
        shift = util.by_pixel(0, 58),
        variation_count = 1,
        scale = 5
      },
      {
        filename = GRAPHICSPATH .. "entity/floating_electric_pole/floating-electric-pole_water_reflection.png",
        width = 34,
        height = 33,
        x = 102,
        shift = util.by_pixel(0, 58),
        variation_count = 1,
        scale = 5
      },

    },
    rotate = false,
    orientation_to_variation = true,
  }
floating_pole.connection_points = {
  { -- Vertical
    shadow = {
      copper = {2.78, -0.5},
      green = {1.875, -0.5},
      red = {3.69, -0.5}
    },
    wire = {
      copper = {0, -4.05},
      green = {-0.59375, -4.05},
      red = {0.625, -4.05}
    }
  },
  { -- Turned right
    shadow = {
      copper = {3.1, -0.648},
      green = {2.3, -1.144},
      red = {3.8, -0.136}
    },
    wire = {
      copper = {-0.0525, -3.906},
      green = {-0.48, -4.179},
      red = {0.36375, -3.601}
    }
  },
  { -- Horizontal
    shadow = {
      copper = {2.9, -0.564},
      green = {3.0, -1.316},
      red = {3.0, 0.152}
    },
    wire = {
      copper = {-0.09375, -3.901},
      green = {-0.09375, -4.331},
      red = {-0.09375, -3.420}
    }
  },
  { -- Turned left
    shadow = {
      copper = {3.3, -0.542},
      green = {3.1, -1.058},
      red = {2.35, -0.035}
    },
    wire = {
      copper = {-0.0625, -3.980},
      green = {0.375, -4.273},
      red = {-0.46875, -3.656}
    }
  }
}
for _,v in pairs(floating_pole.connection_points) do
  v.shadow.copper[1] = v.shadow.copper[1] + 0.74
  v.shadow.green[1] = v.shadow.green[1] + 0.74
  v.shadow.red[1] = v.shadow.red[1] + 0.74
  v.shadow.copper[2] = v.shadow.copper[2] + 0.5
  v.shadow.green[2] = v.shadow.green[2] + 0.5
  v.shadow.red[2] = v.shadow.red[2] + 0.5
end

---------------------------------------------------------------------------------------------------------------

local buoy = table.deepcopy(data.raw["rail-signal"]["rail-signal"])
buoy.name = "buoy"
buoy.icon = GRAPHICSPATH .. "icons/buoy.png"
buoy.icon_size = 64
buoy.icon_mipmaps = 0
buoy.collision_mask = {"object-layer", "rail-layer"}  -- waterway_layer added in data-final-fixes
buoy.selection_box = {{-1.6, -0.8}, {0.01, 0.8}}
buoy.fast_replaceable_group = "buoy"
buoy.minable = {mining_time = 0.5, result = "buoy"}
buoy.green_light = nil
buoy.orange_light = nil
buoy.red_light = nil
buoy.animation = {
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/buoy/buoy-base.png",
      width = 115,
      height = 115,
      frame_count = 1,
      repeat_count = 3,
      direction_count = 8,
      hr_version = {
        filename = GRAPHICSPATH .. "entity/buoy/hr-buoy-base.png",
        width = 230,
        height = 230,
        frame_count = 1,
        repeat_count = 3,
        direction_count = 8,
        scale = 0.5
      }
    },
    {
      filename = GRAPHICSPATH .. "entity/buoy/buoy-shadow.png",
      draw_as_shadow = true,
      width = 115,
      height = 115,
      frame_count = 1,
      repeat_count = 3,
      direction_count = 8,
      hr_version =
      {
        filename = GRAPHICSPATH .. "entity/buoy/hr-buoy-shadow.png",
        draw_as_shadow = true,
        width = 230,
        height = 230,
        frame_count = 1,
        repeat_count = 3,
        direction_count = 8,
        scale = 0.5
      }
    },
    {
      filename = GRAPHICSPATH .. "entity/buoy/buoy-lights.png",
      blend_mode = "additive",
      draw_as_glow = true,
      width = 115,
      height = 115,
      frame_count = 3,
      direction_count = 8,
      hr_version =
      {
        filename = GRAPHICSPATH .. "entity/buoy/hr-buoy-lights.png",
        blend_mode = "additive",
        draw_as_glow = true,
        width = 230,
        height = 230,
        frame_count = 3,
        direction_count = 8,
        scale = 0.5
      }
    },
  }
}
buoy.water_reflection = {
  pictures =
  {
    filename = GRAPHICSPATH .. "entity/buoy/buoy_water_reflection.png",
    width = 23,
    height = 23,
    --shift = util.by_pixel(0, -25),
    variation_count = 8,
    line_length = 1,
    scale = 5
  },
  rotate = false,
  orientation_to_variation = true
}
buoy.rail_piece = nil

---------------------------------------------------------------------------------------------------------------

local chain_buoy = table.deepcopy(data.raw["rail-chain-signal"]["rail-chain-signal"])
chain_buoy.name = "chain_buoy"
chain_buoy.icon = GRAPHICSPATH .. "icons/chain_buoy.png"
chain_buoy.icon_size = 64
chain_buoy.icon_mipmaps = 0
chain_buoy.collision_mask = {"object-layer", "rail-layer"}  -- waterway_layer added in data-final-fixes
chain_buoy.selection_box = {{-1.6, -0.8}, {0.01, 0.8}}
chain_buoy.fast_replaceable_group = "buoy"
chain_buoy.minable = {mining_time = 0.5, result = "chain_buoy"}
chain_buoy.animation = {
  layers = {
    {
      filename = GRAPHICSPATH .. "entity/chain_buoy/chain-buoys-base.png",
      width = 261,
      height = 205,
      frame_count = 1,
      repeat_count = 5,
      axially_symmetrical = false,
      direction_count = 8,
      hr_version =
      {
        filename = GRAPHICSPATH .. "entity/chain_buoy/hr-chain-buoys-base.png",
        width = 522,
        height = 410,
        frame_count = 1,
        repeat_count = 5,
        axially_symmetrical = false,
        direction_count = 8,
        scale = 0.5
      }
    },
    {
      filename = GRAPHICSPATH .. "entity/chain_buoy/chain-buoys-lights.png",
      draw_as_glow = true,
      line_length = 5,
      width = 261,
      height = 205,
      frame_count = 5,
      direction_count = 8,
      hr_version =
      {
        filename = GRAPHICSPATH .. "entity/chain_buoy/hr-chain-buoys-lights.png",
        draw_as_glow = true,
        line_length = 5,
        width = 522,
        height = 410,
        frame_count = 5,
        direction_count = 8,
        scale = 0.5
      }
    }
  }
}
chain_buoy.selection_box_offsets = {
  {-0.15, 0},
  {-0.25, -1},
  {0.8, -1.1},
  {1.7, -1.0},
  {1.8, -0.1},
  {1.9, 0.6},
  {0.9, 0.65},
  {-0.1, 0.6}
}
chain_buoy.rail_piece = nil
chain_buoy.green_light = nil
chain_buoy.orange_light = nil
chain_buoy.red_light = nil
chain_buoy.blue_light = nil

---------------------------------------------------------------------------------------------------------------

local port = table.deepcopy(data.raw["train-stop"]["train-stop"])
port.name = "port"
port.icon = GRAPHICSPATH .. "icons/port.png"
port.icon_size = 64
port.icon_mipmaps = 0
port.minable = {mining_time = 1, result = "port"}
port.rail_overlay_animations = nil
port.collision_mask = {"object-layer"}
port.collision_box = {{-0.01, -0.9}, {1.9, 0.9}}
port.selection_box = {{-0.01, -0.9}, {1.9, 0.9}}

local function maker_layer_port(xshift, yshift)
  return {
    layers = {
      {
        filename = GRAPHICSPATH .. "entity/port/port.png",
        width = 40,
        height = 150,
        shift = util.by_pixel(xshift, yshift),
        scale = 1,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/port/hr-port.png",
          width = 80,
          height = 300,
          shift = util.by_pixel(xshift, yshift),
          scale = 0.5,
        }
      },
      {
        filename = GRAPHICSPATH .. "entity/port/port-shadow.png",
        width = 150,
        height = 40,
        shift = util.by_pixel(xshift, yshift),
        scale = 1,
        draw_as_shadow = true,
        hr_version = {
          filename = GRAPHICSPATH .. "entity/port/hr-port-shadow.png",
          width = 300,
          height = 80,
          shift = util.by_pixel(xshift, yshift),
          scale = 0.5,
          draw_as_shadow = true,
        }
      },
    }
  }
end
port.animations = {
  north = maker_layer_port(30,0),
  east = maker_layer_port(0,30),
  south = maker_layer_port(-30,0),
  west = maker_layer_port(0,-30),
}

local function portwaterref(xshift, yshift)
  return {
    filename = GRAPHICSPATH .. "entity/port/port_water_reflection.png",
    width = 30,
    height = 30,
    shift = util.by_pixel(xshift, yshift),
    scale = 5
  }
end
port.water_reflection = {
  pictures = {
    portwaterref(30, 0),
    portwaterref(0, 30),
    portwaterref(-30, 0),
    portwaterref(0, -30),
  },
  rotate = false,
  orientation_to_variation = true
}
port.top_animations = nil
port.light1 =
{
  light = {intensity = 0.4, size = 4, color = {r = 1.0, g = 1.0, b = 1.0}},
  picture = {
    north = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.95, 0},
      shift = util.by_pixel(30, -69),
    },
    east = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.95, 0},
      shift = util.by_pixel(0, -39),
    },
    south = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.95, 0},
      shift = util.by_pixel(-30, -69),
    },
    west = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.95, 0},
      shift = util.by_pixel(0, -99),
    },
  },
  red_picture = {
    north = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.2, 0.2},
      shift = util.by_pixel(30, -69),
    },
    east = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.2, 0.2},
      shift = util.by_pixel(0, -39),
    },
    south = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.2, 0.2},
      shift = util.by_pixel(-30, -69),
    },
    west = {
      filename = GRAPHICSPATH .. "entity/port/hr-port-light.png",
      width = 44,
      height = 24,
      scale = 0.5,
      tint = {1, 0.2, 0.2},
      shift = util.by_pixel(0, -99),
    },
  }
}
port.light2 = nil
port.working_sound = nil

-- build a new 4 way definition for port
-- show_shadow=false prevents floating circuit box shadows, but wire shadows end nowhere
-- once port shadows are done set show_shadow=true and tweak shadow_offset, should be around (-30, 10) from  main_offset
circuit_connector_definitions["cargo-ships-port"] = circuit_connector_definitions.create(
  universal_connector_template,
  {
    { variation = 18, main_offset = util.by_pixel(37, -61), shadow_offset = util.by_pixel(37, -61), show_shadow = false },
    { variation = 18, main_offset = util.by_pixel(-1.5, -20), shadow_offset = util.by_pixel(-1.5, -20), show_shadow = false },
    { variation = 18, main_offset = util.by_pixel(-39, -59), shadow_offset = util.by_pixel(-39, -59), show_shadow = false },
    { variation = 18, main_offset = util.by_pixel(-1.5, -98), shadow_offset = util.by_pixel(-1.5, -98), show_shadow = false }
  }
)
-- let factorio generate sprite connector offset per wire from definition
port.circuit_wire_connection_points = circuit_connector_definitions["cargo-ships-port"].points
port.circuit_connector_sprites = circuit_connector_definitions["cargo-ships-port"].sprites

data:extend({floating_pole, buoy, chain_buoy, port})
