local function unlock(recipe)
  return {
    type = "unlock-recipe",
    recipe = recipe
  }
end

data:extend ({
{
  type = "technology",
  name = "water_transport",
  icon = GRAPHICSPATH .. "technology/water_transport.png",
  icon_size = 256,
  effects = {
    unlock("boat"),
  },
  prerequisites = {"logistics-2", "engine"},
  unit = {
    count = 100,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-a",
},
{
  type = "technology",
  name = "cargo_ships",
  icon = GRAPHICSPATH .. "technology/cargo_ships.png",
  icon_size = 256,

  effects = {
    unlock("cargo_ship"),
  },
  prerequisites = {"automated_water_transport"},
  unit = {
    count = 150,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-a",
},
{
  type = "technology",
  name = "automated_water_transport",
  icon = GRAPHICSPATH .. "technology/automated_water_transport.png",
  icon_size = 256,
  effects = {
    unlock("port"),
  },
  prerequisites = {"water_transport"},
  unit = {
    count = 75,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-b",
},
{
  type = "technology",
  name = "oversea-energy-distribution",
  icon = GRAPHICSPATH .. "technology/oversea-energy-distribution.png",
  icon_size = 256,
  effects = {
    unlock("floating-electric-pole"),
  },
  prerequisites = {"water_transport", "electric-energy-distribution-1"},
  unit = {
    count = 120,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-e-b",
},
{
  type = "technology",
  name = "water_transport_signals",
  icon = GRAPHICSPATH .. "technology/water_transport_signals.png",
  icon_size = 256,
  effects = {
    unlock("buoy"),
    unlock("chain_buoy"),
  },
  prerequisites = {"automated_water_transport"},
  unit = {
    count = 75,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-b",
},
{
  type = "technology",
  name = "tank_ship",
  icon = GRAPHICSPATH .. "technology/tank_ship.png",
  icon_size = 256,
  effects = {
    unlock("oil_tanker"),
  },
  prerequisites = {"automated_water_transport", "fluid-handling"},
  unit = {
    count = 150,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-b",
},
{
  type = "technology",
  name = "automated_bridges",
  icon = GRAPHICSPATH .. "technology/automated_bridges.png",
  icon_size = 256,
  effects = {
    unlock("bridge_base"),
  },
  prerequisites = {"water_transport_signals", "rail-signals", "advanced-electronics"},
  unit = {
    count = 200,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1}
    },
    time = 30
  },
  order = "c-g-b",
}
})

if settings.startup["deep_oil"].value then
  data:extend{
    {
      type = "technology",
      name = "deep_sea_oil_extraction",
      icon = GRAPHICSPATH .. "technology/deep_sea_oil_extraction.png",
      icon_size = 256,
      effects = {
        unlock("oil_rig"),
      },
      prerequisites = {"tank_ship", "oil-processing"},
      unit = {
        count = 200,
        ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1}
        },
        time = 30
      },
      order = "c-g-b",
    },
  }
end
