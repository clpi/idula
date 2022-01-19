const std = @import("std");
const Thread = std.Thread();
const process = std.process;

pub const System = @This();

pub const Info = struct {
    allocator: std.mem.Allocator = std.heap.GeneralPurposeAllocator(.{}).allocator(),
    iomode: std.io.Mode = .blocking,
    num_cpu: u8 = std.Thread.getCpuCount() catch 1,
    single_thread: if (System.Info.num_cpu == 1) true else false,

    pub fn init(a: std.mem.Allocator) Info {
        return Info{ .allocator = a };
    }
};
