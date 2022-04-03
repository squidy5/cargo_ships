-- Handle conversion of normal oil into deep sea oil

function placeDeepOil(e)
  local surface = e.surface
  local area = e.area
  local count = 0

  -- Check if there is any water at all in this chunk, or if we should delete oil from land
  if (global.no_oil_on_land or surface.count_tiles_filtered{area=area, collision_mask = "water-tile"} > 0) then

    -- Find all the crude oil generated on land or sea
    local vanilla_deposits = surface.find_entities_filtered{area=area, name="crude-oil"}
    local num_deposits = (vanilla_deposits and #vanilla_deposits) or 0

    if num_deposits > 0 then
      -- Check if this chunk is entirely ocean
      local deep_tiles = 0
      if global.no_shallow_oil then
        deep_tiles = surface.count_tiles_filtered{area=area, name="deepwater","deepwater-green"}
      else
        deep_tiles = surface.count_tiles_filtered{area=area, name={"water","water-green","deepwater","deepwater-green"}}
      end

      if deep_tiles == 1024 then
        -- This is a water chunk, consolidate the vanilla deposits into one offshore deposit
        -- create oil in inner part of tile to avoid deep oil too close to land
        local x = 0
        local y = 0
        local a = 0
        for _, deposit in pairs(vanilla_deposits) do
          x = x + deposit.position.x
          y = y + deposit.position.y
          a = a + deposit.amount
          deposit.destroy()
          count = count + 1
        end
        x = x / num_deposits
        y = y / num_deposits
        a = a * global.oil_bonus
        local pos = {x=x, y=y}
        surface.create_entity{name="deep_oil", amount=a, position=pos}
        log(surface.name..": Consolidated "..tostring(num_deposits).." crude-oil into deep_oil amount="..tostring(a).." in WATER chunk "..util.positiontostr(pos))

      else
        -- Did not consolidate anything, but there is both water and oil in this chunk.
        -- If land deposits are disabled, delete all crude-oil deposits.
        -- Otherwise, delete all crude-oil deposits that are on water
        for _, deposit in pairs(vanilla_deposits) do
          if ( global.no_oil_on_land or
               surface.count_tiles_filtered{position=deposit.position, radius=deposit.get_radius(), collision_mask="water-tile"} > 0 ) then
            deposit.destroy()
            count = count + 1
          end
        end
        log(surface.name..": Deleted "..tostring(count).." of "..tostring(num_deposits).." crude-oil in LAND chunk "..util.positiontostr(e.position))
      end
    end
  end
  return count
end


-- Cause this surface to regenerate all oil and redo our postprocessing of it
function regenerateSurface(surface)
  -- For each chunk (to keep lists small):
  -- 1. If deep_oil enabled, delete existing deep_oil
  local destroyed = 0
  if global.deep_oil_enabled then
    for chunk in surface.get_chunks() do
      local old_oils = surface.find_entities_filtered{name="deep_oil", area=chunk.area}
      for _, e in pairs(old_oils) do
        e.destroy()
        destroyed = destroyed + 1
      end
    end
  end

  -- 2. Regenerate crude-oil entities on entire surface
  surface.regenerate_entity("crude-oil")

  -- 3. If deep_oil enabled, reprocess oil in chunk
  local modified = 0
  if global.deep_oil_enabled then
    for chunk in surface.get_chunks() do
      modified = modified + placeDeepOil{surface=surface, area=chunk.area, position={x=chunk.x, y=chunk.y}}
    end
  end

  if destroyed + modified > 0 then
    log("Regenerated oil on "..surface.name..":  "..tostring(destroyed).." deep_oil removed, "..tostring(modified).." crude-oil removed or converted.")
    game.print({"cargo-ship-message.regenerate-stats", surface.name, destroyed, modified})
  else
    log("Regenerated oil on "..surface.name..":  No changes made.")
    game.print({"cargo-ship-message.regenerate-none", surface.name})
  end
  return destroyed + modified
end


function RegenerateOilCommand(params)
  local player = game.players[params.player_index]
  if player then
    if player.admin then
      if params.parameter and game.surfaces[params.parameter] then
        -- Regenerate on a specific surface (only works if RSO is not installed)
        if remote.interfaces["RSO"] then 
          player.print{"cargo-ship-message.error-rso-regenerate-surface"}
        else
          local surface = game.surfaces[params.parameter]
          game.print{"cargo-ship-message.regenerate-started",player.name,surface.name}
          regenerateSurface(game.surfaces[params.parameter])
        end
      else
        -- Regenerate on all surfaces
        game.print{"cargo-ship-message.regenerate-started",player.name,{"cargo-ship-message.all-surfaces"}}
        if remote.interfaces["RSO"] then
          remote.call("RSO", "regenerate")
        end
        local count=0
        local total=#game.surfaces
        for _, surface in pairs(game.surfaces) do
          if regenerateSurface(surface) > 0 then
            count = count + 1
          end
        end
        game.print{"cargo-ship-message.regenerate-finished", count, total}
      end
    else
      player.print{"cargo-ship-message.error-must-be-admin"}
    end
  end
end
