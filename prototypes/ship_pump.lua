----------------------------------------------------------------
--------------------------- PUMP -------------------------------
----------------------------------------------------------------

local ship_pump = table.deepcopy(data.raw["pump"]["pump"])
ship_pump.name = "ship_pump"
ship_pump.icon = GRAPHICSPATH .. "icons/ship_pump.png"
ship_pump.icon_size = 64
ship_pump.icon_mipmaps = 0
ship_pump.minable = {mining_time = 1, result = "ship_pump"}
ship_pump.collision_mask = {"object-layer"}
ship_pump.pumping_speed = 1000
ship_pump.energy_usage = "50kW"
ship_pump.next_upgrade = nil
--ship_pump.fluid_wagon_connector_frame_count = nil
--ship_pump.fluid_wagon_connector_graphics = nil
ship_pump.water_reflection = {
  pictures = {
    filename = GRAPHICSPATH .. "entity/pump/pump-water-reflection.png",
    line_length = 1,
    width = 19,
    height = 19,
    shift = util.by_pixel(0, 10),
    variation_count = 4,
    scale = 5
  },
  rotate = false,
  orientation_to_variation = true
}

local pump_marker = table.deepcopy(data.raw["simple-entity-with-owner"]["simple-entity-with-owner"])
pump_marker.name = "pump_marker"
pump_marker.flags = {"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"}
pump_marker.selectable_in_game = false
pump_marker.allow_copy_paste = false
pump_marker.render_layer = "selection-box"
pump_marker.minable = nil
pump_marker.collision_mask = {}
pump_marker.picture = {
  filename = GRAPHICSPATH .. "green_selection_box.png",
  width = 128,
  height = 128,
  scale = 0.5,
  frame_count = 1
}

data:extend({ ship_pump, pump_marker })
