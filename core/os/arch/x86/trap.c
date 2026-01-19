#include "trap.h"
#include "idt_entry.h"
#include "../../string.h"
#include "../../console.h"
#include "syscall.h"
#include "../../sbi.h"
#include "gdt.h"
#include"page.h"   

extern void user_load(struct trapframe *tf);
extern char boot_stack_top[];
extern void trap_entry_0x80(void);
extern void trap_entry_0(void);
extern void trap_entry_1(void);
extern void trap_entry_2(void);
extern void trap_entry_3(void);
extern void trap_entry_4(void);
extern void trap_entry_5(void);
extern void trap_entry_6(void);
extern void trap_entry_7(void);
extern void trap_entry_8(void);
extern void trap_entry_9(void);
extern void trap_entry_10(void);
extern void trap_entry_11(void);
extern void trap_entry_12(void);
extern void trap_entry_13(void);
extern void trap_entry_14(void);
extern void trap_entry_15(void);
extern void trap_entry_16(void);
extern void trap_entry_17(void);
extern void trap_entry_18(void);
extern void trap_entry_19(void);
extern void trap_entry_20(void);
extern void trap_entry_21(void);
extern void trap_entry_22(void);
extern void trap_entry_23(void);
extern void trap_entry_24(void);
extern void trap_entry_25(void);
extern void trap_entry_26(void);
extern void trap_entry_27(void);
extern void trap_entry_28(void);
extern void trap_entry_29(void);
extern void trap_entry_30(void);
extern void trap_entry_31(void);
extern void syscall(struct trapframe *tf);
extern void user_enter(uint32 entry, uint32 user_stack);
extern char _app_num[];

__attribute__((aligned(4096))) char trap_page[0x1000];
__attribute__((aligned(4096))) char user_stack_top[0x1000];

void idt_init(void)
{
    memset(idt, 0, sizeof(idt));

    set_idt_gate(0x80, trap_entry_0x80, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(0, trap_entry_0, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(1, trap_entry_1, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(2, trap_entry_2, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(3, trap_entry_3, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(4, trap_entry_4, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(5, trap_entry_5, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(6, trap_entry_6, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(7, trap_entry_7, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(8, trap_entry_8, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(9, trap_entry_9, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(10, trap_entry_10, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(11, trap_entry_11, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(12, trap_entry_12, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(13, trap_entry_13, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(14, trap_entry_14, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(15, trap_entry_15, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(16, trap_entry_16, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(17, trap_entry_17, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(18, trap_entry_18, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(19, trap_entry_19, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(20, trap_entry_20, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(21, trap_entry_21, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(22, trap_entry_22, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(23, trap_entry_23, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(24, trap_entry_24, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(25, trap_entry_25, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(26, trap_entry_26, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(27, trap_entry_27, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(28, trap_entry_28, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(29, trap_entry_29, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(30, trap_entry_30, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
    set_idt_gate(31, trap_entry_31, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);

    idt_load();
}

void trap_init()
{
    idt_init();

    asm volatile("sti");
}

void trap_handler(struct trapframe *tf)
{
    if (!tf)
        return;

    switch(tf->trapno)
    {
        case 14: // Page Fault
            page_not_found_handler(tf->err);
            return;
        case 13:
            printf("General Protection Fault at EIP: 0x%x\n", tf->eip);
            shutdown();
        case 0x80: // Syscall
            syscall(tf);
            return;
        default:
            break;
    }

    printf("CPU Exception %d occurred!\n", tf->trapno);
    shutdown();

    return;
}

int user_app_load(uint32 *info)
{
    uint32 start = info[1];
    uint32 end = info[2];
    uint32 length = end - start;

    memset((void *)BASE_ADDRESS, 0, length);
    memmove((void *)BASE_ADDRESS, (void *)start, length);

    return (int)length;
}

void user_app_run(void)
{
    user_app_load((uint32 *)_app_num);
    tss_set((uint32_t)boot_stack_top);
    user_enter(BASE_ADDRESS, (uint32_t)(user_stack_top + sizeof(user_stack_top)));
}
