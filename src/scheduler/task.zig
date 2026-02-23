//! Task definition

/// Number of tasks we support at a time
pub const MAX_TASKS: usize = 10;
var tasks: usize = 0;

/// Number of words the stack can hold
pub const MAX_STACK_SIZE: usize = 100;

pub const LR: usize = MAX_STACK_SIZE - 2;

const stacks: [MAX_TASKS][MAX_STACK_SIZE]u32 = undefined;

pub const Task = packed struct {
    sp: *u32,
    id: u8,

    pub fn init(task: *const fn () void, id: u8) Task {
        var stack = stacks[tasks];
        initStack(&stack);

        stack[LR] = @intFromPtr(task);

        tasks += 1;

        return Task{
            .id = id,
            .sp = &stack[MAX_STACK_SIZE - 16],
        };
    }
};

fn initStack(stack: *[MAX_STACK_SIZE]u32) void {
    stack[MAX_STACK_SIZE - 1] = 0x0100_0000; // Thumb bit

    stack[MAX_STACK_SIZE - 2] = 0xDEAD_BEEF; // PC
    stack[LR] = 0xFEEF_DEEF; // Link Register

    stack[MAX_STACK_SIZE - 4] = 0xABAB_BABA; // R12

    stack[MAX_STACK_SIZE - 5] = 0xBEED_DEEB; // R11
    stack[MAX_STACK_SIZE - 6] = 0xCDAC_CFFF; // R10
    stack[MAX_STACK_SIZE - 7] = 0x9090_9090; // R9
    stack[MAX_STACK_SIZE - 8] = 0x8080_0808; // R8
    stack[MAX_STACK_SIZE - 9] = 0x7070_7070; // R7
    stack[MAX_STACK_SIZE - 10] = 0xA6A6_A6A6; // R6
    stack[MAX_STACK_SIZE - 11] = 0x5005_0550; // R5
    stack[MAX_STACK_SIZE - 12] = 0x4444_4040; // R4

    stack[MAX_STACK_SIZE - 13] = 0x3E3E_3E3E; // R3
    stack[MAX_STACK_SIZE - 14] = 0x2B2B_2B2B; // R2
    stack[MAX_STACK_SIZE - 15] = 0x1010_1010; // R1
    stack[MAX_STACK_SIZE - 16] = 0x0AA0_0AA0; // R0
}
