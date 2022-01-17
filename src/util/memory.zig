const std = @import("std");
const builtin = @import("builtin");
const logger = std.log.scoped(.util);
const Allocator = std.mem.Allocator;
const symbol = @import("../table/symbol.zig");
const scope = @import("../table/scope.zig");
const Symbol = symbol.Symbol;
const Scope = scope.ScopeTable;
const ty = @import("../type.zig");
const Duration = ty.Duration;
const meta = std.meta;
const mem = std.mem;
const str = []const u8;
const Gpa = std.heap.GeneralPurposeAllocator;
const StackTrace = std.builtin.StackTrace;

pub const CustomAllocatorError = error{} || Allocator.Error;

pub const CustomAllocatorConfig = struct {
    verbose_debug: bool = false,
    single_thread: bool = !std.builtin.single_threaded,
    memory_limit: bool = false,
    runtime_safe: bool = std.debug.runtime_safety,


    const Self = @This();

    pub fn default() Self {
        return Self{};
    }
};

pub fn CustomAllocator(comptime config: ?CustomAllocatorConfig) type {
    return struct {
        pub const Error = CustomAllocatorError;
        const Self = @This();

        low_count_buckets = std.math.log2(page_size),
        buckets: [low_count_buckets]?*BucketHead = [1]?*BucketHead{null} ** low_count_buckets,
        large_alloc_table = std.AutoHashMapUnmanaged(usize, LargeAlloc),
        config: CustomAllocatorConfig = config orelse CustomAllocatorConfig.default(),
        mutex: std.Thread.Mutex.AtomicMutex,
        child_allocator: Allocator = std.heap.page_allocator,

        pub fn init(childa: Allocator) !Self {
            return CustomAllocator{ .child_allocator = childa };
        }
        pub fn initConfig(childa: Allocator, conf: CustomAllocatorConfig) !Self {
            return CustomAllocator{ .child_allocator = childa, .config = conf };
        }
    };

    const BucketHead = struct {

    };
    const LargeAlloc = struct {
        bytes: []u8,
    };

}

pub fn Gpallocator() Gpa {
    const gpa = std.heap.GeneralPurposeAllocator(.{});
    return gpa.allocator();
}
