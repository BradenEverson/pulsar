//! Generic tasks to register with known optima

const std = @import("std");

const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

const Scheduler = @import("scheduler/scheduler.zig").Scheduler;

const sched = @import("main.zig");

/// G-Code Parser
pub fn gcodeParser() noreturn {
    var buf: [64]u8 = undefined;
    const req_size = [1]u8{64};
    while (true) {
        // Notify G-Code provider that we're ready
        // for 64 more bytes of G-Code
        sched.ioCall(.{
            .UartTransmit = .{
                .msg = &req_size,
                .uart = .uart4,
            },
        });

        // Wait to receive G-Code payload
        sched.ioCall(.{
            .UartReceive = .{
                .buf = &buf,
                .uart = .uart4,
            },
        });

        // Process current G-Code instructions
        for (0..10_000) |i| _ = i;
    }
}
