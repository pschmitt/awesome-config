-- default rc.lua for shifty
--
-- Standard awesome library
require("awful")
require("awful.autofocus")
-- awesome-client support
require("awful.remote")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- shifty - dynamic tagging library
require("shifty")
local scratch = require("scratch")
-- On screen KB
require("osk")
user_utils = require("user_utils")
vicious = require("vicious")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

-- Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = awful.util.getdir("config") .. "/themes/pzenburn/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
browser = os.getenv("BROWSER")
shell = os.getenv("SHELL")
print(shell)
mail = "mutt"
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
net_dev = "wlan0"
if ifup(net_dev) then
    net_dev = "eth0"
end
battery_dev = "BAT1"
has_battery = file_exists("/sys/class/power_supply/" .. battery_dev  .. "/status")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key, I suggest you to remap
-- Mod4 to another key using xmodmap or other tools.  However, you can use
-- another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- Disable sloppy focus -> click to focus
shifty.config.sloppy = false

-- Shifty configured tags.
shifty.config.tags = {
    ["#!"]  = {
        layout    = awful.layout.suit.max,
        mwfact    = 0.60,
        exclusive = false,
        position  = 1,
        init      = true,
        screen    = 2,
        slave     = true,
    },
    net = {
        --layout      = awful.layout.suit.tile.bottom,
        --mwfact      = 0.65,
        position    = 2,
        screen      = 2,
        max_clients = 1,
        exclusive   = true
        -- spawn       = browser,
    },
    dev = {
        layout      = awful.layout.suit.tile.bottom,
        leave_kills = false,
        persist     = false,
        position    = 3
    },
    uni = {
        layout      = awful.layout.suit.tile.bottom,
        leave_kills = false,
        persist     = false,
        position    = 4
    },
    dl = {
        layout      = awful.layout.suit.tile.bottom,
        leave_kills = false,
        persist     = false,
        position    = 5
    },
    rd = {
        layout      = awful.layout.suit.tile.bottom,
        position    = 7
    },
    mail = {
        layout    = awful.layout.suit.tile,
        exclusive = false,
        position  = 8,
        spawn     = mail,
        slave     = true
    },
    media = {
        layout    = awful.layout.suit.float,
        exclusive = false,
        screen    = 1, -- math.max(screen.count(), 2),
        position  = 6,
    },
    office = {
        layout   = awful.layout.suit.tile,
        position = 10,
    },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "tmux",
        },
        tag = "#!",
    },
    {
        match = {
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
            "Firefox",
            "luakit",
        },
        tag = "net",
    },
    {
        match = {
            "Shredder.*",
            "Thunderbird",
            "mutt",
        },
        tag = "mail",
    },
    {
        match = {
            "pcmanfm",
            "spacefm",
        },
        slave = true
    },
    {
        match = {
            "OpenOffice.*",
            "Abiword",
            "Gnumeric",
        },
        tag = "office",
    },
    {
        match = {
            "Mplayer.*",
            "Vlc",
            "Mirage",
            "gimp",
            "gtkpod",
            "Ufraw",
            "easytag",
        },
        tag = "media",
        nopopup = true,
    },
    {
        match = {
            "MPlayer",
            "Gnuplot",
            "galculator",
        },
        float = true,
    },
    {
        -- Flash video
        match = {
            "plugin-container",
            --".*plugin-container.*",
        },
        tag = "media",
        slave = false,
        intrusive = true,   -- Disregard a tag's exclusive property.
        float = true,
        fullscreen = true,
    },
    {
        match = {
            terminal,
        },
        honorsizehints = false,
        slave = true,
    },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.bottom,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}

function fullscreens(c)
     awful.client.floating.toggle(c)
     if awful.client.floating.get(c) then
         local clientX = screen[1].workarea.x
         local clientY = screen[1].workarea.y
         local clientWidth = 0
         -- look at http://www.rpm.org/api/4.4.2.2/llimits_8h-source.html
         local clientHeight = 2147483640
         for s = 1, screen.count() do
             clientHeight = math.min(clientHeight, screen[s].workarea.height)
             clientWidth = clientWidth + screen[s].workarea.width
         end
         local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
     else
         --apply the rules to this client so he can return to the right tag if there is a rule for that.
         awful.rules.apply(c)
     end
     -- focus our client
     client.focus = c
