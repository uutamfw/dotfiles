local wezterm = require("wezterm")

local process_icons = {
	["zsh"] = wezterm.nerdfonts.dev_terminal,
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["nvim"] = wezterm.nerdfonts.custom_neovim,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["node"] = wezterm.nerdfonts.mdi_nodejs,
	["npm"] = wezterm.nerdfonts.md_npm,
	["python"] = wezterm.nerdfonts.dev_python,
	["python3"] = wezterm.nerdfonts.dev_python,
	["ruby"] = wezterm.nerdfonts.dev_ruby,
	["go"] = wezterm.nerdfonts.seti_go,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["git"] = wezterm.nerdfonts.dev_git,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["docker"] = wezterm.nerdfonts.linux_docker,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["ssh"] = wezterm.nerdfonts.mdi_ssh,
}

local function get_process_icon(process_name)
	return process_icons[process_name] or wezterm.nerdfonts.cod_terminal
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local active_pane = tab.active_pane
	local process_name = active_pane.foreground_process_name:match("([^/]+)$") or "zsh"
	local icon = get_process_icon(process_name)
	local title = process_name

	local edge_background = "#0a0a0f"
	local background = tab.is_active and "#1e2030" or "#141420"
	local foreground = tab.is_active and "#c8d3f5" or "#545c7e"
	local accent = tab.is_active and "#7aa2f7" or "#3b4261"

	local left_sep = wezterm.nerdfonts.ple_lower_right_triangle
	local right_sep = wezterm.nerdfonts.ple_upper_left_triangle

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = background } },
		{ Text = left_sep },
		{ Background = { Color = background } },
		{ Foreground = { Color = accent } },
		{ Text = " " .. icon .. " " },
		{ Foreground = { Color = foreground } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = title .. " " },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = background } },
		{ Text = right_sep },
	}
end)

local style = {
	color_scheme = "London Tube (base16)",
	enable_scroll_bar = true,
	window_background_opacity = 0.7,
	window_base_image_path_hsb = { brightness = 0.8 },
	inactive_pane_hsb = { saturation = 0.8, brightness = 0.4, hue = 1.3 },
	-- background = {
	-- 	{
	-- 		source = { File = base_image_path .. "/blackhole.gif" },
	-- 		repeat_x = "Mirror",
	-- 		-- opacity = 0.8,
	-- 		vertical_align = "Bottom",
	-- 		hsb = dimmer,
	-- 	},
	-- 	{
	-- 		source = { File = base_image_path .. "/guy.gif" },
	-- 		repeat_x = "NoRepeat",
	-- 		repeat_y_size = "150%",
	-- 		width = "12%",
	-- 		height = "30%",
	-- 		hsb = dimmer,
	-- 		vertical_offset = "55%",
	-- 		horizontal_offset = "80%",
	-- 		attachment = { Parallax = 0.15 },
	-- 	},
	-- },
	font_size = 14.0,
	line_height = 1.1,
	font = wezterm.font("NotoSansM Nerd Font Mono", { weight = "Bold" }),
	macos_window_background_blur = 20,
	show_new_tab_button_in_tab_bar = false,
	show_close_tab_button_in_tabs = false,
	window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	},
	window_background_gradient = {
		colors = { "#000000" },
	},
	colors = {
		tab_bar = {
			background = "#0a0a0f",
			active_tab = {
				bg_color = "#1e2030",
				fg_color = "#c8d3f5",
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#141420",
				fg_color = "#545c7e",
			},
			inactive_tab_hover = {
				bg_color = "#1a1b2e",
				fg_color = "#82aaff",
				italic = false,
			},
			new_tab = {
				bg_color = "#0a0a0f",
				fg_color = "#545c7e",
			},
			new_tab_hover = {
				bg_color = "#141420",
				fg_color = "#82aaff",
				italic = false,
			},
			inactive_tab_edge = "none",
		},
	},
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	tab_max_width = 25,
}

return style
