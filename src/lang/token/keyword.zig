const std = @import("std");
const meta = @import("std").meta;
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
const KwType = @import("./keyword/type.zig").KwType;
const KwBlock = @import("./keyword/block.zig").KwBlock;
const KwOp = @import("./keyword/type.zig").KeywordType;

pub const Keywords = union(enum) {
    type: KwType,
    block: KwBlock,
    op: KwOp,
};

// NOTE: Considering breaking up into categories of keywrods...
// NOTE: Keyword Token type
pub const Keyword = enum(u8) {
    //NOTE: loop declarations (statement:: modifier:: scope:: block)
    @"for",
    @"while",
    repeat,
    every,
    loop,

    // NOTE: async/timing statements (statement::modifier:[process, scope::block])
    @"await",
    @"defer",
    wait,
    start,
    then,
    expect,
    future,
    promised,
    awaited,

    //NOTE: modifiers/qualifiers [statement:: modifier:: *]
    //  - PRECEDES the symbol ident
    //  - AFTER declaration statement
    //  - Can be used as discriminators or conditional matches
    local,
    new, // + prefix, new keyword

    auto, //
    all,
    any,
    one,
    once,
    @"async",
    @"pub",
    @"var",
    //NOTE: Structure prop declarations
    //  - FOLLOWS the symbol ident

    // NOTE: modifier suffix statement operators:
    // essentially, builtin prototype methods all actualized symbols can call (since all labels declared entail the symbol actor)
    //
    has,
    is,
    can,
    will,
    does,
    must,
    uses,

    //NOTE: statement (builtin ops: statement:: active:: process)
    @"try",
    exclude,
    include,
    end,
    doc,
    del,
    def,
    do,
    use,
    put,
    let,
    get,
    put,
    mod, // for module/namespaces
    alias,
    @"break",
    @"continue",
    @"await",

    // NOTE: Question/settings words [statement:: clausal:: conditional]
    who,
    whom,
    which,
    where,
    what,
    how,
    when,
    must,

    // NOTE: Descriptive words
    like,
    until,
    assoc,
    with,
    finally,
    without,
    only,

    // NOTE: Descriptive nouns
    parent,
    child,
    meta,
    env,
    symbol,
    link,
    relation,
    quality,
    abstract,
    compiler,

    // NOTE: past tense
    did,
    had,
    used,
    could,
    would,
    could_have,
    would_have,
    had_to,

    //NOTE: structure qua structure decl
    scope,
    @"test",
    bench,
    @"enum",
    tagged,
    @"type",
    @"trait",
    meta, // for compiler/metadata (tag, pair) decl

    // NOTE: conditional statements
    @"if", //
    iff, // if and only if
    @"else",
    else_if,
    @"and", // -- NOTE: boolean ops --
    @"or", // bool op
    is, // NOTE: ops checking for constraints
    is_not,
    child_of,
    parent_of,
    assoc_with,
    can_do,
    cannot_do,
    does_do,
    does_not_do,
    has_field,
    has_no_field,
    whenever, // NOTE: conditional ctx
    wherever,
    however,

    implements,
    type_of, // type
    exists,
    not,
    never,

    //NOTE: type keywords

    // NOTE: reserved type values

    //NOTE: misc
    compiler, // have some compiler operator
    with,
    redo,
    that,
    this,
    by,
    so,
    in,
    to,
    do,
    be,
    of,
    off,
    on,
    as,

    pub fn insert(kw: []const u8) bool {
        const kwset = std.enums.EnumSet(Keyword);
        return &kwset.insert(kw);
    }
    pub fn contains(kw: []const u8) bool {
        const kwset = std.enums.EnumSet(Keyword);
        return kwset.contains(kw);
    }
};

pub const kw_map = std.ComptimeStringMap(Tag, .{
    .{ "addrspace", .keyword_addrspace },
    .{ "align", .keyword_align },
    .{ "allowzero", .keyword_allowzero },
    .{ "and", .keyword_and },
    .{ "anyframe", .keyword_anyframe },
    .{ "anytype", .keyword_anytype },
    .{ "asm", .keyword_asm },
    .{ "async", .keyword_async },
    .{ "await", .keyword_await },
    .{ "break", .keyword_break },
    .{ "callconv", .keyword_callconv },
    .{ "catch", .keyword_catch },
    .{ "comptime", .keyword_comptime },
    .{ "const", .keyword_const },
    .{ "continue", .keyword_continue },
    .{ "defer", .keyword_defer },
    .{ "else", .keyword_else },
    .{ "enum", .keyword_enum },
    .{ "errdefer", .keyword_errdefer },
    .{ "error", .keyword_error },
    .{ "export", .keyword_export },
    .{ "extern", .keyword_extern },
    .{ "fn", .keyword_fn },
    .{ "for", .keyword_for },
    .{ "if", .keyword_if },
    .{ "inline", .keyword_inline },
    .{ "noalias", .keyword_noalias },
    .{ "noinline", .keyword_noinline },
    .{ "nosuspend", .keyword_nosuspend },
    .{ "opaque", .keyword_opaque },
    .{ "or", .keyword_or },
    .{ "orelse", .keyword_orelse },
    .{ "packed", .keyword_packed },
    .{ "pub", .keyword_pub },
    .{ "resume", .keyword_resume },
    .{ "return", .keyword_return },
    .{ "linksection", .keyword_linksection },
    .{ "struct", .keyword_struct },
    .{ "suspend", .keyword_suspend },
    .{ "switch", .keyword_switch },
    .{ "test", .keyword_test },
    .{ "threadlocal", .keyword_threadlocal },
    .{ "try", .keyword_try },
    .{ "union", .keyword_union },
    .{ "unreachable", .keyword_unreachable },
    .{ "usingnamespace", .keyword_usingnamespace },
    .{ "var", .keyword_var },
    .{ "volatile", .keyword_volatile },
    .{ "while", .keyword_while },
});
