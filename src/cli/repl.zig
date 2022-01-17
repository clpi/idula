const std = @import("std");
const trait = std.meta.trait;
const str = []const u8;
const builtin = @import("builtin");
const util = @import("util.zig");
const init = @import("./cli/init.zig");
const compile = @import("./cli/compile.zig");
const build = @import("./cli/build.zig");
const run = @import("./cli/run.zig");
const help = @import("./cli/help.zig");
const process = std.process;
const ChildProcess = std.ChildProcess;
const Thread = std.Thread;
const eq = util.eq;
const readFile = util.readFile;
const eql = std.mem.eql;
const Allocator = std.mem.Allocator;
const stderr = std.io.getStdErr();
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

fn repl(allocator: Allocator) !void {
    var hist = std.ArrayList([]const u8).init(allocator);
    var buf: [512]u8 = undefined;
    while (true) {
        _ = try stdout.write(":idlang:> ");
        const read = try stdin.read(&buf);
        if (read == buf.len) {
            _ = try stdout.write("Over 512 bytes");
            continue;
        }
        const inp = buf[0..read];
        _ = try stdout.write(inp);
        try hist.append(inp);
    }
}
