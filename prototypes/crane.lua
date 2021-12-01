---------------------file unreferenced (disabled in entity.lua)


local crane = table.deepcopy(data.raw["inserter"]["long-handed-inserter"])
crane.name = "crane"
crane.extension_speed = 0.5
crane.rotation_speed = 0.02
crane.drawing_box = {{-100, -100}, {-99, 99}}
crane.hand_base_picture.scale = 2
crane.hand_base_picture.hr_version.scale = 0.5
crane.hand_closed_picture.scale = 2
crane.hand_closed_picture.hr_version.scale = 0.5
crane.hand_open_picture.scale = 2
crane.hand_open_picture.hr_version.scale = 0.5
crane.platform_picture.sheet.scale = 4
crane.platform_picture.sheet.hr_version.scale = 1
crane.pickup_position = {0, -4}
crane.insert_position = {0,4}

local visual_hor = table.deepcopy(data.raw["power-switch"]["power-switch"])
visual_hor.name = "crane_hor"
visual_hor.drawing_box = {{-100, -100}, {-99, 99}}
visual_hor.power_on_animation = {
  filename = GRAPHICSPATH .. "entity/crane/crane_hor.png",
  animation_speed = 0.4,
  line_length = 6,
  width = 300,
  height = 225,
  frame_count = 40,
  --axially_symmetrical = false,
  --direction_count = 1,
  --shift = {1.66, -0.55},
  scale = 0.852,
}
visual_hor.collision_mask = {}

data:extend({
  crane,
  visual_hor,
  {
    type = "item-with-entity-data",
    name = "crane",
    icon = GRAPHICSPATH .. "blank.png",
    icon_size = 64,
    flags = {},
    order = "a[water-system]-f[boat]",
    place_result = "crane",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "crane_hor",
    icon = GRAPHICSPATH .. "blank.png",
    icon_size = 64,
    flags = {},
    order = "a[water-system]-f[boat]",
    place_result = "crane_hor",
    stack_size = 5,
  },
  {
    type = "recipe",
    name = "crane",
    enabled = true,
    energy_required = 1,
    ingredients = {
      {"iron-plate", 1}
    },
    result = "crane"
  },
})






data:extend({

  {
      type = "animation",
      name = "crane_animation_west",
      frame_count = 40,
      filename = GRAPHICSPATH .. "entity/crane/crane_hor.png",
      size = {300,225},
      line_length = 6,
      animation_speed = 0.2,
      render_layer="higher-object-above",
  },
  {
      type = "animation",
      name = "crane_animation_east",
      frame_count = 40,
      filename = GRAPHICSPATH .. "entity/crane/crane_hor.png",
      size = {300,225},
      line_length = 6,
      run_mode="backward",
      animation_speed = 0.2,
      render_layer="higher-object-above",

  },
  {
      type = "sprite",
      name = "crane_west",
      filename = GRAPHICSPATH .. "entity/crane/west.png",
      size = {300,225},
      render_layer="higher-object-above",
  },
  {
      type = "sprite",
      name = "crane_east",
      filename = GRAPHICSPATH .. "entity/crane/east.png",
      size = {300,225},
      render_layer="higher-object-above",
  },
})