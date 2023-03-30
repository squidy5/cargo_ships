function FixBlueprints(e)
  -- Handle both Copy and Blueprint operations
  local player = game.get_player(e.player_index)
  local stack = player.blueprint_to_setup
  if not (stack and stack.valid_for_read) then
    stack = player.cursor_stack
    if not (stack and stack.valid_for_read and stack.is_blueprint) then
      return
    end
  end

  local blues = stack.get_blueprint_entities()
  if blues and next(blues) then
    local ww = false
    for i, blue in pairs(blues) do
      if blue.name == "straight-water-way-placed" then
        blue.name = "straight-water-way"
        ww = true
      elseif blue.name == "curved-water-way-placed" then
        blue.name = "curved-water-way"
        ww = true
      end
    end
    if(ww) then
      stack.set_blueprint_entities(blues)
    end
  end
end

function FixPipette(e)
  -- Pipetting engine or rail boat doesn't work
  local item = e.item
  if item and item.valid then
    local player = game.players[e.player_index]
    local selected = player.selected
    local cursor = player.cursor_stack

    if global.ship_bodies[item.name] or global.boat_bodies[item.name] or global.ship_engines[item.name] then
      -- Get the placing-item of this ship or boat
      local new_item = (global.boat_bodies[item.name] and global.boat_bodies[item.name].placing_item) or
                       (global.ship_bodies[item.name] and global.ship_bodies[item.name].placing_item)
      -- See what ship is coupled to this ship_engine
      if not new_item and selected and global.ship_engines[selected.name] and #selected.train.carriages == 2 then
        for i,c in pairs(selected.train.carriages) do
          if global.ship_bodies[c.name] then
            new_item = global.ship_bodies[c.name].placing_item
            break
          end
        end
      end

      if new_item then
        -- The following logic copied from Robot256Lib.
        if cursor.valid_for_read == true and e.used_cheat_mode == false then
          -- Give boat to replace boat parts that player accidentally had in inventory (when not in cheat mode)
          cursor.set_stack{name=new_item, count=cursor.count}
        else
          -- Check for boat in inventory
          local inventory = player.get_main_inventory()
          local new_stack = inventory.find_item_stack(new_item)
          cursor.set_stack(new_stack)  -- Set cursor with inventory contents OR clear it if none available
          if not cursor.valid_for_read then
            if player.cheat_mode==true then
              -- If none in inventory and cheat mode enabled, give stack of correct items
              cursor.set_stack{name=new_item, count=game.item_prototypes[new_item].stack_size}
            end
          else
            -- Found items in inventory. Remove it from inventory now that it is in the cursor.
            inventory.remove(new_stack)
          end
        end
      else
        -- Can't find valid item, this must be an invisible one
        cursor.clear()
      end
    end
  end
end
