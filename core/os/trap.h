#ifndef TRAP_H
#define TRAP_H

#include "types.h"
#include "arch/arch.h"

#ifdef RISCV64
#include "arch/riscv/sbi.h"
#elif defined(X86)
#include "arch/x86/sbi.h"
#else
#error "Unknown architecture for sbi.h"
#endif

#endif // SBI_H