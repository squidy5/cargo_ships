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
    name = "give-waterway",
    localised_name = {"item-name.waterway"},
    key_sequence = "ALT + W",
    consuming = "none",
  },
  {
    type = "shortcut",
    name = "give-waterway",
    localised_name = {"item-name.waterway"},
    order = "",
    action = "lua",
    associated_control_input = "give-waterway",
    technology_to_unlock = "automated_water_transport",
    --style = "blue",
    icon =
    {
      filename = GRAPHICSPATH .. "icons/waterway-shortcut.png",
      priority = "extra-high-no-scale",
      size = 32,
      scale = 0.5,
      mipmap_count = 1,
      flags = {"gui-icon"}
    },
    disabled_icon =
    {
      filename = GRAPHICSPATH .. "icons/waterway-shortcut-white.png",
      priority = "extra-high-no-scale",
      size = 32,
      scale = 0.5,
      mipmap_count = 1,
      flags = {"gui-icon"}
    }
  }
}
