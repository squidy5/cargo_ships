require("constants")

local collision_mask_util = require("collision-mask-util")

-- change collision mask of boat if it was changed by hovercraft mod:

data.raw["car"]["indep-boat"].collision_mask = {"ground-tile", "train-layer"}

data.raw.fish["fish"].collision_mask = {"ground-tile", "colliding-with-tiles-only"}

if settings.startup["deep_oil"].value and settings.startup["no_oil_for_oil_rig"].value then
  data.raw.technology["deep_sea_oil_extraction"].unit = {
    count = 300,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  }
end

if settings.startup["no_catching_fish"].value then
  for _, inserter in pairs(data.raw.inserter) do
    inserter.use_easter_egg = false
  end
end

-----------------------------
---- DEEP OIL GENERATION ----
-----------------------------

-- Disable sea oil generation and extraction if Omnimatter or Seablock are installed
if data.raw.resource.deep_oil then

  -- If Water_Ores is not installed, make it so that:
  -- 1. Crude Oil can generate on deepwater tiles, and
  -- 2. Other resources cannot generate on any water tiles
  -- (Water ores removes resource-layer from all water tiles, so crude oil AND ores can generate on water.
  --  In that case, it is up to the player if they want Offshore Oil to be consolidated, or leave the vanilla patches.)
  if not mods["Water_Ores"] then
    -- Remove 'resource-layer' from the collision masks of water tiles where oil can go
    if mods["ctg"] or mods["alien-biomes"] then
      valid_oil_tiles = {"water","water-green","deepwater","deepwater-green"}
    else
      valid_oil_tiles = {"deepwater"}
    end
    for _, name in pairs(valid_oil_tiles) do
      if data.raw.tile[name] then
        for i=1, #data.raw.tile[name].collision_mask do
          if data.raw.tile[name].collision_mask[i] == "resource-layer" then
            log("Removing collision layer 'resource-layer' from tile '"..name.."'")
            table.remove(data.raw.tile[name].collision_mask, i)
            break
          end
        end
      end
    end

    -- Make new collision layer 'land-resource'
    local land_resource_layer = collision_mask_util.get_first_unused_layer()

    -- Add a new "land-resource" collision mask to land resources (If Water_Ores is not installed)
    for name, _ in pairs(data.raw.resource) do
      if name ~= "crude-oil" then
        log("Adding collision layer 'land-resource:"..tostring(land_resource_layer).."' to resource '"..name.."'")
        if data.raw.resource[name].collision_mask then
          table.insert(data.raw.resource[name].collision_mask, land_resource_layer)
        else
          data.raw.resource[name].collision_mask = {"resource-layer", land_resource_layer}
        end
      end
    end

    -- Add land-resource to all water tiles also
    for _,tile in pairs(collision_mask_util.collect_prototypes_with_layer("water-tile")) do
      if tile.type == "tile" and string.find(tile.name, "water") then
        log("Adding collision layer 'land-resource:"..tostring(land_resource_layer).."' to resource '"..tile.name.."'")
        if tile.collision_mask then
          table.insert(tile.collision_mask, land_resource_layer)
        else
          tile.collision_mask = {"resource-layer", land_resource_layer}
        end
      end
    end
  end
end
