const std = @import("std");
const str = []const u8;
const buf = [:0]const u8;
const Allocator = std.mem.Allocator;
const ty = @import("./type.zig");
const trait = @import("./trait.zig");
const keyword = @import("./token/keyword.zig");
const block = @import("./token/block.zig");
const op = @import("./token/op.zig");
const Keyword = keyword.Keyword;
const Token = @import("./token.zig");
const TypeVal = ty.TypeVal;
const Op = op.Op;
const Block = block.Block;

pub const Lexer = @This();
pub const Self = @This();

pos: usize,
buf: [:0]const u8,
curr: Token,

pub const State = union(enum) {
    start,
    unknown,
    ident,
    string,
    builtin,
    equal,
    pipe,
    minus,
    keyword: Keyword, // includes type decl ?
    type_decl: Keyword.Type,

    op: Op,
    eof,
    type_val: Self.eof,
};

pub const Cursor = struct {
    line: usize,
    col: usize,
    const Self = @This();

    pub fn default() Cursor {
        return Cursor{ .line = 1, .col = 1 };
    }

    pub fn init(l: usize, c: usize) Cursor {
        return Cursor{ .line = l, .col = c };
    }
    pub fn newLine(self: *Cursor) void {
        self.line += 1;
        self.col = 1;
    }
    pub fn incrCol(self: *Cursor) void {
        self.col += 1;
    }

    pub fn incrLine(self: *Cursor) Cursor {
        self.line += 1;
    }
};

pub fn next(self: *Lexer) Token {
    if (!isValidToken(self.next)) return;

    return Token.init(.unknown);
}

pub fn isValidToken(tok: Token) bool {
    return tok.loc == Cursor.default();
}
