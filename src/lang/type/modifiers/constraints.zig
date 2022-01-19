const std = @import("std");
const builtin = @import("builtin");
const logger = std.log.scoped(.util);
const Allocator = std.mem.Allocator;
const symbol = @import("../../table/symbol.zig");
const scope = @import("../../table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;
const @"type" = @import("../../type.zig");
const traits = @import("../../trait.zig");
const Field = @"type".Field;
const Method = @"type".Method;
const Duration = @"type".Duration;

pub const Constraint = struct {
    name: []const u8,
    const Self = @This();
    pub fn init(name: []const u8) Self {
        return Self{ .name = name };
    }
};
