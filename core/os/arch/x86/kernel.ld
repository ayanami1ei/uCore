ENTRY(_start)

SECTIONS
{
    . = 0x00100000;           /* 内核加载地址 */

    .multiboot : {
        KEEP(*(.multiboot))
    }
    
    skernel = .;

    .text : {
        *(.text.entry)
        *(.text .text.*)
    }

    . = ALIGN(4096);

    .rodata : { *(.rodata*) }
    . = ALIGN(4096);

    .data : { 
        *(.data*)
    }
    . = ALIGN(4096);

    .bss : {
        *(.bss.stack)
        *(.bss*)
        *(.sbss*)
    }
    . = ALIGN(4096);

    ekernel = .;

    /DISCARD/ : { *(.eh_frame) }
}
