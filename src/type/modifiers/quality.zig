const std = @import("std");
const symbol = @import("../table/symbol.zig");
const Allocator = std.mem.Allocator;
const scope = @import("../table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const ty = @import("../type.zig");
const Duration = ty.Duration;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;

pub const Quality = struct {
    name: []const u8,
    tags: std.StringArrayHashMap([]const u8),
    const Self = @This();

    pub fn init(a: Allocator, ide: []const u8) Self {
        return Self{ .name = ide, .tags = std.StringArrayHashMap([]const u8).init(a) };
    }
};
