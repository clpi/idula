const std = @import("std");
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
