const std = @import("std");
const block = @import("../block.zig");
const Block = block.Block;
const Cmt = block.Cmt;
const Doc = block.Doc;
const Meta = block.Meta;
const Code = block.Code;

pub const Closers = struct {
    const Self = @This();

    pub fn fromOpener(b: Block) ?[]const u8 {
        switch (b) {}
        return null;
    }

    pub const anybrack: []const u8 = .{"]"};
    pub const anybrace: []const u8 = .{"}"};
    pub const anyparen: []const u8 = .{")"};

    pub const anystrs: []const u8 = .{"\""};
    pub const anybyte: []const u8 = .{"\'"};
    pub const anybtic: []const u8 = .{"`"};
    pub const anytild: []const u8 = .{"\n"};

    // NOTE: Specific special Blocks
    pub const dtil: []const u8 = .{"~~;"};
    pub const ddot: []const u8 = .{"..;"};
    pub const ddsh: []const u8 = .{"--;"};
    // NOTE: Any and ALL line-based blocks necessarily
    //       are newline-sensitive, as a newline is
    //       essentially the closing block token
    // NOTE: This includes:
    //  - newline itself
    //  - comment, doc, meta desc line cmts
    pub const anyl: []const u8 = .{"\n"};
};
