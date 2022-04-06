require("util")
require("logic.ship_api")
require("logic.ship_placement")
require("logic.oil_placement")
require("logic.rail_placement")
require("logic.long_reach")
require("logic.bridge_logic")
require("logic.pump_placement")
require("logic.blueprint_logic")
require("gui.oil_rig_gui")
--require("logic.crane_logic")
--require("logic.rolling_stock_logic")

-- spawn additional invisible entities
local function onEntityBuild(e)
  --disable rolling stock logic for 1 tick
  --global.rolling_stock_timeout = 1


  local entity = e.created_entity or e.entity or e.destination
  local surface = entity.surface
  local force = entity.force
  local player = (e.player_index and game.players[e.player_index]) or nil


  -- check ghost entities first
  if entity.name == "entity-ghost" then
    if entity.ghost_name == "bridge_base" then
      -- Not allowed to make ghost bridges yet
      entity.destroy()

    elseif entity.ghost_name == "straight-water-way-placed" or entity.ghost_name == "curved-water-way-placed" then
      -- Convert ghosts of water-way-placed into water-way
      local surface = entity.surface
      local time_to_live = entity.time_to_live
      local new_params = {
        name="entity-ghost",
        position=entity.position,
        direction=entity.direction,
        force=entity.force,
        player=entity.last_user,
        inner_name=string.sub(entity.ghost_name, 1, -8),
        expires=(time_to_live and time_to_live < 4294967295)
      }
      -- Destroy the water-way-placed ghost
      entity.destroy()

      -- Make sure the new water-way ghost isn't placed on land, because create_entity doesn't do collision checks
      if surface.count_tiles_filtered{position=new_params.position, radius=1, collision_mask="ground-tile"} == 0 then
        local ghost = surface.create_entity(new_params)
        if ghost and time_to_live then
          ghost.time_to_live = time_to_live
        end
      end
    end

  elseif global.boat_bodies[entity.name] then
    CheckBoatPlacement(entity, player)

  elseif (entity.type == "cargo-wagon" or entity.type == "fluid-wagon" or
          entity.type == "locomotive" or entity.type == "artillery-wagon") then
    --game.players[1].print(entity.collision_mask)
    local engine = nil
    if global.ship_bodies[entity.name] then
      local ship_data = global.ship_bodies[entity.name]
      if ship_data.engine then
        local pos
        local dir
        pos, dir = localize_engine(entity)
        -- see if there is an engine ghost from a blueprint behind us
        local engine_ghosts = surface.find_entities_filtered{ghost_name=ship_data.engine, position = pos, radius = 1, force = force}
        if engine_ghosts and next(engine_ghosts) then
          local q
          q,engine = engine_ghosts[1].revive()
          -- If couldn't revive engine, destroy ghost
          if not engine then
            engine_ghosts[1].destroy()
          end
        else
          engine = surface.create_entity{name = ship_data.engine, position = pos, direction = dir, force = force}
        end
      end
    end
    -- check placement in next tick
    table.insert(global.check_entity_placement, {entity, engine, player, e.robot})

  -- add oilrig slave entity
  elseif entity.name == "oil_rig" then
    local pos = entity.position
    local a = {{pos.x-2, pos.y-2}, {pos.x+2, pos.y+2}}
    local deep_oil = surface.find_entities_filtered{area=a, name="deep_oil"}
    if #deep_oil == 0 then
      if player then
        player.insert{name="oil_rig", count= 1}
        player.print{"cargo-ship-message.error-place-on-water", entity.localised_name}
      elseif e.robot then
        e.robot.get_inventory(defines.inventory.robot_cargo).insert{name="oil_rig", count= 1}
        game.print{"cargo-ship-message.error-place-on-water", entity.localised_name}
      end
      entity.destroy()
    else
      local or_power = surface.create_entity{name = "or_power", position = pos, force = force}
      table.insert(global.or_generators, or_power)
      surface.create_entity{name = "or_pole", position = pos, force = force}
      surface.create_entity{name = "or_radar", position = pos, force = force}
    end

  -- create bridge
  elseif entity.name == "bridge_base" then
    CreateBridge(entity, e.player_index)

  -- make waterway not collide with boats by replacing it with entity that does not have "ground-tile" in its collision mask
  elseif entity.type == "straight-rail" or entity.type == "curved-rail" then
    CheckRailPlacement(entity, player, e.robot)

  elseif entity.name == "buoy" or entity.name == "chain_buoy" then
    -- Make buoys indestructible
    if settings.global["indestructible_buoys"].value then
      entity.destructible = false
    end

  --elseif entity.name == "crane" then
  --  OnCraneCreated(entity)
  end
