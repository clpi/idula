const std = @import("std");
const builtin = @import("builtin");
const logger = std.log.scoped(.util);
const Allocator = std.mem.Allocator;
const symbol = @import("../../table/symbol.zig");
const scope = @import("../../table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const ty = @import("../../type.zig");
const Duration = ty.Duration;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;
const @"type" = @import("../type.zig");
const Field = ty.Field;
const Method = ty.Method;

pub const Capability = struct {
    name: []const u8,
    ident: str,
    has_fields: std.StringHashMap(Field),
    has_methods: std.StringHashMap(Method),

    const Self = @This();
    pub fn init(name: []const u8) Self {
        return Self{ .name = name };
    }
};
