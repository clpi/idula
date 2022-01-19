const std = @import("std");
const event = std.event;
const debug = std.debug;
const str = []const u8;
const os = std.os;
const io = std.io;
const Allocator = std.mem.Allocator;

inline fn eloop() u8 {
    if (std.event.Loop.instance()) {}
}

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
