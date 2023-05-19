----------------------------------------------------------------
--------------------------- PUMP -------------------------------
----------------------------------------------------------------

local collision_mask_util = require("collision-mask-util")

local pump = data.raw["pump"]["pump"]
pump.collision_mask = {"object-layer"}
pump.water_reflection = {
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

-- Ensure player collides with pump
local pump_collision_layer = collision_mask_util.get_first_unused_layer()
collision_mask_util.add_layer(pump.collision_mask, pump_collision_layer)
for _, character in pairs(data.raw.character) do
  local collision_mask = collision_mask_util.get_mask(character)
  if collision_mask_util.mask_contains_layer(collision_mask, "player-layer") then
    collision_mask_util.add_layer(collision_mask, pump_collision_layer)
    character.collision_mask = collision_mask
  end
end

-- In vanilla: shallow waters have object-layer, regular/deep waters have player-layer
-- Many mods that use shallow water remove object-layer from it anyway (e.g. Alien Biomes, Freight Forwarding)
collision_mask_util.remove_layer(data.raw.tile["water-shallow"].collision_mask, "object-layer")
collision_mask_util.remove_layer(data.raw.tile["water-mud"].collision_mask, "object-layer")

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

data:extend({ pump_marker })
