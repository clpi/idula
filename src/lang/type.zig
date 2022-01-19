const std = @import("std");
const relation = @import("./type/rel/relation.zig");
const symbol = @import("./table/symbol.zig");
pub const Symbol = symbol.Symbol;
pub const Relation = relation.Relation;
pub const Tag = @import("./type/meta.zig").Tag;
const assoc = @import("./type/rel/assoc.zig");
pub const Association = assoc.Association;
pub const AssociationType = assoc.AssociationType;
const str = []const u8;

pub const ty = @import("./token/keyword/type.zig");
pub const TypeKind = ty.TypeKind;
pub const FnType = ty.FnType;
pub const BuiltinDataType = ty.BuiltinDataType;
pub const CollectionType = ty.CollectionType;
pub const EdgeType = ty.EdgeType;
pub const CoreDataType = ty.CoreDataType;
pub const DataType = ty.DataType;
pub const NumType = ty.NumType;

pub const Allocator = std.mem.Allocator;
pub const traits = @import("./trait.zig");
pub const Implementation = @import("./trait.zig").Implementation;
pub const Trait = traits.Trait;
pub const Link = @import("./type/rel/link.zig").Link;
pub const Constraint = @import("./type/modifiers/constraints.zig").Constraint;
pub const Capability = @import("./type/modifiers/capability.zig").Capability;
pub const Quality = @import("./type/modifiers/quality.zig").Quality;

pub const TypeId = std.meta.Tag(.TypeKind);

// NOTE: The core type struct, contains defining info for existing and new types
pub const Type = struct {
    kind: TypeKind, // NOTE: extraneous, but i'l leave it here for a sec,
    val: TypeVal,
    public: bool,
    alias: bool,
    variable: bool,
    hooks: std.ArrayList(str),

    impls_qualities: std.StringArrayHashMap(Quality),
    impls_constraints: std.StringArrayHashMap(Constraint),
    impls_capabilities: std.StringArrayHashMap(Capability),
    impls_associations: std.StringArrayHashMap(Association),
    impl_fields: std.StringArrayHashMap(Field),
    impl_methods: std.StringArrayHashMap(Method),

    must_have_qualities: std.StringArrayHashMap(Quality),
    must_have_capabilities: std.StringArrayHashMap(Capability),
    must_have_associations: std.StringArrayHashMap(Association),
    must_have_constraints: std.StringArrayHashMap(Constraint),
    must_have_fields: std.StringArrayHashMap(Field),
    must_have_methods: std.StringArrayHashMap(Method),
};

pub fn Result(comptime T: type, comptime E: anyerror) type {
    return union(enum) {
        err: E,
        ok: T,

        pub fn get(self: Maybe) E!?T {
            switch (self) {
                Result.ok => |pl| return pl,
                Result.err => |pl| return pl,
            }
        }

        pub fn is_err(self: Result) bool {
            return std.mem.eql(u8, std.meta.tagName(self), "err");
        }

        pub fn is_ok(self: Result) bool {
            return std.mem.eql(u8, std.meta.tagName(self), "ok");
        }
    };
}

pub fn Maybe(comptime T: type) type {
    return union(enum) {
        none: void,
        some: T,

        pub fn is_some(self: Maybe) bool {
            return std.mem.eql(u8, std.meta.tagName(self), "some");
        }

        pub fn get(self: Maybe) ?T {
            switch (self) {
                .none => return null,
                .some => |pl| return pl,
            }
        }

        pub fn is_none(self: Maybe) bool {
            return std.mem.eql(u8, std.meta.tagName(self), "none");
        }
    };
}
pub const EdgeTypeVal = union(EdgeType) {
    links: std.StringArrayHashMap(Link),
    associations: std.StringArrayHashMap(Association),
    relations: std.StringArrayHashMap(Relation),
    implementations: std.StringArrayHashMap(Implementation),
    custom: std.StringArrayHashMap(type),
};
// init_fn: fn(anytype) anyerror!@This() ,
// drop_fn: fn(anytype) anyerror!void,
pub const TypeVal = union(enum) {
    primitive_nn: PrimitiveType,
    prim_num: NumTypeVals,
    data_structs: DataStructures,
    symbolic: SymbolVal,
    function: FnVal,
    collection: CollectionTypeVal,
    data_type: DataTypeVal,
    links: std.BufMap,
    custom: std.BufSet,
};
/// Represents common data structures included in std
pub const CollectionTypeVal = union(CollectionType) {
    set: std.BufSet,
    map: std.AutoHashMap(type, type),
    tree: std.AutoHashMap(type, type),
    graph: std.AutoHashMap(type, type),
    seq: std.SinglyLinkedList,
    maybe: Maybe, // Enum defined in base type.zig file
    result: Result, // Enum defined in base type.zig file
    unknown,
    undef,
};
pub const DataTypeVal = union(DataType) {
    concept: []const u8,
    func: fn (anytype) anyerror!?type,
    lambda: fn (anytype) anyerror!?type,
};
pub const FnVal = union(FnType) {
    proc: fn (anytype) anyerror!void,
    func: fn (anytype) anyerror!?type,
    lambda: fn (anytype) anyerror!?type,
};
pub const SymbolVal = union(enum(u8)) {
    ident: str, // symbol instantiation identifier
    trait: str,
    quality: str,
    structure: str,
    enumeration: str,
    link: str,
    params: std.StringArrayHashMap(Type),
    init_fn: fn (anytype) anyerror!@This(),
    drop_fn: fn (anytype) anyerror!void,
};
pub const DataStructures = union(enum(u8)) {
    seq: std.SinglyLinkedList(type),
    set: std.BufSet,
    map: std.ArrayHashMap(type, type),
    dict: std.BufMap,
};
pub const PrimitiveType = union(PrimitiveType) {
    undef: void,
    bool: bool,
    byte: u8,
    bytes: []u8,
    str: []const u8,

    tuple_two: .{ type, type },
    tuple_three: .{ type, type, type },
    tuple_four: .{ type, type, type, type },
};
pub const TupleType = union(enum) {
    tuple_two: .{ type, type },
    tuple_three: .{ type, type, type },
    tuple_four: .{ type, type, type, type },
};

pub const IntVal = struct { signed: bool, bytes: usize, val: i128 };
pub const FltVal = struct { signed: bool, bytes: usize, val: f128 };
/// NOTE: Theoretically, this is the enum that should be 
/// represented by the literal type "num". They're all 
/// numbers, we'll deal with the complexity and nuance.
pub const NumTypeVals = union(NumType) {
    num: anytype = 0,
    complex: i32 = 0,
    decimal: f32 = 0.0,

    int: ?IntVal = null,
    float: ?FloatVal = null,

    //NOTE: aliases of i64, u64, f64 respectively
    int: i64 = 0, // i64
    uint: u64 = 0, // u64
    float: f64, // f64

    usize: usize,
    isize: isize,
    u64: u64,
    i64: i64,
    f64: f64,
    u32: u32,
    i32: i32,
    f32: f32,
    f128: f128,
    u128: u128,
    i128: i128,
    u16: u16,
    i16: i16,
    f16: f16,
    u8: u8,
    i8: i8,
    u6: u6,
    i6: i6,
    u5: u5,
    i5: i5,
    u4: u4,
    i4: i4,
    u3: u3,
    i3: i3,
    u2: u2,
    i2: i2,
    u1: u1,
    i1: u1,
};
pub const Field = struct {
    name: str,
    public: bool,
    mutable: bool,
    val_type: type,
    param_set: std.StringArrayHashMap(Type),
    links: std.BufSet,
    const Self = @This();

    pub fn matches(self: Self, f: Field) bool {
        return (std.mem.eql(u8, self.name, f.name)) and
            (std.mem.eql(u8, self.public, f.public)) and
            (std.mem.eql(u8, self.mutable, f.mutable)) and
            (std.mem.eql(u8, self.val_type, f.val_type)) and
            (std.mem.eql(u8, self.links, f.links));
    }
};
pub const FnKind = enum(u1) {
    proc, // mutable world
    func, // immutable world, no side effects
    const Self = @This();
};
pub const FnSource = enum(u8) {
    direct,
    trait,
    implementation,
};
pub const Lambda = struct {
    name: str,
    scope: str,
    fn_info: MethodInfo,
    source: FnSource,
    public: bool,
};
pub const Method = struct {
    name: str,
    scope: str,
    parent_sym: str,
    public: bool,
    fn_info: MethodInfo,
    source: FnSource,
};
pub const ExecInfo = struct {
    fid: std.rand.limitRangeBiased(usize, 2048),
    ident: str,
    kind: FnKind,
    scope: str,
    tags: std.StringHashMap(Tag),
    fn_lit: fn (anytype) anyerror!?type,
};
pub const MethodInfo = struct {
    fid: std.rand.limitRangeBiased(usize, 2048),
    params: std.StringArrayHashMap(str, Type),
    implemented_by: std.StringArrayHashMap(str),
    ident: str,
    kind: FnKind,
    tags: std.StringHashMap(Tag),
    fn_lit: fn (anytype) anyerror!?type,
};

