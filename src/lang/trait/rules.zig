const std = @import("std");
const trait = @import("../trait.zig");
const Trait = trait.Trait;
const Allocator = std.mem.Allocator;
const str = []const u8;

/// NOTE: The implementation of one or more rules  
/// for a given trait
/// Haven't fully thought out rules yet
pub const Rule = struct {
    const Self = @This();
    ident: ?[]const u8,
    builtin: ?BuiltinRules,
};

/// NOTE: The implementation of one or more rules  
/// for a given trait
pub const RuleSet = struct {
    trait: Trait,
};
pub const RuleSet = struct {
    const Self = @This();
};

pub const BuiltinRules = enum(u16) {
    const Self = @This();
};

pub const RuleMeta = struct {
    const Self = @This();
    pub const RuleTypes = struct {};
};