end

-- destroy waterways when landfill is build on top
local function onTileBuild(e)
  if e.item and e.item.name == "landfill" then
    ----- New event code prevents mods from omitting mandatory arguments, so this will always work
    local surface = game.surfaces[e.surface_index]

    local old_tiles = {}
    for _, tile in pairs(e.tiles) do
      if not surface.can_place_entity{name = "tile_test_item", position = tile.position}
        and surface.can_place_entity{name = "tile_player_test_item", position = tile.position} then
        -- refund
        if e.player_index then
          game.players[e.player_index].insert{name = "landfill", count = 1}
        end
        table.insert(old_tiles, {name = tile.old_tile.name or "deepwater", position = tile.position})

      end
    end
    surface.set_tiles(old_tiles)
  end
end

-- enter or leave ship
local function OnEnterShip(e)
  local player_index = e.player_index
  local player = game.players[player_index]
  local surface = player.surface
  local pos = player.position
  local X = pos.x
  local Y = pos.y

  if player.vehicle == nil then
    -- Only enter vehicle if player has a character
    if player.character then
      for dist = 1,10 do
        local targets = surface.find_entities_filtered{
          position = pos,
          radius = dist,
          name = global.enter_ship_entities
        }
        local done = false
        for _, target in pairs(targets) do
          if target and target.get_driver() == nil then
            target.set_driver(player)
            done = true
          elseif target and target.type == "car" and target.get_passenger() == nil then
            target.set_passenger(player)
            done = true
          end
        end
        if done then
          break
        end
      end
    end
  else
    local new_pos = surface.find_non_colliding_position("tile_player_test_item", pos, 10, 0.5, true)
    if new_pos then
      local old_vehicle = player.vehicle
      if old_vehicle.type == "car" then
        -- Figure out whether the player is driver or passenger
        local driver = old_vehicle.get_driver()  -- Can return either LuaEntity or LuaPlayer
        if driver then
          if not driver.is_player() then
            if driver.type == "character" then
              driver = driver.player  -- Get the player associated with this character, if any
            else
              driver = nil
            end
          end
          if driver and driver == player then
            old_vehicle.set_driver(nil)
          end
        end
        local passenger = old_vehicle.get_passenger()  -- Can return either LuaEntity or LuaPlayer
        if passenger then
          if not passenger.is_player() then
            if passenger.type == "character" then
              passenger = passenger.player  -- Get the player associated with this character, if any
            else
              passenger = nil
            end
          end
          if passenger and passenger == player then
            old_vehicle.set_passenger(nil)
          end
        end
      else
        old_vehicle.set_driver(nil)
      end
      player.driving = false
      player.teleport(new_pos)
    end
  end
end

-- delete invisible entities if master entity is destroyed
local function OnDeleted(e)
  if(e.entity and e.entity.valid) then
    local entity = e.entity
    if global.ship_bodies[entity.name] then
      if entity.train then
        if entity.train.back_stock then
          if global.ship_engines[entity.train.back_stock.name] then
            entity.train.back_stock.destroy()
          end
        end
        if entity.train.front_stock then
          if global.ship_engines[entity.train.front_stock.name] then
            entity.train.front_stock.destroy()
          end
        end
      end

    elseif global.ship_engines[entity.name] then
      if entity.train then
        if entity.train.front_stock then
          if global.ship_bodies[entity.train.front_stock.name] then
            entity.train.front_stock.destroy()
          end
        end
        if entity.train.back_stock then
          if global.ship_bodies[entity.train.back_stock.name]  then
            entity.train.back_stock.destroy()
          end
        end
      end

    elseif entity.name == "oil_rig" then
      local pos = entity.position
      local or_inv = entity.surface.find_entities_filtered{area={{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}}, name="or_power"}
      for i = 1, #or_inv do
        or_inv[i].destroy()
      end
      or_inv = entity.surface.find_entities_filtered{area={{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}}, name="or_pole"}
      for i = 1, #or_inv do
        or_inv[i].destroy()
      end
      or_inv = entity.surface.find_entities_filtered{area={{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}}, name="or_radar"}
      for i = 1, #or_inv do
        or_inv[i].destroy()
      end

    elseif string.match(entity.name, "bridge_") then
      local worked = DeleteBridge(entity, e.player_index)
      if not worked then
        e.buffer.clear()
      end
    end
  end
