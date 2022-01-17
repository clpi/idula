const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;
const ty = @import("./type.zig");
const trait = @import("./trait.zig");
const keyword = @import("./token/keyword.zig");
const block = @import("./token/block.zig");
const op = @import("./token/op.zig");
const Keyword = keyword.Keyword;
const TypeVal = ty.TypeVal;
const Op = op.Op;
const Block = block.Block;

pub const TokenKind = union(enum(u8)) {
    const Self = @This();
    op: Op,
    keyword: Keyword,
    block: Block,
    sym: ?ty.TypeVals,
    unknown,
    eof,
};

pub const Token = struct {
    const Self = @This();
    kind: TokenKind,

    pub fn init() TokenKind {
        return Token{
            .kind = .unknown,
        };
    }

    pub fn fromKind(kind: TokenKind) ?Token {
        switch (kind) {
            .op => return Token{ .kind = op },
            .sym => return Token{ .sym = TypeVal },
        }
    }
};

pub const Rel = enum { start, end };
