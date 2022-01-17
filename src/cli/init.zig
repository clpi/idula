const str = []const u8;
const std = @import("std");
const builtin = @import("builtin");
const util = @import("../`util.zig");
const init = @import("./init.zig");
const repl = @import("./repl.zig");
const compile = @import("./compile.zig");
const build = @import("./build.zig");
const run = @import("./run.zig");
const help = @import("./help.zig");

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

pub const Context = struct {
    allocator: Allocator,
    step: std.atomic.Atomic(usize).init(0),
    recv: Thread.AutoResetEvent = Thread.AutoResetEvent{},
    send: Thread.AutoResetEvent = Thread.AutoResetEvent{},
    thread: Thread = undefined,

    pub const ProjectSetupSteps = enum(u8) { setup = 0, files = 1, compile = 2, install = 3 };

    pub fn sender(self: *@This()) !void {
        std.debug.print("Context value (0): {d}", .{self.step});
        self.step = 1;
        self.send.set();
        self.recv.wait();

        std.debug.print("Context value (2): {d}", .{self.step});
        self.step = 3;
        self.send.set();
        self.recv.wait();

        std.debug.print("Context value (4): {d}", .{self.step});
    }

    pub fn receiver(self: *@This()) !void {
        self.recv.wait();
    }

    const Self = @This();

    pub fn create() Context {
        return Context{};
    }

    pub fn init(a: Allocator) Context {
        return Context{ .allocator = a };
    }

    pub fn run(self: *@This()) !void {
        try self.sender();
    }
};

pub const Project = struct {
    title: str = "Your new idula project",
    author: str = "You",
    version: str = "0.1.0",
    edition: str = "2022",
    lib_name: str = "lib",
    bin_name: str = "main",
    bin_path: str = "./src/bin/main.rs",
    name: str = "example_mod",
    public: str = false,
    compile: str = false,
    const Self = @This();

    pub fn init() void {}
};

pub fn init_project(a: Allocator, dir: ?[]const u8) ![]const u8 {
    var curr_dir = false;

    const path = if (dir) |c| c else {
        curr_dir = true;
        ".";
    };
    const di = try std.fs.cwd().openDir(path, .{ .iterate = true });
    var walkdir = di.iterate();
    const project_file = std.fs.path.join(.{ path, "idle.toml" });
    while (try walkdir.next()) |p| rdir: {
        std.debug.print("{s}\n", .{p.name});
        if (std.mem.eql(u8, p, project_file)) {
            std.io.getStdErr().write("\x1b;33;1mYou've already set up a project in this directory!\x1b[0m");
            break :rdir project_file;
        } else {
            const name = try std.io.getStdIn().reader().readUntilDelimiterOrEofAlloc(a, "\n", 2048);
            const base_files = .{ "Idle.toml", ".gitignore", "README.md", "build.is" }; //Plus out dir

            var files: [4]std.fs.File = .{};
            for (base_files) |fname| {
                const file: std.fs.File = try di.createFile("{s}", .{fname});
                files[0] = file;
            }
            _ = try files[0].writeAll(@embedFile("../../res/new/Idle.toml"));
            _ = try files[1].writeAll(@embedFile("../../res/new/.gitignore"));
            _ = try files[2].writeAll(@embedFile("../../res/new/README.md"));
            _ = try files[3].writeAll(@embedFile("../../res/new/build.is"));

            // const src_files = .{ "main.is", "lib.is" }; // + main.is is in /bin dir in src dir

            _ = try di.makeDir("src");
            _ = try di.makeDir("out");
            _ = try di.writeFile(".gitignore", gignore_dft());
            _ = try di.writeFile("build.is", build_dft());
            try di.openDir("src", .{});
            _ = try di.writeFile("main.is", main_default());
            _ = try di.writeFile("lib.is", lib_default());

            // const giti = [_][]const u8{ "git", "init " };
            // const gitg = [_][]const u8{ "touch", "./res/new/.gitignore" };
            // const cpif = [_][]const u8{ "cp", "-r", "" };

            // var proc = try std.ChildProcess.init(.{""});
            std.io.getStdErr().write("\x1b;33;1mYou've already set up a project in this directory!\x1b[0m");
        }
    }
}
pub fn init_workspace(a: Allocator, dir: ?[]const u8) ![]const u8 {
    const path = if (dir) |c| c else ".";
    const di = try std.fs.cwd().openDir(path, .{ .iterate = true });
    var walkdir = di.iterate();
    while (try walkdir.next()) |p| {
        std.debug.print("{s}\n", .{p.name});
    }
}
pub fn gitignore_default() []u8 {
    const df =
        \\ **out
        \\ **Idle.lock
        \\ **.idle-cache
        \\
        \\ **.env
        \\ **.prod.env
        \\ **.local.env
    ;
}
pub fn gignore_dft() []u8 {
    return @embedFile("~/p/z/il/res/new/.gitignore");
}
pub fn ifile_dft() []u8 {
    return @embedFile("~/p/z/il/res/new/Idle.toml");
}
pub fn build_dft() []u8 {
    return @embedFile("~/p/z/il/res/new/build.is");
}
pub fn main_default() []u8 {
    return @embedFile("~/p/z/il/res/new/src/main.is");
}
pub fn lib_default() []u8 {
    return @embedFile("~/p/z/il/res/new/src/lib.is");
}
