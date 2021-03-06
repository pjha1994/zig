const fixuint = @import("fixuint.zig").fixuint;
const builtin = @import("builtin");

pub extern fn __fixunssfti(a: f32) -> u128 {
    @setDebugSafety(this, builtin.is_test);
    return fixuint(f32, u128, a);
}

test "import fixunssfti" {
    _ = @import("fixunssfti_test.zig");
}

