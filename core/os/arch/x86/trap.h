#ifndef TRAP_H
#define TRAP_H

#include "../../types.h"

#define BASE_ADDRESS 0x00800000
struct trapframe
{
    /* pusha 保存（顺序由 x86 硬件固定） */
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp_dummy; // pusha 保存的原 esp，丢弃
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;

    /* 手动保存的段寄存器 */
    uint32_t gs;
    uint32_t fs;
    uint32_t es;
    uint32_t ds;

    /* 向量号 (由 TRAP_STUB 压入) */
    uint32_t trapno;

    /* 错误代码 (由 CPU 压入)  */
    uint32_t err;

    /* CPU 自动压栈 */
    uint32_t eip;
    uint32_t cs;
    uint32_t eflags;

    /* 仅当 CPL3 -> CPL0 时存在
       为了统一，内核态中断时我们会手动补 0 */
    uint32_t user_esp;
    uint32_t user_ss;
};

#define T_DIVIDE 0
#define T_DEBUG 1
#define T_GP 13
#define T_PGFLT 14
#define T_SYSCALL 0x80
#define IRQ_OFFSET 32
#define IRQ_TIMER (IRQ_OFFSET + 0)
#define IRQ_KBD (IRQ_OFFSET + 1)

void trap_init();
int user_app_load(uint32 *info);
void user_app_run();

/*
Interrupt   Exception Code  Description
0           0               Instruction address misaligned
0           1               Instruction access fault
0           2               Illegal instruction
0           3               Breakpoint
0           4               Load address misaligned
0           5               Load access fault
0           6               Store/AMO address misaligned
0           7               Store/AMO access fault
0           8               Environment call from U-mode
0           9               Environment call from S-mode
0           11              Environment call from M-mode
0           12              Instruction page fault
0           13              Load page fault
0           15              Store/AMO page fault
*/
#endif