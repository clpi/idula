const str = []const u8;
const std = @import("std");
const envir = @import("./env.zig");
const InstrCode = envir.InstrCode;
const InstrMods = envir.InstrMods;
const Cursor = @import("../token.zig").Cursor;
const Allocator = std.mem.Allocator;
const @"type" = @import("./type.zig");
const Type = @"type".Type;
const Sym = @"type".Symbol;
const trait = std.meta.trait;

pub const TextBlock = struct {
    content: str,
    created_in: ?str,
    created_pos: Cursor,
    stored_in: []str = .{},
    syms: []str = .{},
    abs_syms: []str = .{},
    files: []str = .{},
    mods: []str = .{},
    op_ident: ?str,
    instructions: std.ArrayList(str),
    created_ts: i64,

    const Self = @This();

    pub fn create(name: str) Tag {
        const ts = std.time.timestamp();
        return Tag{
            .name = name,
            .created_ts = ts,
        };
    }
};

pub const InstructionList = struct {
    const Self = @This();
    list: std.AutoHashMap(InstrCode, InstrMods),
    str_literal: str,
    created_ts: i64,
};
pub fn Tag(comptime T: anytype) type {
    return struct {
        name: str,
        created_in: ?str,
        stored_in: str,
        created_pos: Cursor,
        created_ts: i64,
        obj_kind_tagged: ?T,
        obj_ident: ?str,
        const Self = @This();

        pub fn create(name: str) Tag {
            const ts = std.time.timestamp();
            return Tag{
                .name = name,
                .created_ts = ts,
            };
        }
    };
}

pub const Pair = struct {
    name: str,
    created_ts: i64,
    const Self = @This();

    pub fn create(name: str) Tag {
        const ts = std.time.timestamp();
        return Tag{
            .name = name,
            .created_ts = ts,
        };
    }
};

pub const Profile = struct {
    keys: ?UserKeys,
    name: ?str,
    email: ?str,
    created_ts: i64,
    accessed_last_ts: i64,
    settings: struct {
        user_id: bool,
        idle_login: bool,
        debug_output: bool,
        compiler_opts: bool,
        llvm_opts: bool,
        dirs: struct {
            base_dir: str =   "$HOME/.idula/",
            config_dir: str = "$HOME/.idula/",
            data_dir: str  =  "$HOME/.idula/data/",
            hist_dir: str  =  "$HOME/.idula/hist/",
            cache_dir: str  = "$HOME/.idula/cache/",
            bin_dir: str =    "$HOME/.idula/bin/",
            pkg_dir: str =    "$HOME/.idula/pkg/",
            lib_dir: str =    "$HOME/.idula/lib/",
            install_dir: str ="$HOME/.idula/bin/",
        },
    },

    pub fn create(name: ?str, email: ?str) Tag {
        const ts = std.time.timestamp();
        return Tag{
            .name = name,
            .created_ts = ts,
        };
    }
};
