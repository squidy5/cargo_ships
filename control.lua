require("util")
require("logic.ship_placement")
require("logic.oil_placement")
require("logic.long_reach")
require("logic.bridge_logic")
require("logic.pump_placement")
require("logic.blueprint_logic")
require("gui.oil_rig_gui")
--require("logic.crane_logic")
--require("logic.rolling_stock_logic")

-- Find the up to six different rails that can be connected to this one
function get_connected_rails(rail)
  local connected_rails = {}
  for _, d in pairs({defines.rail_direction.front, defines.rail_direction.back}) do
    for _, c in pairs({defines.rail_connection_direction.straight, defines.rail_connection_direction.left, defines.rail_connection_direction.right}) do
      local r = rail.get_connected_rail{rail_direction = d, rail_connection_direction = c}
      if r then
        table.insert(connected_rails, r)
      end
    end
  end
  return connected_rails
end

-- spawn additional invisible entities
function onEntityBuild(e)
  --disable rolling stock logic for 1 tick
  --global.rolling_stock_timeout = 1


  local entity = e.created_entity or e.entity or e.destination
  local surface = entity.surface
  local force = entity.force
  local player = (e.player_index and game.players[e.player_index]) or nil


  -- check ghost entities first
  if entity.name == "entity-ghost" then
    if entity.ghost_name == "bridge_base" then
      entity.destroy()
    end

  elseif entity.name == "indep-boat" then
    CheckBoatPlacement(entity, e.player_index)

  elseif entity.type == "cargo-wagon" or entity.type == "fluid-wagon" or entity.type == "locomotive" or entity.type == "artillery-wagon" then
    --game.players[1].print(entity.collision_mask)
    local engine = nil
    if entity.name == "cargo_ship" or entity.name == "oil_tanker" then
      local pos, dir = localize_engine(entity)
      engine = surface.create_entity{name = "cargo_ship_engine", position = pos, direction = dir, force = force}
    elseif entity.name == "boat"  then
      local pos, dir = localize_engine(entity)
      engine = surface.create_entity{name = "boat_engine", position = pos, direction = dir, force = force}
    end
    -- check placement in next tick
    table.insert(global.check_entity_placement, {entity, engine, e.player_index})

  -- add oilrig slave entity
  elseif entity.name == "oil_rig" then
    local pos = entity.position
    local a = {{pos.x-2, pos.y-2}, {pos.x+2, pos.y+2}}
    local deep_oil = surface.find_entities_filtered{area=a, name="deep_oil"}
    if #deep_oil == 0 then
      entity.destroy()
      if player then
        player.insert{name="oil_rig", count= 1}
        player.print{"cargo-ship-message.error-place-on-water", entity.localised_name}
      end
    else
      local or_power = surface.create_entity{name = "or_power", position = pos, force = force}
      table.insert(global.or_generators, or_power)
      surface.create_entity{name = "or_pole", position = pos, force = force}
      surface.create_entity{name = "or_radar", position = pos, force = force}
      --surface.create_entity{name = "or_lamp", position = {pos.x - 3, pos.y -3}, force = force}
      --surface.create_entity{name = "or_lamp", position = {pos.x + 2, pos.y -3}, force = force}
      --surface.create_entity{name = "or_lamp", position = {pos.x + 2, pos.y + 3}, force = force}
      --surface.create_entity{name = "or_lamp", position = {pos.x - 3, pos.y + 3}, force = force}
    end

  -- create bridge
  elseif entity.name == "bridge_base" then
    CreateBridge(entity, e.player_index)

  -- make waterway not collide with boats by replacing it with entity that does not have "ground-tile" in its collision mask
  elseif entity.name == "straight-water-way" or entity.name == "curved-water-way" then
    -- Check if this waterway is connected to a non-waterway
    local bad_connection = false
    local bad_name = ""
    for _, rail in pairs(get_connected_rails(entity)) do
      if not (string.find(rail.name, "%-water%-way") or rail.name == "bridge_crossing") then
        bad_connection = true
        bad_name = rail.name
        break
      end
    end

    local pos = entity.position
    local name = entity.name .. "-placed"
    local dir = entity.direction
    local refund = entity.prototype.items_to_place_this[1]
    entity.destroy() --destroy old

    --check for already placed entities
    local give_refund = false
    local prev = surface.find_entities_filtered{position = pos, name = name}
    if bad_connection then
      -- Refund ww if connected to rails
      give_refund = true
      if player then
        player.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..name.."__", "__ENTITY__"..bad_name.."__"}
      else
        game.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..name.."__", "__ENTITY__"..bad_name.."__"}
      end
    else
      for _, pr in pairs(prev) do
        if pr.direction == dir then
          give_refund = true
          break
        end
      end
    end

    if give_refund then
      -- placement was invalid, give refund and don't rebuild
      if player then
        player.insert(refund)
      end
    else
      -- create waterway
      local WW = surface.create_entity{name = name, position = pos, direction = dir, force = force}
      -- make waterway indestructible
      if WW then
        WW.destructible = false
      end
    end

  elseif entity.type == "straight-rail" or entity.type == "curved-rail" then
    -- Check if this rail is connected to a waterway
    local bad_connection = false
    local bad_name = ""
    for _, rail in pairs(get_connected_rails(entity)) do
      if string.find(rail.name, "%-water%-way") or rail.name == "bridge_crossing" then
        bad_connection = true
        bad_name = rail.name
        break
      end
    end
    if bad_connection then
      local refund = entity.prototype.items_to_place_this[1]
      if player then
        player.insert(refund)
        player.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..entity.name.."__", "__ENTITY__"..bad_name.."__"}
      else
        game.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..entity.name.."__", "__ENTITY__"..bad_name.."__"}
      end
      entity.destroy()
    end

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
function onTileBuild(e)
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
function OnEnterShip(e)
  local player_index = e.player_index
  local player = game.players[player_index]
  local surface = player.surface
  local pos = player.position
  local X = pos.x
  local Y = pos.y

  if player.vehicle == nil then
    -- Only enter vehicle if player has a character
    if player.character then
      for dis = 1,10 do
        local targets = surface.find_entities_filtered{
          area={{X-dis, Y-dis}, {X+dis, Y+dis}},
          name={"indep-boat","boat_engine","cargo_ship_engine"}}
        local done = false
        for _, target in pairs(targets) do
          if target and target.get_driver() == nil then
            target.set_driver(player)
            done = true
          elseif target and target.name == "indep-boat" and target.get_passenger() == nil then
            target.set_passenger(player)
          end
        end
        if done then break end
      end
    end
  else
    local new_pos = surface.find_non_colliding_position("tile_player_test_item", pos, 10, 0.5, true)
    if new_pos then
      local old_vehicle = player.vehicle
      if old_vehicle.name == "indep-boat" then
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
function OnDeleted(e)
  if(e.entity) then
    local entity = e.entity
    if entity.name == "cargo_ship" or entity.name == "oil_tanker" or entity.name == "boat" then
      if entity.train ~= nil then

        if entity.train.back_stock ~= nil then
          if entity.train.back_stock.name == "cargo_ship_engine" or entity.train.back_stock.name == "boat_engine" then
            entity.train.back_stock.destroy()
          end
        end
        if entity.train.front_stock ~= nil then
          if entity.train.front_stock.name == "cargo_ship_engine" or entity.train.front_stock.name == "boat_engine" then
            entity.train.front_stock.destroy()
          end
        end
      end

    elseif entity.name == "cargo_ship_engine" or entity.name == "boat_engine" then
      if entity.train ~= nil then
        if entity.train.front_stock ~= nil then
          if entity.train.front_stock.name == "cargo_ship" or entity.train.front_stock.name == "oil_tanker" or entity.train.front_stock.name == "boat" then
            entity.train.front_stock.destroy()
          end
        end
      end

    elseif entity.name == "oil_rig" then
      local pos = entity.position
      local or_inv = entity.surface.find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_power"}
      for i = 1, #or_inv do
        or_inv[i].destroy()
      end
      --or_inv = entity.surface.find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_lamp"}
      --for i = 1, #or_inv do
      --  or_inv[i].destroy()
      --end
      or_inv = entity.surface.find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_pole"}
      for i = 1, #or_inv do
        or_inv[i].destroy()
      end
      or_inv = entity.surface.find_entities_filtered{area =  {{pos.x-4, pos.y-4},{pos.x+4, pos.y+4}},  name="or_radar"}
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

