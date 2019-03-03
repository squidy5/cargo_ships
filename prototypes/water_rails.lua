
railpictures = function(invisible)
  return railpicturesinternal({{"metals", "metals", mipmap = true},
                               {"backplates", "backplates", mipmap = true},
                               {"ties", "ties"},
                               {"stone_path", "stone-path"},
                               {"segment_visualisation_middle", "segment-visualisation-middle"},
                               {"segment_visualisation_ending_front", "segment-visualisation-ending-1"},
                               {"segment_visualisation_ending_back", "segment-visualisation-ending-2"},
                               {"segment_visualisation_continuing_front", "segment-visualisation-continuing-1"},
                               {"segment_visualisation_continuing_back", "segment-visualisation-continuing-2"}},
                               invisible)
end    

railpicturesinternal = function(elems, invisible)
  local railBlockKeys = {segment_visualisation_middle = true, 
                      segment_visualisation_ending_front = true,
                      segment_visualisation_ending_back = true, 
                      segment_visualisation_continuing_front = true, 
                      segment_visualisation_continuing_back = true}

  local keys = {{"straight_rail", "horizontal", 64, 64, 0, 0},
                {"straight_rail", "vertical", 64, 64, 0, 0},
                {"straight_rail", "diagonal-left-top", 64, 64, 0, 0},
                {"straight_rail", "diagonal-right-top", 64, 64, 0, 0},
                {"straight_rail", "diagonal-right-bottom", 64, 64, 0, 0},
                {"straight_rail", "diagonal-left-bottom", 64, 64, 0, 0},
                {"curved_rail", "vertical-left-top", 128, 256, 0, 0},
                {"curved_rail", "vertical-right-top", 128, 256, 0, 0},
                {"curved_rail", "vertical-right-bottom", 128, 256, 0, 0},
                {"curved_rail", "vertical-left-bottom", 128, 256, 0, 0},
                {"curved_rail" ,"horizontal-left-top", 256, 128, 0, 0},
                {"curved_rail" ,"horizontal-right-top", 256, 128, 0, 0},
                {"curved_rail" ,"horizontal-right-bottom", 256, 128, 0, 0},
                {"curved_rail" ,"horizontal-left-bottom", 256, 128, 0, 0}}
  local res = {}
  for _ , key in ipairs(keys) do
    part = {}
    dashkey = key[1]:gsub("_", "-")
    for _ , elem in ipairs(elems) do
      if(elem[1] == "metals" and not invisible) then
        part[elem[1]] = { 
          sheet = {
              filename = string.format("__cargo-ships__/graphics/entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
              priority = "extra-high", 
              flags = elem.mipmap and { "icon" },
              width = key[3],
              height = key[4],
              shift = {key[5], key[6]},
              variation_count = 1,
          }
        }
      elseif(railBlockKeys[elem[1]] ~= nil) then
        part[elem[1]] = {
          filename = string.format("__cargo-ships__/graphics/entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
          priority = "extra-high", 
          flags = elem.mipmap and { "icon" },
          width = key[3],
          height = key[4],
          shift = {key[5], key[6]},
          variation_count = 1,
        }
      else
        part[elem[1]] = { 
          sheet = {
            filename = string.format("__cargo-ships__/graphics/blank.png", dashkey, dashkey, key[2], elem[2]),
            priority = "extra-high", 
            flags = elem.mipmap and { "icon" },
            width = 2,
            height = 2,
            shift = {0,0},
            variation_count = 1,
          }
        }
      end
    end

    dashkey2 = key[2]:gsub("-", "_")
    res[key[1] .. "_" .. dashkey2] = part
  end
  res["rail_endings"] = {
   sheets =
   {
     {
       filename = "__cargo-ships__/graphics/blank.png",
       priority = "high",
       width = 4,
       height = 4,
     },
     {
       filename = "__cargo-ships__/graphics/blank.png",
       priority = "high",
       flags = { "icon" },
       width = 4,
       height = 4,
     }

    }
  }
  return res 
end


data:extend({
  {
    type = "straight-rail",
    name = "straight-water-way",
    icon = "__cargo-ships__/graphics/blank.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    destructible=false,
    minable = {mining_time = 0.2, result = "water-way"},
    max_health = 100,
    corpse = nil,
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
    collision_box = {{-1.01, -0.95}, {1.01, 0.95}},
    selection_box = {{-1.7, -0.8}, {1.7, 0.8}},
    collision_mask = {'ground-tile'},
    rail_category = "regular",
    pictures = railpictures(),
  },
  {
    type = "curved-rail",
    name = "curved-water-way",
    icon = "__cargo-ships__/graphics/blank.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    destructible=false,
    minable = {mining_time = 0.2, result = "water-way", count = 4},
    max_health = 200,
    corpse = nil,
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
    collision_box = {{-1, -2}, {1, 3.1}},
    secondary_collision_box = {{-0.65, -2.1}, {0.65, 2.1}},
    selection_box = {{-1.7, -0.8}, {1.7, 0.8}},
    collision_mask = {'ground-tile'},
    rail_category = "regular",
    pictures = railpictures(),
    placeable_by = { item="water-way", count = 4}
  },
})

local swwp = table.deepcopy(data.raw["straight-rail"]["straight-water-way"])
swwp.name = "straight-water-way-placed"
swwp.flags =  {"not-blueprintable", "placeable-neutral", "player-creation", "building-direction-8-way"}
swwp.collision_mask = {"object-layer"}
swwp. minable = {mining_time = 0.2, result = "water-way", count = 1}

local cwwp = table.deepcopy(data.raw["curved-rail"]["curved-water-way"])
cwwp.name = "curved-water-way-placed"
cwwp.flags =  {"not-blueprintable", "placeable-neutral", "player-creation", "building-direction-8-way"}
cwwp.collision_mask = {"object-layer"}
cwwp.minable = {mining_time = 0.2, result = "water-way", count = 4}

data:extend({swwp, cwwp})





-- tracks used by bridges

local invisible_rail=table.deepcopy(data.raw["straight-rail"]["straight-rail"])
invisible_rail.name = "invisible_rail"
invisible_rail.flags =  {"not-blueprintable", "placeable-neutral", "player-creation", "building-direction-8-way"}
invisible_rail.pictures = railpictures(true)
invisible_rail.minable = nil
invisible_rail.selection_box = nil
invisible_rail.selectable_in_game = false
invisible_rail.collision_mask ={}
invisible_rail.allow_copy_paste = false

local bridge_crossing=table.deepcopy(data.raw["straight-rail"]["straight-water-way-placed"])
bridge_crossing.name = "bridge_crossing"
bridge_crossing.flags =  {"not-blueprintable", "placeable-neutral", "player-creation", "building-direction-8-way"}
bridge_crossing.minable = nil
bridge_crossing.selection_box = nil
bridge_crossing.selectable_in_game = false
bridge_crossing.allow_copy_paste = false

data:extend({invisible_rail, bridge_crossing})