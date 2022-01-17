const std = @import("std");
const trait = std.meta.trait;
const Allocator = std.mem.Allocator;

pub const Keyword = union(enum(u8)) {
    //NOTE: loop declarations
    @"for",
    @"while",
    repeat,
    every,
    loop,

    // NOTE: async/timing statements
    @"await",
    @"async",
    @"defer",
    wait,
    start,
    then,
    expect,
    future,
    promised,
    awaited,
    put,

    //NOTE: modifiers/qualifiers
    //  - PRECEDES the symbol ident
    local,
    all,
    any,
    one,
    once,
    @"async",
    @"pub",
    @"var",
    //NOTE: Structure prop declarations
    //  - FOLLOWS the symbol ident

    has,
    is,
    can,
    will,
    does,
    must,
    uses,

    //NOTE: statements
    @"try",
    exclude,
    include,
    end,
    doc,
    del,
    new,
    def,
    do,
    use,
    put,
    let,
    get,
    mod, // for module/namespaces
    alias,
    @"break",
    @"continue",
    @"await",

    // NOTE: Question/settings words
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
    @"test",
    bench,
    @"enum",
    valenum,
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
    types: @import("./keyword/type.zig").Type,

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
