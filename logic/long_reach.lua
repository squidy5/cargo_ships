-- Give player extra reach when holding a water item
-- 1. When player picks up an item, increase their reach bonus by the set amount
-- 2. When player puts down an item, decrease their reach bonus by the set amount
-- 3. When player dies while holding an item, decrease by set amount
-- 4. When setting changes, modify bonus of any player holding an item by the change in value

-- Problems: Other mods change reach bonuses. This algo will work if they also make relative changes,
--   but usually they make absolute changes. Best if player disables our feature when using others.
-- Will never result in less reach than the prototype specifies

local is_waterway_str = {
    ["waterway"]=true,
    ["buoy"]=true,
    ["chain_buoy"]=true,
    ["port"]=true,
    ["pump"]=true,
    ["oil_rig"]=true,
    ["floating-electric-pole"]=true,
    ["bridge_base"]=true
  }

local function is_waterway(item)
  if item and item.valid_for_read then
    return is_waterway_str[item.name]
  end
  return false
end

-- Called when a player's cursor_stack changes
function increaseReach(e)
  local reach_setting = global.current_distance_bonus
  if reach_setting > 0 then
    local player = game.players[e.player_index]
    if not player.character then
      return
    end

    local cursor_stack = player.cursor_stack
    if (global.last_cursor_stack_name[e.player_index] and
        cursor_stack and cursor_stack.valid_for_read and
        global.last_cursor_stack_name[e.player_index] == cursor_stack.name) then
      return
    end

    if is_waterway(cursor_stack) and not is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
      player.character.character_build_distance_bonus = player.character.character_build_distance_bonus + reach_setting
      player.character_reach_distance_bonus = player.character_reach_distance_bonus + reach_setting
      --game.print("bonus="..tostring(player.character.character_build_distance_bonus))
    elseif not is_waterway(cursor_stack) and is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
      player.character.character_build_distance_bonus = math.max(player.character.character_build_distance_bonus - reach_setting, 0)
      player.character.character_reach_distance_bonus = math.max(player.character.character_reach_distance_bonus - reach_setting, 0)
      --game.print("bonus="..tostring(player.character.character_build_distance_bonus))
    end
    
    if cursor_stack and cursor_stack.valid_for_read then
      global.last_cursor_stack_name[e.player_index] = cursor_stack.name
    else
      global.last_cursor_stack_name[e.player_index] = nil
    end
  end
end

-- Called when a player dies
function deadReach(e)
  if global.current_distance_bonus > 0 then
    local player = game.players[e.player_index]
    if is_waterway_str[global.last_cursor_stack_name[e.player_index]] then
      player.character.character_build_distance_bonus = math.max(player.character.character_build_distance_bonus - global.current_distance_bonus, 0)
      player.character.character_reach_distance_bonus = math.max(player.character.character_reach_distance_bonus - global.current_distance_bonus, 0)
      --game.print("bonus="..tostring(player.character.character_build_distance_bonus))
    end
    global.last_cursor_stack_name[e.player_index] = nil
  end
end

-- Called when mod setting chages
function applyReachChanges()
  for _, player in pairs(game.players) do
    if is_waterway(player.cursor_stack) then
      player.character.character_build_distance_bonus = math.max(player.character.character_build_distance_bonus + (global.current_distance_bonus - global.last_distance_bonus), 0)
      player.character.character_reach_distance_bonus = math.max(player.character.character_reach_distance_bonus + (global.current_distance_bonus - global.last_distance_bonus), 0)
      --game.print("bonus="..tostring(player.character.character_build_distance_bonus))
    end
  end
  global.last_distance_bonus = global.current_distance_bonus
end
