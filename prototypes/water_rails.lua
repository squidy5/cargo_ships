local invincible =
   {
     {
       type = "physical",
       percent = 100
     },
     {
       type = "explosion",
       percent = 100
     },
     {
       type = "acid",
       percent = 100
     },
     {
       type = "fire",
       percent = 100
     }
   }

railpictures = function(invisible)
  return railpicturesinternal({
    {"metals",                                  "metals"},
    {"backplates",                              "backplates"},
    {"ties",                                    "ties"},
    {"stone_path",                              "stone-path"},
    {"segment_visualisation_middle",            "segment-visualisation-middle"},
    {"segment_visualisation_ending_front",      "segment-visualisation-ending-1"},
    {"segment_visualisation_ending_back",       "segment-visualisation-ending-2"},
    {"segment_visualisation_continuing_front",  "segment-visualisation-continuing-1"},
    {"segment_visualisation_continuing_back",   "segment-visualisation-continuing-2"}
  },
  invisible)
end

railpicturesinternal = function(elems, invisible)
  local railBlockKeys = {
    segment_visualisation_middle = true,
    segment_visualisation_ending_front = true,
    segment_visualisation_ending_back = true,
    segment_visualisation_continuing_front = true,
    segment_visualisation_continuing_back = true
  }

  local keys = {
    {"straight_rail", "horizontal",             128, 128},
    {"straight_rail", "vertical",               128, 128},

    {"straight_rail", "diagonal-left-top",      128, 128},
    {"straight_rail", "diagonal-right-top",     128, 128},
    {"straight_rail", "diagonal-right-bottom",  128, 128},
    {"straight_rail", "diagonal-left-bottom",   128, 128},

    {"curved_rail",   "vertical-left-top",      256, 512},
    {"curved_rail",   "vertical-right-top",     256, 512},
    {"curved_rail",   "vertical-right-bottom",  256, 512},
    {"curved_rail",   "vertical-left-bottom",   256, 512},

    {"curved_rail",   "horizontal-left-top",    512, 256},
    {"curved_rail",   "horizontal-right-top",   512, 256},
    {"curved_rail",   "horizontal-right-bottom",512, 256},
    {"curved_rail",   "horizontal-left-bottom", 512, 256}
  }
  local res = {}

  --postfix = ""
  local tint = {1, 1, 1, 1}
  local blend_mode = "additive"
  if settings.startup["use_dark_blue_waterways"].value then
    --tint = {1, 1, 1, 1}
    blend_mode = "normal"
    --tint = {1, 1, 1, 0.5}
    --postfix = "-dark"
  end

  for _ , key in ipairs(keys) do
    local part = {}
    local dashkey = key[1]:gsub("_", "-")
    for _ , elem in ipairs(elems) do
      if(elem[1] == "metals" and not invisible) then
        part[elem[1]] = {
          layers = {
            --[[{
              filename = string.format(GRAPHICSPATH .. "entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
              priority = "low",
              width = key[3],
              height = key[4],
              variation_count = 1,
              --tint = {0, 0, 0, 0.2},
              shift = util.by_pixel(1,1),
              scale = 0.5,
              draw_as_shadow = true,
            },]]
            {
              filename = string.format(GRAPHICSPATH .. "entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
              priority = "extra-high",
              width = key[3],
              height = key[4],
              variation_count = 1,
              tint = tint,
              blend_mode = blend_mode,
              scale = 0.5,
            },
          }
        }
      elseif(railBlockKeys[elem[1]] ~= nil) then
        part[elem[1]] = {
          filename = string.format(GRAPHICSPATH .. "entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
          priority = "extra-high",
          width = key[3],
          height = key[4],
          variation_count = 1,
          scale = 0.5,
        }
      else
        part[elem[1]] = emptypic
      end
    end

    dashkey2 = key[2]:gsub("-", "_")
    res[key[1] .. "_" .. dashkey2] = part
  end
  res["rail_endings"] = {
    sheets = {
      emptypic,
      emptypic
    }
  }
  return res
end

local mapcolor = {0.56, 0.64, 0.65, 1} --doesn't work yet on rails for some reason
data:extend({
  {
    type = "straight-rail",
    name = "straight-water-way",
    icon = GRAPHICSPATH .. "icons/water_rail.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    resistances = invincible,
    minable = {mining_time = 0.2},
    max_health = 100,
    corpse = nil,
    collision_box = {{-1.01, -0.95}, {1.01, 0.95}},
    selection_box = {{-1.7, -0.8}, {1.7, 0.8}},
    collision_mask = {"object-layer"},  -- waterway_layer added in data-final-fixes
    pictures = railpictures(),
    placeable_by = {item = "waterway", count = 1},
    localised_description = {"item-description.waterway"},
    map_color = mapcolor,
    friendly_map_color = mapcolor,
    enemy_map_color = mapcolor,
  },
  {
    type = "curved-rail",
    name = "curved-water-way",
    icon = GRAPHICSPATH .. "icons/water_rail.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    resistances = invincible,
    minable = {mining_time = 0.2},
    max_health = 200,
    corpse = nil,
    collision_box = {{-1, -2}, {1, 3.1}},
    selection_box = {{-1.7, -0.8}, {1.7, 0.8}},
    collision_mask = {"object-layer"},  -- waterway_layer added in data-final-fixes
    pictures = railpictures(),
    placeable_by = {item = "waterway", count = 1},
    localised_description = {"item-description.waterway"},
    map_color = mapcolor,
    friendly_map_color = mapcolor,
    enemy_map_color = mapcolor,
  },
})


-- tracks used by bridges
local invisible_rail = table.deepcopy(data.raw["straight-rail"]["straight-rail"])
invisible_rail.name = "invisible_rail"
invisible_rail.icon = GRAPHICSPATH .. "icons/water_rail.png"
invisible_rail.icon_size = 64
invisible_rail.flags = {"not-blueprintable", "not-deconstructable", "placeable-neutral", "player-creation", "building-direction-8-way"}
invisible_rail.pictures = railpictures(true)
invisible_rail.minable = nil
invisible_rail.resistances = invincible
invisible_rail.selection_box = nil
invisible_rail.selectable_in_game = false
invisible_rail.collision_mask = {"object-layer"}  -- waterway_layer added in data-final-fixes
invisible_rail.allow_copy_paste = false
invisible_rail.map_color = mapcolor
invisible_rail.friendly_map_color = mapcolor

local bridge_crossing = table.deepcopy(data.raw["straight-rail"]["straight-water-way"])
bridge_crossing.name = "bridge_crossing"
bridge_crossing.icon = GRAPHICSPATH .. "icons/bridge.png"
bridge_crossing.icon_size = 64
bridge_crossing.flags = {"not-blueprintable", "not-deconstructable", "placeable-neutral", "player-creation", "building-direction-8-way"}
bridge_crossing.minable = nil
bridge_crossing.resistances = invincible
bridge_crossing.collision_mask = {"object-layer"}  -- waterway_layer added in data-final-fixes
bridge_crossing.collision_box = {{-0.6, -0.95}, {0.6, 0.95}}
bridge_crossing.selection_box = nil
bridge_crossing.selectable_in_game = false
bridge_crossing.allow_copy_paste = false

data:extend({invisible_rail, bridge_crossing})