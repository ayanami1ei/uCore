#ifndef GDT_H
#define GDT_H

#include "../../types.h"

#define GDT_SIZE 6 // 增加TSS段
// TSS结构体
struct tss_entry
{
    uint32_t prev_tss;
    uint32_t esp0;
    uint32_t ss0;
    uint32_t esp1;
    uint32_t ss1;
    uint32_t esp2;
    uint32_t ss2;
    uint32_t cr3;
    uint32_t eip;
    uint32_t eflags;
    uint32_t eax, ecx, edx, ebx, esp, ebp, esi, edi;
    uint32_t es, cs, ss, ds, fs, gs;
    uint32_t ldt;
    uint16_t trap;
    uint16_t iomap_base;
} __attribute__((packed));

extern struct tss_entry tss;
void tss_set(uint32_t kernel_stack);

// 访问标志
#define SEG_PRESENT 0x80
#define SEG_CODE 0x1A // Executable + Readable
#define SEG_DATA 0x12 // Read/Write
#define SEG_RING0 0x00
#define SEG_RING3 0x60

// 标志
#define GDT_GRAN_4K 0x80
#define GDT_32BIT 0x40

struct gdt_entry
{
    uint16_t limit_low;  // 段界限低 16 位
    uint16_t base_low;   // 基址低 16 位
    uint8_t base_middle; // 基址中 8 位
    uint8_t access;      // 类型 + DPL + P
    uint8_t granularity; // 段界限高 4 位 + 标志
    uint8_t base_high;   // 基址高 8 位
} __attribute__((packed));

struct gdt_ptr
{
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

extern struct gdt_entry gdt[GDT_SIZE];
extern struct gdt_ptr gp;

void gdt_install();

#endif