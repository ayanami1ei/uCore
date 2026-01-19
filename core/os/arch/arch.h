#ifndef ARCH_H
#define ARCH_H

// 根据已有宏或编译器内置宏推导当前架构，
// 为上层代码提供 RISCV64 / X86 宏。

// 如果在编译命令行已经显式定义了 RISCV64 或 X86，
// 则直接使用，避免重复定义产生警告。

#if defined(RISCV64)
/* already defined */
#elif defined(X86)
/* already defined */

#elif defined(__riscv)

#define RISCV64\

#elif defined(__i386__) || defined(__x86_64__)

#define X86

#else
#error "Unknown architecture in arch/arch.h"
#endif

#endif // ARCH_H