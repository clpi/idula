const str = []const u8;
const std = @import("std");
const builtin = @import("builtin");
const util = @import("util.zig");
const init = @import("./cli/init.zig");
const repl = @import("./cli/repl.zig");
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

pub const Cmd = union(enum) {
    help: ?[]const u8,
    run: ?[]const u8,
    compile: ?[]const u8,
    init: ?[]const u8,
    workspace: ?[]const u8,
    repl,

    pub fn exec(self: Cmd, a: Allocator, c2: ?[]const u8, args: []const []const u8) !void {
        std.debug.print("{d}\n", .{args.len});
        switch (self) {
            Cmd.repl => {
                _ = try repl(a);
            },
            Cmd.help => |_| {
                print_usage();
            },
            Cmd.init => |_| if (c2) |c| {
                try init.init_project(c);
            } else {
                try init.init_project(null);
            },
            Cmd.workspace => |_| if (c2) |c| {
                try init.init_workspace(c);
            } else {
                try init.init_workspace(null);
            },
            Cmd.run => |_| {
                if (c2) |f| {
                    const src = try readFile(a, f);
                    const b = try std.fmt.allocPrint(a, "{s}\n", .{src});
                    std.debug.print("{s}\n", .{b});
                }
            },
            Cmd.compile => |_| {
                if (c2) |f| {
                    const src = try readFile(a, f);
                    const b = try std.fmt.allocPrint(a, "{s}\n", .{src});
                    std.debug.print("{s}\n", .{b});
                }
            },
        }
    }

    pub fn setTarget(self: Cmd, tgt: []const u8) void {
        switch (self) {
            Cmd.repl => return,
            Cmd.compile => |*cmp| if (cmp) |c| {
                c.* = tgt;
            } else return,
            Cmd.init => |*ini| if (ini) |i| {
                i.* = tgt;
            } else return,
            Cmd.run => |*run| if (run) |r| {
                r.* = tgt;
            } else return,
            Cmd.help => |*help| if (help) |h| {
                h.* = tgt;
            } else return,
        }
    }
    pub fn fromStr(c: []const u8) !Cmd {
        const cmd: Cmd = cmd: {
            if (eq("r", "run", c)) {
                break :cmd Cmd{ .run = null };
            } else if (eq("c", "compile", c)) {
                break :cmd Cmd{ .compile = null };
            } else if (eq("i", "init", c)) {
                break :cmd Cmd{ .init = null };
            } else if (eq("re", "repl", c)) {
                break :cmd Cmd.repl;
            } else if (eq("h", "help", c)) {
                break :cmd Cmd{ .help = null };
            } else {
                break :cmd Cmd{ .help = null };
            }
        };
        return cmd;
    }
};
pub fn parse_args(a: Allocator, args: *std.process.ArgIterator) ![]const []const u8 {
    var as: [][]u8 = undefined;
    var count: u8 = 2;
    while (try args.next(a)) |arg| : (count += 1) {
        switch (count) {
            2 => {},
            else => {},
        }
        std.debug.print("{d}: {s}", .{ count, arg });
    }
    const argm = as;
    return argm;
}
pub fn print_usage() void {}
