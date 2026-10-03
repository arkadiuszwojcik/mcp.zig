const std = @import("std");

pub const StructField = struct {
    name: [:0]const u8,
    type: type,
};

pub const EnumField = struct {
    name: [:0]const u8,
    value: comptime_int,
};

/// Field list of a struct, given either the type or its `@typeInfo(T).@"struct"` payload.
pub fn structFields(comptime T: anytype) []const StructField {
    comptime {
        const info = if (@TypeOf(T) == type) @typeInfo(T).@"struct" else T;
        var out: [info.field_names.len]StructField = undefined;
        for (info.field_names, info.field_types, &out) |n, t, *o| o.* = .{ .name = n, .type = t };
        const final = out;
        return &final;
    }
}

/// Field list of an enum, given either the type or its `@typeInfo(T).@"enum"` payload.
pub fn enumFields(comptime T: anytype) []const EnumField {
    comptime {
        const info = if (@TypeOf(T) == type) @typeInfo(T).@"enum" else T;
        var out: [info.field_names.len]EnumField = undefined;
        for (info.field_names, info.field_values, &out) |n, v, *o| o.* = .{ .name = n, .value = v };
        const final = out;
        return &final;
    }
}
