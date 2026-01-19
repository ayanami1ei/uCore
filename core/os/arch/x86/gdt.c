#include "../../string.h"

struct tss_entry tss;
#include "gdt.h"

struct gdt_entry gdt[GDT_SIZE];
struct gdt_ptr gp;

void set_gdt_entry(int num, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags)
{
    gdt[num].base_low = base & 0xFFFF;
    gdt[num].base_middle = (base >> 16) & 0xFF;
    gdt[num].base_high = (base >> 24) & 0xFF;

    gdt[num].limit_low = limit & 0xFFFF;
    gdt[num].granularity = ((limit >> 16) & 0x0F) | (flags & 0xF0);

    gdt[num].access = access;
}

void gdt_install()
{
    gp.limit = sizeof(gdt) - 1;
    gp.base = (uint32_t)&gdt;

    // Null descriptor
    set_gdt_entry(0, 0, 0, 0, 0);

    // 内核代码段 (CPL=0)
    set_gdt_entry(1, 0x0, 0xFFFFF,
                  SEG_PRESENT | SEG_CODE | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 内核数据段 (CPL=0)
    set_gdt_entry(2, 0x0, 0xFFFFF,
                  SEG_PRESENT | SEG_DATA | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户代码段 (CPL=3)
    set_gdt_entry(3, 0x0, 0xFFFFFFFF,
                  SEG_PRESENT | SEG_CODE | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户数据段 (CPL=3)
    set_gdt_entry(4, 0x0, 0xFFFFFFFF,
                  SEG_PRESENT | SEG_DATA | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // TSS段 (GDT[5])
    memset(&tss, 0, sizeof(tss));
    tss.ss0 = 0x10; // 内核数据段选择子
    tss.esp0 = 0;   // 需要在任务切换时设置
    uint32_t base = (uint32_t)&tss;
    uint32_t limit = sizeof(tss) - 1;
    set_gdt_entry(5, base, limit, 0x89, 0x00); // 0x89: present, type=32位TSS

    // 加载 GDTR
    asm volatile("lgdt (%0)" : : "r"(&gp));

    // 更新段寄存器，内核态 CS/DS/ES/FS/GS/SS
    asm volatile(
        "mov $0x10, %%ax\n"
        "mov %%ax, %%ds\n"
        "mov %%ax, %%es\n"
        "mov %%ax, %%fs\n"
        "mov %%ax, %%gs\n"
        :
        :
        : "ax");

    // 加载TSS
    asm volatile("ltr %%ax" : : "a"(5 << 3));
}

// 设置TSS的esp0（内核栈顶），可在任务切换时调用
void tss_set(uint32_t kernel_stack)
{
    tss.esp0 = kernel_stack;
}
