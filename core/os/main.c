// main.c (rewritten to remove BOM)
#include "console.h"
#include "arch/riscv/trap.h"
#include"arch/x86/gdt.h"
#include"sbi.h"
#include"arch/x86/page.h"

// 在这里真正定义全局定时器实例
//struct timer t;

int main()
{
   gdt_install();
   trap_init();
   page_init();

   printf("Welcome to uCore!\n");

   printf("Starting user app...\n");
   user_app_run();
   printf("User app finished\n");

   shutdown();

   return 0;
}
