local choices = require("choices")


data:extend({
	{
		type = "string-setting",
		name = "oil_frequency",
		setting_type = "runtime-global",
		default_value = choices.oil_freq.normal,
		allowed_values = choices.oil_freq,
		order = "a-a"
	},
	{
		type = "string-setting",
		name = "oil_richness",
		setting_type = "runtime-global",
		default_value = choices.oil_rich.regular,
		allowed_values = choices.oil_rich,
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
		type = "bool-setting",
		name = "no_oil_for_oil_rig",
		setting_type = "startup",
		default_value = false,
		order = "a-c"
	},

})