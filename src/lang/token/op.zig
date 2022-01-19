const token = @import("../token.zig");
const util = @import("../util.zig");
const eql = util.eql;
const Rel = token.Rel;

pub const Op = union(enum(u8)) {
    math: Math,
    meta: Meta,
    access: Access,
    constraint: Constraints,
    logic: Logic,
    cmp: Cmp,
    assign: Assign,
    range: Range,
    ref: Reference,
    lattr: LhsPrefix,
    rattr: RhsSuffix,
    rel: RelInfix,
    eof,
    newline,
    semicolon,

    const Self = @This();

    pub fn fromStr(s: []const u8) ?Op {
        switch (s[0]) {
            ';' => return Op.semicolon,
            '-' => switch (s[1]) {
                'a'...'z', 'A'...'Z', '0'...'9' => {
                    return null;
                },
            },
            '@' => switch (s[1]) {},
            '#' => switch (s[1]) {},
            '%' => switch (s[1]) {},
            '^' => switch (s[1]) {},
            '&' => switch (s[1]) {},
            '*' => switch (s[1]) {},
            '+' => switch (s[1]) {},
            '=' => switch (s[1]) {},
            '|' => switch (s[1]) {},
            '\\' => switch (s[1]) {},
            '/' => switch (s[1]) {
                '/' => return Op.dbl_fslash,
                '=' => return Op.dbl_fslash,
            },
            '\n' => switch (s[1]) {},
            '\t' => switch (s[1]) {},
            '`' => switch (s[1]) {},
            '~' => switch (s[1]) {},
            '.' => switch (s[1]) {
                '.' => switch (s[2]) {
                    '.' => return Op.range,
                    ':' => return Op.range_col,
                    '=' => return Op.range_inc,
                    '!' => return Op.range_exc,
                    else => return Op.range_pre,
                },
                ' ' => return Op.env_data,
            },
            ',' => switch (s[1]) {},

            '>' => switch (s[1]) {
                '=' => return Op.ge,
                '>' => return Op.dbl_gt,
                ' ', 'a'...'z', 'A'...'Z', '0'...'9', '_' => return Op.gt,
            },
            '<' => switch (s[1]) {
                '>' => return Op.abs,
                '=' => return Op.le,
                '-' => return Op.barrow,
                '<' => return Op.dbl_lt,
                ' ', 'a'...'z', 'A'...'Z', '0'...'9', '_' => return Op.lt,
            },
            '!' => switch (s[1]) {
                '?' => return Op.never_query,
                '!' => return Op.dbl_exclm,
                '=' => return Op.ne,
                ':' => return Op.self_tag,
            },
            ':' => switch (s[1]) {
                'a'...'z', 'A'...'Z', '0'...'9', '_' => return Op.tagged,
                '=' => return Op.def,
                ' ' => return Op.env,
                ':' => switch (s[2]) {
                    '#' => return Op.meta_pair,
                    ' ', '\n', '0'...'9', 'a'...'z', 'A'...'Z', '_' => return Op.dbl_colon,
                },
                '@' => return Op.meta_dev,
                '#' => return Op.meta_tag,
            },
            '?' => switch (s[1]) {
                ':' => return Op.meta_query,
                '?' => return Op.dbl_query,
                '!' => Op.query_never,
            },
            'a'...'z', 'A'...'Z', '0'...'9', '_' => {},
            '&' => switch (s[1]) {
                '&' => return Op.@"and",
            },
        }
        if (eql("->", s)) {
            return Op.farrow;
        } else if (eql("<-", s)) {
            return Op.barrow;
        } else {}
    }
};

/// NOTE: Generally, use text form of constraints
pub const Constraints = enum(u4) {
    // NOTE: Pos cons. Symbol   Text
    must = 0, //       =:   =:
    must_be, //       =*   =:is
    must_be_like, //       =~   =:like
    must_be_able, //       =+   =:can
    must_be_gt, //       =>   =:gt
    must_be_lt, //       =<   =:lt
    must_have, //       =.   =:has
    must_be_tagged, //     =#   =:tagged
    must_do, //     =$   =:does

    // NOTE: Neg cons. Symbol    Text
    must_not = 10, //  =!    =!
    must_not_be, //  =!*   =!is
    must_not_be_able, //  =!+   =!can
    must_not_be_like, //  =!~   =!like
    must_not_have, //  =!.   =!has
    must_not_do, //  =!$   =!does
    must_not_be_tagged, //  =!#   =!tagged
    must_not_be_gt, //  =!>   =!gt
    must_not_be_lt, //  =!<   =!lt

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};

