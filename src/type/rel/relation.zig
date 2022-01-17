const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;
const ty = @import("./type.zig");

/// NOTE: For relations and links where two parties are A and B
///     - Direction.sending: A is sending, B is receiving
///     - Direction.receiving: A is receiving, B is sending
pub const Direction = enum(u1) { sending, receiving };

pub const Relation = struct {
    aid: str,
    bid: str,
    ident: str,
    direction: Direction,
    public: bool,
    mutable: bool,
    qualities: std.BufSet,
    created_ts: i64 = std.time.timestamp(),
};

pub const RelationKind = struct {
    ident: str,
    created_ts: i64 = std.time.timestamp(),
};
