const std = @import("std");
const Allocator = std.mem.Allocator;
const str = []const u8;
const trait = std.meta.TagType;

pub fn Table(comptime T: type) type {
    return struct {
        datatype: T,
    };
}

pub const ETable = struct {};