end


--  Wibox
-- Create a textbox widget
-- mytextclock = awful.widget.textclock({align = "right"})

-- Create a laucher widget and a main menu
myawesomemenu = {
    {"manual", terminal .. " -e man awesome"},
    {"edit config",
     editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua"},
    {"restart", awesome.restart},
    {"quit", awesome.quit}
}

mymainmenu = awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
            {"open terminal", terminal}}
    })

mylauncher = awful.widget.launcher({image = image(beautiful.awesome_icon),
                                     menu = mymainmenu})

-- Create a systray
mysystray = widget({type = "systray", align = "right"})

-- Spacer and separator
spacer = widget({ type = "textbox" })
spacer.text = "  "
separator = widget({ type = "textbox" })
separator.text  = " <span color='" .. beautiful.fg_separator  ..  "'>|</span> "

-- Date / Clock widget
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date,
        "%d<span color='" .. beautiful.fg_unit  .. "'>/</span>%m<span color='" .. beautiful.fg_unit .."'>/</span>%Y<span color='" .. beautiful.fg_separator .."'>_</span>%a %H<span color='" ..beautiful.fg_unit  .. "'>:</span>%M ", 60)

-- Uptime widget
uptimewidget = widget({ type = "textbox", align = "right" })
vicious.register(uptimewidget, vicious.widgets.uptime, "$4 $5 $6", 60)

-- Network widgets
--[[
netdownicon = widget({ type = "imagebox" })
netdownicon.image = image(beautiful.widget_netdown)
netupicon = widget({ type = "imagebox" })
netupicon.image = image(beautiful.widget_netup)
netupwidget = widget({ type = "textbox"})
netupwidget.width = 40
netupwidget.align = "center"
netdownwidget = widget({ type = "textbox"})
netdownwidget.width = 40
netdownwidget.align = "center"
--]]
netwidget = widget({ type = "textbox" })
netwidget.align = "center"
netwidget.width = 95
vicious.cache(vicious.widgets.net)
vicious.register(netwidget, vicious.widgets.net,
    function (widget, args)
        local up_speed = args["{" .. net_dev .. " up_kb}"]
        local down_speed = args["{" .. net_dev .. " down_kb}"]
        local up_fgcolor = beautiful.fg_widget_activity
        local down_fgcolor = beautiful.fg_widget_activity
        if up_speed <= "1.0" then
            up_fgcolor = beautiful.fg_unit
        end
        if down_speed <= "1.0" then
            down_fgcolor = beautiful.fg_unit
        end
        return "<span color='" .. up_fgcolor .. "'>" ..
                   "↑ " ..
               "</span><span color='" .. beautiful.fg_widget .. "'>" ..
                   string.format("%d", up_speed) ..
               "</span>" ..
               "<span color='" .. beautiful.fg_unit  .. "'> - </span>" ..
               "<span color='" .. down_fgcolor .. "'>" ..
                   "↓ " ..
               "</span><span color='" .. beautiful.fg_widget .. "'>" ..
                   string.format("%d", down_speed) ..
               "</span>"
    end, 1
)

-- Layout text widget
txtlayoutwidget = widget({ type = "textbox" })
txtlayoutwidget.align = "center"
--txtlayoutwidget.text = awful.layout.getname(awful.layout.get(1))
txtlayoutwidget.text = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(mouse.screen))]

-- function update_txt()
--    txtlayoutwidget.text = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(mouse.screen))]
--end

function updatelayoutbox(l, s)
    local screen = s or 1
    l.text = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(screen))]
end

