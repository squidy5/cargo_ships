--GRAPHICSPATH = "__cargo-ships__/graphics/"
GRAPHICSPATH = "__cargo-ships-graphics__/graphics/"
emptypic = { filename = GRAPHICSPATH .. "blank.png", size = 1, direction_count = 1, variation_count = 1 }

local collision_mask_util = require("collision-mask-util")

waterway_layer = collision_mask_util.get_first_unused_layer ()
