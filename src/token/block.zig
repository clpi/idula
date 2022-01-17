const std = @import("std");
const token = @import("../token.zig");
const util = @import("../util.zig");
const Rel = token.Rel;

pub const Block = union(enum(u8)) {
    paren: Rel,
    arrow: Rel, // ref: <, >
    brace: Rel,
    bracket: Rel,
};
pub const Cmt = union(enum(u8)) {
    cmt_ln,
    cmt_block,
};
pub const Doc = union(enum(u8)) {
    doc_top,
    doc_ln,
    doc_block,
};
pub const Arrays = union(enum(u8)) {
    squote,
    dquote,
    btick,
};
pub const Meta = union(enum(u8)) {
    meta_tag,
    meta_pair,
    meta_block,
    meta_dev,
};
pub const Code = union(enum(u8)) {
    paren: Rel,
    arrow: Rel, // ref: <, >
    brace: Rel,
    bracket: Rel,
};
