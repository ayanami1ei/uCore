SECTIONS
{
    /* 程序装载起始虚拟地址（需在 0x80000000 以下，避免 medlow 重定位溢出） */
    . = 0x80400000;

    /* 启动入口，crt.S 中的 _start 放在最前面 */
    .startup :
    {
        KEEP(*(.text.entry))
    }

    .text :
    {
        *(.text .text.*)
    }

    .rodata :
    {
        *(.rodata .rodata.*)
    }

    .data :
    {
        *(.data .data.*)
    }

    .bss :
    {
        *(.bss .bss.* COMMON)
    }

    /DISCARD/ :
    {
        *(.eh_*)
    }
}