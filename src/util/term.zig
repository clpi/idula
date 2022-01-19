// NOTE: This file is meant to represent and encapsulate
// the system terminal. should be imported as const Term = @import("root/term.zig");
const Self = @This();

const std = @import("std");
const TTY = std.debug.TTY;
const os = std.os;
const xos = std.x.os;
const builtin = std.builtin;
const str = []const u8;

config: Config,
target: std.Target,
color_support: Color.Support,
shell: Shell,

pub const Fmt = struct {
    pos: Style.Position = .fg,
    bright: Color.Brightness = .bright,
    color: ?Color = null,
    style: ?Style = null,

    pub const fg = Position.fg;
    pub const bg = Position.bg;
    pub const Position = enum(u1) { 
        fg, bg,
        pub fn(p: @This()) str { return if (p == .fg) "3" else "4"; }
    };
    
    pub fn reset() str {
        return "x1b[0m";
    }
};

pub const Config = struct {
    const Self = @This();
    tty_conf: std.debug.detectTTYConfig(),
    mode: std.io.Mode = .blocking,
    tty: std.debug.TTY,
    termios: ?std.os.termios = null,

    pub fn default() Config {
        return Config{};
    }

    pub const ColorSupport = enum(u8) {
        c8, c16, c256,
    };


    pub const ColorSupport = enum(u4) {
        c8, c16, c256,
    };
};

pub const Color = union(Config.ColorSupport) {

    const Self = @This();
    const Scheme = std.enums.EnumMap;
    // black, white, red, green, yellow, blue, purple, cyan, none, custom,
    c8: Color.@"8Color" = .default,
    c16: struct {
        color: Color.@"8Color" = .default,
        bright: bool,
    },
    c256: struct {
        red: u16,
        green: u16,
        blue: u16
    },

    pub const @"8Color" = enum(u3) {
        black, white, red, green, yellow, blue, purple, cyan,

        pub const Code = union(Color.@"8Color") {
            black: str = "0",
            white: str =  "7",
            red: str = "2",
            green: str = "3",
            yellow: str = "4",
            blue: str = "5",
            purple: str = "6",
            config: void,
        };
    };

    pub const @"8Color" = enum(u4) {
        black, white, red, green, yellow, blue, purple, cyan, default, custom,
    };

    pub const @"256Color" = union(enum) {
        hex: str  = "#FFFFFF",
        hexa: str = "#FFFFFFFF",
        rgb: Rgb = Rgb.init(255, 255, 255),
        rgba: Rgba = Rgba.init(255, 255, 255, 100),
    };

    pub const Rgb = packed struct {
        red: u16 = 255,
        green: u16 = 255,
        blue: u16 = 255,

        pub fn init(r: u16, g: u16, b: u16) !Rgb {
            if (r > 255 or g > 255 or b > 255) 
                return TermFmtError.RgbValueOver255;
            return Rgb { .red = r, .green = g, .blue = b};
        }
    };

    pub const Rgba = packed struct {
        color: Color.Rgb = Rgb.init(255, 255, 255) catch Rgb { },
        alpha: u16 = 100,

        pub fn init(r: u16, g: u16, b: u16, a: u16) !Rgba {
            if (a > 100) return TermFmtError.RgbaAlphaOver100;
            return Rgba { .rgb = try Rgb.init(r, g, b), .a = a };
        }
    };

    pub const bright = Brightness { .bright = true };

    pub const Brightness = union {
        bright: bool = false,
        percent_int: u16 = 100,
    };
};


pub const Styled = struct {
    styling: Styling = Style.default(),
    color: Color = Color.default,
    term: Config = Config.default(),
    pos: Position = .fg,


    const Self = @This();

};

pub const Style = enum(u4) {
    bold,
    underlined,
    reversed,
    blink,
    strikethrough,
    dim,
    none,
    reset,

    pub const default = Style.none;

    pub const Code = union(Styling) {
        default: str = "m",
        bold: str =  ";1m",
        underlined: str = ";4m",
        reversed: str = ";5m",
        blink: str = ";0m",
        strikethrough: str = ";0m",
        dim: str = ";0m",
        none: void,

    };
};

pub const Status = enum(u8) {
    ok, warn, err, hint, default,

    const Self = @This();
    const Spec = std.enums.EnumMap(Status, Fmt);

    pub const Spec = std.enums.EnumMap(Status) {

    };

    pub const Debug = union(Status) {

    };

    pub const StatusComponent = enum (u8) {

    };

    pub const Fmt = union(Status) {
        ok: []const u8 = "",
        warn: []const u8 = "",
        err: void,
        hint: void,
        default: void,
    };

    // NOTE: returns style correspondingto 
    pub fn style(status: Status) []const u8 {
        return switch (status) {
            .ok => "\x1b["
            .err => "",
            .warn => "",
            .hint => "",
            .default = 
        };
    };

    pub fn bold


};

pub const Color = enum(u8) {
    black, red, green, yellow, blue, purple, cyan
};


pub const COLOR_PRE = "x1b[";
pub const FG_PRE = "3";
pub const BG_PRE = "4";

pub cons tFmtError = error{
    InvalidHex,
    RgbValueOver255,
    RgbaAlphaOver100,
} 
    || std.os.TermiosSetError 
    || std.os.TermiosGetError;

pub const Shell = enum(u4) {
    sh, bash, zsh, python, fish, elvsh, nu, 
};

pub const Colors = Color.@"8Color";

    pub const code_default: str = "m";
    pub const code_bold: str =  ";1m";
    pub const code_underlined: str = ";4m";
    pub const code_reversed: str = ";5m";
    pub const code_strikethrough: str = ";5m";
    pub const code_dim: str = ";5m";

