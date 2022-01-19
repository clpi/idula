const std = @import("std");

pub fn Graph(comptime N: type, comptime E: type) type {
    return struct {
        allocator: std.mem.Allocator,
        dir: Directed,

        pub const Directed = enum(u1) { directed, undirected };

        pub fn init(a: std.mem.Allocator) Graph {}
    };
}