end


-- recover fuel of cargo ship engine if attempted to mine by player and robot
local function OnMined(e)
  if(e.entity and e.entity.valid) then
    local entity = e.entity
    local okay_to_delete = true
    if global.ship_bodies[entity.name] then
      okay_to_delete = false
      local player = (e.player_index and game.players[e.player_index]) or nil
      local robot = e.robot
      if entity.train then
        local engine
        if entity.train.back_stock and
          (global.ship_engines[entity.train.back_stock.name]) then
          engine = entity.train.back_stock
        elseif entity.train.front_stock and
              (global.ship_engines[entity.train.front_stock.name]) then
          engine = entity.train.front_stock
        end
        if ( engine and global.ship_engines[engine.name].recover_fuel and
             engine.get_fuel_inventory() and not engine.get_fuel_inventory().is_empty() ) then
          local fuel = engine.get_fuel_inventory()
          if player and player.character then
            for f_type,f_amount in pairs(fuel.get_contents()) do
              player.insert{name=f_type, count=f_amount}
              fuel.remove{name=f_type, count=f_amount}
            end
          elseif robot then
            local robotInventory = robot.get_inventory(defines.inventory.robot_cargo)
            local robotSize = 1 + robot.force.worker_robots_storage_bonus
            local robotEmpty = robotInventory.is_empty()
            if robotEmpty and fuel then
              for index=1,#fuel do
                local stack = fuel[index]
                if stack.valid_for_read then
                  --game.print("Giving robot cargo stack: "..stack.name.." : "..stack.count)
                  local inserted = robotInventory.insert{name=stack.name, count=math.min(stack.count, robotSize)}
                  fuel.remove{name=stack.name, count=inserted}
                  if not robotInventory.is_empty() then
                    robotEmpty = false
                    break
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

local function powerOilRig(e)
  if e.tick % 120 == 0 then
    if global.or_generators == nil then
      global.or_generators = {}
      for _, surface in pairs(game.surfaces) do
        for _, generator in pairs(surface.find_entities_filtered{name="or_power"}) do
          table.insert(global.or_generators, generator)
        end
      end
    end
    for i, generator in pairs(global.or_generators) do
      if(generator.valid) then
        generator.fluidbox[1] = {name="steam", amount = 200, temperature=165}
      else
        --game.players[1].print("found invalid")
        table.remove(global.or_generators,i)
      end
    end
  end
end

local function updateAllBuoys()
  -- search for all buoys and make them either destructible or indestructible
  local destructible = not settings.global["indestructible_buoys"].value
  local count = 0
  for _, surface in pairs(game.surfaces) do
    local buoys = surface.find_entities_filtered{name={"buoy","chain_buoy"}}
    for _, buoy in pairs(buoys) do
      buoy.destructible = destructible
      count = count + 1
    end
  end
  --game.print("updated "..tostring(count).." buoys with destructible="..tostring(destructible))
end

local function onModSettingsChanged(e)
  if e.setting == "waterway_reach_increase" then
    global.current_distance_bonus = settings.global["waterway_reach_increase"].value
    applyReachChanges()
  elseif e.setting == "indestructible_buoys" then
    updateAllBuoys()
  end
end