//NOTE: boolean logic operators
pub const Logic = enum(u8) {
    @"and", //       &&
    @"or", //        ||
    not, //          ~~
    never, //        !
    therefore, //    :;
    query, // ?
    amp, // &
    pipe,
    bslash,
    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};
//NOTE: math operators
pub const Math = enum(u8) {
    add,
    mul,
    div,
    sub,
    mod,
    exp,
    abs, // <>

    // NOTE: unassigned
    dbl_query,
    dbl_mod,
    dbl_scolon,
    dbl_exclm,
    dbl_caret,
    dbl_fslash,

    // NOTE: special operators, user overridable
    join, //    ++ NOTE: for specifically matrix concatenation
    mul, //     ** NOTE: for matrix multiplication
    dot, //     *+ NOTE: for dot product

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};

/// NOTE: comparison operators
pub const Cmp = enum(u8) {
    eq, //     ==
    ne, //     !=
    gt, //     >
    lt, //     <
    ge, //     >=
    le, //     <=
    is, //     :=
    dbl_lt, //     <<
    dbl_gt, //     >>

    approx_eq, //     ~=
    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};
pub const LinkInfix = enum(u8) {};

// NOTE: Primarily for shorthand letter-prefixes to initialize
//       builtin data types and syntax. Specified as prefix
//       on the identifier on the LHS of an assignment.
//       Occurs before any assignment is done.
pub const LhsPrefix = enum(u8) {
    @"async", //     a:ident
    func, //         f:ident    specifies function ident
    proc, //         p:ident
    @"enum", //      e:ident    specifies enum ident
    set, //          &:ident    specifies set
    block, //        b:ident    specifies block ident
    trait, //        trait:ident    specifies trait ident
    quality, //      q:ident    specifies abstract quality ident
    @"struct", //    s:ident    specifies struct ident
    module_pre, //   m:ident    specifies module ident
    inln, //         i:ident
    @"import", //    I:ident
    neg, //          !:ident
    @"export", //    X:ident
    abs, //          ~:ident    specifies abstract type ident
    dev, //          @:ident
    meta, //         #:ident
    compiler, //     c:ident
    macro, //        *:ident
    using, //        u:ident
    assoc, //        **:ident
    dev, //          @@:ident
    implement, //    +:ident
    constrain, //    -:ident
    from_other, //   >:ident
    to_other, //     <:ident
    pass_other_in, //  >>:ident    opt: specify param let var g:a:((dotenv:get "DB_URL");do)>>:db_client
    pass_other_out, // <<:ident
    pass_output, //  <<:ident
    do, //           d:ident
    concept, //      &:ident
    suspended, //    _:ident
    @"defer", //     .:ident    defer initialization until end of scope
    @"var", //       v:ident    set as mutable
    public, //       pub:ident
    local, //        loc:ident
    iter, //         /:ident
    pipe, //         |:ident
    err, //          E:ident
    lit, //          \:ident    (one bslash) (for literals)
    @"try", //       try:ident  attempt to unwrap if data is optional type, otherwise just return
    ty, //           ty(type):ident
    can, //          ab(trait_ability1)(tabil2):ident
    abs,
};
// NOTE: Primarily for shorthand letter-postfixes
//       to specify what initialized data types should do
//       Specified after the right hand value declaration,
//       before the end of a statement;
pub const RhsSuffix = enum(u8) {
    do, //              val;do
    @"defer", //        val;.
    @"suspend", //      val;_
    @"await", //        val;a
    del, //             val;D
    inln, //            val;i
    assoc, //           val;**
    implement, //       val;+
    constrain, //       val;-
    meta, //            val;#
    abstract, //        val;~
    concept, //         val;&
    loop, //            val;l
    neg, //             val;!
    compiler, //        val;c
    assign_to, //       val;=
    send, //            val;->
    recv, //            val;<-
    iter, //            val;/
    lit, //             val;\  (one bslash) (for literals)
    pipe, //            val;|
    for_range, //       val;r0...10     <iterable>;r<range>
    map, //             val;m           <iterable>;m<closure>
    self_apply_fn, //   val;<
    apply_fn, //        val;>
    with, //            val;w
    debug, //           val;D   if <ident> can write a str representation of itself to file, debug will print that out to stdout
    as, // as           val;as(TYPE)
    with, //            val;w(TYPE-INSTANTIATION)
    dev, //             val;@
    dev_ext, //         val;@@
    compiler, //        val;c
    macro, //           val;m*
    using, //           val;u

    match_of, //        val;?of
    match_in, //        val;?in
    match_is, //        val;?is
    match_eq, //        val;?eq
    match_has, //       val;?has
    match_does, //      val;?does
    match_can, //       val;?can
    match_constrain, // val;?not
    match_like, //      val:?assoc

    cond_eq_sym, //      val;?==
    cond_ne_sym, //      val;?!=
    cond_gt_sym, //      val;?>
    cond_lt_sym, //      val;?<
    cond_ge_sym, //      val;?>=
    cond_le_sym, //      val;?<=

    if_else_sym, //      ident;?(COND)t(RESULT)f(ELSE-RESULT):e  ex. let vm = g:

    assoc, //        +:ident
    constraint, //   -:ident

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};

