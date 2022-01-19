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
pub const Lib = union(enum) {
    logid: Logid,
    ispec: Ispec,
    idown: Idown,
    idlex: Idlex,
    pub const Idlex = struct {};
    pub const Logid = struct {};
    pub const Idown = struct {};
    pub const Ispec = struct {};
    pub fn toStr(self: Lib) str {
        return @tagName(self);
    }
};
pub fn outOpts(sourcedir: str) std.build.InstallDirectoryOptions {
    return std.build.InstallDirectoryOptions{
        .source_dir = sourcedir,
        .install_dir = "out",
        .install_subdir = "lib",
    };
}
