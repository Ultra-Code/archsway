const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const eql = std.mem.eql;

fn fmt(arena: Allocator, comptime fmt_spec: []const u8, args: anytype) []const u8 {
    return std.fmt.allocPrint(arena, fmt_spec, args) catch unreachable;
}

const Options = struct {
    terminal: []const u8,
    wallpaper: []const u8,
    screen_lock: []const u8,
    screenshot_path: []const u8,
    max_volume: f16,
    screen_shot_sound: []const u8,
    file_manager: []const u8,
    desktop_launcher: []const u8,
    menu_launcher: []const u8,
    status_bar: []const u8,
    xcursor_theme: []const u8,

    pub fn init(arena: Allocator) @This() {
        const HOME = home(arena);
        const term = terminal(arena);

        return .{
            .terminal = term,
            .wallpaper = wallpaper(arena, HOME),
            .screen_lock = "waylock",
            .screenshot_path = screenshot_path(arena, HOME),
            // wpctl's -l flag clip volume to 160% == 1.6
            .max_volume = 1.6,
            .screen_shot_sound = "/usr/share/sounds/freedesktop/stereo/screen-capture.oga",
            .file_manager = "lf",
            .desktop_launcher = desktop_launcher(arena, term),
            .menu_launcher = menu_launcher(arena, term),
            .status_bar = "levee pulse backlight battery",
            .xcursor_theme = "Adwaita 24",
        };
    }

    fn screenshot_path(arena: Allocator, HOME: []const u8) []const u8 {
        return fmt(
            arena,
            "{[HOME]s}/files/Pictures/Screenshot/Captura-de-pantalla-de_{[date]s}.png",
            .{ .HOME = HOME, .date = "\"$(date +%F_%X)\"" },
        );
    }

    fn desktop_launcher(arena: Allocator, term: []const u8) []const u8 {
        return fmt(
            arena,
            "fuzzel --terminal {[term]s} --lines 25 --width 54 --show-actions",
            .{ .term = term },
        );
    }

    fn menu_launcher(arena: Allocator, term: []const u8) []const u8 {
        return fmt(
            arena,
            "fuzzel --terminal {[term]s} --lines 25 --width 90 --dmenu",
            .{ .term = term },
        );
    }

    fn getenv(allocator: Allocator, env_key: []const u8) []const u8 {
        return std.process.getEnvVarOwned(allocator, env_key) catch unreachable;
    }

    fn terminal(arena: Allocator) []const u8 {
        // virtual terminal number
        const vtnr = getenv(arena, "XDG_VTNR");
        const term = fmt(
            arena,
            "kitty --single-instance --instance-group {[vtnr]s}",
            .{ .vtnr = vtnr },
        );
        return term;
    }

    fn home(arena: Allocator) []const u8 {
        return getenv(arena, "HOME");
    }

    fn wallpaper(arena: Allocator, HOME: []const u8) []const u8 {
        const wallpapers_path = fmt(
            arena,
            "{[HOME]s}/files/Pictures/Code/",
            .{ .HOME = HOME },
        );
        const random_wallpaper = fmt(
            arena,
            "ls {[wallpapers_path]s} | shuf -n 1",
            .{ .wallpapers_path = wallpapers_path },
        );
        const choosen_wallpaper = fmt(
            arena,
            "{[wallpapers_path]s}{[wallpaper]s}",
            .{ .wallpapers_path = wallpapers_path, .wallpaper = Run.popen(
                arena,
                random_wallpaper,
            ) },
        );

        return choosen_wallpaper;
    }
};

