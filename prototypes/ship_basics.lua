non_standard_wheels =
{
  priority = "very-low",
  width = 2,
  height = 2,
  direction_count = 256,
  filenames =
  {
      "__cargo-ships__/graphics/blank.png",
      "__cargo-ships__/graphics/blank.png"
  },
  line_length = 8,
  lines_per_file = 16
}
function ship_light()
return
{
  {
    type = "oriented",
    minimum_darkness = 0.3,
    picture =
    {
      filename = "__cargo-ships__/graphics/light-cone.png",
      priority = "extra-high",
      flags = { "light" },
      scale = 2,
      width = 200,
      height = 200
    },
    shift = {0, -3},
    size = 2,
    intensity = 0.8,
    color = {r = 0.92, g = 0.77, b = 0.3}
  },
}
end

local wave = table.deepcopy(data.raw["trivial-smoke"]["light-smoke"])
wave.name = "wave"
wave.cyclic = false
wave.affected_by_wind = false
wave.animation =
    {
      filename = "__base__/graphics/entity/water-splash/water-splash.png",
      priority = "extra-high",
      width = 92,
      height = 66,
      frame_count = 15,
      line_length = 5,
      shift = {-0.437, -0.5},
      animation_speed = 0.15,
    }
wave.start_scale = 1.3
wave.color = { r = 0.9, g = 0.9, b = 0.9 }
wave.render_layer = "lower-object"

data:extend({wave})




