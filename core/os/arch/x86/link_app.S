.align 4
    .section .data
    .global _app_num
_app_num:
    .long 1          # app 数量（目前 1 个）
    .long app_start  # 应用起始地址（32 位）
    .long app_end    # 应用结束地址（32 位）

    .globl _app_names
_app_names:
    .string "helloworld.bin"

    .section .data.app
    .globl app_start
app_start:
    .incbin "../user_app/bin/user_app.bin"
app_end:
    .global _app_names
