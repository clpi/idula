const std = @import("std");
const symbol = @import("../table/symbol.zig");
const scope = @import("../table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const ty = @import("../type.zig");
const Duration = ty.Duration;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;
const @"type" = @import("../type.zig");
const Field = @"type".Field;
const Method = @"type".Method;
pub const Constraint = @import("./type/modifiers/constraints.zig").Constraint;
pub const Capability = @import("./type/modifiers/capability.zig").Capability;
pub const Quality = @import("./type/modifiers/quality.zig").Quality;

pub const Link = struct {
    name: []const u8,
    with: []const u8,
    const Self = @This();

    pub fn init(name: []const u8, with: []const u8) Quality {
        return Self{ .name = name, .with = with };
    }
};
