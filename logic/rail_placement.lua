
-- Find the up to six different rails that can be connected to this one
local function get_connected_rails(rail)
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

function CheckRailPlacement(entity, player, robot)
  local surface = entity.surface
  local force = entity.force

  -- make waterway not collide with boats by replacing it with entity that does not have "ground-tile" in its collision mask
  if (entity.name == "straight-water-way" or entity.name == "curved-water-way" or
      entity.name == "straight-water-way-placed" or entity.name == "curved-water-way-placed") then
    -- Check if this waterway is connected to a non-waterway
    local bad_connection = false
    local bad_name = ""
    if settings.global["prevent_waterway_rail_connections"].value then
      for _, rail in pairs(get_connected_rails(entity)) do
        if not (string.find(rail.name, "%-water%-way") or rail.name == "bridge_crossing") then
          bad_connection = true
          bad_name = rail.name
          break
        end
      end
    end

    local do_swap = (entity.name == "straight-water-way" or entity.name == "curved-water-way")
    local give_refund = false

    local pos = entity.position
    local name = (do_swap and (entity.name .. "-placed")) or entity.name
    local dir = entity.direction
    local refund = entity.prototype.items_to_place_this[1]

    local prev
    if do_swap then
      entity.destroy() --destroy old
      --check for already placed entities after deleting the old one
      prev = surface.find_entities_filtered{position = pos, name = name}
    end

    if bad_connection then
      -- Refund ww if connected to rails
      give_refund = true
      if player then
        player.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..name.."__", "__ENTITY__"..bad_name.."__"}
      else
        game.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..name.."__", "__ENTITY__"..bad_name.."__"}
      end

    elseif prev then
      -- Refund ww if we tried to swap and for some reason a placed entity already exists
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
      elseif robot then
        robot.get_inventory(defines.inventory.robot_cargo).insert(refund)
      end
    elseif do_swap then
      -- create new placed waterway
      local WW = surface.create_entity{name = name, position = pos, direction = dir, force = force}
      -- make waterway indestructible
      if WW then
        WW.destructible = false
      end
    else
      -- make newly placed water-way-placed indestructible
      entity.destructible = false
    end

  -- Handle non-waterway rail entities
  elseif settings.global["prevent_waterway_rail_connections"].value then
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
        if robot then
          robot.get_inventory(defines.inventory.robot_cargo).insert(refund)
        end
        game.print{"cargo-ship-message.error-connect-rails", "__ENTITY__"..entity.name.."__", "__ENTITY__"..bad_name.."__"}
      end
      entity.destroy()
    end
  end
end
