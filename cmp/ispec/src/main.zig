const std = @import("std");
const spec = @import("spec");
pub const str = []const u8;
const testing = std.testing;
const Dir = std.fs.Dir;
const EntryKind = Dir.Entry.Kind;
const Thread = std.Thread;
const Walker = std.fs.Dir.Walker;
const event = std.event;
const mt = std.meta;

const asset_exts = [_]u8{ ".html", ".mdx", ".svx", ".xml", ".jpeg", ".png", ".jpg" };

pub fn main() !void {
    const al = std.heap.GeneralPurposeAllocator(.{});
    var gpa = al.allocator();
    const wk = try WalkExt.initRel(al, "");

    var md_paths = std.ArrayList(str);
    const wwik = WalkExt.initAbs(al, "/Users/clp/wiki/", asset_exts);
}

pub fn relDir(d: str) !Dir {
    return std.fs.cwd().openDir(d, .{ .iterate = true });
}

pub fn walkRel(a: std.mem.Allocator, dir: str) !std.fs.Dir.Walker {
    return std.fs.cwd().openDir(dir, .{}).walk(a);
}

pub const WalkExt = struct {
    ext: str,
    secondary_exts: std.ArrayList(str),
    a: std.mem.Allocator,
    abs_dir: Dir = std.fs.cwd(),
    map: ?std.StringArrayHashMap(str) = null,
    sec_map: ?std.StringArrayHashMap(str) = null,
    const Self = @This();

    pub fn initAbs(a: std.mem.Allocator, dir: str, ext: str, sec_ext: ?[]str) !Self {
        return Self{
            .ext = ext,
            .a = a,
            .abs_dir = dir,
            .exts = std.ArrayList(str).init(a),
        };
    }
    pub fn initRel(a: std.mem.Allocator, rel_dir: str, ext: str, sec_ext: ?[]str) !Self {
        return Self{
            .ext = ext,
            .a = a,
            .abs_dir = try std.fs.cwd().openDir(rel_dir),
            .exts = std.ArrayList(str).init(a),
        };
    }

    pub fn walk(self: *Self) !*Self {
        var wk = try self.abs_dir.walk();
        var paths = std.ArrayList(str);
        var sec_paths = std.StringArrayHashMap(str).init(self.a);
        while (try wk.next()) |ent| {
            const p = ent.path;
            const kind = ent.kind;
            if (kind == .File and std.mem.endsWith(u8, ".md", p)) {
                try paths.append(p);
                continue;
            }
            if (sec_ext) |se| for (se) |s| try sec_paths.put(s, p);
        }
        self.*.map = paths;
        self.*.sec_map = sec_paths;
        return self;
    }
};

pub fn recursiveFtFind(a: std.mem.Allocator, dir: str, ext: str) !std.ArrayList(str) {
    const wk = try walkRel(a, dir);
}
