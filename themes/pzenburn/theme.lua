-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.wallpaper_cmd = { "nitrogen --restore" }
-- }}}

-- {{{ Styles
theme.font      = "Tamsyn 9"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#000000"
theme.fg_urgent = "#FFFFFF"
theme.bg_normal = "#202020"
theme.bg_focus  = "#585858"
theme.bg_urgent = "#FF0505"
theme.taglist_bg_focus = "#3465A4"
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets and wibar
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
theme.icon_path = "/home/pschmitt/pictures/icons/xbm8x8/png/"    
theme.fg_widget = "#dcdccc"
theme.bg_widget = "#000000"
theme.fg_separator = "#007b8c"
theme.fg_unit = "#515056"
theme.fg_widget_activity = "#00aa00"
theme.fg_widget_important = "#fb7906"
theme.fg_widget_critical = "#aa0000"
theme.widget_netdown = theme.icon_path .. "net_down_01.png"
theme.widget_netup = theme.icon_path .. "net_up_01.png"
theme.widget_netdown_active = theme.icon_path .. "net_down_01_active.png"
theme.widget_netup_active = theme.icon_path .. "net_up_01_active.png"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/zenburn/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_icon_path  = "/home/pschmitt/pictures/icons/icons-awesome-anrxc/layouts-small-outline/"
theme.layout_tile       = theme.layout_icon_path .. "tile.png"
theme.layout_tileleft   = theme.layout_icon_path .. "tileleft.png"
theme.layout_tilebottom = theme.layout_icon_path .. "tilebottom.png"
theme.layout_tiletop    = theme.layout_icon_path .. "tiletop.png"
theme.layout_fairv      = theme.layout_icon_path .. "fairv.png"
theme.layout_fairh      = theme.layout_icon_path .. "fairh.png"
theme.layout_spiral     = theme.layout_icon_path .. "spiral.png"
theme.layout_dwindle    = theme.layout_icon_path .. "dwindle.png"
theme.layout_max        = theme.layout_icon_path .. "max.png"
theme.layout_fullscreen = theme.layout_icon_path .. "fullscreen.png"
theme.layout_magnifier  = theme.layout_icon_path .. "magnifier.png"
theme.layout_floating   = theme.layout_icon_path .. "floating.png"

theme.layout_txt_tile       = "[t]" 
theme.layout_txt_tileleft   = "[l]"
theme.layout_txt_tilebottom = "[r]"
theme.layout_txt_tiletop    = "[t]"
theme.layout_txt_fairv      = "[fv]"
theme.layout_txt_fairh      = "[fh]"
theme.layout_txt_spiral     = "[s]"
theme.layout_txt_dwindle    = "[d]"
theme.layout_txt_max        = "[mx]"
theme.layout_txt_fullscreen = "[F]"
theme.layout_txt_magnifier  = "[M]"
theme.layout_txt_floating   = "[*]"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/zenburn/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
