data:extend ({

{
	type = "technology",
	name = "water_transport",
	icon = "__cargo-ships__/graphics/icons/cargoship_icon.png", 
    icon_size = 64,

    effects =
    {
    	{
    		type = "unlock-recipe",
    		recipe = "cargo_ship"
    	},
    	{
    		type = "unlock-recipe",
    		recipe = "water-way"
    	},
	},
	prerequisites = {"logistics-2", "engine"},
	unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
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
        recipe = "port_lb"
      },
	},
	prerequisites = {"water_transport"},
	unit =
    {
      count = 75,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 30
    },
    order = "c-g-b",
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
        {"science-pack-1", 1},
        {"science-pack-2", 1},
      },
      time = 30
    },
    order = "c-g-b",
},
{
	type = "technology",
	name = "tank_ship",
	icon = "__cargo-ships__/graphics/icons/tanker.png", 
  icon_size = 64,

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
	prerequisites = {"water_transport", "fluid-handling" },
	unit =
  {
    count = 150,
    ingredients =
    {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
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
    count = 250,
    ingredients =
    {
      {"science-pack-1", 1},
      {"science-pack-2", 1},
    },
    time = 30
  },
  order = "c-g-b",
}



})