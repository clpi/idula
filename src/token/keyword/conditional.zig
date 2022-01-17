const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Conditional = enum(u8) {
    @"if", //
    iff, // if and only if
    @"else",
    else_if,
    @"and", // -- NOTE: boolean ops --
    @"or", // bool op
    is, // NOTE: ops checking for constraints
    is_not,
};
