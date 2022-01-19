//! Base of the primarily Idula-focused portion
//! of this zig project
const std = @import("std");
const Allocator = std.mem.Allocator;
const str = []const u8;

pub const scope = @import("./lang/env/scope.zig");
pub const Scope = scope.Scope;
pub const ScopeType = scope.ScopeType;
pub const GlobalScope = scope.GlobalScope;

pub const ty = @import("./lang/type.zig");
pub const Maybe = ty.Maybe;
pub const Custom = ty.Custom;
pub const FnType = ty.FnType;
pub const FnVal = ty.FnVal;
pub const Field = ty.Field;
pub const CollectionType = ty.CollectionType;
pub const CollectionTypeVal = ty.CollectionTypeVal;

pub const compile = @import("./lang/compile.zig");
pub const Compiler = compile.Compiler;

pub const token = @import("./lang/token.zig");
pub const Token = token.Token;

pub const parse = @import("./lang/parse.zig");
pub const Parser = parse.Parser;

pub const lex = @import("./lang/lex.zig");
pub const Lexer = lex.Lexer;

pub const ast = @import("./lang/ast.zig");
pub const Ast = ast.Ast;

// NOTE: Interface from backend compiler to frontend options
pub const IdulaFrontend = struct {
    const Self = @This();
    compiler: Compiler,
    ast_root: Ast,
    parser: Parser,

    allocator: std.mem.Allocator,
    arena: std.heap.ArenaAllocator.init(Self.allocator),
};

// NOTE: Meta about the three different languages and formats
pub const kw_map = std.ComptimeStringMap(Tag, .{
    .{ "is", .keyword_addrspace },
    .{ "id", .keyword_align },
    .{ "il", .keyword_allowzero },
});
