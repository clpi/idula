//! Keywords corresponding to typee names
const str = []const u8;
pub const scope = @import("./lang/env/scope.zig");
pub const Scope = scope.Scope;
const env = @import("../../type/env.zig");
const std = @import("std");
const eql = @import("../../util.zig").eql;
const Cursor = @import("../../token.zig").Cursor;
const ScopeType = scope.ScopeType;
pub usingnamespace @import("../../token.zig");
const Allocator = std.mem.Allocator;

pub const KeywordType = @This();

pub const KwType = Type;

pub const Type = union(enum) {
    primitive_nn: PrimitiveType,
    prim_num: NumType,
    builtin_types: BuiltinType,
    core_types: CoreDataType,
    abstract_types: AbstractType,
    function: FnType,
    collection: CollectionType,
    // data_type: DataType,
    meta_type: MetaDataType,
    edge_type: EdgeType,
};

pub const TypeInfo = struct {
    pos: Cursor,
    scope: Scope,
    env: EnvInfo, // globals, settings, config/ the env itself
};

/// NOTE: Types differentiated by the fact that they are identified
/// with two symbol ident keys, and perhaps a tag/meta key.
pub const EnvInfo = struct {
    current: u8,
    scope: Scope,
    // rules: Rules,
    context: ScopeType,
    pos: Cursor,
    offset: usize,
};
/// NOTE: Types differentiated by the fact that they are identified
/// with two symbol ident keys, and perhaps a tag/meta key.
pub const EdgeType = enum(u8) {
    links,
    assoc,
    rel,
    custom,
};

/// NOTE: Literal enumeration of builtin types and custom 
///       placeholders to identify them as excluded keywords
/// NOTE: This is just an enum, a tagged union which uses
///       this enum will be in the base /src/token/value.zig
///       which stores respective values as payloads
/// NOTE: Primitive types in this enum
pub const PrimitiveType = enum(u8) {
    undef = 0,
    bool = 1,
    ident,
    byte,
    bytes,
    char,
    str,
    tuple,
};
pub const BuiltinType = enum(u8) {
    seq,
    time,
    set,
    maybe, // Enum defined in base type.zig file
    result, // Enum defined in base type.zig file
    either, // Enum now defined in type.zig -- either value "left" or "right" (which will for now be kws)
    unknown,
    undef,

    const Self = @This();

    pub fn fromStr(s: str) ?Self {
        for (std.enums.valuesFromFields(std.meta.declarations(KwType))) |field| {
            if (std.mem.eql(u8, s, field)) {
                return field;
            }
        }
        return null;
    }
};
pub const NumType = enum(u8) {
    // NOTE: dynamically typed numbers
    num,
    complex,
    decimal,

    //NOTE: aliases of i64, u64, f64 respectively
    int, // i64
    uint, // u64
    float, // f64

    usize,
    isize,

    u64,
    i64,
    f64,

    u32,
    i32,
    f32,

    u128,
    i128,
    f128,

    u16,
    i16,
    f16,
    u8,
    i8,
    u6,
    i6,
    u5,
    i5,
    u4,
    i4,
    u3,
    i3,
    u2,
    i2,
    u1,
    i1,
};

/// Represents common data structures included in std
pub const CollectionType = enum(u8) {
    map,
    idx_map,
    queue,
    linked_list,
    btree,
    bptree,
    graph,

    pub fn init() @This() {
        return CollectionType.map;
    }
    pub fn fromStr(s: str) @This() {
        return switch (s) {
            else => CollectionType.map,
        };
    }
};

pub const MetaDataType = enum(u8) {
    compiler,
    tags,
    pairs,
    posts,
    custom_ops,
    custom_keywords,
    custom_types,
    custom_blocks,
    symbol_meta_data,

    macro,
    template,
    derivation,
};
// Represents abstract relations, attributes, properties,
// constraints, rules, etc. that exist in a idula runtime
pub const AbstractType = enum(u8) {
    @"trait",
    @"quality",
    @"approximality",
    @"implementation",
    @"constraint",
    @"capability",
    @"abstraction",
    @"field",
    @"representation",
    @"generalization",
    @"taxonomy",
    @"env",
    @"type",
    @"prop",
    @"attribute",
    custom,
    // NOTE: A set of associations, rules, constraints, and/or abilities
    //       that define a possible type and instantiations of that type.
    @"concept",

    const Self = @This();
    pub fn fromStr(s: []const u8) Self {
        for (std.meta.fields(AbstractType)) |field| {
            if (std.mem.eql(u8, @tagName(field), s)) {
                return field;
            }
        }
        return null;
    }
};

