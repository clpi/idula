const std = @import("std");
const io = std.io;

// pub const Term = @import("./util/term.zig");
pub const err = @import("./util/error.zig");
pub const memory = @import("./util/memory.zig");
pub const settings = @import("./util/settings.zig");
pub const uid = @import("./util/uid.zig");

// pub const Tfmt = term.TermFmt;
// pub const Status = term.Status;
// pub const Color = term.Color;
// pub const Style = term.Style;

pub const str = []const u8;
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const stderr = std.io.getStdErr();
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

pub fn tty_config() std.debug.TTY.Config {
    const cfg = std.debug.detectTTYConfig();
    return cfg;
}
pub fn eql(short: []const u8, match: []const u8) bool {
    return std.mem.eql(u8, short, match);
}
pub fn eq(short: []const u8, long: []const u8, match: []const u8) bool {
    return std.mem.eql(u8, short, match) or std.mem.eql(u8, long, match);
}
pub fn readFile(allocator: Allocator, path: []const u8) ![]const u8 {
    const src = try std.fs.cwd().readFileAlloc(allocator, path, 1_000_000);
    return src;
}

pub fn dump_strace() void {
    std.debug.dumpStackTrace();
}

pub fn single_thread() bool {
    return builtin.single_threaded;
}

pub fn is_wasm() void {
    const tgt = std.builtin.cpu.arch;
    return tgt == .wasm32;
}

/// Prompts user for a line of less than 2048 size from stdin
pub fn promptLn(a: std.mem.Allocator, prompt_fmt: []const u8, args: anytype) str {
    try stdout.write(prompt_fmt, args);
    const res = try stdin.reader().readUntilDelimiterOrEofAlloc(a, "\n", 2048);
    return res;
}

pub fn promptOk() void {}
