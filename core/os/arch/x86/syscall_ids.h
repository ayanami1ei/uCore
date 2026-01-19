#ifndef USERAPP_ARCH_X86_SYSCALL_IDS_H
#define USERAPP_ARCH_X86_SYSCALL_IDS_H

// x86 32 位用户态使用的系统调用号
// 目前只用到 write / exit，保持与内核 x86 实现一致。

#define SYS_write 64
#define SYS_exit 93
#define SYS_sbrk 94

#endif