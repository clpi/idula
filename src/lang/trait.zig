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

pub const Trait = struct {
    name: []const u8,
    scope: []const u8,
    public: bool,
    isvar: bool,
    assoc_type: std.ArrayList(Type),
    constraints: std.StringArrayHashMap(Constraint),
    capabilities: std.StringArrayHashMap(Capability),
    assoc: std.StringArrayHashMap(Association),
    links: std.StringArrayHashMap(Link),
    fields: std.StringArrayHashMap(Field),
    methods: std.StringArrayHashMap(Method),
    qualities: std.StringArrayHashMap(Quality),
    allocator: std.mem.Allocator,
    arena: std.heap.ArenaAllocator,
    const Self = @This();

    pub fn init(a: Allocator, name: []const u8, scope: []const u8, public: bool, isvar: bool) Trait {
        return Self{
            .name = name,
            .scope = scope,
            .isvar = isvar,
            .public = public,
            .assoc_type = std.ArrayList(Type).init(a),
            .links = std.StringArrayHashMap(Link).init(a),
            .constraints = std.StringArrayHashMap(Constraint).init(a),
            .capabilities = std.StringArrayHashMap(Capability).init(a),
            .assoc = std.StringArrayHashMap(Association).init(a),
            .fields = std.StringArrayHashMap(Field).init(a),
            .methods = std.StringArrayHashMap(Method).init(a),
            .allocator = a,
            .arena = std.heap.ArenaAllocator.init(a),
        };
    }

    pub const Method = struct {};
    pub const Field = struct {};
};
