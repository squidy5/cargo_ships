require("water_rails")
require("buoys")
require("ships")
require("ship_pump")
if settings.startup["deep_oil"].value then
	require("oil_rig")
end
require("bridge")
require("landfill")
--require("crane")
