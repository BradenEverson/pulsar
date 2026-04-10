//! Connected Vehicle Gateway (CVG) tasks for interpreting CAN signals in the car and managing
//! cloud based transmissions. This workload set has many mixed behavior tasks, ideally highlighting
//! PULSAR's dynamic allocation scheme

const std = @import("std");
const sched = @import("main.zig");
const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

var telemtry_buffer: [1024]u8 = undefined;
var buffer_index: usize = 0;
var buffer_mutex: bool = false;

/// CAN Bus Reading and Logging Buffer Task
pub fn canBusLogger() noreturn {
    var rx_frame: [8]u8 = undefined;
    while (true) {
        sched.ioCall(.{
            .UartReceive = .{ .buf = &rx_frame, .uart = .uart4 },
        });

        var i: u8 = 0;
        while (i < 8) : (i += 1) {
            rx_frame[i] = rx_frame[i] * 2;
        }

        if (buffer_index < 1000) {
            telemtry_buffer[buffer_index] = rx_frame[0];
            buffer_index += 1;
        } else {
            sched.ioCall(.{ .SleepMs = 10 });
        }
    }
}

/// Cloud encryption and transmission task
pub fn cloudSync() noreturn {
    var encrypted_chunk: [128]u8 = undefined;
    while (true) {
        if (buffer_index > 128) {
            for (telemtry_buffer[0..128], 0..) |byte, i| {
                var j: u32 = 0;
                var val = byte;
                while (j < 500) : (j += 1) {
                    const j_u8: u8 = @truncate(j);
                    val = val ^ j_u8;
                }
                encrypted_chunk[i] = val;
            }

            sched.ioCall(.{
                .UartTransmit = .{ .msg = &encrypted_chunk, .uart = .uart2 },
            });

            buffer_index = 0;
        } else {
            sched.ioCall(.{ .SleepMs = 100 });
        }
    }
}

/// Simulated Computer Vision task for car cameras
pub fn edgeVisionInference() noreturn {
    while (true) {
        // GPIO trigger when frame is ready
        sched.ioCall(.{ .GpioWait = .{ .port = .A, .pin = 0 } });

        var x: f32 = 1.1;
        var i: u32 = 0;
        while (i < 5000) : (i += 1) {
            x = x * 1.0001;
        }

        c.HAL_GPIO_TogglePin(c.GPIOA, c.GPIO_PIN_5);
    }
}

/// User Screen UI management task
pub fn infotainmentUI() noreturn {
    while (true) {
        c.HAL_GPIO_WritePin(c.GPIOB, c.GPIO_PIN_1, c.GPIO_PIN_SET);
        sched.ioCall(.{ .SleepMs = 16 });

        c.HAL_GPIO_WritePin(c.GPIOB, c.GPIO_PIN_1, c.GPIO_PIN_RESET);
        sched.ioCall(.{ .SleepMs = 1 });
    }
}
