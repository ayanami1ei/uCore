#include "sbi.h"

static char *video_memory = (char *)0xb8000;

void put_char(char c)
{
    // 简单的换行处理 logic
    if (c == '\n')
    {
        uint32_t current_offset = (uint32_t)(video_memory - 0xb8000);
        uint32_t current_row = (current_offset / 2) / 80;
        uint32_t next_row_offset = (current_row + 1) * 80 * 2;
        video_memory = (char *)(0xb8000 + next_row_offset);
    }
    else
    {
        *video_memory = c;
        video_memory++;
        *video_memory = 0x07; // 黑底灰字
        video_memory++;
    }

    // 也写到串口 COM1（0x3F8），便于在 QEMU 中使用 -serial stdio 查看
    unsigned short port = 0x3f8;
    asm volatile("outb %0, %1" ::"a"(c), "Nd"(port));
}

static inline void outw(uint16_t port, uint16_t value)
{
    __asm__ volatile("outw %0, %1" : : "a"(value), "Nd"(port));
}

void shutdown()
{
    outw(0x604, 0x2000); // QEMU power off
    for (;;)
        __asm__ volatile("hlt");
}