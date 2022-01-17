const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;
const Association = @import("./type/rel/assoc.zig").Association;
const Link = @import("./type/rel/link.zig").Link;
const Constraint = @import("./type/modifiers/constraints.zig").Constraint;
const Capability = @import("./type/modifiers/capability.zig").Capability;
const Quality = @import("./type/modifiers/quality.zig").Quality;
const @"type" = @import("./type.zig");
const Type = @"type".Type;
const Sym = @"type".Symbol;
const trait = std.meta.trait;

const Self = @This();

inp: [:0]const u8,
tokens: TokenList.Slice,
