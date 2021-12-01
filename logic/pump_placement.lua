local function AddVisuals(player)
  local new_markers = {}
  local pos = player.position
  local a = {{pos.x-100, pos.y-100}, {pos.x+100, pos.y+100}}
  local ports = player.surface.find_entities_filtered{area=a, name="port"}
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

function PumpVisualisation(e)
  local player = game.players[e.player_index]
  local stack = player.cursor_stack

  -- if stack valid
  if stack and stack.valid_for_read then
    -- if last was pump, current is not
    if global.ship_pump_selected[e.player_index] and stack.name ~= "ship_pump" then
      RemoveVisuals(e.player_index)
      global.ship_pump_selected[e.player_index] = nil

    -- if current is pump and last was not
    elseif (not global.ship_pump_selected[e.player_index]) and stack.name == "ship_pump" then
      AddVisuals(player)
      global.ship_pump_selected[e.player_index] = true
    end

  -- if stack empty
  elseif global.ship_pump_selected[e.player_index] then
    RemoveVisuals(e.player_index)
    global.ship_pump_selected[e.player_index] = nil
  end
end
