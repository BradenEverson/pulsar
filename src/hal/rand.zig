//! Static Random Number Generation

const std = @import("std");
const time = @import("time.zig");

var prng: ?std.Random.DefaultPrng = null;

pub inline fn getRand() std.Random {
    if (prng) |*r| {
        return r.random();
    } else {
        // prng = .init(@as(u64, time.getTimeMicros()));
        prng = .init(0x90908797);
        // prng = .init(0xFBFBFBF);
        // prng = .init(0x0BBFDFD9);
        // prng = .init(0xC238945B);
        return prng.?.random();
    }
}
