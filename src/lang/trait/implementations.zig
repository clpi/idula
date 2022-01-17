//! meant to be more different to traits than the label makes it sound. oh well.
//!     can occur when simply creating a new type that guards
//!     by ensuring some fields / methods are necessarily
//!     implemented
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

pub const Implementations = struct {
    sid: str,
    sident: ?str,
    list: std.ArrayList(Implementation),
};

pub const Implementation = struct {
    sid: str,
    sident: ?str,
    impl_id: str = str,
    impl_label: ?str,
    implemented_obj_id: str,
    implemented_type: ImplementationType,
    implemented_on: i64 = std.time.timestamp(),
    implenented_for: Duration,

    pub fn initTraitImpl(sym: Symbol, label: ?str, impl_obj_id: str) Implementation {
        var bf: []u8 = undefined;
        std.rand.DefaultPrng.random().bytes(&bf);
        return Implementation{
            .sid = sym.sid,
            .sident = sym.ident,
            .impl_id = bf,
            .impl_label = label,
            .implemented_obj_id = impl_obj_id,
            .implemented_type = ImplementationType.trait,
            .implemented_on = std.time.timestamp(),
            .implemented_for = Duration.forever,
        };
    }
};

pub const ImplementationType = enum(u8) {
    func,
    trait,
    field,
    quality,
    modifier,
    meta,
    hook,
    rule,
    assoc,
    link,
    rel,
};
