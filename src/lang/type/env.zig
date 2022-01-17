const std = @import("std");
const str = []const u8;
const Allocator = std.mem.Allocator;

pub const InstructionQueue = struct {
    instructions: std.AutoArrayHashMap(Instruction, InstructionMod),
    const Self = @This();

    pub fn init(a: Allocator) Self {
        return Self{ .instructions = std.AutoArrayHashMap(Instruction, InstructionMod).init(a) };
    }
};

pub const InstrCode = union(enum(u16)) {
    hint: InstrHintCode,
    data: InstrDataCode,
};
pub const InstrHintCode = enum(u16) {
    // NOTE: Attribute hints: Link 1:1 with a tag to provide that tag with a compiler
    //       strategy, such as conditional compilation, dynamic compilation.
    //       ex. :hint_rare:[fnct]
    //                  ^- to have this tag provide compiler hints, just store to meta:
    //       ex. do link @link_type:one_one, @tag:tag.hint_rare) -> :@compiler.hint.rarely_used

    // NOTE: Hints about usage freq for functions, syms, etc.
    rarely_used,
    often_used,
    set_inline,
    never_inline,

    // NOTE: Conditional compilation based on computer architecture
    //  - tags a block of code, which will then only run if condition is true
    cond_arch,
    cond_tag,
    cond_pair_val,
    cond_workspace_feature,
    cond_project_feature,

    // NOTE: Compilation direct options
    //  - not necessary to tag any object or symbol
    compiler_release_mode,
    compiler_incremental,

    llvm_args,
    llvm_lto,
    llvm_metadata,
};

pub const InstrDataCode = enum(u16) {
    list_tables = 0,
    list_syms,
    list_rels,
    list_assocs,
    list_links,
    list_constraints,
    list_capabilitiess,
    list_implementations,
    list_qualities,
    list_types,
    list_data_types,
    list_concepts,
    list_abstract_types,
    list_tags,
    list_text_blocks,
    list_pairs,

    get_table = 25,
    get_sym,
    get_rel,
    get_assoc,
    get_link,
    get_constraint,
    get_capabilities,
    get_implementation,
    get_quality,
    get_type,
    get_data_types,
    get_abstract_types,
    get_tag,
    get_text_block,
    get_pair,

    rm_table = 50,
    rm_sym,
    rm_rel,
    rm_assoc,
    rm_link,
    rm_constraint,
    rm_capabilities,
    rm_implementation,
    rm_quality,
    rm_type,
    rm_data_types,
    rm_abstract_types,
    rm_tag,
    rm_text_block,
    rm_pair,

    add_table = 75,
    add_sym,
    add_rel,
    add_assoc,
    add_link,
    add_constraint,
    add_capabilities,
    add_implementation,
    add_quality,
    add_type,
    add_data_types,
    add_abstract_types,
    add_tag,
    add_text_block,
    add_pair,

    add_sym_field = 100,
    add_sym_method,
    add_sym_capability,
    add_sym_quality,
    add_sym_link,
    add_sym_rel,
    add_sym_constraint,
    add_sym_capability,
    add_sym_implementation,
    add_sym_tag,
    set_sym_type,
    set_sym_ident,

    create_type = 125,
    create_alias,
    create_trait,
    create_abstract_type,

    log = 200,
    tg_verbose,
    tg_color_mode,
    abort,
    exit,

    pub fn fromStr(s: str) ?@This() {
        for (std.meta.fields(InstrDataCode)) |field| fld: {
            if (std.mem.eql(u8, @tagName(field), s)) {
                break :fld field;
            }
        }
        return null;
    }
};
// NOTE: metadata? for instructions being interpreted?
pub const InstructionMod = struct {
    tag_ident: str,
    created_ts: i64,
    const Self = @This();
    pub fn init(ident: str) Self {
        return Self{ .tag_ident = ident, .created_ts = std.time.timestamp() };
    }
};

pub const Instruction = union(InstrCode) {
    list_tables: str,
    list_sym: str,
    list_types: str,
    list_data_types: str,
    list_abstract_types: str,

    get_table: str,
    get_sym: str,
    get_type: str,
    get_data_types: str,
    get_abstract_types: str,

    rm_table: str,
    rm_sym: str,
    rm_type: str,
    rm_data_types: str,
    rm_abstract_types: str,

    log: str,
    exit: u1,

    new_type_name: str,
    new_table_name: str,
};
