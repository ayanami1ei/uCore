#include "stdlib.h"
#include "unistd.h"
#include "string.h"

#define ALIGNMENT 8
#define ALIGN(size) (((size) + (ALIGNMENT - 1)) & ~(ALIGNMENT - 1))

typedef struct block
{
    size_t size;
    struct block *next;
    int free;
} block_t;

static block_t *heap_start = NULL;
static block_t *last_block = NULL;

void *malloc(size_t size)
{
    if (size == 0)
        return NULL;

    size = ALIGN(size);

    // 查找空闲块
    block_t *current = heap_start;
    while (current)
    {
        if (current->free && current->size >= size)
        {
            current->free = 0;
            return (void *)(current + 1);
        }
        current = current->next;
    }

    // 没有找到，扩展堆
    size_t total_size = sizeof(block_t) + size;
    void *new_block = sbrk(total_size);
    if (new_block == (void *)-1)
        return NULL;

    block_t *blk = (block_t *)new_block;
    blk->size = size;
    blk->next = NULL;
    blk->free = 0;

    if (!heap_start)
    {
        heap_start = blk;
    }
    else
    {
        last_block->next = blk;
    }
    last_block = blk;

    return (void *)(blk + 1);
}

void free(void *ptr)
{
    if (!ptr)
        return;

    block_t *blk = (block_t *)ptr - 1;
    blk->free = 1;

    // 可选：合并空闲块，但简化版不做
}