#include "syscall.h"
#include "trap.h"
#include "sbi.h"
#include "syscall_ids.h"
#include "../../types.h"
#include "../../console.h"

static uint32 heap_end = 0x900000; // 初始堆顶，假设在用户空间

uint32 sys_write(int fd, const char *str, uint32 len)
{
    // fd=1 (stdout) 或 fd=2 (stderr) 都可以输出
    if ((fd != 1 && fd != 2) || str == 0)
        return -1;
    for (uint32_t i = 0; i < len; ++i)
        put_char(str[i]);
    return len;
}

__attribute__((noreturn)) void sys_exit(int code)
{
    shutdown();
    __builtin_unreachable();
}

uint32 sys_sbrk(int increment)
{
    uint32 old_heap = heap_end;
    heap_end += increment;
    // 这里可以添加页面分配逻辑，如果需要
    return old_heap;
}

void syscall(struct trapframe *tf)
{
    if (!tf)
        return;
    int id = tf->eax;
    int ret = -1;
    uint32 args[6] = {tf->ebx, tf->ecx, tf->edx, tf->esi, tf->edi, tf->ebp};

    // 获取自动压栈内容
    __attribute__((unused)) uint32 *stack = (uint32 *)(tf + 1);
    __attribute__((unused)) uint32 eip = stack[0];
    __attribute__((unused)) uint32 cs = stack[1];
    __attribute__((unused)) uint32 eflags = stack[2];
    __attribute__((unused)) uint32 user_esp = stack[3];
    __attribute__((unused)) uint32 user_ss = stack[4];
    switch (id)
    {
    case SYS_write:
        ret = sys_write(args[0], (const char *)args[1], args[2]);
        break;
    case SYS_exit:
        sys_exit(args[0]);
        break;
    case SYS_sbrk:
        ret = sys_sbrk(args[0]);
        break;
    default:
        printf("unknown interrupt or exception");
        sys_exit(args[0]);
        break;
    }
    tf->eax = ret;
}
