#include "sbi.h"

const uint64 SBI_SET_TIMER = 0;
const uint64 PUT_CHAR_MODE = 1;
const uint64 SHUTDOWN_MODE = 8;

const uint64 UART0_ADDRESS = 0x10000000UL;
const uint64 UART_RHR = 0;
const uint64 UART_LSR = 5;

#define PLIC_BASE 0x0c000000UL
#define UART0_IRQ 10
#define HART0_SENABLE (PLIC_BASE + 0x2080)
#define HART0_STHRESHOLD (PLIC_BASE + 0x201000)

static inline void plic_write32(uint64 addr, uint32 val)
{
    *(volatile uint32 *)addr = val;
}

static inline uint32 plic_read32(uint64 addr)
{
    return *(volatile uint32 *)addr;
}

void plic_enable_uart0(void)
{
    // 1. 设置 UART0 的优先级 > 0
    plic_write32(PLIC_BASE + 4 * UART0_IRQ, 1);

    // 2. 在 hart0 S-mode enable 寄存器里打开 UART0 对应的 bit
    uint32 en = plic_read32(HART0_SENABLE);
    en |= (1u << UART0_IRQ);
    plic_write32(HART0_SENABLE, en);

    // 3. 把 S-mode threshold 设为 0（只要有优先级>0 的中断就能进来）
    plic_write32(HART0_STHRESHOLD, 0);
}

inline int sbi_call(uint64 which, uint64 arg0, uint64 arg1, uint64 arg2)
{
    register uint64 a0 asm("a0") = arg0;
    register uint64 a1 asm("a1") = arg1;
    register uint64 a2 asm("a2") = arg2;
    register uint64 a7 asm("a7") = which;

    asm volatile("ecall"
                 : "=r"(a0)
                 : "r"(a0), "r"(a1), "r"(a2), "r"(a7)
                 : "memory");

    return a0;
}

int put_char(char c)
{
    return sbi_call(PUT_CHAR_MODE, (uint64)c, 0, 0);
}

int shutdown()
{
    put_char('s');
    put_char('h');
    put_char('u');
    put_char('t');
    put_char('d');
    put_char('o');
    put_char('w');
    put_char('n');
    put_char('\n');
    return sbi_call(SHUTDOWN_MODE, 0, 0, 0);
}

uint8 r_LSR(void)
{
    return *(volatile uint8 *)(UART0_ADDRESS + UART_LSR);
}

uint8 r_RHR(void)
{
    return *(volatile uint8 *)(UART0_ADDRESS + UART_RHR);
}
