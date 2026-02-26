//! Scheduler control for all the tasks

const task = @import("task.zig");
const time = @import("../time.zig");
const Task = task.Task;

const logger = @import("../logger.zig");

extern fn SchedulerStart() void;

const c = @cImport({
    @cDefine("USE_HAL_DRIVER", {});
    @cDefine("STM32F446xx", {});
    @cInclude("main.h");
});

pub inline fn disable_irq() void {
    asm volatile ("cpsid i" ::: .{ .memory = true });
}

pub inline fn enable_irq() void {
    asm volatile ("cpsie i" ::: .{ .memory = true });
}

export var CurrentTask: *Task = undefined;

pub const Scheduler = struct {
    task_count: usize = 0,
    curr: usize = 0,
    tasks: [task.MAX_TASKS]Task = undefined,

    last_time: u32 = 0,

    /// Choose who goes next and allocate the proper time slice for them
    pub inline fn schedule(self: *Scheduler) void {
        const now = time.getTimeMicros();

        const delta = now - self.last_time;
        CurrentTask.metadata.run_time += delta;

        self.curr += 1;
        self.curr %= self.task_count;

        CurrentTask = &self.tasks[self.curr];

        self.last_time = time.getTimeMicros();
    }

    pub fn register(self: *Scheduler, t: *const fn () noreturn, id: u8) void {
        const t_constructed = Task.init(t, id);
        self.tasks[self.task_count] = t_constructed;

        if (self.task_count == 0) {
            CurrentTask = &self.tasks[self.task_count];
        }

        self.task_count += 1;
    }

    pub fn start(self: *Scheduler) noreturn {
        if (self.task_count == 0) {
            logger.info("Error: No Tasks Registered!!!\r\n");
            @panic("Invalid State");
        }

        disable_irq();

        self.last_time = time.getTimeMicros();
        c.SCHEDULER_ENABLE_IT();

        // Call the start asm fn
        SchedulerStart();

        unreachable;
    }
};
