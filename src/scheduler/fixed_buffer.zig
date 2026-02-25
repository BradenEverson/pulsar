//! Fixed Buffer ArrayList-like Structure

const std = @import("std");

pub const FixedBufferError = error{
    BufferFull,
};

pub fn FixedBufferArrayList(T: type, max: comptime_int) type {
    return struct {
        vals: [max]T = undefined,
        len: usize = 0,

        const Self = @This();

        pub fn append(self: *Self, val: T) !void {
            if (self.len == self.vals.len) return error.BufferFull;

            self.vals[self.len] = val;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.len == 0) return null;

            self.len -= 1;
            return self.vals[self.len];
        }
    };
}

test "FixedBuffer init" {
    const TenIntBuffer = FixedBufferArrayList(i32, 10);

    var foo = TenIntBuffer{};
    try foo.append(0);

    const val = foo.vals[0];

    try std.testing.expectEqual(0, val);

    try foo.append(1);
    try foo.append(2);
    try foo.append(3);
    try foo.append(4);
    try foo.append(5);
    try foo.append(6);
    try foo.append(7);
    try foo.append(8);
    try foo.append(9);

    const err = foo.append(10);

    try std.testing.expectError(error.BufferFull, err);
}

test "Pop" {
    const TenIntBuffer = FixedBufferArrayList(i32, 10);

    var foo = TenIntBuffer{};
    try foo.append(0);
    try foo.append(1);
    try foo.append(2);
    try foo.append(3);
    try foo.append(4);
    try foo.append(5);
    try foo.append(6);
    try foo.append(7);
    try foo.append(8);
    try foo.append(9);

    try std.testing.expectEqual(9, foo.pop().?);
    try std.testing.expectEqual(8, foo.pop().?);
    try std.testing.expectEqual(7, foo.pop().?);
    try std.testing.expectEqual(6, foo.pop().?);
    try std.testing.expectEqual(5, foo.pop().?);
    try std.testing.expectEqual(4, foo.pop().?);
    try std.testing.expectEqual(3, foo.pop().?);
    try std.testing.expectEqual(2, foo.pop().?);
    try std.testing.expectEqual(1, foo.pop().?);
    try std.testing.expectEqual(0, foo.pop().?);
    try std.testing.expectEqual(null, foo.pop());
}
