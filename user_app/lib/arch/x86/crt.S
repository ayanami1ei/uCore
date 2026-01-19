.section .text.entry
.globl _start
_start:
    # push argc(0) and argv(NULL)
    push $0
    push $0
    call __start_main
.hang:
    hlt
    jmp .hang
