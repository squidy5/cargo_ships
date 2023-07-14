require("__cargo-ships__/constants")
local collision_mask_util = require("collision-mask-util")

-- Prevent waterways being placed on land, but without colliding with ground-tile directly, so that ships don't collide
waterway_layer = collision_mask_util.get_first_unused_layer()
for _, tile in pairs(data.raw.tile) do
  if collision_mask_util.mask_contains_layer(tile.collision_mask, "ground-tile") then
    table.insert(tile.collision_mask, waterway_layer)
  end
end
collision_mask_util.add_layer(data.raw["straight-rail"]["straight-water-way"].collision_mask, waterway_layer)
collision_mask_util.add_layer(data.raw["curved-rail"]["curved-water-way"].collision_mask, waterway_layer)
collision_mask_util.add_layer(data.raw["straight-rail"]["invisible_rail"].collision_mask, waterway_layer)
collision_mask_util.add_layer(data.raw["straight-rail"]["bridge_crossing"].collision_mask, waterway_layer)

collision_mask_util.add_layer(data.raw["rail-signal"]["buoy"].collision_mask, waterway_layer)
collision_mask_util.add_layer(data.raw["rail-chain-signal"]["chain_buoy"].collision_mask, waterway_layer)
collision_mask_util.add_layer(data.raw["rail-chain-signal"]["invisible_chain_signal"].collision_mask, waterway_layer)

data.raw.tile["landfill"].check_collision_with_entities = true

-- Change drawing of fish to be underneath bridges
data.raw.fish["fish"].collision_mask = {"ground-tile", "colliding-with-tiles-only"}
data.raw.fish["fish"].pictures[1].draw_as_shadow = true
data.raw.fish["fish"].pictures[2].draw_as_shadow = true
data.raw.fish["fish"].selection_priority = 48

-- Change technology requirement if oil is not available on land
if settings.startup["deep_oil"].value and (settings.startup["no_oil_on_land"].value or settings.startup["no_oil_for_oil_rig"].value) then
  data.raw.technology["deep_sea_oil_extraction"].unit = {
    count = 300,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
    },
    time = 30
  }
end

-- Change inserters to not catch fish when waiting for ships
if settings.startup["no_catching_fish"].value then
  for _, inserter in pairs(data.raw.inserter) do
    inserter.use_easter_egg = false
  end
end

-- Krastorio2 fuel compatibility
if mods["Krastorio2"] and settings.startup['kr-rebalance-vehicles&fuels'].value then
  data.raw.locomotive["cargo_ship_engine"].burner.fuel_categories = { "chemical", "vehicle-fuel" }
  log("Updated cargo_ship_engine to use chemical fuel and Krastorio2 vehicle-fuel")
  data.raw.locomotive["boat_engine"].burner.fuel_categories = { "vehicle-fuel" }
  log("Updated boat_engine to use only Krastorio2 vehicle-fuel")
end

-- Ensure player collides with pump
local pump = data.raw["pump"]["pump"]
local pump_collision_layer = collision_mask_util.get_first_unused_layer()
collision_mask_util.add_layer(pump.collision_mask, pump_collision_layer)
for _, character in pairs(data.raw.character) do
  local collision_mask = collision_mask_util.get_mask(character)
  if collision_mask_util.mask_contains_layer(collision_mask, "player-layer") then
    collision_mask_util.add_layer(collision_mask, pump_collision_layer)
    character.collision_mask = collision_mask
  end
end

-- Compatibility for pump upgrade mods
for _, other_pump in pairs(data.raw.pump) do
  if other_pump.fast_replaceable_group == pump.fast_replaceable_group then
    other_pump.collision_mask = table.deepcopy(pump.collision_mask)
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
    -- Make new collision layer 'land-resource'
    local land_resource_layer = collision_mask_util.get_first_unused_layer()

    -- Replace 'resource-layer' with 'land-resource' in the collision masks of water tiles where oil can go
    if settings.startup["no_shallow_oil"].value then
      valid_oil_tiles = {"deepwater","deepwater-green"}
    else
      valid_oil_tiles = {"water","water-green","deepwater","deepwater-green"}
    end
    for _, name in pairs(valid_oil_tiles) do
      if data.raw.tile[name] then
        for i=1, #data.raw.tile[name].collision_mask do
          if data.raw.tile[name].collision_mask[i] == "resource-layer" then
            log("Replacing collision layer 'resource-layer' with 'land-resource:"..tostring(land_resource_layer).."' on tile '"..name.."'")
            data.raw.tile[name].collision_mask[i] = land_resource_layer
            break
          end
        end
      end
    end

    -- Add a new "land-resource" collision mask to land resources (If Water_Ores is not installed)
    for name, _ in pairs(data.raw.resource) do
      if name ~= "crude-oil" and name ~= "deep_oil" then
        if data.raw.resource[name].collision_mask then
          table.insert(data.raw.resource[name].collision_mask, land_resource_layer)
          data.raw.resource[name].selection_priority = math.max((data.raw.resource[name].selection_priority or 50) - 1, 0)
        else
          data.raw.resource[name].collision_mask = {"resource-layer", land_resource_layer}
          data.raw.resource[name].selection_priority = math.max((data.raw.resource[name].selection_priority or 50) - 1, 0)
        end
        log("Adding collision layer 'land-resource:"..tostring(land_resource_layer).."' to resource '"..name.."' and demoting to selection_priority="..tostring(data.raw.resource[name].selection_priority))
      end
    end
    
    -- Fix Alien Biomes tree selection priority
    for name, _ in pairs(data.raw.tree) do
      if data.raw.tree[name].selection_priority and data.raw.tree[name].selection_priority == 0 then
        data.raw.tree[name].selection_priority = 1
      end
    end

  end

  -- Make sure the oil rig can mine deep oil:
  data.raw["mining-drill"]["oil_rig"].resource_categories = {data.raw.resource["deep_oil"].category}

end
