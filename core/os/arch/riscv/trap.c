#include "trap.h"
#include "sbi.h"
// #include "timer.h"
// #include "keyboard.h"
#include "../../console.h"
#include "syscall.h"
#include "../../string.h"

extern void user_save(void);
extern char _app_num[];
extern void *user_load(uint64);
extern char boot_stack_top[];

__attribute__((aligned(4096))) char user_stack[0x1000];
__attribute__((aligned(4096))) char trap_page[0x1000];

void trap_init()
{
    // 设置 S 模式 trap 向量到 user_save，这样来自 U 模式的 ecall 会先进入 user_save
    w_stvec((uint64)user_save);
}

int user_app_load(uint64 *info)
{
    uint64 start = info[1];
    uint64 end = info[2];
    uint64 length = end - start;

    memset((void *)BASE_ADDRESS, 0, length);
    memmove((void *)BASE_ADDRESS, (void *)start, length);

    return (int)length;
}

void user_app_run()
{
    struct trapframe *tf = (struct trapframe *)trap_page;
    user_app_load((uint64 *)_app_num);

    memset(tf, 0, 4096);
    tf->epc = BASE_ADDRESS;
    tf->sp = (uint64)user_stack + 0x1000;

    usertrapret(tf, (uint64)boot_stack_top);
}

void usertrap(struct trapframe *trapframe)
{
    if ((r_sstatus() & SSTATUS_SPP) != 0)
        printf("usertrap: not from user mode");

    uint64 cause = r_scause();
    if (cause == UserEnvCall)
    {
        trapframe->epc += 4;
        syscall();
        usertrapret(trapframe, (uint64)boot_stack_top);
        return;
    }
    switch (cause)
    {
    case StoreMisaligned:
    case StorePageFault:
    case LoadMisaligned:
    case LoadPageFault:
    case InstructionMisaligned:
    case InstructionPageFault:
        printf("%d in application, bad addr = %p, bad instruction = %p, core "
               "dumped.",
               cause, r_stval(), trapframe->epc);
        break;
    case IllegalInstruction:
        printf("IllegalInstruction in application, epc = %p, core dumped.",
               trapframe->epc);
        break;
    default:
        printf("unknown trap: %p, stval = %p sepc = %p", r_scause(),
               r_stval(), r_sepc());
        break;
    }
    printf("switch to next app");
    user_app_run();
    printf("ALL DONE\n");
    shutdown();
}

void usertrapret(struct trapframe *trapframe, uint64 kstack)
{
    trapframe->kernel_satp = r_satp();      // kernel page table
    trapframe->kernel_sp = kstack + PGSIZE; // process's kernel stack
    trapframe->kernel_trap = (uint64)usertrap;
    trapframe->kernel_hartid = r_tp(); // hartid for cpuid()

    w_sepc(trapframe->epc);
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    uint64 x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    w_sstatus(x);

    // tell trampoline.S the user page table to switch to.
    // uint64 satp = MAKE_SATP(p->pagetable);
    user_load((uint64)trapframe);
}