#include "syscall.h"
#include "syscall_ids.h"
#include "stddef.h"

ssize_t write(int fd, const void *buf, size_t count)
{
    return (ssize_t)syscall(SYS_write, fd, (long)buf, (long)count);
}

void exit(int code)
{
    syscall(SYS_exit, code);
}
