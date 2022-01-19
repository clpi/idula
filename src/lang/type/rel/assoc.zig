const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;
const trait = @import("../trait.zig");
const Implementation = @import("../trait.zig").Implementation;
const ty = @import("../type.zig");
const Field = ty.Field;
const meta = @import("../meta.zig");
const Tag = meta.Tag;

// NOTE: associations, unlike relations, are necessarily undrirected
//       but act in the flexible and free-form hypergraph generalization
//       of high dimensionality graph data. associations can be made between
//       qualities, symbols, relations, constraints, etc.
pub const Association = struct {
    aid: str,
    bid: str,
    public: bool,
    mutable: bool,
    kind: AssociationType,
    const Self = @This();
};

pub const AssociationType = struct {
    ident: str,
    public: bool,
    qualities: std.BufSet,
    associations: std.BufMap,
    implementations: std.StringArrayHashMap(Implementation),
    tags: std.StringArrayHashMap(Tag),
    fields: std.StringArrayHashMap(Field),
    const Self = @This();

    pub fn init(a: Allocator, ide: []const u8) Self {
        return Self{ .ident = ide, .tags = std.StringArrayHashMap([]const u8).init(a) };
    }
};