const Run = struct {
    arena: Allocator,
    options: Options,

    pub fn init(arena: Allocator, options: Options) Run {
        return .{
            .arena = arena,
            .options = options,
        };
    }

    fn autostart(self: Run) void {
        const swayidle = fmt(
            self.arena,
            "swayidle -w timeout 300 {[waylock]s} before-sleep {[waylock]s} idlehint 780",
            .{ .waylock = self.options.screen_lock },
        );

        const background =
            fmt(
            self.arena,
            "wbg {[wallpaper]s}",
            .{
                .wallpaper = self.options.wallpaper,
            },
        );

        const autostarts_commands = [_][]const u8{
            "systemctl --user set-environment XDG_CURRENT_DESKTOP=river",
            "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
            "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river",
            swayidle,
            background,
            // -- { status_bar }, # don't run status bar on startup
            "wlsunset -t 700 -l 5.5502 -L -0.2174",
            "wl-paste --watch cliphist store",
            "batsignal -b -e -p -w 35 -c 18 -d 12 -f 85 -m 180 -D systemctl suspend",
        };

        for (autostarts_commands) |command| {
            run(
                self.arena,
                fmt(
                    self.arena,
                    "riverctl spawn \'{[cmd]s}\'",
                    .{ .cmd = command },
                ),
            );
        }
    }

    fn run(arena: Allocator, cmd: []const u8) void {
        var process = std.process.Child.init(&.{ "sh", "-c", cmd }, arena);
        const exec_status = process.spawnAndWait() catch unreachable;

        assert(exec_status.Exited == 0);
    }

    fn popen(arena: Allocator, cmd: []const u8) []const u8 {
        const process_result = std.process.Child.run(.{ .allocator = arena, .argv = &.{ "sh", "-c", cmd } }) catch unreachable;
        assert(eql(u8, process_result.stderr, ""));
        return std.mem.trim(u8, process_result.stdout, "\n");
    }

    fn oneshot(self: Run) void {
        const oneshot_commands = [_][]const u8{
            "kanshi",
        };
        const ProcessState = enum { active, inactive };

        for (oneshot_commands) |command| {
            var cmd = std.mem.splitScalar(u8, command, ' ');
            const name = cmd.next().?;

            //run program once
            const process_state = popen(self.arena, fmt(
                self.arena,
                "if pgrep {[name]s} >/dev/null 2>&1 ; then echo 'active' ; else echo 'inactive' ; fi",
                .{ .name = name },
            ));
            const state = std.meta.stringToEnum(ProcessState, process_state).?;

            switch (state) {
                .active => {},
                .inactive => {
                    run(self.arena, fmt(
                        self.arena,
                        "riverctl spawn '{[command]s}'",
                        .{ .command = command },
                    ));
                },
            }
        }
    }

    fn configure_input(self: Run) void {
        const device = "pointer-2-14-ETPS/2_Elantech_Touchpad";

        const InputOptions = enum {
            events,
            @"accel-profile",
            @"pointer-accel",
            @"click-method",
            drag,
            @"disable-while-typing",
            @"middle-emulation",
            @"natural-scroll",
            tap,
            @"tap-button-map",
            @"scroll-method",
        };

        var inputs = std.enums.EnumMap(
            InputOptions,
            []const u8,
        ).init(.{
            .events = "disabled-on-external-mouse",
            .@"accel-profile" = "adaptive",
            .@"pointer-accel" = "0.6",
            .@"click-method" = "clickfinger",
            .drag = "enabled",
            .@"disable-while-typing" = "enabled",
            .@"middle-emulation" = "enabled",
            .@"natural-scroll" = "enabled",
            .tap = "enabled",
            .@"tap-button-map" = "left-right-middle",
            .@"scroll-method" = "two-finger",
        });

        var iter = inputs.iterator();
        while (iter.next()) |option| {
            run(self.arena, fmt(
                self.arena,
                "riverctl input {[device]s} {[key]s} {[value]s}",
                .{
                    .device = device,
                    .key = @tagName(option.key),
                    .value = option.value.*,
                },
            ));
        }
    }

    fn river_options(self: Run) void {
        const RiverOptions = enum {
            @"default-attach-mode",
            @"border-width",
            @"focus-follows-cursor",
            @"hide-cursor",
            @"set-cursor-warp",
            @"set-repeat",
            @"xcursor-theme",
            @"default-layout",
        };

        var options = std.enums.EnumMap(
            RiverOptions,
            []const u8,
        ).init(.{
            .@"default-attach-mode" = "top",
            .@"border-width" = "0",
            .@"focus-follows-cursor" = "normal",
            .@"hide-cursor" = "when-typing enabled",
            .@"set-cursor-warp" = "on-output-change",
            .@"set-repeat" = "50 300",
            .@"xcursor-theme" = self.options.xcursor_theme,
            .@"default-layout" = "rivertile",
        });

        var iter = options.iterator();
        while (iter.next()) |option| {
            run(self.arena, fmt(
                self.arena,
                "riverctl {[option]s} {[value]s}",
                .{
                    .option = @tagName(option.key),
                    .value = option.value.*,
                },
            ));
        }
    }

    fn gnome_settings(self: Run) void {
        const setting_group = "org.gnome.desktop.interface";

        var theme_values = std.mem.splitScalar(u8, self.options.xcursor_theme, ' ');
        const adwaita = theme_values.next().?;
        const font_size = theme_values.next().?;

        const Gsettings = enum {
            @"gtk-theme",
            @"icon-theme",
            @"cursor-theme",
            @"cursor-size",
            @"color-scheme",
        };

        var gsettings = std.enums.EnumMap(
            Gsettings,
            []const u8,
        ).init(.{
            .@"gtk-theme" = "Adwaita-dark",
            .@"icon-theme" = "Adwaita",
            .@"cursor-theme" = adwaita,
            .@"cursor-size" = font_size,
            .@"color-scheme" = "prefer-dark",
        });

        var iter = gsettings.iterator();
        while (iter.next()) |option| {
            run(self.arena, fmt(
                self.arena,
                "gsettings set {[group]s} {[key]s} {[value]s}",
                .{
                    .group = setting_group,
                    .key = @tagName(option.key),
                    .value = option.value.*,
                },
            ));
        }
    }

    const Mod = enum { Super, None, Shift, Alt, Control };
    // zig fmt: off
    const Key = enum { 
        A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, 
        T, U, V, W, X, Y, Z, Return, Print, Space, Tab, Escape,
        XF86Eject, XF86AudioRaiseVolume, XF86AudioLowerVolume,
        XF86AudioMute, XF86AudioMicMute, XF86AudioStop,
        XF86AudioPause, XF86AudioPlay, XF86AudioPrev,
        XF86AudioNext, XF86MonBrightnessUp, XF86MonBrightnessDown,
        BTN_LEFT, BTN_RIGHT, F11
    };
    // zig fmt: on
    const Command = struct {
        mod: []const Mod,
        key: Key,
        cmd: []const u8,
    };

    fn mod(arena: Allocator, mods: []const Mod) []const u8 {
        return switch (mods.len) {
            1 => @tagName(mods[0]),
            2 => fmt(arena, "{s}+{s}", .{ @tagName(mods[0]), @tagName(mods[1]) }),
            3 => fmt(arena, "{s}+{s}+{s}", .{ @tagName(mods[0]), @tagName(mods[1]), @tagName(mods[2]) }),
            // only a maximum of 3 modifiers are supported
            else => unreachable,
        };
    }

    // TODO: consider simplifying mapping with custom modes https://wiki.archlinux.org/title/River#Modes
    fn mappings(self: Run) void {
        const Map = union(enum) {
            const Type = enum { map, @"map-pointer" };
            const Opt = enum { repeat, release };
            const Normal = Command;
            const Locked = struct {
                mod: []const Mod,
                key: Key,
                cmd: []const u8,
                opt: ?Opt = null,
            };
            normal: []const Normal,
            locked: []const Locked,

            fn run(
                map: @This(),
                arena: Allocator,
                comptime mtype: Type,
            ) void {
                switch (map) {
                    inline .normal => |normal_maps, mode| {
                        for (normal_maps) |normal| {
                            Run.run(
                                arena,
                                fmt(
                                    arena,
                                    "riverctl {[type]s} {[opt]s} {[mode]s} {[mod]s} {[key]s} {[cmd]s}",
                                    .{
                                        .type = @tagName(mtype),
                                        .opt = "",
                                        .mode = @tagName(mode),
                                        .mod = mod(arena, normal.mod),
                                        .key = @tagName(normal.key),
                                        .cmd = normal.cmd,
                                    },
                                ),
                            );
                        }
                    },
                    inline else => |locked_maps| {
                        for (locked_maps) |locked| {
                            Run.run(
                                arena,
                                fmt(
                                    arena,
                                    "riverctl {[type]s} {[opt]s} {[mode]s} {[mod]s} {[key]s} {[cmd]s}",
                                    .{
                                        .type = @tagName(mtype),
                                        .opt = if (locked.opt) |opt|
                                            fmt(arena, "-{[opt]s}", .{ .opt = @tagName(opt) })
                                        else
                                            "",
                                        .mode = @tagName(.locked),
                                        .mod = mod(arena, locked.mod),
                                        .key = @tagName(locked.key),
                                        .cmd = locked.cmd,
                                    },
                                ),
                            );

                            //run also in normal mode
                            Run.run(
                                arena,
                                fmt(
                                    arena,
                                    "riverctl {[type]s} {[opt]s} {[mode]s} {[mod]s} {[key]s} {[cmd]s}",
                                    .{
                                        .type = @tagName(mtype),
                                        .opt = if (locked.opt) |opt|
                                            fmt(arena, "-{[opt]s}", .{ .opt = @tagName(opt) })
                                        else
                                            "",
                                        .mode = @tagName(.normal),
                                        .mod = mod(arena, locked.mod),
                                        .key = @tagName(locked.key),
                                        .cmd = locked.cmd,
                                    },
                                ),
                            );
                        }
                    },
                }
            }
        };

        const normal_mappings = Map{
            .normal = &.{
                .{
                    .mod = &.{.Super},
                    .key = .T,
                    .cmd = fmt(self.arena,
                        \\spawn '{[terminal]s}'
                    , .{ .terminal = self.options.terminal }),
                },
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .Return,
                    .cmd = fmt(self.arena,
                        \\spawn '{[terminal]s} --class "coding"'
                    , .{ .terminal = self.options.terminal }),
                },
                // clear notifications
                .{
                    .mod = &.{.Super},
                    .key = .U,
                    .cmd = fmt(self.arena,
                        \\spawn 'makoctl dismiss --all'
                    , .{}),
                },
                .{
                    .mod = &.{.Super},
                    .key = .R,
                    .cmd = fmt(self.arena,
                        \\spawn ~/.config/river/init
                    , .{}),
                },

                .{
                    .mod = &.{.Super},
                    .key = .E,
                    .cmd = fmt(self.arena,
                        \\spawn '{[terminal]s} --class "fm" --title "file manager" bash -c "{[file_manager]s}"'
                    , .{
                        .terminal = self.options.terminal,
                        .file_manager = self.options.file_manager,
                    }),
                },
                .{
                    .mod = &.{.Super},
                    .key = .B,
                    .cmd = "spawn firefox",
                },
                .{
                    .mod = &.{.Super},
                    .key = .D,
                    .cmd = fmt(self.arena,
                        \\spawn '{[desktop_launcher]s}'
                    , .{ .desktop_launcher = self.options.desktop_launcher }),
                },
                // Clipboard management with cliphist
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .C,
                    .cmd = fmt(self.arena,
                        \\spawn 'cliphist list | {[fuzzel_menu]s} | cliphist decode | wl-copy'
                    , .{ .fuzzel_menu = self.options.menu_launcher }),
                },
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .D,
                    .cmd = fmt(self.arena,
                        \\spawn 'cliphist list | {[fuzzel_menu]s} | cliphist delete'
                    , .{ .fuzzel_menu = self.options.menu_launcher }),
                },
                // Take screenshot of a window
                .{
                    .mod = &.{.None},
                    .key = .Print,
                    .cmd = fmt(self.arena,
                        \\spawn 'grim "{[screenshot_path]s}" ; pw-play {[screen_shot_sound]s}'
                    , .{
                        .screenshot_path = self.options.screenshot_path,
                        .screen_shot_sound = self.options.screen_shot_sound,
                    }),
                },
                // Take a screenshot of a region of a window
                .{
                    .mod = &.{.Super},
                    .key = .Print,
                    .cmd = fmt(self.arena,
                        \\spawn 'grim -g "$(slurp)" "{[screenshot_path]s}" ; pw-play {[screen_shot_sound]s}'
                    , .{
                        .screenshot_path = self.options.screenshot_path,
                        .screen_shot_sound = self.options.screen_shot_sound,
                    }),
                },
                // Take a screenshot and copy to clipboard
                .{
                    .mod = &.{.Alt},
                    .key = .Print,
                    .cmd = fmt(self.arena,
                        \\spawn 'grim - | wl-copy ; pw-play {[screen_shot_sound]s}'
                    , .{ .screen_shot_sound = self.options.screen_shot_sound }),
                },
                // Super+Q to close the focused view
                .{
                    .mod = &.{.Super},
                    .key = .Q,
                    .cmd = "close",
                },
                // Super+Shift+Q to exit river (requires 'swaynag' program from sway)
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .Q,
                    .cmd =
                    \\spawn 'swaynag -t warning -m "Exit river?" -b "Yes" "riverctl exit" -s "No"'
                    ,
                },
                // Super+Shift+X to lock the screen
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .X,
                    .cmd = fmt(
                        self.arena,
                        "spawn {[waylock]s}",
                        .{
                            .waylock = self.options.screen_lock,
                        },
                    ),
                },
                // toggle showing status bar
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .B,
                    .cmd = fmt(self.arena,
                        \\spawn "if pgrep {[bar]s} ; then pkill {[bar]s} ; else {[status_bar]s} & fi"
                    , .{
                        .bar = brk: {
                            var bar_tok =
                                std.mem.splitScalar(u8, self.options.status_bar, ' ');
                            break :brk bar_tok.next().?;
                        },
                        .status_bar = self.options.status_bar,
                    }),
                },
                // Super+{J,K} to focus next/previous view in the layout stack
                .{
                    .mod = &.{.Super},
                    .key = .J,
                    .cmd = "focus-view next",
                },
                .{
                    .mod = &.{.Super},
                    .key = .K,
                    .cmd = "focus-view previous",
                },
                // Super+Shift+{J,K} to swap focused view with the next/previous view in the layout stack
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .J,
                    .cmd = "swap previous",
                },
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .K,
                    .cmd = "swap next",
                },

                // Alt+{P,N} to focus next/previous available display output
                .{
                    .mod = &.{.Alt},
                    .key = .P,
                    .cmd = "focus-output previous",
                },
                .{
                    .mod = &.{.Alt},
                    .key = .N,
                    .cmd = "focus-output next",
                },
                // Alt+Shift+{P,N} to send the focused view to next/previous available display output
                .{
                    .mod = &.{ .Alt, .Shift },
                    .key = .P,
                    .cmd = "send-to-output previous",
                },
                .{
                    .mod = &.{ .Alt, .Shift },
                    .key = .N,
                    .cmd = "send-to-output next",
                },
                // Super+Shift+E to bump the focused view to the top of the layout stack
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .E,
                    .cmd = "zoom",
                },
                // Super+{H,L} to decrease/increase the main_factor value of rivertile by 0.02
                .{
                    .mod = &.{.Super},
                    .key = .H,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-ratio -0.02'
                    ,
                },
                .{
                    .mod = &.{.Super},
                    .key = .L,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-ratio +0.02'
                    ,
                },
                // Super+Shift+{H,L} to increment/decrement the main_count value of rivertile
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .H,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-count -1'
                    ,
                },
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .L,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-count +1'
                    ,
                },
                // Control+Alt+{H,J,K,L} ie control in which direction the main area is positioned
                .{
                    .mod = &.{ .Control, .Alt },
                    .key = .H,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-location left'
                    ,
                },
                .{
                    .mod = &.{ .Control, .Alt },
                    .key = .J,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-location bottom'
                    ,
                },
                .{
                    .mod = &.{ .Control, .Alt },
                    .key = .K,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-location top'
                    ,
                },
                .{
                    .mod = &.{ .Control, .Alt },
                    .key = .L,
                    .cmd =
                    \\send-layout-cmd rivertile 'main-location right'
                    ,
                },
                // Super+Alt+{H,J,K,L} to move views (floating)
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .H,
                    .cmd = "move left 100",
                },
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .J,
                    .cmd = "move down 100",
                },
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .K,
                    .cmd = "move up 100",
                },
                .{
                    .mod = &.{ .Super, .Alt },
                    .key = .L,
                    .cmd = "move right 100",
                },
                // Super+Control+{H,J,K,L} to resize views (floating)
                .{
                    .mod = &.{ .Super, .Control },
                    .key = .H,
                    .cmd = "resize horizontal -100",
                },
                .{
                    .mod = &.{ .Super, .Control },
                    .key = .J,
                    .cmd = "resize vertical -100",
                },
                .{
                    .mod = &.{ .Super, .Control },
                    .key = .K,
                    .cmd = "resize vertical 100",
                },
                .{
                    .mod = &.{ .Super, .Control },
                    .key = .L,
                    .cmd = "resize horizontal 100",
                },
                // Super+Alt+Control+{H,J,K,L} to snap views to screen edges (floating)
                .{
                    .mod = &.{ .Super, .Alt, .Control },
                    .key = .H,
                    .cmd = "snap left",
                },
                .{
                    .mod = &.{ .Super, .Alt, .Control },
                    .key = .J,
                    .cmd = "snap down",
                },
                .{
                    .mod = &.{ .Super, .Alt, .Control },
                    .key = .K,
                    .cmd = "snap up",
                },
                .{
                    .mod = &.{ .Super, .Alt, .Control },
                    .key = .L,
                    .cmd = "snap right",
                },
                // Super+Space to toggle float
                .{
                    .mod = &.{.Super},
                    .key = .Space,
                    .cmd = "toggle-float",
                },
                // Super+F to toggle fullscreen
                .{
                    .mod = &.{.Super},
                    .key = .F,
                    .cmd = "toggle-fullscreen",
                },
                // Sets tags to their previous value on the currently focused output, allowing jumping back and forth between 2 tag setups.
                .{
                    .mod = &.{.Super},
                    .key = .Tab,
                    .cmd = "focus-previous-tags",
                },
                // Assign the currently focused view the previous tags of the currently focused output.
                .{
                    .mod = &.{ .Super, .Shift },
                    .key = .Tab,
                    .cmd = "send-to-previous-tags",
                },
            },
        };

        const locked_mappings = Map{
            .locked = &.{
                // Eject optical drives
                .{
                    .mod = &.{.None},
                    .key = .XF86Eject,
                    .cmd =
                    \\spawn 'eject -T'
                    ,
                },
                // Control pipewire volume
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioRaiseVolume,
                    .cmd = fmt(
                        self.arena,
                        \\spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ -l {[vol]d:.[precision]}'
                    ,
                        .{
                            .vol = self.options.max_volume,
                            .precision = 2,
                        },
                    ),
                    .opt = .repeat,
                },
                // To lower the volume
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioLowerVolume,
                    .cmd = fmt(
                        self.arena,
                        \\spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- -l {[vol]d:.[precision]}'
                    ,
                        .{
                            .vol = self.options.max_volume,
                            .precision = 2,
                        },
                    ),
                    .opt = .repeat,
                },
                // To mute/unmute the volume
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioMute,
                    .cmd =
                    \\spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
                    ,
                },
                // To mute/unmute the microphone
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioMicMute,
                    .cmd =
                    \\spawn 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'
                    ,
                },
                // Control MPRIS aware media players with 'mpc'
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioStop,
                    .cmd =
                    \\spawn 'mpc stop'
                    ,
                },
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioPause,
                    .cmd =
                    \\spawn 'mpc pause'
                    ,
                },
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioPlay,
                    .cmd =
                    \\spawn 'mpc toggle'
                    ,
                },
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioPrev,
                    .cmd =
                    \\spawn 'mpc prev'
                    ,
                },
                .{
                    .mod = &.{.None},
                    .key = .XF86AudioNext,
                    .cmd =
                    \\spawn'mpc next'
                    ,
                },
                // Control screen backlight brightness
                .{
                    .mod = &.{.None},
                    .key = .XF86MonBrightnessUp,
                    .cmd =
                    \\spawn 'brightnessctl set 1%+'
                    ,
                    .opt = .repeat,
                },
                .{
                    .mod = &.{.None},
                    .key = .XF86MonBrightnessDown,
                    .cmd =
                    \\spawn 'brightnessctl set 1%-'
                    ,
                    .opt = .repeat,
                },
            },
        };

        // Mappings for pointer (mouse)
        const pointer_mapping = Map{
            .normal = &.{
                // Super + Left Mouse Button to move views
                .{
                    .mod = &.{.Super},
                    .key = .BTN_LEFT,
                    .cmd = "move-view",
                },
                // Super + Right Mouse Button to resize views
                .{
                    .mod = &.{.Super},
                    .key = .BTN_RIGHT,
                    .cmd = "resize-view",
                },
            },
        };

        normal_mappings.run(self.arena, .map);
        locked_mappings.run(self.arena, .map);
        pointer_mapping.run(self.arena, .@"map-pointer");
    }

    fn user_mode(self: Run) void {
        // set $power_mangement "(s)uspend,hy(b)rid-sleep,(h)ibernate,(r)eboot,suspend-(t)hen-hibernate,(l)ock,(R)UEFI,(S)hutdown"
        const UserMode = struct {
            const Enter =
                struct {
                mod: Mod,
                key: Key,
            };
            const Exit = Enter;

            name: []const u8,
            enter: Enter,
            cmds: []const Command,
            exit: Exit,

            fn declare_mode(arena: Allocator, mode_name: []const u8) void {
                Run.run(arena, fmt(
                    arena,
                    "riverctl declare-mode {[declared_mode]s}",
                    .{ .declared_mode = mode_name },
                ));
            }

            fn enter_mode(
                arena: Allocator,
                mode_name: []const u8,
                enter: Enter,
            ) void {
                Run.run(arena, fmt(
                    arena,
                    "riverctl map normal {[mod]s} {[key]s} enter-mode {[declared_mode]s}",
                    .{
                        .mod = @tagName(enter.mod),
                        .key = @tagName(enter.key),
                        .declared_mode = mode_name,
                    },
                ));
            }

            fn exit_mode(
                arena: Allocator,
                mode_name: []const u8,
                exit: Exit,
            ) void {
                Run.run(
                    arena,
                    fmt(arena, "riverctl map {[declared_mode]s} {[mod]s} {[key]s} enter-mode normal", .{
                        .declared_mode = mode_name,
                        .mod = @tagName(exit.mod),
                        .key = @tagName(exit.key),
                    }),
                );
            }

            fn run(mode: @This(), arena: Allocator) void {
                declare_mode(arena, mode.name);
                enter_mode(arena, mode.name, mode.enter);
                exit_mode(arena, mode.name, mode.exit);

                for (mode.cmds) |cmd| {
                    Run.run(arena, fmt(arena,
                        \\riverctl map {[declared_mode]s} {[mod]s} {[key]s} spawn "riverctl enter-mode normal  && {[cmd]s}"
                    , .{
                        .declared_mode = mode.name,
                        .mod = mod(arena, cmd.mod),
                        .key = @tagName(cmd.key),
                        .cmd = cmd.cmd,
                    }));
                }
            }
        };

        const power_management = UserMode{
            .name = "power_management",
            .enter = .{
                .mod = .Super,
                .key = .P,
            },
            .cmds = &.{
                .{
                    .mod = &.{.None},
                    .key = .S,
                    .cmd = "systemctl suspend",
                },
                .{
                    .mod = &.{.None},
                    .key = .T,
                    .cmd =
                    \\'swaynag -t warning -m "Sleepy time?!?!" -b "ZzZz..." "systemctl suspend-then-hibernate" -s "No"'
                    ,
                },
                .{
                    .mod = &.{.None},
                    .key = .B,
                    .cmd = "systemctl hybrid-sleep",
                },
                .{
                    .mod = &.{.None},
                    .key = .H,
                    .cmd = "systemctl hibernate",
                },
                .{
                    .mod = &.{.None},
                    .key = .R,
                    .cmd = "systemctl reboot",
                },
                .{
                    .mod = &.{.Shift},
                    .key = .R,
                    .cmd = "systemctl reboot --firmware-setup",
                },
                .{
                    .mod = &.{.Shift},
                    .key = .S,
                    .cmd = "systemctl poweroff -i",
                },
            },
            .exit = .{
                .mod = .None,
                .key = .Escape,
            },
        };

        // switch between 'passthrough' and 'normal' mode
        const passthrough = UserMode{
            .name = "passthrough",
            .enter = .{
                .mod = .Super,
                .key = .F11,
            },
            .cmds = &.{},
            .exit = .{
                .mod = .Super,
                .key = .F11,
            },
        };

        power_management.run(self.arena);
        passthrough.run(self.arena);
    }

    // Mappings for tag management
    // These mappings are repeated, so they are separated from the mappings table
    fn window_tags(self: Run) void {
        inline for (1..10) |tag| {
            const tag_mask = @shlExact(1, tag - 1);

            // Super+[1-9] to set specified tag output (tag-mask) as current focused tag output
            run(self.arena, fmt(
                self.arena,
                "riverctl map normal Super {[tag]d} set-focused-tags {[tag_mask]d}",
                .{ .tag = tag, .tag_mask = tag_mask },
            ));

            // Super+Shift+[1-9] to set/move focused view/window onto specified tag output [0-8]
            run(self.arena, fmt(
                self.arena,
                "riverctl map normal Super+Shift {[tag]d} set-view-tags {[tag_mask]d}",
                .{ .tag = tag, .tag_mask = tag_mask },
            ));

            // Super+Control+[1-9] to toggle (copying of specified) tag output [0-8] onto current focused tag output
            run(self.arena, fmt(
                self.arena,
                "riverctl map normal Super+Control {[tag]d} toggle-focused-tags {[tag_mask]d}",
                .{ .tag = tag, .tag_mask = tag_mask },
            ));

            // Super+Alt+[1-9] to toggle (sending a copy of) current focused view/window onto specified tag output [0-8]
            run(self.arena, fmt(
                self.arena,
                "riverctl map normal Super+Control+Shift {[tag]d} toggle-view-tags {[tag_mask]d}",
                .{ .tag = tag, .tag_mask = tag_mask },
            ));
        }

        // Super+0 to focus all tags
        // Super+Shift+0 to tag focused view/window with all tags
        // river has a total of 32 tags
        const all_tags_mask = @shlExact(1, 32) - 1;

        run(self.arena, fmt(
            self.arena,
            "riverctl map normal Super 0 set-focused-tags {[all_tags_mask]d}",
            .{ .all_tags_mask = all_tags_mask },
        ));

        run(self.arena, fmt(
            self.arena,
            "riverctl map normal Super+Shift 0 set-view-tags {[all_tags_mask]d}",
            .{ .all_tags_mask = all_tags_mask },
        ));
    }

    // Mappings for scratchpad tag management
    fn scratchpad_tags(self: Run) void {

        // The scratchpad will live on an unused tag. Which tags are used depends on your
        // config, but rivers default uses the first 9 tags.
        const scratch_tags = @shlExact(1, 21);

        // Toggle viewing the scratchpad on the current tag output with Super+S
        run(self.arena, fmt(
            self.arena,
            "riverctl map normal Super S toggle-focused-tags {[scratch_tags]d}",
            .{ .scratch_tags = scratch_tags },
        ));

        // Send view/window to the scratchpad with Super+Shift+S
        run(self.arena, fmt(
            self.arena,
            "riverctl map normal Super+Shift S set-view-tags {[scratch_tags]d}",
            .{ .scratch_tags = scratch_tags },
        ));

        // Set spawn tagmask to ensure new windows don't have the scratchpad tag unless explicitly set.
        const all_but_scratch_tags = ((1 << 32) - 1) ^ scratch_tags;

        run(self.arena, fmt(
            self.arena,
            "riverctl spawn-tagmask {[all_but_scratch_tags]d}",
            .{ .all_but_scratch_tags = all_but_scratch_tags },
        ));
    }

    fn workspace_rules(self: Run) void {
        // zig fmt: off
        const Action = enum {
            float, csd, tags, position,
            // @"no-float", ssd, output, 
            //dimensions, fullscreen, @"no-fullscreen",
        };
        // zig fmt: on

        const Rules = union(Action) {
            const Type = enum { @"-app-id", @"-title" };
            const Float = struct {
                type: Type,
                name: []const u8,
            };
            const Tag = struct {
                type: Type,
                name: []const u8,
                args: []const u8,
            };
            const Csd = Float;
            const Position = Tag;

            float: []const Float,
            csd: []const Csd,
            tags: []const Tag,
            position: []const Position,

            fn workspace(comptime tag: u32) u32 {
                return 1 << (tag - 1);
            }

            fn run(rules: @This(), arena: Allocator) void {
                switch (rules) {
                    inline .float, .csd => |frules, action| {
                        for (frules) |rule| {
                            Run.run(arena, fmt(
                                arena,
                                "riverctl rule-add {[rule_type]s} '{[pattern]s}' {[action]s}",
                                .{
                                    .rule_type = @tagName(rule.type),
                                    .pattern = rule.name,
                                    .action = @tagName(action),
                                },
                            ));
                        }
                    },
                    inline .tags, .position => |trules, action| {
                        for (trules) |rule| {
                            Run.run(arena, fmt(
                                arena,
                                "riverctl rule-add {[rule_type]s} '{[pattern]s}' {[action]s} {[arguments]s}",
                                .{
                                    .rule_type = @tagName(rule.type),
                                    .pattern = rule.name,
                                    .action = @tagName(action),
                                    .arguments = rule.args,
                                },
                            ));
                        }
                    },
                }
            }
        };

        const float = Rules{ .float = &.{
            .{
                .type = .@"-title",
                .name = "Extension*",
            },
            .{
                .type = .@"-title",
                .name = "Picture-in-Picture",
            },
            .{
                .type = .@"-title",
                .name = "About Mozilla*",
            },
            .{
                .type = .@"-title",
                .name = "Library*",
            },
        } };

        const csd = Rules{ .csd = &.{
            .{
                .type = .@"-app-id",
                .name = "firefox",
            },
        } };

        const tag = Rules{ .tags = &.{
            .{
                .type = .@"-app-id",
                .name = "firefox",
                .args = fmt(
                    self.arena,
                    "{d}",
                    .{Rules.workspace(2)},
                ),
            },
            .{ .type = .@"-app-id", .name = "mpv", .args = fmt(
                self.arena,
                "{d}",
                .{Rules.workspace(3)},
            ) },
        } };

        const position = Rules{ .position = &.{
            .{
                .type = .@"-title",
                .name = "Picture-in-Picture",
                .args = "0 0",
            },
        } };

        float.run(self.arena);
        tag.run(self.arena);
        csd.run(self.arena);
        position.run(self.arena);
    }

    fn rivertile(self: Run) noreturn {
        const env = std.process.getEnvMap(self.arena) catch unreachable;
        std.process.execve(self.arena, &.{
            "rivertile",
            "-view-padding",
            "0",
            "-outer-padding",
            "0",
            "-main-location",
            "left",
            "-main-count",
            "1",
            "-main-ratio",
            "0.6",
        }, &env) catch unreachable;
    }
};

pub fn main() !void {
    var buf: [1024 * 1024 * 1]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    var arena_allocator = std.heap.ArenaAllocator.init(fba.allocator());
    const arena = arena_allocator.allocator();

    const options = Options.init(arena);
    const run = Run.init(arena, options);

    run.autostart();
    run.oneshot();
    run.configure_input();
    run.river_options();
    run.mappings();
    run.user_mode();
    run.window_tags();
    run.scratchpad_tags();
    run.workspace_rules();
    run.gnome_settings();
    run.rivertile();
}
