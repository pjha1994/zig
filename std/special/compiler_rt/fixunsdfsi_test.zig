const __fixunsdfsi = @import("fixunsdfsi.zig").__fixunsdfsi;
const assert = @import("../../index.zig").debug.assert;

fn test__fixunsdfsi(a: f64, expected: u32) {
    const x = __fixunsdfsi(a);
    assert(x == expected);
}

test "fixunsdfsi" {
    test__fixunsdfsi(0.0, 0);

    test__fixunsdfsi(0.5, 0);
    test__fixunsdfsi(0.99, 0);
    test__fixunsdfsi(1.0, 1);
    test__fixunsdfsi(1.5, 1);
    test__fixunsdfsi(1.99, 1);
    test__fixunsdfsi(2.0, 2);
    test__fixunsdfsi(2.01, 2);
    test__fixunsdfsi(-0.5, 0);
    test__fixunsdfsi(-0.99, 0);
    test__fixunsdfsi(-1.0, 0);
    test__fixunsdfsi(-1.5, 0);
    test__fixunsdfsi(-1.99, 0);
    test__fixunsdfsi(-2.0, 0);
    test__fixunsdfsi(-2.01, 0);

    test__fixunsdfsi(0x1.000000p+31, 0x80000000);
    test__fixunsdfsi(0x1.000000p+32, 0xFFFFFFFF);
    test__fixunsdfsi(0x1.FFFFFEp+31, 0xFFFFFF00);
    test__fixunsdfsi(0x1.FFFFFEp+30, 0x7FFFFF80);
    test__fixunsdfsi(0x1.FFFFFCp+30, 0x7FFFFF00);

    test__fixunsdfsi(-0x1.FFFFFEp+30, 0);
    test__fixunsdfsi(-0x1.FFFFFCp+30, 0);

    test__fixunsdfsi(0x1.FFFFFFFEp+31, 0xFFFFFFFF);
    test__fixunsdfsi(0x1.FFFFFFFC00000p+30, 0x7FFFFFFF);
    test__fixunsdfsi(0x1.FFFFFFF800000p+30, 0x7FFFFFFE);
}