--[[
vicious.register(netupwidget, vicious.widgets.net,
    function (widget, args)
        if args["{" .. net_dev .. " up_kb}"] == "0.0" then
            netupicon.image = image(beautiful.widget_netup)
        else
            netupicon.image = image(beautiful.widget_netup_active)
        end
        return args["{" .. net_dev .. " up_kb}"]
    end, 1
)
vicious.register(netdownwidget, vicious.widgets.net,
    function (widget, args)
        if args["{" ..  net_dev .. " down_kb}"] == "0.0" then
            netdownicon.image = image(beautiful.widget_netdown)
        else
            netdownicon.image = image(beautiful.widget_netdown_active)
        end
        return args["{" .. net_dev .. " down_kb}"]
    end, 1
)
--]]

-- Battery widget
--[[
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat,
   function (widget, args)
        local bat_percent = args[2]
        local fg_color = beautiful.fg_widget
        if bat_percent < 50 then
            fg_color = beautiful.fg_widget_important
        elseif bat_percent < 15 then
            fg_color = beautiful.fg_widget_critical
        end
        return "<span color='" .. fg_color  .. "'>"..
                   bat_percent ..
               "</span><span color='" .. beautiful.fg_unit .. "'>%</span>"
   end, 61, battery_dev
)
--]]

-- Battery
if has_battery then
    -- print("has battery")
    require("battery")
    batwidget = widget({ type = "textbox", name = "batwidget", align = "right" })
    bat_clo = battery.batclosure(battery_dev)
    batwidget.text = bat_clo()
    print(bat_clo())
    battimer = timer({ timeout = 30 })
    battimer:add_signal("timeout", function() batwidget.text = bat_clo() end)
    battimer:start()

end
-- Memory widget
-- memwidget = widget({ type = "textbox" })
-- vicious.cache(vicious.widgets.mem)
-- vicious.register(memwidget, vicious.widgets.mem, "$1", 10)

-- Mail widget
-- mailwidget = widget({ type = "textbox" })
-- vicious.register(mailwidget, vicious.widgets.gmail, "${count}", 120)

-- Updates widget
-- pkgwidget = widget({ type = "textbox" })
-- vicious.register(pkgwidget, vicious.widgets.pkg, "Arch", 3600)

-- ALSA widget
volwidget = widget({ type = "textbox"})
vicious.register(volwidget, vicious.widgets.volume,
    function(widget, args)
        -- TODO Why is fgcolor nil after its init !?
        if args[2] ~= "♫" then
            return "<span color='" .. beautiful.fg_widget_critical .. "'>" ..
                       args[1] .. "</span>" ..
                   "<span color='" .. beautiful.fg_unit  .. "'>%</span>"
        end
        return "<span color='" .. beautiful.fg_widget .. "'>" ..
                       args[1] .. "</span>" ..
                   "<span color='" .. beautiful.fg_unit  .. "'>%</span>"
    end, 2, "Master -c 0")
volwidget:buttons(awful.util.table.join(
    -- awful.button({}, 1, function() awful.util.spawn( "mpc next" ) end),
    awful.button({}, 3, function() awful.util.spawn("amixer set Master toggle") end),
    awful.button({}, 4, function() awful.util.spawn("amixer -c 0 sset Master 1+ unmute") end),
    awful.button({}, 5, function() awful.util.spawn("amixer -c 0 sset Master 1- unmute") end)))

-- mpd widget
--[[
mpdwidget = widget({ type = "textbox" })
mpdwidget.width = 200
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if   args["{state}"] == "Stop" then
            return "Stopped"
        else
            return args["{Artist}"] .. " <span color='" .. beautiful.fg_unit  ..  "'>-</span> " .. args["{Title}"]
      end
    end, 2
)
mpdwidget:buttons(awful.util.table.join(
    -- awful.button({}, 1, function() awful.util.spawn( "mpc next" ) end),
    awful.button({}, 1, function() awful.util.spawn("mpc toggle") end),
    awful.button({}, 4, function() awful.util.spawn("mpc next") end),
    awful.button({}, 5, function() awful.util.spawn("mpc prev") end)))
--]]

