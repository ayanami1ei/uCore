BASE_ADDRESS = 0x80200000;

SECTIONS
{
    . = BASE_ADDRESS;
    skernel = .;

    s_text = .;
    .text : {
        *(.text.entry)
        *(.text .text.*)
    }

    . = ALIGN(4096);
    e_text = .;
    s_rodata = .;
    .rodata : {
        *(.rodata .rodata.*)
    }

    . = ALIGN(4096);
    e_rodata = .;
    s_data = .;
    .data : {
        *(.data)
        . = ALIGN(0x1000);
        *(.data.app)

        *(.data.*)
    }

    . = ALIGN(4096);
    e_data = .;
    s_bss = .;
    .bss : {
        *(.bss.stack)
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    . = ALIGN(4096);
    e_bss = .;
    ekernel = .;

    /DISCARD/ : {
        *(.eh_frame)
    }
}