-- recover fuel of cargo ship engine
function OnMined(e)
  if(e.entity) then
    if e.entity.name == "cargo_ship" or e.entity.name == "oil_tanker" or e.entity.name == "boat" then
      local entity = e.entity
      local player_index = e.player_index
      local engine
      if entity.train then
        if entity.train.back_stock then
          if entity.train.back_stock.name == "cargo_ship_engine" or entity.train.back_stock.name == "boat_engine"  then
            local fuel = entity.train.back_stock.get_fuel_inventory().get_contents()
            for f_type,f_amount in pairs(fuel) do
              game.players[player_index].insert{name=f_type, count=f_amount}
            end
          end
        end
        if entity.train.front_stock then
          if entity.train.front_stock.name == "cargo_ship_engine" or entity.train.front_stock.name == "boat_engine"  then
            local fuel = entity.train.front_stock.get_fuel_inventory().get_contents()
            for f_type,f_amount in pairs(fuel) do
              game.players[player_index].insert{name=f_type, count=f_amount}
            end
          end
        end
      end
    end
  end
  -- destroy
  OnDeleted(e)
end

function powerOilRig(e)
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

function updateAllBuoys()
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

function onModSettingsChanged(e)
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
end

function init()
  -- Cache startup settings
  global.deep_oil_enabled = settings.startup["deep_oil"].value
  local oil_richness = settings.startup["oil_richness"].value
  local mult = 1
  if oil_richness == "very-poor" then
    mult = 0.25
  elseif oil_richness == "poor" then
    mult = 0.5
  elseif oil_richness == "good" then
    mult = 2
  elseif oil_richness == "very-good" then
    mult = 4
  end
  global.oil_bonus = mult
  global.no_oil_on_land = settings.startup["no_oil_on_land"].value
  global.oil_rig_capacity = settings.startup["oil_rig_capacity"].value

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