-- Awesompd
require("awesompd/awesompd")
mpdwidget = awesompd:create() -- Create awesompd widget
mpdwidget.font = beautiful.font -- Set widget font
mpdwidget.scrolling = true -- If true, the text in the widget will be scrolled
mpdwidget.output_size = 30 -- Set the size of widget in symbols
mpdwidget.update_interval = 10 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
mpdwidget.path_to_icons = "/home/pschmitt/.config/awesome/awesompd/icons"
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
mpdwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks and local tracks will also contain
-- album cover image.
mpdwidget.show_album_cover = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
mpdwidget.album_cover_size = 50
-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
mpdwidget.mpd_config = "/etc/mpd.conf"
-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
mpdwidget.browser = browser
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
mpdwidget.ldecorator = " "
mpdwidget.rdecorator = " "
-- Set all the servers to work with (here can be any servers you use)
mpdwidget.servers = {
    { server = "LaXLinux", port = 6600 },
    { server = "LaXLinux-CL", port = 6600 },
    { server = "alarmpi", port = 6600 }
}
-- Set the buttons of the widget
mpdwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, mpdwidget:command_toggle() },
                             { "", awesompd.MOUSE_SCROLL_UP, mpdwidget:command_volume_up() },
                             { "", awesompd.MOUSE_SCROLL_DOWN, mpdwidget:command_volume_down() },
                             { "", awesompd.MOUSE_RIGHT, mpdwidget:command_show_menu() },
                             --[[
                             { "", awesompd.MOUSE_RIGHT, function()
                                                            if #mpdwidget.servers >= 1 then
                                                                if mpdwidget.current_server <= #mpdwidget.servers then
                                                                    mpdwidget:change_server(mpdwidget.current_server + 1)
                                                                else
                                                                    mpdwidget:change_server(1)
                                                                end
                                                            end
                                                            -- mpdwidget:change_server()
                                                         end },
                             --]]
                             { "Control", awesompd.MOUSE_SCROLL_UP, mpdwidget:command_prev_track() },
                             { "Control", awesompd.MOUSE_SCROLL_DOWN, mpdwidget:command_next_track() },
})

mpdwidget:run() -- After all configuration is done, run the widget

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
txtlayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1, awful.tag.viewonly),
    awful.button({modkey}, 1, awful.client.movetotag),
    awful.button({}, 3, function(tag) tag.selected = not tag.selected end),
    awful.button({modkey}, 3, awful.client.toggletag),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
    )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
        end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
        end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
        end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
        end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] =
        awful.widget.prompt({layout = awful.widget.layout.leftright})
    -- Create an imagebox widget which will contains an icon indicating which
    -- layout we're using.  We need one layoutbox per screen.
    txtlayoutbox[s] = widget({ type = "textbox" })
    txtlayoutbox[s].text = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))]
    awful.tag.attached_add_signal(s, "property::selected", function ()
        updatelayoutbox(txtlayoutbox[s], s)
    end)
    awful.tag.attached_add_signal(s, "property::layout", function ()
        updatelayoutbox(txtlayoutbox[s], s)
    end)
    txtlayoutbox[s]:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s,
                                            awful.widget.taglist.label.all,
                                            mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                        return awful.widget.tasklist.label.currenttags(c, s)
                    end,
                                              mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({position = "top", height = "14", screen = s})
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            -- mylauncher,
            mytaglist[s],
            separator,
            txtlayoutbox[s],
            spacer,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        datewidget,
        -- Show systray on last screen
        s == screen.count() and separator or nil,
        s == screen.count() and mysystray or nil,
        separator,
        -- netdownwidget, netdownicon, netupwidget, netupicon,
        netwidget,
        separator,
        mpdwidget.widget,
        separator,
        volwidget,
        separator,
        uptimewidget,
        has_battery and separator or nil,
        has_battery and batwidget or nil,
        spacer,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox[s].screen = s
