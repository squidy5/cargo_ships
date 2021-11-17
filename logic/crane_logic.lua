

function OnCraneCreated(entity)
  local sur = entity.surface
  local dir = entity.direction
  local pos = entity.position
  local f = entity.force
  local inserter
  local switch
  local reverse = false

  game.players[1].print("placing crane in direction: " .. entity.direction)
--  if(dir == defines.direction.west) then
--    switch = entity.surface.create_entity{name="crane_hor", position=pos,force=f}
--  end

  local startSprite
  if(entity.direction == defines.direction.west) then
    startSprite = rendering.draw_sprite{
      sprite = "crane_west",
      target = entity,
      surface = entity.surface}
  elseif(entity.direction == defines.direction.east) then
    startSprite = rendering.draw_sprite{
      sprite = "crane_east",
      target = entity,
      surface = entity.surface}
  end

  inserter = entity
  table.insert(global.cranes, {inserter})
end

function ManageCranes(e)

  --if e.tick % 2 == 0 then
  --game.players[1].print("we manage: " .. #global.cranes .. " cranes")


  for i=#global.cranes, 1, -1 do
    local crane = global.cranes[i]
    -- remove unvalid
    if not crane[1].valid then
      table.remove(global.cranes, i)
    else

      local inserter = crane[1]
      local framecount = crane[2] -- framecount == -1 --> inactive
      -- TODO check if inserter active
      --(if active and at pickup, and empty, and pickup empty --> not active) --> replace animation with sprite
      --(if ~active and ~at pickup --> active) --> replace sprite with animation


      if (not inserter.held_stack == nil) and
        not AtPosition(ent.held_stack_position, ent.pickup_position, 0.1) then
        --moving towards drop off

        --switch.power_switch_state = reversed and true or false
      elseif (inserter.held_stack == nil) then

        -- moving towards pickup
        --switch.power_switch_state = reversed and false or true
      end
    end
  end
  --end
end

function AtPosition(pos1, pos2, thresh)
  --d = math.abs(pos1.x-pos2.x) + math.abs(pos1.y-pos2.y)
  --game.players[1].print("cheging: " .. d)

  if math.abs(pos1.x-pos2.x) + math.abs(pos1.y-pos2.y) <= thresh then
    return true
  else
    return false
  end
end


