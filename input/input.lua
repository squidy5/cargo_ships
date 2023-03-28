data:extend{
  {
    type = "custom-input",
    name = "enter_ship",
    key_sequence = "SHIFT + RETURN",
    consuming = "none"
    -- 'consuming'
    -- available options:
    -- none: default if not defined
    -- game-only: The opposite of script-only: blocks game inputs using the same key sequence but lets other custom inputs using the same key sequence fire.
  },
  {
    type = "custom-input",
    name = "give-water-way",
    localised_name = {"item-name.water-way"},
    key_sequence = "",
    consuming = "none",
  },
  {
    type = "shortcut",
    name = "give-water-way",
    localised_name = {"item-name.water-way"},
    order = "",
    action = "lua",
    associated_control_input = "give-water-way",
    technology_to_unlock = "automated_water_transport",
    --style = "blue",
    icon =
    {
      filename = GRAPHICSPATH .. "icons/water_rail.png",
      priority = "extra-high-no-scale",
      size = 64,
      scale = 0.5,
      mipmap_count = 1,
      flags = {"gui-icon"}
    },
  }
}
