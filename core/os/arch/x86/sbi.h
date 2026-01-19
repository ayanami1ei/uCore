#ifndef X86_SBI_H
#define X86_SBI_H

#include "../../types.h"

void put_char(char c);
void shutdown();

// x86 平台下提供与 RISC-V 部分类似的内联工具，
// 主要用于中断开关、读取栈指针和简单时间源。

// 打开中断（IF 位置 1）
static inline void intr_on()
{
    asm volatile("sti" ::: "memory");
}

// 关闭中断
static inline void intr_off()
{
    asm volatile("cli" ::: "memory");
}

// 查询当前是否开中断（检查 EFLAGS/RFLAGS 的 IF 位）
static inline int intr_get()
{
    unsigned long flags;
    asm volatile("pushf; pop %0" : "=r"(flags));
    return (flags & (1UL << 9)) != 0; // IF 位
}

// 读取当前栈指针（根据 32/64 位区分使用 ESP/RSP）
static inline uint32 r_sp()
{
    uint32 x;
#if defined(__x86_64__)
    asm volatile("mov %%rsp, %0" : "=r"(x));
#else
    unsigned long tmp;
    asm volatile("mov %%esp, %0" : "=r"(tmp));
    x = (uint32)tmp;
#endif
    return x;
}

// 通用页大小/对齐宏：x86 同样使用 4KiB 页
#define PGSIZE 4096
#define PGSHIFT 12

#define PGROUNDUP(sz) (((sz) + PGSIZE - 1) & ~(PGSIZE - 1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE - 1))

#endif // X86_SBI_H
