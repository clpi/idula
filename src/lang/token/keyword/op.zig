//! Keywords which are effectively operators
//! and may overlap (likely do) with a symbolic operator's 
//! function.

const std = @import("std");
const Allocator = std.mem.Allocator;
const str = []const u8;

pub const Op = enum(u8) {
    none,
};
