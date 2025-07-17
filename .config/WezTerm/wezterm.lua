-- local dark = {brightness = 0.3, hue = 1.4}
local keys = require("keybindings")
local style = require("style")

return {
	keys = keys,
	enable_scroll_bar = style.enable_scroll_bar,
	window_background_opacity = style.window_background_opacity,
	window_background_image_hsb = style.window_background_image_hsb,
	inactive_pane_hsb = style.inactive_pane_hsb,
	background = style.background,
	font_size = style.font_size,
	line_height = style.line_height,
	font = style.font,
	macos_window_background_blur = 20,
	window_decorations = "RESIZE",
	color_scheme = "Horizon Dark (Gogh)",
	colors = style.colors,
	use_fancy_tab_bar = style.use_fancy_tab_bar,
	tab_bar_at_bottom = style.tab_bar_at_bottom,
	tab_max_width = style.tab_max_width,
}
