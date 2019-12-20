function onOilrickGuiOpened(e)
	if e.entity ~= nil and e.entity.name == "oil_rig" then
		local gui = game.players[e.player_index].gui
		if not gui.top.oilStorageFrame then 
			local frame = gui.top.add{type="frame", name="oilStorageFrame", caption="Oil rig storage", direction="vertical"}
			--frame.add{type="line", name="line1"}
			local progressbar = frame.add{type="progressbar", name="oily_progress"}
			frame.add{type="label", name="oily_caption", caption="0k of 100k"}
		end
		global.gui_oilrigs[e.player_index] = e.entity
	end
end

function onOilrickGuiClosed(e)
	if e.entity ~= nil and e.entity.name == "oil_rig" then
		if not game.players[e.player_index].gui.top.oilStorageFrame then return end
		game.players[e.player_index].gui.top.oilStorageFrame.destroy()	
		global.gui_oilrigs[e.player_index] = nil
	end
end

function UpdateOilRigGui(e)
	if e.tick%5 ~= 0 then return end

	if global.gui_oilrigs == nil then
		global.gui_oilrigs = {}
	end
	local oil_rig_capacity = settings.startup["oil_rig_capacity"].value;


	for i, oilrig in ipairs(global.gui_oilrigs) do
		if oilrig ~= nil then
			local ourframe = game.players[i].gui.top.oilStorageFrame
			if not ourframe then return end

			local amount = oilrig.fluidbox[1] and oilrig.fluidbox[1]["amount"] or 0
			--game.players[1].print("we have so much oil: " .. amount)
			ourframe.oily_progress.value = amount/(oil_rig_capacity*1000)
			ourframe.oily_caption.caption = math.floor(amount/1000) .. "k of ".. oil_rig_capacity .."k"

		end
	end
end