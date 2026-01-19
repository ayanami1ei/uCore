SECTIONS
{
    . = 0x00800000;

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
