const str = []const u8;
const std = @import("std");
const meta = @import("../type/meta.zig");
const Scope = @import("../type/env.zig").Scope;
const Tag = meta.Tag;
const Pair = meta.Pair;
const Allocator = std.mem.Allocator;
const @"type" = @import("../type.zig");
const traits = @import("../trait.zig");
const Trait = traits.Trait;
const Field = @"type".Field;
const Method = @"type".Method;
const Type = @"type".Type;
const Sym = @"type".Symbol;
const trait = std.meta.trait;
const Quality = @import("./qualities.zig").Quality;
const Capability = @import("../type/modifiers/capability.zig").Capability;
const Constraint = traits.Constraint;
const Association = traits.Association;

pub const Symbol = struct {
    const Relation = @import("../type.zig").Relation;
    sid: str = id: {
        var b: [36]u8 = undefined;
        std.rand.DefaultCsprng.fill(&b);
        break :id b;
    },
    name: ?[]const u8,
    scope: []const u8,
    public: bool = false,
    variable: bool = false,
    optional: bool = false,
    type: Type,
    rel: Relation,

    fields: std.StringArrayHashMap(Field),
    methods: std.StringArrayHashMap(Method),
    // implementations: std.StringArrayHashMap(Implementation),
    traits: std.StringArrayHashMap(Trait),
    qualities: std.StringArrayHashMap(Quality),
    constraints: std.StringArrayHashMap(Quality),
    // capabilities: std.StringArrayHashMap(Capabilities),

    tags: std.ArrayList(Tag),

    const Self = @This();

    pub fn init(a: Allocator, name: ?str, scope: Scope, tt: Type, rel: Relation) Symbol {
        return Self{
            .name = name,
            .scope = scope,
            .optional = false,
            .variable = false,
            .public = false,
            .type = tt,
            .rel = rel,
            .fields = std.StringArrayHashMap(Field).init(a),
            .methods = std.StringArrayHashMap(Method).init(a),
            .traits = std.StringArrayHashMap(Trait).init(a),
            // .implementations = std.StringArrayHashMap(Implementation).init(a),
            .fields = std.StringArrayHashMap(Field).init(a),
            .qualities = std.StringArrayHashMap(Quality).init(a),
            .constraints = std.StringArrayHashMap(Constraint).init(a),
            // .capabilities = std.StringArrayHashMap(Capabilities).init(a),
            .tags = std.ArrayList(Tag).init(a),
        };
    }
};

pub const SymbolRel = union(enum(u8)) {
    can: .{ str, str }, // type instance -> trait instance
    has_data: .{ str, str }, // type instance -> field ident
    can_do: .{ str, str }, // type instance -> funcinstance
    parent_of: .{ str, str }, // type instance 1 <-> type instance 2
    child_of: .{ str, str }, // type instance 1 <-> type instance 2
};

pub const SymbolDebug = struct {
    ident: ?str,
    // pos: Cursor,
    type: Type,
};
