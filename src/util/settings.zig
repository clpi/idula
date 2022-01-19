const std = @import("std");
const builtin = @import("builtin");
const logger = std.log.scoped(.util);
const Allocator = std.mem.Allocator;
const symbol = @import("../lang/table/symbol.zig");
const scope = @import("../lang/table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const ty = @import("../type.zig");
const Duration = ty.Duration;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;

pub const RunConfig = struct {
    safety: bool = std.debug.runtime_safety,
    single_thread: bool = !builtin.single_thread,
};
