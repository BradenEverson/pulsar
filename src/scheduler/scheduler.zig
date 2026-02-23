//! Scheduler control for all the tasks

const task = @import("task.zig");
const Task = task.Task;

pub const Scheduler = struct {
    task_count: usize = 0,
    tasks: [task.MAX_TASKS]?Task = [_]?Task{null} ** task.MAX_TASKS,

    pub fn register(self: *Scheduler, t: *const fn () void, id: u8) void {
        const t_constructed = Task.init(t, id);
        self.tasks[self.task_count] = t_constructed;

        self.task_count += 1;
    }
};