//NOTE: assignment operators
pub const Assign = enum(u8) {
    assign, //         =
    def_assign, //    :=
    opt_assign, //    ?=
    add_assign, //    +=
    sub_assign, //    -=
    mul_assign, //    *=
    div_assign, //    /=
    exp_assign, //    ^=
    mod_assign, //    %=

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};
//NOTE: module accessor operators -
//      accessor syntax lies between the parent data struct
//      and the child field data to be outputted. so it is an infix op.
pub const Access = enum(u8) {
    // NOTE: env acc. @SYM    @DESCRIPTION
    env_data, //       .      unconnected to any other idents
    env_proc, //       :      unconnected to any other idents
    env_assoc, //      :+     (not followed or preceded by alphanum)
    env_do, //         :-     (not followed or preceded by alphanum)
    abs_env_proc, //   ::     unconnected to any other idents
    abs_env_data, //   :.     unconnected to any other idents

    // NOTE: sym acc. @SYM   @EXAMPLE   [ for instantiated types ]
    sym_data, //       .      datastruct.data
    sym_proc, //       :      datastruct:proc
    sym_qual, //       :|     datastruct:|dkey:|dkey2
    sym_attr, //       :/     datastruct:/attr1:/attr2
    sym_do, //         :>     datastruct:>data
    sym_assoc, //      :+     datastruct:+data,

    // NOTE: abstract @SYM    @DESCRIPTION [ for abstract instantiable types ]
    abs_sym_data, //   .:     datastruct.:abstract_data
    abs_sym_do, //     ::>    let some res = datastruct::>parent_func
    abs_sym_proc, //   ::     let some res = datastruct::parent_func do
    abs_sym_qual, //   ::|    datastruct:|dkey:|dkey2
    abs_sym_attr, //   ::/    datastruct:/attr1:/attr2
    abs_sym_assoc, //  ::+    datastruct:+data,

    // NOTE: abstract @SYM    @DESCRIPTION [ for uninstantiable abstract types (traits, ) ]
    abs_data, //        :~.   let var db_field = is_database:~.conn_url
    abs_proc, //        :~:   pub f:fly = do can_fly:~:fly
    abs_sym_qual, //    :~|   trait_type:~|qual1 v:~|qual 2:~|q3 false
    abs_assoc, //       :~+   if can_walk:~+can_fly :blk { print "yay" }
    abs_do, //          :~-   can_fly:~>

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};

//NOTE: meta operators
pub const Meta = enum(u8) {
    meta_dev, //       :@ ex: compiler statement: :@compiler
    meta_tag, //   :#  ex: tag modification let var keys = :#key;
    meta_pair, //  ::# ex: pair set val: ::#key=value; get val: let v = ::#key
    meta_query, // ?:

    query_never, // ?!
    never_query, // !?

    self_tag, //      : !:ident tags "ident" as a meta key
    tagged, //       :tag[data] or :"tag name"[data] or :(tag key)[data]
    paired, //        ::(key val)[some data] or ::key[data] (where data = val)
    pub fn fromStr(s: []const u8) ?Meta {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};

//NOTE: ref/pointer operators
pub const Reference = enum(u8) {
    ref, //             &ident
    dbl_ref, //         &&ident
    deref, //           *ident     (call pointer?)
    copy, //            +ident
    actor_repr, //      $ident
    abs_actor_repr, //  $$ident
    dev, //             @ident
    dev_meta, //        @@ident
    lit_tag, //         :ident
    lit_pair, //        ::ident-tag val-ident
    meta_tag, //        #tag-ident
    meta_pair, //       ##tag-ident val-ident

    farrow, //          ->
    barrow, //          <-
    fdbl_arrow, //      ->>
    bdbl_arrow, //      <<-

    both_arrow, //       <->

    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};
//NOTE: range operators
pub const Range = enum(u8) {
    range_pre, // ..
    range_col, // ..:
    range_opt, // ..?
    range_exc, // ..!
    range_inc, // ..=
    range, // ... (inc by default)
    pub fn fromStr(s: []const u8) @This() {
        if (s[0] == '=') switch (s[1]) {
            '!' => switch (s[2]) {},
        } else return null;
    }
};
