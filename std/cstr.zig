const std = @import("index.zig");
const debug = std.debug;
const mem = std.mem;
const assert = debug.assert;

pub fn len(ptr: &const u8) -> usize {
    var count: usize = 0;
    while (ptr[count] != 0) : (count += 1) {}
    return count;
}

pub fn cmp(a: &const u8, b: &const u8) -> i8 {
    var index: usize = 0;
    while (a[index] == b[index] and a[index] != 0) : (index += 1) {}
    if (a[index] > b[index]) {
        return 1;
    } else if (a[index] < b[index]) {
        return -1;
    } else {
        return 0;
    }
}

pub fn toSliceConst(str: &const u8) -> []const u8 {
    return str[0..len(str)];
}

pub fn toSlice(str: &u8) -> []u8 {
    return str[0..len(str)];
}

test "cstr fns" {
    comptime testCStrFnsImpl();
    testCStrFnsImpl();
}

fn testCStrFnsImpl() {
    assert(cmp(c"aoeu", c"aoez") == -1);
    assert(len(c"123456789") == 9);
}

/// Returns a mutable slice with exactly the same size which is guaranteed to
/// have a null byte after it.
/// Caller owns the returned memory.
pub fn addNullByte(allocator: &mem.Allocator, slice: []const u8) -> %[]u8 {
    const result = try allocator.alloc(u8, slice.len + 1);
    mem.copy(u8, result, slice);
    result[slice.len] = 0;
    return result;
}

pub const NullTerminated2DArray = struct {
    allocator: &mem.Allocator,
    byte_count: usize,
    ptr: ?&?&u8,

    /// Takes N lists of strings, concatenates the lists together, and adds a null terminator
    /// Caller must deinit result
    pub fn fromSlices(allocator: &mem.Allocator, slices: []const []const []const u8) -> %NullTerminated2DArray {
        var new_len: usize = 1; // 1 for the list null
        var byte_count: usize = 0;
        for (slices) |slice| {
            new_len += slice.len;
            for (slice) |inner| {
                byte_count += inner.len;
            }
            byte_count += slice.len; // for the null terminators of inner
        }

        const index_size = @sizeOf(usize) * new_len; // size of the ptrs
        byte_count += index_size;

        const buf = try allocator.alignedAlloc(u8, @alignOf(?&u8), byte_count);
        %defer allocator.free(buf);

        var write_index = index_size;
        const index_buf = ([]?&u8)(buf);

        var i: usize = 0;
        for (slices) |slice| {
            for (slice) |inner| {
                index_buf[i] = &buf[write_index];
                i += 1;
                mem.copy(u8, buf[write_index..], inner);
                write_index += inner.len;
                buf[write_index] = 0;
                write_index += 1;
            }
        }
        index_buf[i] = null;

        return NullTerminated2DArray {
            .allocator = allocator,
            .byte_count = byte_count,
            .ptr = @ptrCast(?&?&u8, buf.ptr),
        };
    }

    pub fn deinit(self: &NullTerminated2DArray) {
        const buf = @ptrCast(&u8, self.ptr);
        self.allocator.free(buf[0..self.byte_count]);
    }
};

