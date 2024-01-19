
-- ███╗░░░███╗██╗░█████╗░██████╗░░█████╗░██╗░░██╗░█████╗░░██╗░░░░░░░██╗██╗░░██╗
-- ████╗░████║██║██╔══██╗██╔══██╗██╔══██╗██║░░██║██╔══██╗░██║░░██╗░░██║██║░██╔╝
-- ██╔████╔██║██║██║░░╚═╝██████╔╝██║░░██║███████║███████║░╚██╗████╗██╔╝█████═╝░
-- ██║╚██╔╝██║██║██║░░██╗██╔══██╗██║░░██║██╔══██║██╔══██║░░████╔═████║░██╔═██╗░
-- ██║░╚═╝░██║██║╚█████╔╝██║░░██║╚█████╔╝██║░░██║██║░░██║░░╚██╔╝░╚██╔╝░██║░╚██╗
-- ╚═╝░░░░░╚═╝╚═╝░╚════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library

local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment

require("awful.autofocus")

-- Widget and layout library

local wibox         = require("wibox")

-- Theme handling library

local beautiful     = require("beautiful")

-- Notification library

local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100
local lain          = require("lain")
local freedesktop   = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps

local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Check if awesome encountered an error during startup and fell back to another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops an error happened :(",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Autostart windowless processes

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root", "mako", "swayosd-server" }) -- entries must be comma-separated

local themes = {
    "tokyo-night" --1
}

-- Choose your theme here
local chosen_theme = themes[1]

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- modkey or mod4 = super key

local modkey       = "Mod4"
local altkey       = "Mod1"
local modkey1      = "Control"

-- personal variables

local browser           = "google-chrome-stable"
local editor            = "nvim"
local filemanager       = "pcmanfm"
local mediaplayer       = "vlc"
local scrlocker         = "betterlockscreen"
local terminal          = "kitty"

-- awesome variables
--
awful.util.terminal = terminal
awful.util.tagnames = { " 1 ", " 2 ", " 3 ", " 4 "}
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    -- awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.right,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

-- Menu

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", terminal .. " -e nano ~/.config/awesome/rc.lua" },
    { "arandr", "arandr" },
    { "restart", awesome.restart },
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Exit", "systemctl poweroff" },
        -- other triads can be put here
    }
})

-- Screen

screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- Mouse bindings

root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings

globalkeys = my_table.join(

  awful.key({ modkey, "Shift" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),

  awful.key({ modkey }, "space",
        function ()
          os.execute("sh ~/.config/rofi/scripts/launcher_t7")
      end,
      {description = "show dmenu", group = "hotkeys"}),

  awful.key(
      {modkey}, 'p',
      function()
          os.execute("sh ~/.config/rofi/scripts/powermenu_t5")
      end,
              {description = 'Lock the screen', group = 'awesome'}
          ),

   -- Standard program

  --Example command to launch an App
  -- awful.key({ modkey,  }, "key", function () awful.util.spawn( "app-name" ) end),

  awful.key({ modkey, }, "e", function () awful.util.spawn( "thunar" ) end),

  awful.key({ modkey, }, "b", function () awful.util.spawn( "google-chrome-stable" ) end),

  awful.key({ modkey, }, "t", function () awful.spawn(terminal) end),

  awful.key({ modkey, }, "s", function () awful.util.spawn( "spotify" ) end),

 -- screenshots

  awful.key({ }, "Print", function () awful.util.spawn("gnome-screenshot") end,
      {description = "Gnome Screenshot", group = "screenshots"}),

  awful.key({ modkey           }, "Print", function () awful.util.spawn( "gnome-screenshot" ) end,
      {description = "Gnome Screenshot", group = "screenshots"}),

  awful.key({ modkey, "Shift"  }, "Print", function() awful.util.spawn("gnome-screenshot") end,
      {description = "Gnome Screenshot", group = "screenshots"}),

  -- Personal keybindings}}}

   -- Tag browsing modkey + tabs

  awful.key({ modkey,           }, "Tab",   awful.tag.viewnext,
      {description = "view next", group = "tag"}),

  awful.key({ modkey, "Shift"   }, "Tab",  awful.tag.viewprev,
      {description = "view previous", group = "tag"}),

  -- Default client focus
  awful.key({ modkey, }, "Right",
      function ()
          awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey, }, "Left",
      function ()
          awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
  ),

  -- On the fly useless gaps change
  -- awful.key({ altkey, "Control" }, "j", function () lain.util.useless_gaps_resize(1) end,
  --           {description = "increment useless gaps", group = "tag"}),
  --
  -- awful.key({ altkey, "Control" }, "l", function () lain.util.useless_gaps_resize(-1) end,
  --           {description = "decrement useless gaps", group = "tag"}),

  -- Dynamic tagging
  -- awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
  --           {description = "add new tag", group = "tag"}),
  -- awful.key({ modkey, "Control" }, "r", function () lain.util.rename_tag() end,
  --           {description = "rename tag", group = "tag"}),
  -- awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
  --           {description = "move tag to the left", group = "tag"}),
  -- awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
  --           {description = "move tag to the right", group = "tag"}),
  -- awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
  --           {description = "delete tag", group = "tag"}),

   --LOG_OUT
  awful.key({modkey, }, "Delete", _G.awesome.quit, 
            {description = 'quit awesome', group = 'awesome'}),

  -- Brightness
  awful.key({ }, "XF86MonBrightnessUp", function () os.execute("brightnessctl set 10%+") end,
            {description = "+10%", group = "hotkeys"}),

  awful.key({ }, "XF86MonBrightnessDown", function () os.execute("brightnessctl set 10%-") end,
            {description = "-10%", group = "hotkeys"}),

  -- ALSA volume control

  awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false) end),

  awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false) end),

  awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -D pulse sset Master toggle", false) end),
  awful.key({ modkey1, "Shift" }, "m",
      function ()
          os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
          beautiful.volume.update()
      end),
  awful.key({ modkey1, "Shift" }, "0",
      function ()
          os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
          beautiful.volume.update()
      end),

  -- Copy primary to clipboard (terminals to gtk)
  awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
            {description = "copy terminal to gtk", group = "hotkeys"}),
  -- Copy clipboard to primary (gtk to terminals)
  awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
            {description = "copy gtk to terminal", group = "hotkeys"}),


  -- Default
  --[[ Menubar

  awful.key({ modkey }, "p", function() menubar.show() end,
            {description = "show the menubar", group = "super"})
  --]]

  awful.key({ altkey, "Shift" }, "x",
            function ()
                awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"})
  --]]
)

