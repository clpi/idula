const std = @import("std");
const TTY = std.debug.TTY;
const str = []const u8;

pub const TermConfig = struct {
    tty_conf: std.debug.detectTTYConfig(),
    termios: std.os.termios,
};

pub const TermColorSupport = enum(u2) {
    c8,
    c16,
    c256
};

pub const COLOR_PRE = "x1b[";
pub const FG_PRE = "3";
pub const BG_PRE = "4";

pub const Style = struct {
    format: Style.Format = .    
    color: TermColor,
};

pub const Styling = union(enum) {
    default: str = "m",
    bold: str =  ";1m",
    underlined: str = ";4m";
    reversed: str = ";5m";
    strikethrough,
    dim,
};

pub const Color = union {
    
}

pub const Status = enum(u8) {
    ok, warn, err, hint, default,

    pub fn fgPre(status: Status) []const u8 {
        return switch (status) {
            .ok => "\x1b["
        }
    }

};

pub const TermColor = enum(u8) {
    black, red, green, yellow, blue, purple, cyan
};

pub const StatusFmt = union(Status) {
    ok: []const u8 
};
