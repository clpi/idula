const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;
const ty = @import("./type.zig");
const Type = ty.Type;
const trait = @import("./trait.zig");
const keyword = @import("./token/keyword.zig");
const block = @import("./token/block.zig");
const op = @import("./token/op.zig");
const Keyword = keyword.Keyword;
const TypeVal = ty.TypeVal;
const Op = op.Op;
const Block = block.Block;

pub const Cursor = @import("./lexer.zig").Cursor;
const Self = @This();
pub const Token = Self;
pub const TokenKind = Kind;

kind: Token.Kind,
loc: Cursor,

pub const Id = u32;
pub const Entry = struct { tag: Tag, start: u32 };
pub const List = std.MultiArrayList(Token.Entry);

pub fn toIdent(self: Token) ?[]const u8 {
    return switch (self.kind) {
        .keyword => |kw| if (kw) |k| k.toStr() else null,
        .op => |o| if (o) |oper| oper.toStr() else null,
        .types => |typ| if (typ) |tt| tt.toStr() else null,
        .block => |blc| if (blc) |bl| bl.toStr() else null,
        Kind.unknown => null,
        Kind.eof => null,
    };
}

pub fn initType(t: Type, loc: Cursor) Token {
    return Token{ .kind = t, .loc = loc };
}
pub fn initKw(oper: Keyword, loc: Cursor) Token {
    return Token{ .kind = oper, .loc = loc };
}
pub fn initOp(oper: Op, loc: Cursor) Token {
    return Token{ .kind = oper, .loc = loc };
}

// TODO change to tag?
pub const Kind = Token.Tag;
pub const Tag = union(enum(u8)) {
    const Self = @This();
    op: Op,
    keyword: Keyword,
    block: Block,
    sym: ?ty.TypeVals,
    unknown,
    eof,
};

pub fn init() Token.Kind {
    return Token{
        .kind = .unknown,
    };
}

pub fn fromKind(kind: TokenKind) ?Self {
    switch (kind) {
        .op => return Token{ .kind = op },
        .sym => return Token{ .sym = TypeVal },
    }
}

// pub fn isOp(self: Token) bool {
//     return false;
// }
// pub fn isKeyword(self: Token) bool {
//     return false;
// }

pub const Rel = enum { start, end };