/// Represents core data organization patterns
pub const CoreDataType = enum(u8) {
    // NOTE: A unique data type where only one of a set of string-like labels (variants)
    //       can be associated with any given instantiation at a time. In idula, enums are
    //       encouraged to be seen as slightly-more-fancy Set[String] where fields, u8
    //       indexing, and tagging with unions is all very highly encouraged. They are
    //       intended to feel closer to just a enforceable slice of unique string literals
    //       where pattern matching and capturing is done by using enums and unions in tandem.
    @"enum",
    // NOTE: A data structure. A struct definition is a unique type, due to its name,
    //       fields (and their name and types), and local procedures. In idula, a sharp
    //       distinction is made between a strut's data and its methods. All symbols
    //       are immutable by default, and functions which strictly take input and
    //       produce output are encouraged and nudged along.
    @"struct",
    // NOTE: A datatype with one or more fields, which can only be fulfilled once at
    //       a time (with or without field values). much like how enums work in rust.
    //       I think the destinction between bare-bones enums and super-fancy-complex
    //       enum matching is a good one made in zig, so I decided the same.
    @"union",
    // NOTE: A type qua type reference. Can be used to declare new, custom types
    //       which can have their defining features fleshed out through abstract type
    //       associations and constraints/implementations.
    // NOTE: A simple type alias, but rather being called "type" it's instantiated
    //       using the declarative "alias"
    @"alias",
};
pub const FnType = enum(u8) {
    // NOTE: Functions with all of the power of normal fns, which are intended to be
    //       treated as datatypes on their own, used for callbacks, responders, etc.
    //       It is a real goal to have lambda functions be first-first class residents
    //       in Idula. Still a ways to go
    lambda,
    // NOTE: A fn is more of a first-class citizen in idula than it is in most environments.
    //       it is one of threee different function data types -- neighbors to proc, lambda.
    //       A function is flexible, but is firstly intended to do a simple task: take an
    //       input, produce an output, without changing the world outside. So a function's
    //       inside world has been made to be as dynamic and powerful as possible, but it is
    //       intentionally limited to what a function should actually do. Mutating var-flagged
    //       symbols is of course allowed, through procs primarily, which have full freedom.

    @"fn",
    // NOTE: Procedures are blocks of executable code, which runs when called with an optional
    //       set of input params to produce a specified output, however, procedures have the freedom
    //       to change any part of their input params, output params, or things completely unrelated
    //       to them, since a procedure's job, or ability perhaps, is to *do* and *change* things about the
    //       env around them. Try not to incur too many side effects
    proc,

    // NOTE: a procedure call which belongs to the encapsulated data of a module which itself has
    // associated data. Allowed to change the state of its scope or outside
    method_proc,
    // NOTE: a fn call which belongs to the encapsulated data of a module which itself has
    // associated data. Cannot change the state of its scope or outside
    method_fn,
};

pub const Descriptors = enum(u8) {
    custom,
    const Self = @This();

    pub fn custom() Self {
        return Type.Custom;
    }
};

// NOTE: Values which are plain alphabetic ASCII text,
//       so must be checked for
pub const Values = enum(u8) {
    maybe, // option val
    none, // option val
    true, // bool val
    false, // bool val
    err, // result val
    ok, // result val
    now, // time val
};

// NOTE: AbstractType alt fromStr
// return if (eql(s, "link")) {
//     return .link;
// } else if (eql(s, "trait")) {
//     return .trait;
// } else if (eql(s, "quality")) {
//     return .quality;
// } else if (eql(s, "prop")) {
//     return .prop;
// } else if (eql(s, "attr")) {
//     return .attr;
// } else if (eql(s, "assoc")) {
//     return .assoc;
// } else if (eql(s, "relation")) {
//     return .relation;
// } else return AbstractType.custom;
