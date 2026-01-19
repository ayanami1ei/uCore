#ifndef PAGE_H
#define PAGE_H

#include <stdint.h>

struct PagedDirectoryEntry {
    uint32_t present    : 1;  // P 位，是否存在，存在为 1
    uint32_t rw         : 1;  // R/W 位，是否可读写，可读写为 1
    uint32_t user       : 1;  // U/S 位，用户态访问权限，用户态可访问为 1
    uint32_t reserved   : 9;  // 保留位
    uint32_t table_addr : 20; // 页表物理地址高 20 位（4KB 对齐）
};

struct PageTableEntry {
    uint32_t present    : 1;  // P 位，是否存在，存在为 1
    uint32_t rw         : 1;  // R/W 位，是否可读写，可读写为 1
    uint32_t user       : 1;  // U/S 位，用户态访问权限，用户态可访问为 1
    uint32_t reserved   : 9;  // 保留位
    uint32_t frame_addr : 20; // 页帧物理地址高 20 位（4KB 对齐）
};

void page_init();
void page_not_found_handler(uint32_t err_code);

#endif