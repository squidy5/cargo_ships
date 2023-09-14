data:extend({
  {
    type = "bool-setting",
    name = "deep_oil",
    setting_type = "startup",
    default_value = true,
    order = "a-a"
  },
  {
    type = "string-setting",
    name = "oil_richness",
    setting_type = "startup",
    default_value = "regular",
    allowed_values = {
      "very-poor",
      "poor",
      "regular",
      "good",
      "very-good"
    },
    order = "a-b"
  },
  {
    type = "int-setting",
    name = "oil_rig_capacity",
    setting_type = "startup",
    minimum_value = 1,
    default_value = 100,
    maximum_value = 500,
    order = "a-c"
  },
  {
    type = "string-setting",
    name = "oil_rigs_require_external_power",
    setting_type = "startup",
    default_value = "only-when-moduled",
    allowed_values = {
      "enabled",
      "only-when-moduled",
      "disabled",
    },
    order = "a-d"
  },
  {
    type = "bool-setting",
    name = "no_oil_for_oil_rig",
    setting_type = "startup",
    default_value = false,
    order = "a-e"
  },
  {
    type = "bool-setting",
    name = "no_oil_on_land",
    setting_type = "startup",
    default_value = false,
    order = "a-f"
  },
  {
    type = "bool-setting",
    name = "no_shallow_oil",
    setting_type = "startup",
    default_value = true,
    order = "a-g"
  },
  {
    type = "double-setting",
    name = "speed_modifier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.25,
    maximum_value = 4,
    order = "b-a"
  },
  {
    type = "double-setting",
    name = "fuel_modifier",
    setting_type = "startup",
    default_value = 2,
    minimum_value = 0.5,
    maximum_value = 10,
    order = "b-b"
  },
  {
    type = "int-setting",
    name = "tanker_capacity",
    setting_type = "startup",
    minimum_value = 100,
    default_value = 250,
    maximum_value = 500,
    order = "b-c"
  },
  {
    type = "bool-setting",
    name = "no_catching_fish",
    setting_type = "startup",
    default_value = true,
    order = "c-a"
  },
  {
    type = "bool-setting",
    name = "use_dark_blue_waterways",
    setting_type = "startup",
    default_value = false,
    order = "c-b"
  },
  {
    type = "int-setting",
    name = "waterway_reach_increase",
    setting_type = "runtime-global",
    minimum_value = 0,
    default_value = 100,
    maximum_value = 1000,
    order = "a-a"
  },
  {
    type = "bool-setting",
    name = "prevent_waterway_rail_connections",
    setting_type = "runtime-global",
    default_value = true,
    order = "a-c"
  }
})
