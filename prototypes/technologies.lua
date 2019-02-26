data:extend ({

{
	type = "technology",
	name = "water_transport",
	icon = "__cargo-ships__/graphics/icons/boat.png", 
    icon_size = 64,

    effects =
    {
    	{
    		type = "unlock-recipe",
    		recipe = "boat"
    	},

	},
	prerequisites = {"logistics-2", "engine"},
	unit =
    {
      count = 100,
      ingredients =
      {
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
  icon = "__cargo-ships__/graphics/icons/cargoship_icon.png", 
    icon_size = 128,

    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "cargo_ship"
      },
  },
  prerequisites = {"automated_water_transport"},
  unit =
    {
      count = 150,
      ingredients =
      {
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
	icon = "__cargo-ships__/graphics/icons/port-research.png", 
    icon_size = 64,

    effects =
    {
     	{
    		type = "unlock-recipe",
    		recipe = "port"
    	},
      {
        type = "unlock-recipe",
        recipe = "water-way"
      },
	},
	prerequisites = {"water_transport"},
	unit =
    {
      count = 75,
      ingredients =
      {
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
  icon = "__cargo-ships__/graphics/icons/floating_pole_research.png", 
    icon_size = 96,

    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "floating-electric-pole"
      },
  },
  prerequisites = {"water_transport", "electric-energy-distribution-1"},
  unit =
    {
      count = 120,
      ingredients =
      {
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
	icon = "__cargo-ships__/graphics/icons/buoys-research.png", 
    icon_size = 64,

    effects =
    {
    	{
    		type = "unlock-recipe",
    		recipe = "buoy"
    	},
    	{
    		type = "unlock-recipe",
    		recipe = "chain_buoy"
    	}
	},
	prerequisites = {"automated_water_transport"},
	unit =
    {
      count = 75,
      ingredients =
      {
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
	icon = "__cargo-ships__/graphics/icons/tanker.png", 
  icon_size = 128,

  effects =
  {
  	{
  		type = "unlock-recipe",
  		recipe = "oil_tanker"
  	},
  	{
  		type = "unlock-recipe",
  		recipe = "ship_pump"
  	}
	},
	prerequisites = {"automated_water_transport", "fluid-handling" },
	unit =
  {
    count = 150,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  },
  order = "c-g-b",
},
{
  type = "technology",
  name = "deep_sea_oil_extraction",
  icon = "__cargo-ships__/graphics/icons/oil_rig.png", 
  icon_size = 96,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "oil_rig"
    },
  },
  prerequisites = {"tank_ship", "oil-processing" },
  unit =
  {
    count = 200,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1}
    },
    time = 30
  },
  order = "c-g-b",
},
{
  type = "technology",
  name = "automated_bridges",
  icon = "__cargo-ships__/graphics/icons/bridge_research.png", 
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "bridge_base"
    },
  },
  prerequisites = {"water_transport_signals", "rail-signals", "advanced-electronics"},
  unit =
  {
    count = 200,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1}
    },
    time = 30
  },
  order = "c-g-b",
}



})