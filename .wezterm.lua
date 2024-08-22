local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"NotoSans Nerd Font",
	{ family = "Symbols Nerd Font Mono", scale = 0.75 },
})
config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 12

config.scrollback_lines = 5000

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.keys = {
	{
		key = "H",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = ".",
		mods = "CMD",
		action = act.EmitEvent("trigger-password-input"),
	},
}

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local project_dir = "$HOME/git"
	local _, editor_pane, window = mux.spawn_window({
		workspace = "code",
		cwd = project_dir,
		args = args,
	})

	window:gui_window():maximize()

	editor_pane:activate()

	mux.set_active_workspace = "code"
end)

wezterm.on("trigger-password-input", function(_, pane)
	local _, stdout, _ = wezterm.run_child_process({
		"security",
		"find-generic-password",
		"-w",
		"-a",
		"account-name",
		"-s",
		"item-name",
	})
	pane:send_text(stdout)
end)

return config
