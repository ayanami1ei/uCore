// Dispatcher header: select arch-specific syscall IDs.

#ifndef USERAPP_SYSCALL_IDS_H
#define USERAPP_SYSCALL_IDS_H

#if defined(__riscv)
#include "arch/riscv/syscall_ids.h"
#elif defined(__i386__)
#include "arch/x86/syscall_ids.h"
#else
#error "Unsupported architecture for user_app syscall_ids.h"
#endif

#endif