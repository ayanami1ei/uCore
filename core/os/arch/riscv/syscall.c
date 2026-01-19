#include "syscall.h"
#include "../../types.h"
#include "trap.h"
#include "syscall_ids.h"
#include "sbi.h"

uint64 sys_write(int fd, const char *str, uint len)
{
    if (fd != 1 || str == 0)
        return -1;
    for (uint i = 0; i < len; ++i)
        put_char(str[i]);
    return len;
}

__attribute__((noreturn)) void sys_exit(int code)
{
    shutdown();
    __builtin_unreachable();
}

extern char trap_page[];

void syscall()
{
    struct trapframe *trapframe = (struct trapframe *)trap_page;
    int id = trapframe->a7, ret;
    uint64 args[6] = {trapframe->a0, trapframe->a1, trapframe->a2,
                      trapframe->a3, trapframe->a4, trapframe->a5};
    switch (id)
    {
    case SYS_write:
        ret = sys_write(args[0], (const char *)args[1], args[2]);
        break;
    case SYS_exit:
        sys_exit(args[0]);
        // 不返回
    default:
        ret = -1;
        break;
    }
    trapframe->a0 = ret;
}