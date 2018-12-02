data:extend({
    {
        type = "recipe", 
        name = "boat",
        enabled = false, 
        energy_required = 3,
        ingredients =
        {
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
        energy_required = 10,
        ingredients =
        {
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
        energy_required = 10,
        ingredients =
        {
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
        name = "ship_pump",
        enabled = false, 
        energy_required = 1,
        ingredients =
        {
            {"engine-unit", 2},
            {"steel-plate", 5},
            {"pipe", 2}
        },
        result = "ship_pump"
    },
    {
        type = "recipe",
        name = "water-way",
        enabled = false,
        ingredients =
        {
          {"iron-stick", 1},
        },
        result = "water-way",
        result_count = 10
    },
    {
        type = "recipe",
        name = "port",
        enabled = false,
        ingredients =
        {
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
        ingredients =
        {
            {"empty-barrel", 4},
            {"big-electric-pole", 5},
            {"steel-plate", 3}
        },
        result = "floating-electric-pole",
        result_count = 1
    },
    {
        type = "recipe",
        name = "buoy",
        enabled = false,
        ingredients =
        {
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
        ingredients =
        {
            {"empty-barrel", 2},
            {"electronic-circuit", 2},
            {"iron-plate", 5}
        },
        result = "chain_buoy",
        result_count = 1
    },
    {
        type = "recipe",
        name = "oil_rig",
        enabled = false,
        ingredients =
        {
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
    --[[
    {
        type = "recipe",
        name = "bridge_base",
        enabled = true,
        ingredients =
        {
            {"iron-plate", 1},
        },
        result = "bridge_base",
        result_count = 1
    },
    {
        type = "recipe",
        name = "bridge_east",
        enabled = false,
        ingredients =
        {
            {"iron-plate", 1},
        },
        result = "bridge_east",
        result_count = 1
    }]]
})
