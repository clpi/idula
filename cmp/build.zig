const std = @import("std");
const libs = @import("../pkg/build.zig");
const Bpkg = std.build.Pkg;
const Ver = std.build.Version;
const InstallDirStep = std.build.InstallDirStep;
const ObjStep = std.build.LibExeObjStep;
const Builder = std.build.Builder;
const XTarget = std.zig.CrossTarget;
const FileSource = std.build.FileSource;
const InstallDir = std.build.InstallDir;
const RunStep = std.build.RunStep;
const path = std.fs.path;
const builtin = std.builtin;
const str = []const u8;

pub const Idl = struct {
    exe: std.build.LibExeObjStep,
    run: RunStep = RunStep.create(@tagName(Idl) ++ "-run"),

    pub fn init(b: *Builder) Idl {
        const idl = b.addExecutable("idl", "src/main.zig");
        return Idl{
            .exe = idl,
        };
    }
    pub fn addExe(self: Idl, b: *Builder) void {
        const target = b.standardTargetOptions(.{});
        const mode = std.builtin.Mode.Debug;
        // self.exe.addPackagePath("iact", "./pkg/iact/");
        self.exe.addPackagePath("ipar", "./pkg/ipar/");
        self.exe.addPackagePath("logid", "./pkg/logid/");
        self.exe.addPackagePath("idlex", "./pkg/ido/");
        self.exe.addPackagePath("idlex", "./pkg/ispec/");
        self.exe.addPackagePath("idlex", "./pkg/idlex/");
        self.exe.setOutputDir("./out/bin/");
        self.exe.setTarget(target);
        self.exe.setBuildMode(mode);
        self.exe.install();
    }
    pub fn runStep(self: Idl) void {
        self.b.step(self.step);
    }
};

pub const Idlsp = struct {
    b: *Builder,
    exe: std.build.LibExeObjStep,
    run: RunStep = RunStep.create(@tagName(Idlsp) ++ "-run"),

    pub fn init(b: *Builder) Idl {
        const idl = b.addExecutable("idl", "src/main.zig");
        return Idl{
            .b = b,
            .exe = idl,
        };
    }

    pub fn addExe(self: Idlsp, b: *Builder) void {
        const target = b.standardTargetOptions(.{});
        const mode = std.builtin.Mode.Debug;
        self.exe.setOutputDir("./out/bin/");
        self.exe.setTarget(target);
        self.exe.setBuildMode(mode);
        self.exe.install();
    }
    pub fn runStep(self: Idlsp) std.build.RunStep {
        var s = std.build.RunStep.create(self.b, "lsp-run");
        s.addPathDir("./pkg/idlsp/src/main.zig");
        return s;
    }
};

pub const Logid = struct {
    pub const pk = Bpkg{ .name = "logid", .path = "./pkg/logid/", .dependencies = null };
};

pub const Itask = struct {};

pub const Idli = struct {
    pub const abs_dir: str = "/Users/clp/p/z/il/pkg/idlsp/src/main.zig";

    pub fn fileSrc() std.build.FileSource {
        return std.build.FileSource.relative(Idli.abs_dir);
    }
};

pub const Bin = enum {
    idlsp,
    itask,
    idlex,
    idli,
    idl,
};

pub fn outOpts(sourcedir: str) std.build.InstallDirectoryOptions {
    return std.build.InstallDirectoryOptions{
        .source_dir = sourcedir,
        .install_dir = "out",
        .install_subdir = "bin",
    };
}
