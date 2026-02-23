.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global SchedulerStart

.extern CurrentTask

.section .text.SchedulerStart
.type SchedulerStart, %function
SchedulerStart:
    cpsid I              // disable interrupts
    ldr r0, =CurrentTask // load current task ptr ptr
    ldr r1, [r0]         // load current task ptr
    ldr sp, [r1]         // load field 1 of current task, SP

    pop {r0-r11}        // load regs 0-11
    pop {r12}           // load temp reg
    pop {lr}            // load lr (discard)
    pop {lr}            // load pc to lr
    pop {r1}            // discard the thumb bit psr
    cpsie I             // enable interrupts
    bx lr
