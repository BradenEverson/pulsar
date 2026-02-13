//! Zig Entrypoint

const std = @import("std");

const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

export fn timerIT() callconv(.c) void {}

export fn entry() callconv(.c) void {
    while (true) {}
}
