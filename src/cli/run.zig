const str = []const u8;
const std = @import("std");
const builtin = @import("builtin");
const util = @import("util.zig");
const init = @import("./cli/init.zig");
const repl = @import("./cli/repl.zig");
const compile = @import("./cli/compile.zig");
const build = @import("./cli/build.zig");
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

pub fn run() void {}
