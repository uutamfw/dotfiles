local wezterm = require("wezterm")

local tab_keys = {}
for i = 1, 4 do
	table.insert(tab_keys, {
		key = tostring(i),
		mods = 'CMD',
		action = wezterm.action.ActivateTab(i - 1)
	})
end

local keys = {
	{
		key = 'd',
		mods = 'CMD',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
	},
	{
		key = 'i',
		mods = 'CMD',
		action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
	},
	{ key = 'n', mods = 'SHIFT|CTRL', action = wezterm.action.ToggleFullScreen },
	{
		key = 'w',
		mods = 'CMD',
		action = wezterm.action.CloseCurrentPane { confirm = true }
	}, {
	key = 'l',
	mods = 'SHIFT|CTRL',
	action = wezterm.action.ActivatePaneDirection 'Right'
}, {
	key = 'h',
	mods = 'SHIFT|CTRL',
	action = wezterm.action.ActivatePaneDirection 'Left'
}, {
	key = 'k',
	mods = 'SHIFT|CTRL',
	action = wezterm.action.ActivatePaneDirection 'Up'
}, {
	key = 'j',
	mods = 'SHIFT|CTRL',
	action = wezterm.action.ActivatePaneDirection 'Down'
}, {
	key = "h",
	mods = "OPT",
	action = wezterm.action.ActivateTabRelativeNoWrap(-1)
},
	{
		key = "l",
		mods = "OPT",
		action = wezterm.action.ActivateTabRelativeNoWrap(1)
	}
}

return keys
