-- Support for  Schallfalke's Schall Transport Group mod
local subgroup_shipequip = "water_transport"

if mods["SchallTransportGroup"] then
  subgroup_shipequip = "water_equipment"
end

data:extend({
  {
    type = "item",
    name = "bridge_base",
    icon = GRAPHICSPATH .. "icons/bridge.png",
    icon_size = 64,
    subgroup = subgroup_shipequip,
    flags = {},
    order = "a[water-system]-e[bridge_base]",
    place_result = "bridge_base",
    stack_size = 5,
  },
})










