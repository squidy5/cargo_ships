

local crane = table.deepcopy(data.raw["inserter"]["inserter"])
crane.name = "crane"
crane.extension_speed = 0.005
crane.rotation_speed = 0.002
crane.animation = 
    {
      filename = "__base__/graphics/entity/power-switch/power-switch.png",
      animation_speed = 0.2,
      line_length = 2,
      width = 117,
      height = 74,
      frame_count = 6,
      shift = {0.453125, 0.1875}
    }



 
data:extend({      
		crane,

		{type = "item-with-entity-data", 
        name = "crane", 
        icon = "__cargo-ships__/graphics/blank.png", 
        icon_size = 64,
        flags = {}, 
        order = "a[water-system]-f[boat]",
        place_result = "crane", 
        stack_size = 5, 
        },

        {
        type = "recipe", 
        name = "crane",
        enabled = true, 
        energy_required = 1,
        ingredients =
        {
            {"iron-plate", 1}
        },
        result = "crane"
    },
})
