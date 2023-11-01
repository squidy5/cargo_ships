-- Handle GUI generation for Oil Rig storage status

-- What we actually need is a relative GUI permanently created for each player
-- It stays attached to "oil_rig" guis and only appears when that player opens an oil rig
-- Then we just have to detect when it's opened and update it while it stays opened
-- No need to delete it.
-- Only time to delete GUI frame is if we detect that oil rig has been removed from the game
-- Only time to add a GUI frame is if a player is added, and when the mod is created/updated, or when oil rig is added to the game
-- When we open, we do need to store which oilrig was opened

-- Also need a migration to delete gui.top.oilStorageFrame

local OILRIG_FRAME = "oilStorageFrame"

-- Update the display in this GUI
local function updateProgress(frame, oilrig)
  local amount = (oilrig.fluidbox[1] and oilrig.fluidbox[1]["amount"]) or 0
  frame.oily_progress.value = amount / (global.oil_rig_capacity*1000)
  if amount >= 10000 then
    amount = string.format("%.0f", amount/1000)
  else
    amount = string.format("%.1f", amount/1000)
  end
  frame.oily_caption.caption = {"cargo-ship-gui.oil-rig-progress", amount, global.oil_rig_capacity}
end

-- Creates a relative GUI that automatically appears when oil_rig entity GUI is opened.
-- Performance is improved by not creating and destroying GUI elements every time
function createGuiForPlayer(player)
  local gui = player.gui
  if not gui.relative[OILRIG_FRAME] then
    local frame = gui.relative.add{
          type="frame", 
          name=OILRIG_FRAME, 
          caption={"cargo-ship-gui.oil-rig-storage"}, 
          direction="vertical",
          anchor={gui=defines.relative_gui_type.mining_drill_gui,
                  position=defines.relative_gui_position.left,
                  name="oil_rig"}}
    frame.add{type="progressbar", name="oily_progress"}
    frame.add{type="label", name="oily_caption", caption={"cargo-ship-gui.oil-rig-progress",0,100}}
  end
end

-- create GUI for this new player
function onPlayerCreated(e)
  local player = game.players[e.player_index]
  if player and player.valid then
    createGuiForPlayer(player)
  end
end

-- create GUIS for all players if not already there, or delete them if not needed
function createGuiAllPlayers()
  for _, player in pairs(game.players) do
    if global.deep_oil_enabled then
      createGuiForPlayer(player)
    elseif player.gui.relative[OILRIG_FRAME] then
      player.gui.relative[OILRIG_FRAME].destroy()
    end
    -- this is a migration from the old floating gui:
    if player.gui.top[OILRIG_FRAME] then
      player.gui.top[OILRIG_FRAME].destroy()
    end
  end
end

-- Adds this player and oilrig to the global update list
function onOilrigGuiOpened(e)
  -- GUI opens automatically if it's an oil rig
  -- Just need to update it
  if e.entity and e.entity.name == "oil_rig" then
    local player = game.players[e.player_index]
    if game.entity_prototypes["oil_rig"].fluid_capacity > 0 then
      updateProgress(player.gui.relative[OILRIG_FRAME], e.entity)
    else
      player.gui.relative[OILRIG_FRAME].visible = false
    end
    global.gui_oilrigs[e.player_index] = e.entity
  end
end

-- Removes this player and oilrig from the update list
function onOilrigGuiClosed(e)
  if e.entity and e.entity.name == "oil_rig" then
    global.gui_oilrigs[e.player_index] = nil
  end
end

-- Updates the display on any open oilrigs
function UpdateOilRigGui(e)
  if e.tick % 5 == 0 then
    for i, oilrig in pairs(global.gui_oilrigs) do
      if not oilrig.valid then
        global.gui_oilrigs[i] = nil
      elseif game.entity_prototypes["oil_rig"].fluid_capacity > 0 then
        updateProgress(game.players[i].gui.relative[OILRIG_FRAME], oilrig)
      end
    end
  end
end