function onTick(e)
  checkPlacement()
  ManageBridges(e)
  UpdateVisuals(e)
  if global.deep_oil_enabled then
    powerOilRig(e)
    UpdateOilRigGui(e)
  end
  --ManageCranes(e)
end

function onStackChanged(e)
  increaseReach(e)
  PumpVisualisation(e)
end

---- Register Default Events ----
-- init
script.on_load(init_events)
script.on_init(init)
script.on_configuration_changed(init)
script.on_event(defines.events.on_runtime_mod_setting_changed, onModSettingsChanged)

-- custom commands
script.on_event("enter_ship", OnEnterShip)

-- delete invisibles
local deleted_filters = {
    {filter="name", name="cargo_ship"},
    {filter="name", name="oil_tanker"},
    {filter="name", name="boat"},
    {filter="name", name="cargo_ship_engine"},
    {filter="name", name="boat_engine"},
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
script.on_event(defines.events.on_entity_died, OnDeleted, deleted_filters)
script.on_event(defines.events.on_robot_mined_entity, OnDeleted, deleted_filters)
script.on_event(defines.events.script_raised_destroy, OnDeleted, deleted_filters)
script.on_event(defines.events.on_player_mined_entity, OnMined, deleted_filters)

-- tile created
script.on_event(defines.events.on_player_built_tile, onTileBuild)
script.on_event(defines.events.on_robot_built_tile, onTileBuild)

-- entity created
local entity_filters = {
    {filter="ghost", ghost_name="bridge_base"},
    {filter="type", type="cargo-wagon"},
    {filter="type", type="fluid-wagon"},
    {filter="type", type="locomotive"},
    {filter="type", type="artillery-wagon"},
    {filter="name", name="indep-boat"},
    {filter="name", name="oil_rig"},
    {filter="name", name="bridge_base"},
    {filter="type", type="straight-rail"},
    {filter="type", type="curved-rail"},
    {filter="name", name="buoy"},
    {filter="name", name="chain_buoy"}
  }
script.on_event(defines.events.on_built_entity, onEntityBuild, entity_filters)
script.on_event(defines.events.on_robot_built_entity, onEntityBuild, entity_filters)
script.on_event(defines.events.on_entity_cloned, onEntityBuild, entity_filters)
script.on_event(defines.events.script_raised_built, onEntityBuild, entity_filters)
script.on_event(defines.events.script_raised_revive, onEntityBuild, entity_filters)

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

-- Compatibility with AAI Vehicles
remote.add_interface("aai-sci-burner", {
  hauler_types = function(data)
    return {
      'indep-boat',
    }
  end,
})

------------------------------------------------------------------------------------
--                    FIND LOCAL VARIABLES THAT ARE USED GLOBALLY                 --
--                              (Thanks to eradicator!)                           --
------------------------------------------------------------------------------------
setmetatable(_ENV,{
  __newindex=function (self,key,value) --locked_global_write
    error('\n\n[ER Global Lock] Forbidden global *write*:\n'
      .. serpent.line{key=key or '<nil>',value=value or '<nil>'}..'\n')
    end,
  __index   =function (self,key) --locked_global_read
    error('\n\n[ER Global Lock] Forbidden global *read*:\n'
      .. serpent.line{key=key or '<nil>'}..'\n')
    end ,
  })
