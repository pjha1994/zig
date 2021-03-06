const std = @import("../index.zig");
const math = std.math;
const assert = std.debug.assert;

pub fn isInf(x: var) -> bool {
    const T = @typeOf(x);
    switch (T) {
        f32 => {
            const bits = @bitCast(u32, x);
            return bits & 0x7FFFFFFF == 0x7F800000;
        },
        f64 => {
            const bits = @bitCast(u64, x);
            return bits & (@maxValue(u64) >> 1) == (0x7FF << 52);
        },
        else => {
            @compileError("isInf not implemented for " ++ @typeName(T));
        },
    }
}

pub fn isPositiveInf(x: var) -> bool {
    const T = @typeOf(x);
    switch (T) {
        f32 => {
            return @bitCast(u32, x) == 0x7F800000;
        },
        f64 => {
            return @bitCast(u64, x) == 0x7FF << 52;
        },
        else => {
            @compileError("isPositiveInf not implemented for " ++ @typeName(T));
        },
    }
}

pub fn isNegativeInf(x: var) -> bool {
    const T = @typeOf(x);
    switch (T) {
        f32 => {
            return @bitCast(u32, x) == 0xFF800000;
        },
        f64 => {
            return @bitCast(u64, x) == 0xFFF << 52;
        },
        else => {
            @compileError("isNegativeInf not implemented for " ++ @typeName(T));
        },
    }
}

test "math.isInf" {
    assert(!isInf(f32(0.0)));
    assert(!isInf(f32(-0.0)));
    assert(!isInf(f64(0.0)));
    assert(!isInf(f64(-0.0)));
    assert(isInf(math.inf(f32)));
    assert(isInf(-math.inf(f32)));
    assert(isInf(math.inf(f64)));
    assert(isInf(-math.inf(f64)));
}

test "math.isPositiveInf" {
    assert(!isPositiveInf(f32(0.0)));
    assert(!isPositiveInf(f32(-0.0)));
    assert(!isPositiveInf(f64(0.0)));
    assert(!isPositiveInf(f64(-0.0)));
    assert(isPositiveInf(math.inf(f32)));
    assert(!isPositiveInf(-math.inf(f32)));
    assert(isPositiveInf(math.inf(f64)));
    assert(!isPositiveInf(-math.inf(f64)));
}

test "math.isNegativeInf" {
    assert(!isNegativeInf(f32(0.0)));
    assert(!isNegativeInf(f32(-0.0)));
    assert(!isNegativeInf(f64(0.0)));
    assert(!isNegativeInf(f64(-0.0)));
    assert(!isNegativeInf(math.inf(f32)));
    assert(isNegativeInf(-math.inf(f32)));
    assert(!isNegativeInf(math.inf(f64)));
    assert(isNegativeInf(-math.inf(f64)));
}
