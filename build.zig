const std = @import("std");
const build = std.build;
const builtin = std.builtin;
const InstallArtifactStep = build.InstallArtifactStep;
const Builder = std.build.Builder;
const TranslateCStep = std.build.TranslateCStep;
const Step = std.build.Step;
const RunStep = std.build.RunStep;
const InstallDirOpts = std.build.InstallDirectoryOptions;
const InstallDirStep = std.build.InstallDirStep;
const InstallDir = std.build.InstallDir;
const LibExeObjStep = std.build.LibExeObjStep;
const FileSource = std.build.FileSource;
const FmtStep = std.build.FmtStep;
const RunStep = std.build.RunStep;
const Pkg = std.build.Pkg;
const InstallFileStep = std.build.InstallFileStep;
const GeneratedFile = std.build.GeneratedFile;
const Target = std.build.Target;
const Step = std.build.Step;

pub fn build(b: *std.build.Builder) void {
    b.exec(.{ "echo", "\x1b[32;mIDULA is installing...\x1b[0m" });
    const target = b.standardTargetOptions(.{});

    const mode_opt = std.builtin.Mode.Debug;
    const mode = b.setPreferredReleaseMode(mode_opt);

    const exe = b.addExecutable("il", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
