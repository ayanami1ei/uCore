#ifndef X86_SYSCALL_H
#define X86_SYSCALL_H

#include "trap.h"

void syscall(struct trapframe *tf);

#endif
