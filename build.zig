const std = @import("std");
// const bins = @import("./cmp/build.zig");
// const libs = @import("./pkg/build.zig");
const Bpkg = std.build.Pkg;
const Ver = std.build.Version;
const InstallDirStep = std.build.InstallDirStep;
const ObjStep = std.build.LibidlObjStep;
const Builder = std.build.Builder;
const XTarget = std.zig.CrossTarget;
const FileSource = std.build.FileSource;
const InstallDir = std.build.InstallDir;
const RunStep = std.build.RunStep;
const path = std.fs.path;
const builtin = std.builtin;
const str = []const u8;

pub const depd = "./out/deps/";
pub const bind = InstallDir{ .bin = "./out/bin/" };
pub const libd = InstallDir{ .lib = "./out/lib/" };

pub const objd = "./out/obj/";

pub fn build(b: *std.build.Builder) void {
    // b.idlc(.{ "echo", "\x1b[32;mIDULA is installing...\x1b[0m" });
    // const target = std.zig.system.NativeTargetInfo.detect() catch null;
    const target = b.standardTargetOptions(.{});
    const mode = std.builtin.Mode.Debug;
    b.setPreferredReleaseMode(std.builtin.Mode.Debug);

    const exe = b.addExecutable("idl", "src/main.zig");
    exe.setOutputDir("./out/bin/");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    exe.addPackagePath("ipar", "./pkg/ipar/");
    exe.addPackagePath("logid", "./pkg/logid/");
    exe.addPackagePath("idlex", "./pkg/idlex/");
    exe.addPackagePath("idlex", "./pkg/ispec/");

    const lsp = b.addExecutable("idlsp", "./cmp/idlsp/src/main.zig");
    lsp.setOutputDir("./out/bin/");
    lsp.setTarget(target);
    lsp.setBuildMode(mode);
    lsp.install();

    const run_lsp = lsp.run();
    run_lsp.step.dependOn(b.getInstallStep());
    if (b.args) |a| run_lsp.addArgs(a);
    const lsp_rs = b.step("run-lsp", "Run the lsp");
    lsp_rs.dependOn(&run_lsp.step);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const idl_tests = b.addTest("src/main.zig");
    idl_tests.setTarget(target);
    idl_tests.setBuildMode(mode);

    // const cfiles = [*]const []const u8{ "./ext/cpp/main.cpp", "./ext/c/main.c" };
    // const c = b.addExecutable("c", null);
    // //
    // c.addCSourceFiles(cfiles, .{});
    // c.setTarget(target);
    // c.setOutputDir("./out/etc/");
    // c.linkLibC();
    // c.linkSystemLibrary("libcurl");
    // c.install();
    //
    // const c_run = c.run();
    // c_run.step.dependOn(&c.step);
    // c.addCSourceFile("./ext/cpp/main.cpp");
    //
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&idl_tests.step);

    // b.installArtifact()
}

// --- NOTE: Package and metaddata ---

// pub fn addLib(b: *Builder, idl: *ObjStep, obj: []const u8) !void {}
pub fn addExe(b: *Builder) std.build.LibExeObjStep {
    const target = b.standardTargetOptions(.{});
    const mode = std.builtin.Mode.Debug;
    const exe = b.addExecutable("idl", "src/main.zig");
    exe.setOutputDir("./out/bin/");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();
    return exe;
}
pub fn runStep(b: *Builder) std.build.RunStep {
    var s = std.build.RunStep.create(b, "lsp-run");
    s.addPathDir("./pkg/idlsp/src/main.zig");
    return s;
}
// const idl = bins.Idl.init(&b);
// const idlsp = bins.Idlsp.init(&b);
// idl.addExe();
// idlsp.addExe();
// idlsp.runStep();
