const std = @import("std");
const Allocator = std.mem.Allocator;
const str = []const u8;

// NOTE: Generalized scope struct
pub const Scope = struct {
    sid: str,
    parent_sid: str,
    label: ?str,
    depth: usize,
    children: std.StringArrayHashMap(Scope),
    kind: ScopeType,
    const Self = @This();
    pub fn init(a: Allocator, lbl: ?str, parent_sid: str, parent_depth: str) Scope {
        var bf: []u8 = undefined;
        try std.rand.Gimli.fill(&bf);
        return Self{
            .sid = bf,
            .label = lbl,
            .depth = parent_depth + 1,
            .parent_sid = parent_sid, // NOTE: TODO after you've created scope tables
            .children = std.StringArrayHashMap(Scope).init(a), // NOTE: TODO after you've created scope tables
            .kind = ScopeType.global,
        };
    }
};

// NOTE: Global scope struct
pub const GlobalScope = struct {
    label: str = "global",
    depth: usize = 0,
    parent: ?Scope = null,
    kind: ScopeType.global,
};

pub const ScopeType = enum(u8) {
    global,

    norm_braces,
    norm_brackets,
    norm_parens,
    in_parens,

    // NOTE: Parenthesis
    in_param_parens,
    in_condition_parens,

    // NOTE: In meta block
    in_meta_block,

    // NOTE: In doc comments (should be noticed)
    in_doc_ln,
    in_doc_top_ln,
    in_doc_block,
    in_doc_top_block,

    in_loop_braces, //---
    //                   |
    in_for_braces, //  ------ NOTE: Should all be the same
    //                   |
    in_whil_braces, //---|

    // NOTE: pattern: TypeInst does {  ... method decl / implementation / specification... }
    in_does_braces,

    // NOTE: pattern: CustomStruct has {  ... fields decl / impl / spec .... }
    in_has_braces,

    // NOTE: pattern: CustomStruct can { ... capabilities / trait / constraints impl ... }
    in_can_braces,

    // NOTE: pattern: CustomStruct is { ... meta/attr / qualities / links / assoc/ rel/ impl ... }
    in_is_braces,
};
