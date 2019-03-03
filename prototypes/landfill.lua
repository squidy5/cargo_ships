


local dummy_tile = table.deepcopy(data.raw["tile"]["grass-1"])
dummy_tile.collision_mask = {"ground-tile", "object-layer"}
dummy_tile.name = "dummy_tile"

data:extend{dummy_tile}


data.raw["item"]["landfill"] =
{

    type = "item",
    name = "landfill",
    icon = "__base__/graphics/icons/landfill.png",
    icon_size = 32,
    subgroup = "terrain",
    order = "c[landfill]-a[dirt]",
    stack_size = 100,
    place_as_tile =
    {
      result = "dummy_tile",
      condition_size = 1,
      condition = {"ground-tile"}
    }
}
