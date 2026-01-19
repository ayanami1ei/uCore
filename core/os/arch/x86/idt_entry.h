#ifndef IDT_ENTRY_H
#define IDT_ENTRY_H

#include "../../types.h"

#define IDT_PRESENT 0x80
#define IDT_INT_GATE 0x0E
#define IDT_RING3 0x60 // DPL = 3

struct idt_entry
{
    uint16_t offset_low;  // handler 地址低 16 位
    uint16_t selector;    // 代码段选择子（通常是 0x08）
    uint8_t zero;         // 必须为 0
    uint8_t type_attr;    // 类型 + DPL + P
    uint16_t offset_high; // handler 地址高 16 位
} __attribute__((packed));

struct idt_ptr
{
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

#define IDT_SIZE 256

extern struct idt_entry idt[IDT_SIZE];
extern struct idt_ptr idtp;

void set_idt_gate(int vec, void (*handler)(), uint16_t selector, uint8_t flags);
void idt_load(void);

#endif