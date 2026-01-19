.section .multiboot, "a"
.align 4
.long 0x1BADB002       # magic
.long 0x0               # flags
.long -(0x1BADB002 + 0x0)
    
    .section .text.entry, "ax"
    .code32                 # 明确告诉汇编器是 32 位代码
    .globl _start
_start:
    # 初始化内核栈指针 ESP
    mov $boot_stack_top, %esp

    call main               # 调到 C 里的 main()

    # 如果 main 返回，简单死循环或停机
.hang:
    hlt
    jmp .hang

    .section .bss.stack, "aw", @nobits
    .align 16
    .globl boot_stack
boot_stack:
    .space 4096 * 16        # 16 页 4K 栈
    .globl boot_stack_top

boot_stack_top: