const std = @import("std");
const str = []const u8;
const ty = @import("./keyword/type.zig");
const typ = @import("../type.zig");
const TypeVals = typ.TypeVal;
const Result = typ.Result;
const Maybe = typ.Maybe;
const Allocator = std.mem.Allocator;

pub const BuiltinEnumTypes = union(enum) {
    result: Result,
    maybe: Maybe,
    bool: bool, //actually representation of 0 and 1?
    time: i64,
    const Self = @This();

    pub fn fromKwVals(v: TextValues) @This() {
        switch (v) {
            .some => |_| Maybe{ .some = "" },
            .none => Maybe.none,
            .ok => |_| Result{ .ok = "" },
            .err => |_| Result{ .err = "" },
            .now => std.time.timestamp(),
        }
    }
};

// NOTE: Values which are plain alphabetic ASCII text,
//       so must be checked for
pub const TextValues = union(enum(u8)) {
    some: Maybe = .some,
    none: Maybe = .none,
    true: bool = true,
    false: bool = false,
    err: Result = .err,
    ok: Result = .ok,
    now: i64 = std.time.timestamp(),
    const Self = @This();

    pub fn fromStr(s: str) TextValues {
        for (std.meta.fields(TextValues)) |field| {
            if (std.mem.eql(u8, field, s)) {
                return field;
            }
        }
        return null;
    }

    pub fn toType(self: @This()) BuiltinEnumTypes {
        return BuiltinEnumTypes.fromKwVals(self);
    }
};
