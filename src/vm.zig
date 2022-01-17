const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Vm = struct {
    allocator: Allocator,
    symbols: std.StringArrayHashMap(Symbol),

    pub fn init(a: Allocator) Vm {
        return Vm{ .allocator = a, .symbols = std.StringArrayHashMap(Symbol).init() };
    }
    pub fn deinit(self: *Vm) void {
        self.symbols.deinit();
    }

    // pub fn interpret(self: *Vm, src: []const u8) !void {
    //
    // }
};

pub const Type = union(enum(u8)) {
    proc: fn (anytype) void,
    int: i32,
    uint: u32,
    float: f32,
    list: []type,
    map: .{ type, type },
    byte: u8,
    bytes: []u8,
    str: []const u8,
    custom: .{ []const u8, []const u8 },
    tag: []const u8,
    pair: .{ []const u8, []const u8 },
};

pub const Symbol = struct {
    name: []const u8,
    type: Type,
};
