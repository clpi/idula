const std = @import("std");
const TypeInfo = std.builtin.TypeInfo;
const Tuple = struct {
    fn argsTuple() void {}
};

pub fn Tuple(comptime types: []const type) type {
    var fields: [types.len]TypeInfo.StructField = undefined;

    const type_info: TypeInfo.Struct = TypeInfo.Struct{
        .is_tuple = true,
        .layout = .Auto,
        .decls = &[_]TypeInfo.Declaration{},
        .fields = &fields,
    };

    inline for (types) |T, i| {
        @setEvalBranchQuota(10_000);
        var num_buf: [128]u8 = undefined;
        tuple_fields[i] = std.builtin.TypeInfo.StructField{
            .name = std.fmt.bufPrint(&num_buf, "{d}", .{i}) catch unreachable,
            .field_type = T,
            .default_value = @as(?T, null),
            .is_comptime = false,
            .alignment = if (@sizeOf(T) > 0) @alignOf(T) else 0,
        };
    }

    return @Type(TypeInfo{ .Struct = type_info });
}
