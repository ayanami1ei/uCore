.section .text
.code32
.globl trap_entry
trap_entry:
    /*
     * 栈结构：
     * [SS, ESP] (Ring 3 Only)
     * EFLAGS
     * CS
     * EIP
     * Vector (Pushed by macro)
     */

    /* ---------- 保存段寄存器 ---------- */
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs

    /* ---------- 保存通用寄存器 ---------- */
    pusha

    /* ---------- 切换到内核数据段 ---------- */
    mov $0x10, %ax              /* 内核数据段选择子 */
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    /* ---------- 调用 C 处理函数 ---------- */
    pushl %esp                  /* struct trapframe* */
    call trap_handler
    addl $4, %esp

    /* ---------- 恢复寄存器（严格反序） ---------- */
    popa
    popl %gs
    popl %fs
    popl %es
    popl %ds
    
    /* 弹出 vector 号 (4字节) */
    addl $4, %esp 

    /* 弹出 err 号 (4字节) */
    addl $4, %esp

    /* ---------- 判断返回到用户态还是内核态 ---------- */
    /* iret 会根据栈上 CS 的 ring 位自动决定是否弹出 SS/ESP */
    testl $3, 4(%esp)  /* 检查 CS 的低2位是否为3 (用户态) */
    jnz user_return

kernel_return:
    /* 返回到内核态 */
    ret

user_return:
    /* 返回到用户态 */
    iret


    .section .text
    .code32
    .macro TRAP_STUB_err vec
    .globl trap_entry_\vec
trap_entry_\vec:
    pushl $\vec
    jmp trap_entry
    #pushl $trap_entry
    #ret
    .endm

    .section .text
    .code32
    .macro TRAP_STUB vec
    .globl trap_entry_\vec
trap_entry_\vec:
    pushl $0
    pushl $\vec
    jmp trap_entry
    #pushl $trap_entry
    #ret
    .endm

    # 生成 syscall 向量 0x80 的 stub
    .if 1
    TRAP_STUB 0
    TRAP_STUB 1
    TRAP_STUB 2
    TRAP_STUB 3
    TRAP_STUB 4
    TRAP_STUB 5
    TRAP_STUB 6
    TRAP_STUB 7
    TRAP_STUB 8
    TRAP_STUB 9
    TRAP_STUB 10
    TRAP_STUB 11
    TRAP_STUB 12
    TRAP_STUB 13
    TRAP_STUB_err 14
    TRAP_STUB 15
    TRAP_STUB 16
    TRAP_STUB 17
    TRAP_STUB 18
    TRAP_STUB 19
    TRAP_STUB 20
    TRAP_STUB 21
    TRAP_STUB 22
    TRAP_STUB 23
    TRAP_STUB 24
    TRAP_STUB 25
    TRAP_STUB 26
    TRAP_STUB 27
    TRAP_STUB 28
    TRAP_STUB 29
    TRAP_STUB 30
    TRAP_STUB 31
    TRAP_STUB 0x80
    .endif



        