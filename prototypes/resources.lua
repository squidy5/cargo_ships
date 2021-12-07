----------------------------------------------------------------
-------------------------DEEP SEA OIL --------------------------
----------------------------------------------------------------

local deep_oil = table.deepcopy(data.raw.resource["crude-oil"])
if mods["angelspetrochem"] then
  deep_oil.minable = {
    hardness = 1,
    mining_time = 1,
    results =
    {
      {
        type = "fluid",
        name = "liquid-multi-phase-oil",
        amount_min = 10,
        amount_max = 10,
        probability = 1
      }
    }
  }
end
deep_oil.name = "deep_oil"
deep_oil.infinite_depletion_amount = 40
deep_oil.autoplace = nil
deep_oil.collision_mask = {'ground-tile','resource-layer'}
deep_oil.resource_patch_search_radius = 32
deep_oil.stages = {
  sheet = {
    filename = GRAPHICSPATH .. "entity/crude-oil/water-crude-oil.png",
    priority = "extra-high",
    width = 74,
    height = 60,
    frame_count = 4,
    variation_count = 1,
    shift = util.by_pixel(0, -2),
    scale = 1.4,
    hr_version =
    {
      filename = GRAPHICSPATH .. "entity/crude-oil/hr-water-crude-oil.png",
      priority = "extra-high",
      width = 148,
      height = 120,
      frame_count = 4,
      variation_count = 1,
      shift = util.by_pixel(0, -2),
      scale = 0.7
    }
  }
}
deep_oil.water_reflection = nil

data:extend{deep_oil}

-- Make sure the oil rig can mine deep oil:
data.raw["mining-drill"]["oil_rig"].resource_categories = {data.raw.resource["deep_oil"].category}
