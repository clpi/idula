const std = @import("std");
const cli = @import("cli.zig");
const eql = std.mem.eql;
const Allocator = std.mem.Allocator;
const builtin = @import("builtin");
const stderr = std.io.getStdErr();
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const a = init: {
        if (comptime builtin.target.isWasm()) {
            break :init gpa.allocator();
        } else {
            break :init std.heap.c_allocator;
        }
    };
    var args = std.process.args();
    _ = args.skip();
    const c1 = if (try args.next(a)) |cs| cs else "help";
    const c2: ?[]const u8 = try args.next(a);
    const cmd: cli.Cmd = try cli.Cmd.fromStr(c1);
    const ags: []const []const u8 = try cli.parse_args(a, &args);
    std.log.info("cmd is {s}", .{cmd});
    try cmd.exec(a, c2, ags);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