pub const Time = union(enum(u8)) {
    now: i64,
    now_milli: i64,
    now_nano: i128,

    tomorrow,
    yesterday,
    specific_time_mill: i64,
    specific_time_nano: i28,

    pub const Watch = struct {
        timer: std.time.Timer,
        hist: std.array_hash_map.AutoArrayHashMap(usize, i64),
        var last_read: i64 = std.math.maxInt(i64);

        pub fn init(a: Allocator) Self {
            return Self{
                .timer = std.time.Timer,
                .hist = std.AutoArrayHashMap(usize, i64).init(a),
            };
        }
        pub fn start(self: Watch) i64 {
            const begin = self.timer.start();
            last_read = begin;
            return begin;
        }
        pub fn end(self: Watch) i64 {
            const end = self.timer.lap();
            const diff = end - last_read;
            return diff;
        }
    };
};

pub const Duration = union(enum) {
    seconds: usize,
    minutes: usize,
    hours: usize,
    days: usize,
    weeks: usize,
    forever: void,
    diff = struct {
        diff: ?f64 = null,
        start: ?f64 = null,
        end: ?f64 = null,
    },

    /// NOTE: Outputs to miliseconds
    pub fn fromNano(start: i28, end: i28) Duration {
        const diff: i28 = end - start;
        return Duration{ .value = @as(f64, diff / std.time.ns_per_ms) }; // in ms
    }
    /// NOTE: We are using millisecond timestamps in all cases except hi-precision
    pub fn fromMilli(start: i64, end: i64) Duration {
        const diff: i64 = end - start;
        return Duration{ .value = @as(f64, diff) }; // in ms
    }
};

pub const List = struct {
    ty: Type,
    a: Allocator,
    cap: usize,
    content: std.ArrayList(Type),

    pub fn init(a: Allocator, typ: Type) List {
        return List{
            .a = a,
            .ty = typ,
            .cap = 2048,
            .content = std.ArrayList(Type).init(a),
        };
    }
};

pub fn Custom(comptime T: type) type {
    return struct {
        name: []const u8,
        base_name: []const u8,
        base: T,
    };
}

// NOTE: Not used
pub const TypeVals = union(Types) {
    ident: str,
    tag: str,
    pair: .{ str, str },
    undef: void,
    bool: bool,
    byte: u8,
    bytes: []u8,
    str: []const u8,
    time: i64, // ms timestamp
    tuple: .{ type, type },
    list: []type,
    proc: fn (anytype) anyerror!void,
    func: fn (anytype) type,
    NumType: NumTypeVals,
    seq: std.SinglyLinkedList(type),
    set: std.BufSet,
    map: std.ArrayHashMap(type, type),
    dict: std.BufMap,
};
