    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    # 将 trap_entry 的地址装入通用寄存器，再写入 stvec
    #la t0, trap_entry
    #la t0, user_save
    #csrw stvec, t0
    call main    

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 * 16
    .globl boot_stack_top
boot_stack_top:

