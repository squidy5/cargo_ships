
local spor = {}
spor[0] = {{x=-4,y=-1.5},{x=-4,y=1.5},{x=6,y=-1.5},{x=6,y=1.5}}
spor[4] = {{x=4,y=1.5},{x=4,y=-1.5},{x=-6,y=1.5},{x=-6,y=-1.5}}
spor[2] = {{x=1.5,y=-4.5},{x=-1.5,y=-4.5},{x=1.5,y=6},{x=-1.5,y=6}}
spor[6] = {{x=-1.5,y=4},{x=1.5,y=4},{x=-1.5,y=-6},{x=1.5,y=-6}}

local spow = {}
spow[0] = {{x=-0.5,y=-2.5},{x=-3.5,y=2.5},{x=-3.5,y=-2.5},{x=-0.5,y=2.5}}
spow[4] = {{x=0.5,y=2.5},{x=3.5,y=-2.5},{x=3.5,y=2.5},{x=0.5,y=-2.5}}
spow[2] = {{x=-2.5,y=-1},{x=2.5,y=-3.5},{x=-2.5,y=-3.5},{x=2.5,y=-1}}
spow[6] = {{x=2.5,y=0.5},{x=-2.5,y=3.5},{x=2.5,y=3.5},{x=-2.5,y=0.5}}

function CreateBridge(ent, player_index)
  local pos = ent.position
  local dir = ent.direction
  local f = ent.force
  local bridge
  local closed_bridge
  local ver, hor, x, y
  local surface = ent.surface
  ent.destroy()

  if dir == defines.direction.north then
    if checkBridgePlacement(pos, -4.5, -3, 6.5, 3, player_index, surface) then
      bridge = surface.create_entity {name="bridge_north", position = pos, force = f, create_build_effect_smoke = false}
      closed_bridge = surface.create_entity {name="bridge_north_closed", position = pos, force = f, create_build_effect_smoke = false}
      surface.create_entity {name="bridge_north_clickable", position = pos, force = f, create_build_effect_smoke = false}
      ver = 1
      hor = 0
    end
  elseif dir == defines.direction.east then
    if checkBridgePlacement(pos, -3, -4.5, 3, 6.5, player_index, surface) then
      bridge = surface.create_entity {name="bridge_east", position = pos, force = f, create_build_effect_smoke = false}
      closed_bridge = surface.create_entity {name="bridge_east_closed", position = pos, force = f, create_build_effect_smoke = false}
      surface.create_entity {name="bridge_east_clickable", position = pos, force = f, create_build_effect_smoke = false}
      ver = 0
      hor = 1
    end
  elseif dir == defines.direction.south then
    if checkBridgePlacement(pos, -6.5, -3, 4.5, 3, player_index, surface) then
      bridge = surface.create_entity {name="bridge_south", position = pos, force = f, create_build_effect_smoke = false}
      closed_bridge = surface.create_entity {name="bridge_south_closed", position = pos, force = f, create_build_effect_smoke = false}
      surface.create_entity {name="bridge_south_clickable", position = pos, force = f, create_build_effect_smoke = false}
      ver = -1
      hor = 0
    end
  elseif dir == defines.direction.west then
    if checkBridgePlacement(pos, -3, -6.5, 3, 4.5, player_index, surface) then
      bridge = surface.create_entity {name="bridge_west", position = pos, force = f, create_build_effect_smoke = false}
      closed_bridge = surface.create_entity {name="bridge_west_closed", position = pos, force = f, create_build_effect_smoke = false}
      surface.create_entity {name="bridge_west_clickable", position = pos, force = f, create_build_effect_smoke = false}
      ver = 0
      hor = -1
    end
  end

  if(bridge and closed_bridge) then
    bridge.destructible = false
    closed_bridge.destructible = false
    local s1,s2,s3,s4, s5, s6
    s1, s2, s3, s4, s5, s6 = createSlaves(surface, pos, dir, hor, ver, f)
    table.insert(global.bridges, {bridge, closed_bridge, nil, s1, s2, s3, s4, s5, s6, 0})
  end
end

function checkBridgePlacement(pos, x1, y1, x2, y2, player_index, surface)
  local valid = true
  local entities = surface.find_entities{{pos.x+x1, pos.y+y1}, {pos.x+x2, pos.y+y2}} --{{pos.x-5, pos.y-3},{pos.x+7, pos.y+3}})--
  local counter = 0
  for _, ent in pairs(entities) do
    if (not (ent.name == "fish" or ent.name == "bridge_base")) then
      counter = counter+1
      if (ent.name ~= "straight-water-way" or counter > 3) then
        valid = false
        break
      end
    end
  end
  if not valid then
    if player_index then
      game.players[player_index].print{"cargo-ship-message.error-ship-no-space", "__ENTITY__bridge_base__"}
      game.players[player_index].insert{name="bridge_base", count=1}
    end
  else
    for _, ent in pairs(entities) do
      if (not (ent.name == "fish" or ent.name == "bridge_base")) then
        ent.destroy()
      end
    end
  end
  return valid
end

function createSlaves(surface, pos, dir, hor, ver, f)
  local tmp, p, x, y, s1, s2, s3, s4, s5, s6, shift_x, shift_y
  shift_y = 0
  shift_x = 0
  -- spawn waterway part of bridge, including signals
  for s=-2, 2, 2 do
    x=s*hor - 2*ver
    y=s*ver - 2*hor
    p = {pos.x+x, pos.y+y}
    addEntity(surface, p, dir, "bridge_crossing", f)
  end
  -- spawn rail part of bridge, including signals
  for l=-4,6,2 do
    x = l*ver
    y = l*hor
    p = {pos.x+x, pos.y+y}
    addEntity(surface, p, (dir+2)%4, "invisible_rail", f)
  end

  p = calcPos(pos, spow[dir][1])
  s1 = addEntity(surface, p, (dir+4)%8, "invisible_chain_signal", f)
  p = calcPos(pos, spow[dir][2])
  s2 = addEntity(surface, p, dir, "invisible_chain_signal", f)
  p = calcPos(pos, spow[dir][3])
  s5 = addEntity(surface, p, dir, "invisible_chain_signal", f)
  p = calcPos(pos, spow[dir][4])
  s6 = addEntity(surface, p, (dir+4)%8, "invisible_chain_signal", f)

  p = calcPos(pos, spor[dir][1])
  s3 = addEntity(surface, p, (dir+2)%8, "invisible_chain_signal", f)
  p = calcPos(pos, spor[dir][2])
  addEntity(surface, p, (dir-2)%8, "invisible_chain_signal", f)
  p = calcPos(pos, spor[dir][3])
  addEntity(surface, p, (dir+2)%8, "invisible_chain_signal", f)
  p = calcPos(pos, spor[dir][4])
  s4 = addEntity(surface, p, (dir-2)%8, "invisible_chain_signal", f)

--[[
  game.players[1].print(dir .. " s1: { x=" .. pos.x - s1.position.x .. ", " .. pos.y - s1.position.y .. "}")
  game.players[1].print(dir .. " s2: { x=" .. pos.x - s2.position.x .. ", " ..pos.y - s2.position.y .. "}")
  game.players[1].print(dir .. " s5: { x=" .. pos.x - s5.position.x .. ", " .. pos.y - s5.position.y .. "}")
  game.players[1].print(dir .. " s6: { x=" .. pos.x - s6.position.x .. ", " .. pos.y - s6.position.y .. "}")
--]]
  return s1,s2,s3,s4,s5,s6
end

function calcPos(pos1, pos2)
  return {pos1.x+pos2.x, pos1.y+pos2.y}
end

function addEntity(surface, pos, dir, n, f)
  local tokill = surface.find_entities_filtered{position = pos, name ={"straight-water-way","curved-water-way", "straight-rail", "curved-rail"}}
  for _, k in pairs(tokill) do
    k.destroy()
  end

  local slave = surface.create_entity{name=n , position = pos, direction = dir, force = f, create_build_effect_smoke = false}
  if slave then
    --slave.destructible = false
    slave.minable = false
  end
  return slave
end


function DeleteBridge(ent, player_index)
  local pos = ent.position
  local name = ent.name
  local surface = ent.surface

  -- check for any trains/ships using the bridge
  local entities = surface.find_entities({{pos.x-1.5, pos.y-1.5}, {pos.x+1.5, pos.y+1.5}})
  local empty = true
  for _, e in pairs(entities) do
    if e.name == "invisible_rail" or e.name == "bridge_crossing" then
      if e.trains_in_block > 0 then
        empty = false
        break
      end
    end
  end

  if not empty then
    if player_index~= nil then
      game.players[player_index].print{"cargo-ship-message.error-bridge-busy"}
    end
    ent.surface.create_entity{name=name, position=pos, direction = ent.direction, force = ent.force, create_build_effect_smoke = false}
    return false
  else
    if string.find(name, "bridge_north") then
      deleteSlaves(surface, pos, -5,-3,7,3, "north")
    elseif string.find(name, "bridge_east") then
      deleteSlaves(surface, pos, -3,-5,3,7, "east")
    elseif string.find(name, "bridge_south") then
      deleteSlaves(surface, pos, -7,-3,5,3, "south")
    elseif string.find(name, "bridge_west") then
      deleteSlaves(surface, pos, -3,-7,3,5, "west")
    end
    return true
  end
end

function deleteSlaves(surface, pos, x1, y1, x2, y2, dirname)
  local entities =surface.find_entities{{pos.x+x1, pos.y+y1},{pos.x+x2, pos.y+y2}}
  for _, ent in pairs(entities) do
    local n = ent.name
    if (n == "invisible_chain_signal" or
        n == "invisible_signal" or
        n == "invisible_rail" or
        n == "bridge_" .. dirname or
        n == "bridge_" .. dirname .. "_closed" or
        n == "bridge_" .. dirname .. "_open" ) then
      ent.destroy()
    elseif n == "bridge_crossing" then
      local p = ent.position
      local d = ent.direction
      local f = ent.force
      ent.destroy()
      surface.create_entity{name = "straight-water-way", direction = d, position = p, force = f, create_build_effect_smoke = false}
    end
  end
end

local animation_time = 7

function ManageBridges(e)
  if e.tick % 6 == 0 then
    for i=#global.bridges, 1, -1 do
      local entry = global.bridges[i]
      if not entry[1].valid then
        table.remove(global.bridges, i)
      else
        ----------------------------------------------
        -------------process slow change
        ----------------------------------------------
        if entry[10] > 0 then
          entry[10] = entry[10]-1
          if entry[1].power_switch_state == false and entry[10]==0 then--closing?
            entry[2] = entry[1].surface.create_entity{name=entry[1].name .. "_closed", position = entry[1].position, force = entry[1].force, create_build_effect_smoke = false}
            entry[2].destructible = false
            entry[2].minable = false
          elseif entry[1].power_switch_state == false and entry[10] == animation_time -1 then
            game.play_sound{path = "cs_bridge", position = entry[1].position}
          elseif entry[1].power_switch_state == true and entry[10] == animation_time -1 then
            if entry[2].valid then
              entry[2].destroy()
              game.play_sound{path = "cs_bridge", position = entry[1].position}
            end
          end

        ----------------------------------------------
        -------------check signal reservations
        ----------------------------------------------
        else
          --check if valid first, got some errors on "entry[4].signal_state"
          local valid = true
          for i = 4, 9 do
            valid = valid and entry[i].valid
          end
          -- delete broken bridge...
          if not valid then
            DeleteBridge(entry[1])
          end

          if valid and entry[1].power_switch_state == false then -- bridge closed ?
            --game.players[1].print("bridge " .. i .. " is closed")
            if (entry[4].signal_state == defines.signal_state.reserved or
                entry[5].signal_state == defines.signal_state.reserved) then -- reserved by ship?
              -- open bridge --
              entry[1].power_switch_state = true
              entry[10] = animation_time - entry[10]
              --entry[3] =surface.create_entity{name=entry[1].name .. "_open", position = entry[1].position, force = entry[1].force}
              --entry[3].destructible = false
            end
          else -- bridge open?
            if valid and (
                ((entry[8].signal_state == defines.signal_state.open or entry[9].signal_state == defines.signal_state.open) and
                  entry[4].signal_state ~= defines.signal_state.reserved and entry[5].signal_state ~= defines.signal_state.reserved) or
                  entry[6].signal_state == defines.signal_state.reserved or
                  entry[7].signal_state == defines.signal_state.reserved
              ) then -- no ships or reserved by train?
              -- close bridge --
              entry[1].power_switch_state = false
              entry[10] = animation_time - entry[10]
              --[[if entry[3].valid then
                entry[3].destroy()
              end
              --]]
            end
          end
        end
      end
    end
  end
end
