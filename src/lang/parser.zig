const std = @import("std.zig");
const meta = @import("std").meta;
const Token = @import("./token.zig");
const TokenList = Token.List;
const Lexer = @import("./lexer.zig");
const Cursor = @import("./lexer.zig").Cursor;
const Tag = meta.Tag;
const TagType = meta.TagType;
const Elem = meta.Elem;
const Child = meta.Child;
const ArgsTuple = meta.ArgsTuple;
const FieldEnum = meta.FieldEnum;
const Progress = std.Progress;
const ProgressNode = std.Progress.Node;
const trait = std.meta.trait;
const Allocator = std.mem.Allocator;

const Self = @This();
pub const Parser = @This();

pub const Error = error{
    OutOfMemory,
    InvalidStringLiteral,
};

pub const State = enum {
    ident,
    string,
    string_esc,
    char,
    comment_ln,
    comment_block,
    in_comment,
    doc_ln,
    doc_block,
    in_doc_ln,
    in_doc_block,

    plus,
    minus,
    equals,
    pipe,
    excl,
    ques,

    builtin,

    // pub const Info = union(State) {
    //
    // };
};

// pub const Current = union(State) {};

pub const Result = union(enum) {
    ok,
    err: ErrorInfo,
};

pub const ErrorInfo = union {
    invalid_character: usize,
    expected_hex_digits: usize,
    invalid_hex_escape: usize,
    invalid_unicode_escape: usize,
    missing_matching_rbrace: usize,
    expected_unicode_digits: usize,
};
