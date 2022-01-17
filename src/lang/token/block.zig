const std = @import("std");
const str = []const u8;
const token = @import("../token.zig");
const util = @import("../../util.zig");
const eq = util.eql;
const Rel = token.Rel;

pub const Block = union(enum(u8)) {
    paren: Rel,
    brace: Rel,
    bracket: Rel,
    str: Str,

    pub fn toStr() []const u8 {
        return "";
    }

    pub fn fromStr(s: str) ?Block {
        if (Str.fromStr(s)) |st1| {
            return Block.str(st1);
        } else if (Cmt.fromStr(s)) |st2| {
            return Block.cmt(st2);
        } else if (Doc.fromStr(s)) |st3| {
            return Block.cmt(st3);
        } else return null;
    }
};
pub const Cmt = union(enum(u8)) {
    cmt_ln,
    cmt_block,

    pub fn fromStr(s: str) ?Cmt {
        if (eq(s, "--")) return Cmt.cmt_ln;
        if (eq(s, "--:")) return Cmt{ .cmt_block = Rel.start };
        if (eq(s, ";--")) return Cmt{ .cmt_block = Rel.end };
        return null;
    }
};
pub const Doc = union(enum(u8)) {
    doc_top,
    doc_ln,
    doc_block,
};
pub const Meta = union(enum(u8)) {
    meta_tag,
    meta_pair,
    meta_block,
    meta_dev,

    pub fn fromStr(s: str) ?Meta {
        if (eq("#:", s)) return .char else if (eq("}", s)) return .byte;
        if (eq("[", s)) return .str else if (eq("]", s)) return .bytes;
        if (eq("(", s)) return .raw_str else if (eq(")", s)) return .path_str;

        if (eq("f\"", s)) return .fmt_str else if (eq("e\"")) return .escaped_str;
        if (eq("`", s)) return .btick else if (eq("```")) return .multiline_btick;
        if (eq("r\"\"", s)) return .raw_multiline else if (eq("f\"\"")) return .fmt_multiline;
        if (eq("\"\"\"", s)) return .multiline;
        return null;
    }
};
pub const Code = union(enum(u8)) {
    paren: Rel,
    arrow: Rel, // ref: <, >
    brace: Rel,
    bracket: Rel,

    pub fn fromStr(s: str) ?Code {
        if (eq("{", s)) return .char else if (eq("}", s)) return .byte;
        if (eq("[", s)) return .str else if (eq("]", s)) return .bytes;
        if (eq("(", s)) return .raw_str else if (eq(")", s)) return .path_str;

        if (eq("f\"", s)) return .fmt_str else if (eq("e\"")) return .escaped_str;
        if (eq("`", s)) return .btick else if (eq("```")) return .multiline_btick;
        if (eq("r\"\"", s)) return .raw_multiline else if (eq("f\"\"")) return .fmt_multiline;
        if (eq("\"\"\"", s)) return .multiline;
        return null;
    }
};
pub const Str = enum(u8) {
    char,
    byte,
    str,
    bytes,
    fmt_str,
    raw_str,
    path_str,
    multiline_str,
    escaped_str,
    btick,
    multiline_btick,

    pub fn fromStr(s: str) ?Str {
        if (eq("\'", s)) return .char else if (eq("b\'", s)) return .byte;
        if (eq("\"", s)) return .str else if (eq("b\"")) return .bytes;
        if (eq("r\"", s)) return .raw_str else if (eq("p\"")) return .path_str;
        if (eq("f\"", s)) return .fmt_str else if (eq("e\"")) return .escaped_str;
        if (eq("`", s)) return .btick else if (eq("```")) return .multiline_btick;
        if (eq("r\"\"", s)) return .raw_multiline else if (eq("f\"\"")) return .fmt_multiline;
        if (eq("\"\"\"", s)) return .multiline;
        return null;
    }
};