end

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mymainmenu:show({keygrabber=true}) end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
    -- Tags
    awful.key({modkey,}, "Left", awful.tag.viewprev),
    awful.key({modkey,}, "Right", awful.tag.viewnext),
    awful.key({modkey,}, "Up", awful.tag.history.restore),

    -- Shifty: keybindings specific to shifty
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey, "Shift"}, "m", shifty.send_prev), -- client to prev tag
    awful.key({modkey}, "n", shifty.send_next), -- client to next tag
    awful.key({modkey, "Control"}, "Right",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
                  awful.screen.focus(t.screen)
              end), -- Move tag to next screen
    awful.key({modkey, "Control"}, "Left",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen - 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
                  awful.screen.focus(t.screen)
              end), -- Move tag to previous screen
    awful.key({modkey, "Control"}, "s",
              function()
              end), -- Swap tags -- TODO WIP !
    awful.key({modkey}, "a", shifty.add), -- create a new tag
    awful.key({modkey,}, "F2", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
            function()
        shifty.add({nopopup = true})
    end),

    awful.key({modkey,}, "j",
    function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,}, "k",
    function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey, "Control"}, "w", function() mymainmenu:show(true) end),

    -- Layout manipulation
    awful.key({modkey, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end),
    awful.key({modkey, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end),
    -- Focus previous screen
    awful.key({modkey, "Control"}, "j", function() awful.screen.focus(mouse.screen - 1) end),
    -- Focus next screen
    awful.key({modkey, "Control"}, "k", function() awful.screen.focus(mouse.screen + 1) end),
    awful.key({modkey,}, "u", awful.client.urgent.jumpto),
    awful.key({modkey,}, "Tab",
    function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    awful.key({modkey, "Shift"}, "r", awesome.restart),
    awful.key({modkey, "Shift"}, "q", awesome.quit),

    awful.key({modkey,}, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({modkey,}, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1) end),
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1) end),
    awful.key({modkey, "Control"}, "h", function() awful.tag.incncol(1) end),
    awful.key({modkey, "Control"}, "l", function() awful.tag.incncol(-1) end),
    awful.key({modkey,}, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({modkey, "Shift"}, "space",
        function() awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({modkey}, "r", function()
        awful.prompt.run({prompt = "$ "},
        mypromptbox[mouse.screen].widget,
        awful.util.spawn, awful.completion.shell, -- TODO: use zsh completion !
        awful.util.getdir("cache") .. "/history")
        end),

    awful.key({modkey}, "F4", function()
        awful.prompt.run({prompt = "Run Lua code: "},
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
        end),
    -- Scratchpads
    awful.key({modkey, "Shift"}, "t", function () scratch.drop("urxvtc", "bottom") end),
    awful.key({modkey, "Shift"}, "n", function () scratch.drop("urxvtc -e ncmpcpp", "center", "center", 0.6, 0.75) end),
    awful.key({modkey, "Control", "Shift"}, "n", function () scratch.drop("urxvtc -e ncmpcpp -h laxlinux", "center", "center", 0.6, 0.75) end),
    awful.key({modkey }, "e", function () scratch.drop("spacefm", "center", "center", 0.6, 0.75) end),
    awful.key({modkey, "Shift"}, "v", function () osk() end) -- Not a scratchpad, but its behavious is the same    ))
    )
-- Client awful tagging: this is useful to tag some clients and then do stuff
-- like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({modkey,}, "f", function(c) c.fullscreen = not c.fullscreen  end),
    awful.key({modkey, "Shift"}, "f", fullscreens),
    awful.key({modkey, "Shift"}, "c", function(c) c:kill() end),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle),
    awful.key({modkey, "Control"}, "Return",
        function(c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey,}, "o", awful.client.movetoscreen),
    awful.key({modkey, "Control"}, "r", function(c) c:redraw() end),
    awful.key({modkey}, "t", awful.client.togglemarked),
    awful.key({modkey,}, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            awful.tag.viewonly(shifty.getpos(i))
            local t = shifty.getpos(i)
            -- set this tag "used" so that it gets destroyed when leaving (only if no clients on)
            awful.tag.setproperty(t, "used", true)
            awful.screen.focus(t.screen)
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                local t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
                awful.screen.focus(t.screen)
            end
        end))
    end

-- Set keys
root.keys(globalkeys)

-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)
