require("util")
require("__cargo-ships__/logic/ship_api")
require("__cargo-ships__/logic/ship_placement")
require("__cargo-ships__/logic/oil_placement")
require("__cargo-ships__/logic/rail_placement")
require("__cargo-ships__/logic/long_reach")
require("__cargo-ships__/logic/bridge_logic")
require("__cargo-ships__/logic/pump_placement")
require("__cargo-ships__/logic/blueprint_logic")
require("__cargo-ships__/logic/ship_enter")
require("__cargo-ships__/gui/oil_rig_gui")
--require("__cargo-ships__/logic/crane_logic")
--require("__cargo-ships__/logic/rolling_stock_logic")

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
    elseif entity.ghost_name == "straight-water-way" or entity.ghost_name == "curved-water-way" then
      entity.silent_revive{raise_revive = true}
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
      surface.create_entity{name = "or_power_electric", position = pos, force = force}
      surface.create_entity{name = "or_pole", position = pos, force = force}
      surface.create_entity{name = "or_radar", position = pos, force = force}
      global.oil_rigs[entity.unit_number] = entity
    end

  -- create bridge
  elseif entity.name == "bridge_base" then
    CreateBridge(entity, e.player_index)

  -- make waterway not collide with boats by replacing it with entity that does not have "ground-tile" in its collision mask
  elseif entity.type == "straight-rail" or entity.type == "curved-rail" then
    CheckRailPlacement(entity, player, e.robot)

  --elseif entity.name == "crane" then
  --  OnCraneCreated(entity)
  end
end

local function onMarkedForDeconstruction(e)
  local entity = e.entity
  if entity.name == "straight-water-way" or entity.name == "curved-water-way" then
    entity.destroy()
  end
end

local function onGiveWaterway(e)
  local player = game.get_player(e.player_index)
  local cleared = player.clear_cursor()
  if cleared then
    player.cursor_ghost = "waterway"
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
      or_inv = entity.surface.find_entities_filtered{area={{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}}, name="or_power_electric"}
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

local function updateSmoke(e)
  -- Called every 0.5s
  for unit_number, oil_rig in pairs(global.oil_rigs) do
    if oil_rig.valid then
      local rig_status = oil_rig.status
      if not (rig_status == defines.entity_status.no_power or rig_status == defines.entity_status.marked_for_deconstruction) then
        oil_rig.surface.create_entity{name="or-smoke-10", position=oil_rig.position}
      end
    else
      global.oil_rigs[unit_number] = nil
    end
  end
end

local function onModSettingsChanged(e)
  if e.setting == "waterway_reach_increase" then
    global.current_distance_bonus = settings.global["waterway_reach_increase"].value
    applyReachChanges()
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
      {filter="ghost", ghost_name="straight-water-way"},
      {filter="ghost", ghost_name="curved-water-way"},
      {filter="type", type="cargo-wagon"},
      {filter="type", type="fluid-wagon"},
      {filter="type", type="locomotive"},
      {filter="type", type="artillery-wagon"},
      {filter="name", name="oil_rig"},
      {filter="name", name="bridge_base"},
      {filter="type", type="straight-rail"},
      {filter="type", type="curved-rail"},
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

  local deconstructed_filters = {
    {filter="name", name="straight-water-way"},
    {filter="name", name="curved-water-way"},
  }
  script.on_event(defines.events.on_marked_for_deconstruction, onMarkedForDeconstruction, deconstructed_filters)

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

local function init_oil_rigs()
  local oil_rigs = {}
  for _, surface in pairs(game.surfaces) do
    for _, entity in pairs(surface.find_entities_filtered{name="oil_rig"}) do
      oil_rigs[entity.unit_number] = entity
    end
  end
  global.oil_rigs = oil_rigs
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
  global.or_generators = nil  -- Removed
  if not global.oil_rigs then
    init_oil_rigs()  -- Creates global.oil_rigs
  end

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
  log("cargo ships on_configuration_changed")
  init()
  end)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChanged)

-- custom-input and shortcut button
script.on_event({defines.events.on_lua_shortcut, "give-waterway"},
  function(e)
    if e.prototype_name and e.prototype_name ~= "give-waterway" then return end
    onGiveWaterway(e)
  end
)

-- update entities
script.on_event(defines.events.on_tick, onTick)
script.on_nth_tick(30, updateSmoke)

-- long reach
script.on_event(defines.events.on_player_cursor_stack_changed, onStackChanged)
script.on_event(defines.events.on_pre_player_died, deadReach)

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
