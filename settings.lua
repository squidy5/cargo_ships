--local choices = require("choices")


data:extend({
	{
		type = "string-setting",
		name = "oil_frequency",
		setting_type = "runtime-global",
		default_value = "normal",
		allowed_values = {
			"none",
			"minimal",
			"very-very-low",
			"very-low",
			"low",
			"normal",
			"high",
			"very-high"
		},
		order = "a-a"
	},
	{
		type = "string-setting",
		name = "oil_richness",
		setting_type = "runtime-global",
		default_value = "regular",
		allowed_values = {
		"very-poor",
		"poor",
		"regular",
		"good",
		"very-good"
		},
		order = "a-a"
	},
	{
		type = "int-setting",
		name = "waterway_reach_increase",
		setting_type = "runtime-global",
		minimum_value = 0,
		default_value = 100,
		maximum_value = 1000,
		order = "a-b"
	},
	{
        type = "double-setting",
        name = "speed_modifier",
        setting_type = "startup",
        default_value = 1,
		minimum_value = 0.5,
		maximum_value = 2
	},
	{
        type = "bool-setting",
        name = "no_catching_fish",
        setting_type = "startup",
        default_value = true,
		minimum_value = 0.5,
		order = "a-c"
	},
	{
		type = "bool-setting",
		name = "no_oil_for_oil_rig",
		setting_type = "startup",
		default_value = false,
		order = "a-c"
	},
	{
		type = "bool-setting",
		name = "use_dark_blue_waterways",
		setting_type = "startup",
		default_value = false,
		order = "a-d"
	},
	{
		type = "int-setting",
		name = "oil_rig_capacity",
		setting_type = "startup",
		minimum_value = 1,
		default_value = 100,
		maximum_value = 500,
		order = "a-b"
	},
	{
		type = "int-setting",
		name = "tanker_capacity",
		setting_type = "startup",
		minimum_value = 100,
		default_value = 250,
		maximum_value = 500,
		order = "a-b"
	},

})