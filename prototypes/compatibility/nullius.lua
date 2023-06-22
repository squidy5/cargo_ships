if not mods["nullius"] then
    return
end

-- Places ships in crafting menu after the train wagons in nullius (train wagons are order: "g" in nullius)
data.raw["item-subgroup"]["water_transport"].order = "gb"


data.raw.technology["water_transport"].prerequisites = {"nullius-freight-transportation-1"}
-- Order or name in technology and recipe must "nullius-" in it or nullius hides it
data.raw.technology["water_transport"].order = "nullius-bb"
data.raw.technology["water_transport"].unit = {
    count = 50,
    ingredients = {
        {"nullius-geology-pack", 1},
        {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 1}
    },
    time = 5
}
data.raw.recipe["boat"].category = "large-crafting"
data.raw.recipe["boat"].always_show_made_in = true
data.raw.recipe["boat"].order = "nullius-aa"
data.raw.recipe["boat"].ingredients = {
    {"nullius-cargo-wagon-1", 1},
    {"nullius-motor-1", 6},
    {"nullius-steel-gear", 8},
    {"nullius-steel-plate", 32},
    {"nullius-portable-generator-1", 1},
    {"nullius-glass", 4}
}


data.raw.technology["oversea-energy-distribution"].prerequisites = {"nullius-energy-distribution-2", "water_transport"}
data.raw.technology["oversea-energy-distribution"].order = "nullius-bb"
data.raw.technology["oversea-energy-distribution"].unit = {
    count = 30,
    ingredients = {
        {"nullius-geology-pack", 2},
        {"nullius-climatology-pack", 2},
        {"nullius-mechanical-pack", 2},
        {"nullius-electrical-pack", 1}
    },
    time = 25
}
data.raw.recipe["floating-electric-pole"].category = "large-crafting"
data.raw.recipe["floating-electric-pole"].always_show_made_in = true
data.raw.recipe["floating-electric-pole"].order = "nullius-ag"
data.raw.recipe["floating-electric-pole"].ingredients = {
    {"empty-barrel", 5},
    {"nullius-pylon-1", 1},
    {"nullius-iron-plate", 6}
}


data.raw.technology["automated_water_transport"].prerequisites = {"nullius-freight-logistics", "water_transport"}
data.raw.technology["automated_water_transport"].order = "nullius-bb"
data.raw.technology["automated_water_transport"].unit = {
    count = 45,
    ingredients = {
        {"nullius-geology-pack", 1},
        {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 1},
        {"nullius-electrical-pack", 1}
    },
    time = 25
}
data.raw.recipe["port"].category = "medium-crafting"
data.raw.recipe["port"].always_show_made_in = true
data.raw.recipe["port"].order = "nullius-ad"
data.raw.recipe["port"].ingredients = {
    {"decider-combinator", 3},
    {"nullius-steel-plate", 8},
    {"nullius-steel-beam", 4},
}


data.raw.technology["cargo_ships"].prerequisites = {"nullius-electromagnetism-2", "automated_water_transport"}
data.raw.technology["cargo_ships"].order = "nullius-bb"
data.raw.technology["cargo_ships"].unit = {
    count = 60,
    ingredients = {
        {"nullius-geology-pack", 1},
        {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 2},
        {"nullius-electrical-pack", 1}
    },
    time = 25
}
data.raw.recipe["cargo_ship"].category = "large-crafting"
data.raw.recipe["cargo_ship"].always_show_made_in = true
data.raw.recipe["cargo_ship"].order = "nullius-ab"
data.raw.recipe["cargo_ship"].ingredients = {
    {"nullius-steel-plate", 80},
    {"nullius-motor-2", 8},
    {"nullius-steel-gear", 32},
    {"decider-combinator", 18}
}


data.raw.technology["tank_ship"].prerequisites = {"nullius-pumping-2", "nullius-electromagnetism-2", "automated_water_transport"}
data.raw.technology["tank_ship"].order = "nullius-bb"
data.raw.technology["tank_ship"].unit = {
    count = 75,
    ingredients = {
        {"nullius-geology-pack", 1},
        {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 2},
        {"nullius-electrical-pack", 2}
    },
    time = 25
}
data.raw.recipe["oil_tanker"].category = "large-crafting"
data.raw.recipe["oil_tanker"].always_show_made_in = true
data.raw.recipe["oil_tanker"].order = "nullius-ac"
data.raw.recipe["oil_tanker"].ingredients = {
    {"nullius-steel-plate", 60},
    {"nullius-motor-2", 8},
    {"nullius-steel-gear", 32},
    {"decider-combinator", 18},
    {"nullius-medium-tank-2", 6}
}


data.raw.technology["water_transport_signals"].prerequisites = {"nullius-traffic-control", "automated_water_transport"}
data.raw.technology["water_transport_signals"].order = "nullius-bb"
data.raw.technology["water_transport_signals"].unit = {
    count = 35,
    ingredients = {
        {"nullius-geology-pack", 1},
        {"nullius-climatology-pack", 2},
        {"nullius-mechanical-pack", 1},
        {"nullius-electrical-pack", 2}
    },
    time = 25
}
data.raw.recipe["buoy"].category = "small-crafting"
data.raw.recipe["buoy"].always_show_made_in = true
data.raw.recipe["buoy"].order = "nullius-ae"
data.raw.recipe["buoy"].ingredients = {
    {"empty-barrel", 1},
    {"decider-combinator", 1},
    {"nullius-sensor-1", 1},
    {"power-switch", 1},
    {"small-lamp", 1}
}
data.raw.recipe["chain_buoy"].category = "small-crafting"
data.raw.recipe["chain_buoy"].always_show_made_in = true
data.raw.recipe["chain_buoy"].order = "nullius-af"
data.raw.recipe["chain_buoy"].ingredients = {
    {"buoy", 1},
    {"copper-cable", 2}
}


data.raw.technology["automated_bridges"].prerequisites = {"nullius-concrete-1", "nullius-parallel-computing-1", "water_transport_signals"}
data.raw.technology["automated_bridges"].order = "nullius-bb"
data.raw.technology["automated_bridges"].unit = {
    count = 150,
    ingredients = {
        {"nullius-geology-pack", 2},
        {"nullius-climatology-pack", 1},
        {"nullius-mechanical-pack", 2},
        {"nullius-electrical-pack", 1}
    },
    time = 25
}
data.raw.recipe["bridge_base"].category = "large-crafting"
data.raw.recipe["bridge_base"].always_show_made_in = true
data.raw.recipe["bridge_base"].order = "nullius-ag"
data.raw.recipe["bridge_base"].ingredients = {
    {"nullius-concrete-1", 16},
    {"nullius-coprocessor-productivity-1", 1},
    {"nullius-steel-plate", 45},
    {"nullius-steel-gear", 25},
    {"rail", 10}
}
