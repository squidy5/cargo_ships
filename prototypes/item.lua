require("__cargo-ships__/prototypes/bridge_items")

-- Support for  Schallfalke's Schall Transport Group mod
local subgroup_ship = "water_transport"
local subgroup_shipequip = "water_transport"

if mods["SchallTransportGroup"] then
  data:extend{
    {
      type = "item-subgroup",
      name = "water_transport2",
      group ="transport",
      order = "b-2",
    },
    {
      type = "item-subgroup",
      name = "water_equipment",
      group ="transport",
      order = "j-2",
    },
  }
  subgroup_ship = "water_transport2"
  subgroup_shipequip = "water_equipment"
end


data:extend{
  {
    type = "item-subgroup",
    name = "water_transport",
    group ="logistics",
    order = "e",
  },
  {
    type = "item-with-entity-data",
    name = "indep-boat",
    icon = GRAPHICSPATH .. "icons/boat.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_ship,
    order = "a[water-system]-f[boat]",
    place_result = "boat",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "boat",
    icon = GRAPHICSPATH .. "icons/boat.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_ship,
    order = "a[water-system]-f[boat]",
    place_result = "indep-boat",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "boat_engine",
    icon = "__base__/graphics/icons/engine-unit.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"hidden"},
    subgroup = subgroup_ship,
    order = "a[water-system]-z[boat_engine]",
    place_result = "boat_engine",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "cargo_ship_engine",
    icon = "__base__/graphics/icons/engine-unit.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"hidden"},
    subgroup = subgroup_ship,
    order = "a[water-system]-z[cargo_ship_engine]",
    place_result = "cargo_ship_engine",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "cargo_ship",
    icon = GRAPHICSPATH .. "icons/cargoship_icon.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_ship,
    order = "a[water-system]-f[cargo_ship]",
    place_result = "cargo_ship",
    stack_size = 5,
  },
  {
    type = "item-with-entity-data",
    name = "oil_tanker",
    icon = GRAPHICSPATH .. "icons/tanker.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_ship,
    order = "a[water-system]-g[oil_tanker]",
    place_result = "oil_tanker",
    stack_size = 5,
  },
  {
    type = "rail-planner",
    name = "waterway",
    icon = GRAPHICSPATH .. "icons/water_rail.png",
    icon_size = 64,
    localised_name = {"item-name.waterway"},
    flags = {"only-in-cursor"},
    subgroup = subgroup_shipequip,
    order = "a[water-system]-a[water-way]",
    place_result = "straight-water-way",
    stack_size = 100,
    straight_rail = "straight-water-way",
    curved_rail = "curved-water-way"
  },
  {
    type = "item",
    name = "port",
    icon = GRAPHICSPATH .. "icons/port.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_shipequip,
    order = "a[water-system]-b[train-stop]",
    place_result = "port",
    stack_size = 10
  },
  {
    type = "item",
    name = "floating-electric-pole",
    icon = GRAPHICSPATH .. "icons/floating_pole.png",
    icon_size = 64,
    flags = {},
    subgroup = "energy-pipe-distribution",
    order = "a[energy]-c[big-electric-pole]-a[floating-electric-pole]",
    place_result = "floating-electric-pole",
    stack_size = 50
  },
  {
    type = "item",
    name = "buoy",
    icon = GRAPHICSPATH .. "icons/buoy.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_shipequip,
    order = "a[water-system]-c[buoy]",
    place_result = "buoy",
    stack_size = 100
  },
  {
    type = "item",
    name = "chain_buoy",
    icon = GRAPHICSPATH .. "icons/chain_buoy.png",
    icon_size = 64,
    flags = {},
    subgroup = subgroup_shipequip,
    order = "a[water-system]-d[chain_buoy]",
    place_result = "chain_buoy",
    stack_size = 100
  },
  {
    type = "item",
    name = "pump_marker",
    icon = "__base__/graphics/icons/crude-oil-resource.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"hidden"},
    order = "b[fluids]-c[oil_rig]",
    place_result = "pump_marker",
    stack_size = 5,
  },
}

if settings.startup["deep_oil"].value then
  data:extend{
    {
      type = "item",
      name = "oil_rig",
      icon = GRAPHICSPATH .. "icons/oil_rig.png",
      icon_size = 64,
      flags = {},
      subgroup = "extraction-machine",
      order = "b[fluids]-c[oil_rig]",
      place_result = "oil_rig",
      stack_size = 5,
    },
  }
end
