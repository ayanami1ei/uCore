#include "idt_entry.h"

struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtp;
extern void idt_flush(uint32_t);

void set_idt_gate(int vec, void (*handler)(), uint16_t selector, uint8_t flags)
{
    uint32_t addr = (uint32_t)handler;

    idt[vec].offset_low = addr & 0xFFFF;
    idt[vec].selector = selector;
    idt[vec].zero = 0;
    idt[vec].type_attr = flags;
    idt[vec].offset_high = (addr >> 16) & 0xFFFF;
}

void idt_load(void)
{
    idtp.limit = sizeof(idt) - 1;
    idtp.base = (uint32_t)&idt;

    asm volatile("lidt %0" : : "m"(idtp));

    idt_flush((uint32_t)&idtp);
}
