


local tile_test_item = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
tile_test_item.name = "tile_test_item"
tile_test_item.collision_mask = {"object-layer", "train-layer", "player-layer"}
tile_test_item.collsion_box = {{-4,-4.2},{4,4.2}}
tile_test_item.selection_box = {{-4,-4.2},{4,4.2}}


local tile_player_test_item = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])
tile_player_test_item.name = "tile_player_test_item"
tile_player_test_item.collision_mask = {"water-tile", "train-layer", "player-layer"}
tile_player_test_item.collsion_box = {{-1,-1.2},{1,1.2}}


data:extend({
        {
        type = "item", 
        name = "tile_test_item", 
        icon = "__cargo-ships__/graphics/blank.png", 
        icon_size = 1,
        flags = {"hidden"}, 
        place_result = "tile_test_item", 
        stack_size = 1, 
        },
        {
        type = "item", 
        name = "tile_player_test_item", 
        icon = "__cargo-ships__/graphics/blank.png", 
        icon_size = 1,
        flags = {"hidden"}, 
        place_result = "tile_player_test_item", 
        stack_size = 1, 
        }  
})

data:extend({tile_test_item, tile_player_test_item})




