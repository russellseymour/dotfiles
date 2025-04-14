-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()
local keys = {}
local mouse_bindings= {}
local launch_menu = {}

-- This is where you actually apply your config choices

-- Set the shell to lanuch
config.default_prog = {"pwsh"}

-- Set the colour scheme
config.color_scheme = "Monokai Remastered"

-- Set the font and size
config.font = wezterm.font("MesloLGM Nerd Font")
config.font_size = 10
config.launch_menu = launch_menu

-- Make the cursor a blinking rectangle
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true

-- this adds the ability to use ctrl+v to paste the system clipboard 
config.keys = {
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    {
        key = 't',
        mods = 'SHIFT|ALT',
        action = act.SpawnTab 'CurrentPaneDomain',
      },
}

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
    {
      event = { Down = { streak = 3, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
   {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
     local has_selection = window:get_selection_text_for_pane(pane) ~= ""
     if has_selection then
      window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
      window:perform_action(act.ClearSelection, pane)
     else
      window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
     end
    end),
   },
  }

  config.mouse_bindings = mouse_bindings

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.2,
    brightness = 1.5,
  }

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

-- config.window_decorations = "TITLE | RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
-- config.win32_system_backdrop = "Acrylic"

-- and finally, return the configuration to wezterm
return config
