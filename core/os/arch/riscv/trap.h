#ifndef TRAP_H
#define TRAP_H

#include "../../types.h"
#include "../arch.h"

#define BASE_ADDRESS 0x80400000
struct trapframe
{
    /*   0 */ uint64 kernel_satp;   // kernel page table
    /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
    /*  16 */ uint64 kernel_trap;   // usertrap()
    /*  24 */ uint64 epc;           // saved user program counter
    /*  32 */ uint64 kernel_hartid; // saved kernel tp
    /*  40 */ uint64 ra;
    /*  48 */ uint64 sp;
    /*  56 */ uint64 gp;
    /*  64 */ uint64 tp;
    /*  72 */ uint64 t0;
    /*  80 */ uint64 t1;
    /*  88 */ uint64 t2;
    /*  96 */ uint64 s0;
    /* 104 */ uint64 s1;
    /* 112 */ uint64 a0;
    /* 120 */ uint64 a1;
    /* 128 */ uint64 a2;
    /* 136 */ uint64 a3;
    /* 144 */ uint64 a4;
    /* 152 */ uint64 a5;
    /* 160 */ uint64 a6;
    /* 168 */ uint64 a7;
    /* 176 */ uint64 s2;
    /* 184 */ uint64 s3;
    /* 192 */ uint64 s4;
    /* 200 */ uint64 s5;
    /* 208 */ uint64 s6;
    /* 216 */ uint64 s7;
    /* 224 */ uint64 s8;
    /* 232 */ uint64 s9;
    /* 240 */ uint64 s10;
    /* 248 */ uint64 s11;
    /* 256 */ uint64 t3;
    /* 264 */ uint64 t4;
    /* 272 */ uint64 t5;
    /* 280 */ uint64 t6;
};

enum Exception
{
    InstructionMisaligned = 0,
    InstructionAccessFault = 1,
    IllegalInstruction = 2,
    Breakpoint = 3,
    LoadMisaligned = 4,
    LoadAccessFault = 5,
    StoreMisaligned = 6,
    StoreAccessFault = 7,
    UserEnvCall = 8,
    SupervisorEnvCall = 9,
    MachineEnvCall = 11,
    InstructionPageFault = 12,
    LoadPageFault = 13,
    StorePageFault = 15,
};

enum Interrupt
{
    UserSoft = 0,
    SupervisorSoft,
    UserTimer = 4,
    SupervisorTimer,
    UserExternal = 8,
    SupervisorExternal,
};

void trap_init();
void usertrap(struct trapframe *trapframe);
void usertrapret(struct trapframe *trapframe, uint64 kstack);
int user_app_load(uint64 *info);
void user_app_run();

/*
Interrupt   Exception Code  Description
0           0               Instruction address misaligned
0           1               Instruction access fault
0           2               Illegal instruction
0           3               Breakpoint
0           4               Load address misaligned
0           5               Load access fault
0           6               Store/AMO address misaligned
0           7               Store/AMO access fault
0           8               Environment call from U-mode
0           9               Environment call from S-mode
0           11              Environment call from M-mode
0           12              Instruction page fault
0           13              Load page fault
0           15              Store/AMO page fault
*/
#endif