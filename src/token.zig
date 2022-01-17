const std = @import("std");
const Allocator = std.mem.Allocator;
const ty = @import("./type.zig");
const trait = @import("./trait.zig");
const keyword = @import("./token/keyword.zig");
const block = @import("./token/block.zig");
const op = @import("./token/op.zig");
const Keyword = keyword.Keyword;
const TypeVals = ty.TypeVals;
const Op = op.Op;
const Block = block.Block;

pub const TokenKind = union(enum(u8)) {
    op: Op,
    keyword: Keyword,
    block: Block,
    value: ?ty.TypeVals,
    unknown,
    eof,
};

pub const Token = struct {
    kind: TokenKind,
};

pub const Rel = enum { start, end };