clientkeys = my_table.join(

  awful.key({ modkey, }, "m",
      function (c)
          c.fullscreen = not c.fullscreen
          c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),

  awful.key({ modkey, }, "q",      function (c) c:kill() end,
            {description = "close", group = "hotkeys"}),

  awful.key({ modkey, }, "f",  awful.client.floating.toggle ,
            {description = "toggle floating", group = "client"}),

  awful.key({ modkey, }, "n",
      function (c)
          -- The client currently has the input focus, so it cannot be
          -- minimized, since minimized clients can't have the focus.
          c.minimized = true
      end ,
      {description = "minimize", group = "client"}),

  awful.key({ modkey, "Shift" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false,  floating = false , maximized = false } },

    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command
    --{ rule = { class = browser1 },
      --properties = { screen = 1, tag = awful.util.tagnames[1] } },

    --{ rule = { class = editorgui },
        --properties = { screen = 1, tag = awful.util.tagnames[2] } },

    --{ rule = { class = "Geany" },
        --properties = { screen = 1, tag = awful.util.tagnames[2] } },

    -- Set applications to always map on the tag 3 on screen 1.
    --{ rule = { class = "Inkscape" },
        --properties = { screen = 1, tag = awful.util.tagnames[3] } },

    -- Set applications to always map on the tag 4 on screen 1.
    --{ rule = { class = "Gimp" },
        --properties = { screen = 1, tag = awful.util.tagnames[4] } },

    -- Set applications to be maximized at startup.
    -- find class or role via xprop command

    -- { rule = { class = editorgui },
    --       properties = { maximized = true } },

    { rule = { class = "Gimp*", role = "gimp-image-window" },
          properties = { maximized = true } },

    { rule = { class = "inkscape" },
          properties = { maximized = true } },

    -- { rule = { class = mediaplayer },
    --       properties = { maximized = true } },

    -- { rule = { class = "Vlc" },
    --       properties = { maximized = true } },



    { rule = { class = "VirtualBox Manager" },
          properties = { maximized = true } },

    { rule = { class = "VirtualBox Machine" },
          properties = { maximized = true } },

    { rule = { class = "Xfce4-settings-manager" },
          properties = { floating = false } },



    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Blueberry",
          "Galculator",
          "Gnome-font-viewer",
          "Gpick",
          "Imagewriter",
          "Font-manager",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Oblogout",
          "Peek",
          "Skype",
          "System-config-printer.py",
          "Sxiv",
          "Unetbootin.elf",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,5)
    end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 21}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- }}}

-- Autostart applications
--os.execute("sh ~/.screenlayout/rightAcerMonitor.sh")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nm-applet")
--awful.spawn.with_shell("pa-applet")
awful.spawn.with_shell("redshift -l 21.9974:79.0011 -O 4900")
awful.spawn.with_shell("pasystray")
awful.spawn.with_shell("nitrogen --restore")
-- awful.spawn.with_shell("blueman-tray")
-- awful.spawn.with_shell("volumeicon")
--  awful.spawn.with_shell("redshift")
awful.spawn.with_shell("flameshot")
awful.spawn.with_shell("xset r rate 400 60")
-- FOR EXTERNAL SAMSUNG MONITOR
-- os.execute("sh ~/.screenlayout/samsungMonitor.sh")
-- os.execute("feh --bg-scale ~/Pictures/wallpapers/fuji_p.jpg ~/Pictures/wallpapers/fuji_p.jpg")
--awful.spawn.with_shell("libinput-gestures-setup start")
--
