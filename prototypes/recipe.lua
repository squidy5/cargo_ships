data:extend({
  {
    type = "recipe",
    name = "boat",
    enabled = false,
    energy_required = 3,
    ingredients = {
      {"steel-plate", 40},
      {"engine-unit", 15},
      {"iron-gear-wheel", 15},
      {"electronic-circuit", 6}
    },
    result = "boat"
  },
  {
    type = "recipe",
    name = "cargo_ship",
    enabled = false,
    energy_required = 15,
    ingredients = {
      {"steel-plate", 220},
      {"engine-unit", 50},
      {"iron-gear-wheel", 60},
      {"electronic-circuit", 20}
    },
    result = "cargo_ship"
  },
  {
    type = "recipe",
    name = "oil_tanker",
    enabled = false,
    energy_required = 15,
    ingredients = {
      {"steel-plate", 180},
      {"engine-unit", 50},
      {"iron-gear-wheel", 60},
      {"electronic-circuit", 20},
      {"storage-tank", 6}
    },
    result = "oil_tanker"
  },
  {
    type = "recipe",
    name = "port",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {"electronic-circuit", 5},
      {"iron-plate", 10},
      {"steel-plate", 5}
    },
    result = "port",
    result_count = 1
  },
  {
    type = "recipe",
    name = "floating-electric-pole",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {"empty-barrel", 4},
      {"big-electric-pole", 1},
      {"iron-plate", 5}
    },
    result = "floating-electric-pole",
    result_count = 1
  },
  {
    type = "recipe",
    name = "buoy",
    enabled = false,
    energy_required = 1,
    ingredients = {
      {"empty-barrel", 2},
      {"electronic-circuit", 2},
      {"iron-plate", 5}
    },
    result = "buoy",
    result_count = 1
  },
  {
    type = "recipe",
    name = "chain_buoy",
    enabled = false,
    energy_required = 1,
    ingredients = {
      {"empty-barrel", 2},
      {"electronic-circuit", 2},
      {"iron-plate", 5}
    },
    result = "chain_buoy",
    result_count = 1
  },
  {
    type = "recipe",
    name = "bridge_base",
    enabled = false,
    energy_required = 15,
    ingredients = {
      {"advanced-circuit", 15},
      {"steel-plate", 60},
      {"iron-gear-wheel", 30},
      {"rail", 10},
    },
    result = "bridge_base",
    result_count = 1
  },

})

if settings.startup["deep_oil"].value then
  data:extend{
    {
      type = "recipe",
      name = "oil_rig",
      enabled = false,
      energy_required = 30,
      ingredients = {
        {"pumpjack", 5},
        {"boiler", 1},
        {"steam-engine", 1},
        {"steel-plate", 150},
        {"electronic-circuit", 75},
        {"pipe", 75}
      },
      result = "oil_rig",
      result_count = 1
    },
  }
end
