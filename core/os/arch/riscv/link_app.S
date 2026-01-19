.align 4
    .section .data
    .global _app_num
_app_num:
    .quad 1
    .quad app_start
    .quad app_end

    .global _app_names
_app_names:
.string "helloworld.bin"

    .section .data.app
    .global app_start
app_start:
    .incbin "/home/ayanami/C++/OS/user_app/bin/user_app.bin"
app_end: