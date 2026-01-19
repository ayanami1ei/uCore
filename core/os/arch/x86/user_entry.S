.intel_syntax noprefix
.global user_enter

# 参数：eax = 用户态栈顶地址 (user_esp)
#        ebx = 用户代码入口 (entry)

user_enter:
    cli
    # C调用约定：
    #   第一个参数 [esp+4]  -> entry (用户程序入口)
    #   第二个参数 [esp+8]  -> user_esp (用户栈顶)
    mov eax, [esp + 8]    # user_esp
    mov ebx, [esp + 4]    # entry

    push 0x23             # SS (用户数据段选择子，ring3)
    push eax              # ESP (用户栈顶)
    pushfd
    or dword ptr [esp], 0x200
    push 0x1B             # CS (用户代码段选择子，ring3)
    push ebx              # EIP (用户入口)
    iret

    
.intel_syntax noprefix
.globl idt_flush
idt_flush:
	mov eax, [esp+4]  #参数存入 eax 寄存器
	lidt [eax]        #加载到 IDTR
	ret
