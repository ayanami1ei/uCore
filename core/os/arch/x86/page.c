#include"page.h"
#include "../../types.h"
#include"../../string.h"

#define PAGE_SIZE 4096

// 位操作函数
static inline int get_bit(uint8_t *bitmap, int bit) {
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
}

static inline void set_bit(uint8_t *bitmap, int bit) {
    bitmap[bit / 8] |= (1 << (bit % 8));
}

static inline void clear_bit(uint8_t *bitmap, int bit) {
    bitmap[bit / 8] &= ~(1 << (bit % 8));
}

__attribute__((aligned(4096))) struct PagedDirectoryEntry page_directory[1024];
__attribute__((aligned(4096))) struct PageTableEntry page_table[512][1024]; // 512个页表，每个1024项
uint8_t phys_bitmap[512]; // 每位表示一个物理页

void page_init() {
    // 初始化页目录和页表
    for (int i = 0; i < 1024; i++) {
        page_directory[i].present = 0;
        page_directory[i].rw = 1;
        page_directory[i].user = 0;
        page_directory[i].reserved = 0;
        page_directory[i].table_addr = 0;
    }

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 1024; j++) {
            page_table[i][j].present = 0;
            page_table[i][j].rw = 1;
            page_table[i][j].user = 0;
            page_table[i][j].reserved = 0;
            page_table[i][j].frame_addr = 0;
        }
    }

    // 初始化物理页位图，所有页初始为可用（除了内核使用的）
    memset(phys_bitmap, 0, sizeof(phys_bitmap));
    // 标记内核使用的页为已用（假设内核使用前64页，256KB）
    for (int i = 0; i < 64; i++) {
        set_bit(phys_bitmap, i);
    }

    // 映射前 4MB 内存
    for (int i = 0; i < 1024; i++) {
        page_table[0][i].present = 1;
        page_table[0][i].rw = 1;
        page_table[0][i].user = 0;
        page_table[0][i].frame_addr = i; // 映射到物理地址 i * 4KB
    }

    // 设置页目录的第一个条目指向第一个页表
    page_directory[0].present = 1;
    page_directory[0].rw = 1;
    page_directory[0].user = 0;
    page_directory[0].table_addr = ((uint32_t)page_table[0]) >> 12;

    // 映射直接映射区域 0xC0000000 到物理 0 (前 4MB)
    for (int i = 0; i < 1024; i++) {
        page_table[1][i].present = 1;
        page_table[1][i].rw = 1;
        page_table[1][i].user = 0;
        page_table[1][i].frame_addr = i; // 映射到物理地址 i * 4KB
    }

    // 设置页目录的第768个条目指向第二个页表 (0xC0000000)
    page_directory[768].present = 1;
    page_directory[768].rw = 1;
    page_directory[768].user = 0;
    page_directory[768].table_addr = ((uint32_t)page_table[1]) >> 12;

    // 预先设置用户程序页目录项（页目录索引2，对应0x00800000）
    page_directory[2].present = 1;
    page_directory[2].rw = 1;
    page_directory[2].user = 1;
    page_directory[2].table_addr = ((uint32_t)page_table[2]) >> 12;

    //内核页表，0-1MB

    // 加载页目录地址到 CR3 寄存器
    asm volatile("mov %0, %%cr3" : : "r"(&page_directory));

    // 启用分页，设置 CR0 寄存器的分页位
    uint32_t cr0;
    asm volatile("mov %%cr0, %0" : "=r"(cr0));
    cr0 |= 0x80000000; // 设置分页位
    asm volatile("mov %0, %%cr0" : : "r"(cr0));
}

uint32_t alloc_phys_page() {
    for (int i = 0; i < 4096; i++) {
        if (!get_bit(phys_bitmap, i)) { // 页空闲
            set_bit(phys_bitmap, i);   // 标记为已用
            return i * PAGE_SIZE;      // 返回物理地址
        }
    }
    return 0; // 没有空闲页
}

void free_phys_page(uint32_t addr) {
    int index = addr / PAGE_SIZE;
    clear_bit(phys_bitmap, index);
}

void alloc_page(uint32_t fault_addr, bool is_write, bool is_user) {
    uint32_t dir_idx   = (fault_addr >> 22) & 0x3FF; // 高 10 位
    uint32_t table_idx = (fault_addr >> 12) & 0x3FF; // 中间 10 位

    struct PagedDirectoryEntry *pde = &page_directory[dir_idx];

    if (!pde->present) {
        // 设置PDE指向对应的页表
        pde->table_addr = ((uint32_t)page_table[dir_idx]) >> 12;
        pde->present    = 1;
        pde->rw         = 1;
        pde->user       = 1;
    }

    struct PageTableEntry *pte = &page_table[dir_idx][table_idx];
    uint32_t phys_page = alloc_phys_page();  // 新分配一个 4 KB 物理页
    
    // 通过直接映射区域清零物理页
    //uint32_t virt_addr = 0xC0000000 + phys_page;  // 直接映射虚拟地址
    //memset((void*)virt_addr, 0, PAGE_SIZE);

    pte->frame_addr = phys_page >> 12;
    pte->present    = 1;
    pte->rw         = is_write ? 1 : 0;
    pte->user       = is_user ? 1 : 0;
}

int r_cr2(){
    uint32_t val;
    asm volatile("mov %%cr2, %0" : "=r"(val));
    return val;
}

void page_not_found_handler(uint32_t err) {
    uint32_t fault_addr = r_cr2();
    uint32_t err_code = err;
    bool is_write = err_code & (1 << 1);
    bool is_user  = err_code & (1 << 2);

    alloc_page(fault_addr, is_write, is_user);
}


