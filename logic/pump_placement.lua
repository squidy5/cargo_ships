local function PlaceVisuals(position, horizontal, mult, player)
  local surface = player.surface
  local markers = {}
  if horizontal ~= 0 then
    for x = 5, 9, 2 do
      for y = -4, 0, 4 do
        local pos = {position.x+x*mult, position.y-y*mult}
        local m = surface.create_entity{name="pump_marker", position=pos}
        m.render_player = player
        table.insert(markers, m)
      end
    end
  else
    for y = 5, 9, 2 do
      for x = -4, 0, 4 do
        local pos = {position.x+x*mult, position.y+y*mult}
        local m = surface.create_entity {name="pump_marker", position=pos}
        m.render_player = player
        table.insert(markers, m)
      end
    end
  end
  return markers
end

local function AddVisuals(player)
  local new_markers = {}
  local pos = player.position
  local a = {{pos.x-100, pos.y-100}, {pos.x+100, pos.y+100}}
  local ports = player.surface.find_entities_filtered{area=a, name="port"}
  local ltnports = player.surface.find_entities_filtered{area=a, name="ltn-port"}
  for _, ltnport in pairs(ltnports) do
    table.insert(ports, ltnport)
  end
  -- initalize marker array if necessarry
  global.pump_markers[player.index] = global.pump_markers[player.index] or {}
  for _, port in pairs(ports) do
    local dir = port.direction
    if dir == defines.direction.north then
      new_markers = PlaceVisuals(port.position, 0, 1, player)
    elseif dir == defines.direction.south then
      new_markers = PlaceVisuals(port.position, 0, -1, player)
    elseif dir == defines.direction.east then
      new_markers = PlaceVisuals(port.position, 1, -1, player)
    elseif dir == defines.direction.west then
      new_markers = PlaceVisuals(port.position, 1, 1, player)
    end
    table.insert(global.pump_markers[player.index], new_markers)
  end
end

local function RemoveVisuals(player_index)
  for _, marker_set in pairs(global.pump_markers[player_index]) do
    for _, marker in pairs(marker_set) do
      marker.destroy()
    end
  end
  -- reset gloabl to remove remenant empty marker sets
  global.pump_markers[player_index] = nil
end

function UpdateVisuals(e)
  if e.tick % 120 == 0 then
    for pidx, player in pairs(game.players) do
      if global.ship_pump_selected[pidx] then
        RemoveVisuals(pidx)
        AddVisuals(player)
      end
    end
  end
end

local function is_holding_pump(player)
  if player.is_cursor_blueprint() then
    local blueprint_entities = player.get_blueprint_entities()
    if blueprint_entities then
      for _, bp_entity in pairs(blueprint_entities) do
        if bp_entity.name == "pump" then
          return true
        end
      end
    end
    return false
  end
  local stack = player.cursor_stack
  if stack and stack.valid_for_read and stack.name == "pump" then
    return true
  end
  local ghost = player.cursor_ghost
  if ghost and ghost.name == "pump" then
    return true
  end
end

function PumpVisualisation(e)
  local player = game.get_player(e.player_index)

  local holding_pump = is_holding_pump(player)

  if (not global.ship_pump_selected[e.player_index]) and holding_pump then
    -- if current is pump and last was not
    AddVisuals(player)
    global.ship_pump_selected[e.player_index] = true

  elseif global.ship_pump_selected[e.player_index] and not holding_pump then
    -- if last was pump, current is not
    RemoveVisuals(e.player_index)
    global.ship_pump_selected[e.player_index] = nil
  end
end