-- Register conditional events based on mod settting
function init_events()
  if settings.startup["deep_oil"].value then
    -- place deep oil
    script.on_event(defines.events.on_chunk_generated, placeDeepOil)
    -- handle oil rig storage info guis
    script.on_event(defines.events.on_gui_opened, onOilrigGuiOpened)
    script.on_event(defines.events.on_gui_closed, onOilrigGuiClosed)
    script.on_event(defines.events.on_player_created, onPlayerCreated)
  end

  -- entity created, check placement and create invisible elements
  local entity_filters = {
      {filter="ghost", ghost_name="bridge_base"},
      {filter="ghost", ghost_name="straight-water-way-placed"},
      {filter="ghost", ghost_name="curved-water-way-placed"},
      {filter="type", type="cargo-wagon"},
      {filter="type", type="fluid-wagon"},
      {filter="type", type="locomotive"},
      {filter="type", type="artillery-wagon"},
      {filter="name", name="oil_rig"},
      {filter="name", name="bridge_base"},
      {filter="type", type="straight-rail"},
      {filter="type", type="curved-rail"},
      {filter="name", name="buoy"},
      {filter="name", name="chain_buoy"}
    }
  if global.boat_bodies then
    for name,_ in pairs(global.boat_bodies) do
      table.insert(entity_filters, {filter="name", name=name})
    end
  end
  script.on_event(defines.events.on_built_entity, onEntityBuild, entity_filters)
  script.on_event(defines.events.on_robot_built_entity, onEntityBuild, entity_filters)
  script.on_event(defines.events.on_entity_cloned, onEntityBuild, entity_filters)
  script.on_event(defines.events.script_raised_built, onEntityBuild, entity_filters)
  script.on_event(defines.events.script_raised_revive, onEntityBuild, entity_filters)

  -- delete invisible oil rig, bridge, and ship elements
  local deleted_filters = {
      {filter="name", name="oil_rig"},
      {filter="name", name="bridge_base"},
      {filter="name", name="bridge_north"},
      {filter="name", name="bridge_north_closed"},
      {filter="name", name="bridge_north_clickable"},
      {filter="name", name="bridge_east"},
      {filter="name", name="bridge_east_closed"},
      {filter="name", name="bridge_east_clickable"},
      {filter="name", name="bridge_south"},
      {filter="name", name="bridge_south_closed"},
      {filter="name", name="bridge_south_clickable"},
      {filter="name", name="bridge_west"},
      {filter="name", name="bridge_west_closed"},
      {filter="name", name="bridge_west_clickable"}
    }
  if global.ship_bodies then
    for name,_ in pairs(global.ship_bodies) do
      table.insert(deleted_filters, {filter="name", name=name})
    end
  end
  if global.ship_engines then
    for name,_ in pairs(global.ship_engines) do
      table.insert(deleted_filters, {filter="name", name=name})
    end
  end
  script.on_event(defines.events.on_entity_died, OnDeleted, deleted_filters)
  script.on_event(defines.events.script_raised_destroy, OnDeleted, deleted_filters)
  script.on_event(defines.events.on_player_mined_entity, OnDeleted, deleted_filters)
  script.on_event(defines.events.on_robot_mined_entity, OnDeleted, deleted_filters)

  -- recover fuel from mined ships
  local mined_filters = {}
  if global.ship_bodies then
    for name,_ in pairs(global.ship_bodies) do
      table.insert(mined_filters, {filter="name", name=name})
    end
  end
  script.on_event(defines.events.on_pre_player_mined_item, OnMined, mined_filters)
  script.on_event(defines.events.on_robot_pre_mined, OnMined, mined_filters)

  -- Compatibility with AAI Vehicles (Modify this whenever the list of boats changes)
  remote.remove_interface("aai-sci-burner")
  remote.add_interface("aai-sci-burner", {
    hauler_types = function(data)
      local types={}
      if global.boat_bodies then
        for name,_ in pairs(global.boat_bodies) do
          table.insert(types, name)
        end
      end
      return types
    end,
  })

end

local function init()
  -- Cache startup settings
  global.deep_oil_enabled = settings.startup["deep_oil"].value
  local oil_richness = settings.startup["oil_richness"].value
  local mult = 1
  if oil_richness == "very-poor" then
    mult = 0.25
  elseif oil_richness == "poor" then
    mult = 0.5
  elseif oil_richness == "good" then
    mult = 4
  elseif oil_richness == "very-good" then
    mult = 10
  end
  global.oil_bonus = mult
  global.no_oil_on_land = settings.startup["no_oil_on_land"].value
  global.oil_rig_capacity = settings.startup["oil_rig_capacity"].value
  global.no_shallow_oil = settings.startup["no_shallow_oil"].value

  -- Init global variables
  global.check_entity_placement = global.check_entity_placement or {}
  global.bridges = global.bridges or {}
  global.bridgesToReplace = global.bridgesToReplace or {}
  global.ship_pump_selected = global.ship_pump_selected or {}
  global.pump_markers = global.pump_markers or {}
  global.cranes = global.cranes or {}
  global.new_cranes = global.new_cranes or {}
  global.gui_oilrigs = (global.deep_oil_enabled and global.gui_oilrigs) or {}
  global.connection_counter = 0

  init_ship_globals()  -- Init database of ship parameters

  -- Initialize or migrate long reach state
  global.last_cursor_stack_name =
    ((type(global.last_cursor_stack_name) == "table") and global.last_cursor_stack_name)
      or {}
  global.last_distance_bonus =
    ((type(global.last_distance_bonus) == "number") and global.last_distance_bonus)
      or settings.global["waterway_reach_increase"].value
  global.current_distance_bonus = settings.global["waterway_reach_increase"].value

  -- Reapply long reach settings to existing characters

  -- Reapply buoy setting when mod is updated
  updateAllBuoys()

  -- Update GUI for all players if needed (after globals are re-cached)
  createGuiAllPlayers()

  -- Register conditional events
  init_events()
end

local function onTick(e)
  checkPlacement()
  ManageBridges(e)
  UpdateVisuals(e)
  if global.deep_oil_enabled then
    powerOilRig(e)
    UpdateOilRigGui(e)
  end
  --ManageCranes(e)
end

local function onStackChanged(e)
  increaseReach(e)
  PumpVisualisation(e)
end

---- Register Default Events ----
-- init
script.on_load(function()
  log("cargo ships on_load")
  init_events()
  end)
script.on_init(function()
  log("cargo ships on_init")
  init()
  end)
script.on_configuration_changed(function()
  log("cargo ships on_init")
  init()
  end)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChanged)

-- custom commands
script.on_event("enter_ship", OnEnterShip)

-- tile created
script.on_event(defines.events.on_player_built_tile, onTileBuild)
script.on_event(defines.events.on_robot_built_tile, onTileBuild)


-- update entities
script.on_event(defines.events.on_tick, onTick)

-- long reach
script.on_event(defines.events.on_player_cursor_stack_changed, onStackChanged)
script.on_event(defines.events.on_pre_player_died, deadReach)

-- blueprints
script.on_event(defines.events.on_player_configured_blueprint, FixBlueprints)
script.on_event(defines.events.on_player_setup_blueprint, FixBlueprints)

-- pipette
script.on_event(defines.events.on_player_pipette, FixPipette)

-- rolling stock connect
script.on_event(defines.events.on_train_created, On_Train_Created)

-- Console commands
commands.add_command("regenerate-oil", {"cargo-ship-message.regenerate-oil-help"}, RegenerateOilCommand)


------------------------------------------------------------------------------------
--                    FIND LOCAL VARIABLES THAT ARE USED GLOBALLY                 --
--                              (Thanks to eradicator!)                           --
------------------------------------------------------------------------------------
--[[setmetatable(_ENV,{
  __newindex=function (self,key,value) --locked_global_write
    error('\n\n[ER Global Lock] Forbidden global *write*:\n'
      .. serpent.line{key=key or '<nil>',value=value or '<nil>'}..'\n')
    end,
  __index   =function (self,key) --locked_global_read
    error('\n\n[ER Global Lock] Forbidden global *read*:\n'
      .. serpent.line{key=key or '<nil>'}..'\n')
    end ,
  })
--]]
