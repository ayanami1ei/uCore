    .section .text
    
    .equ tf_kernel_satp, 0
    .equ tf_kernel_sp, 8
    .equ tf_kernel_trap, 16
    .equ tf_epc, 24
    .equ tf_kernel_hartid, 32
    .equ tf_ra, 40
    .equ tf_sp, 48
    .equ tf_gp, 56
    .equ tf_tp, 64
    .equ tf_t0, 72
    .equ tf_t1, 80
    .equ tf_t2, 88
    .equ tf_s0, 96
    .equ tf_s1, 104
    .equ tf_a0, 112
    .equ tf_a1, 120
    .equ tf_a2, 128
    .equ tf_a3, 136
    .equ tf_a4, 144
    .equ tf_a5, 152
    .equ tf_a6, 160
    .equ tf_a7, 168
    .equ tf_s2, 176
    .equ tf_s3, 184
    .equ tf_s4, 192
    .equ tf_s5, 200
    .equ tf_s6, 208
    .equ tf_s7, 216
    .equ tf_s8, 224
    .equ tf_s9, 232
    .equ tf_s10, 240
    .equ tf_s11, 248
    .equ tf_t3, 256
    .equ tf_t4, 264
    .equ tf_t5, 272
    .equ tf_t6, 280

    .equ TF_SIZE,(8*36)

    .globl user_save
    .align 2
user_save:
    csrrw a0, sscratch, a0

    sd ra, tf_ra(a0)
    sd sp, tf_sp(a0)
    sd gp, tf_gp(a0)
    sd tp, tf_tp(a0)
    sd t0, tf_t0(a0)
    sd t1, tf_t1(a0)
    sd t2, tf_t2(a0)
    sd s0, tf_s0(a0)
    sd s1, tf_s1(a0)
    sd a1, tf_a1(a0)
    sd a2, tf_a2(a0)
    sd a3, tf_a3(a0)
    sd a4, tf_a4(a0)
    sd a5, tf_a5(a0)
    sd a6, tf_a6(a0)
    sd a7, tf_a7(a0)
    sd s2, tf_s2(a0)
    sd s3, tf_s3(a0)
    sd s4, tf_s4(a0)
    sd s5, tf_s5(a0)
    sd s6, tf_s6(a0)
    sd s7, tf_s7(a0)
    sd s8, tf_s8(a0)
    sd s9, tf_s9(a0)
    sd s10, tf_s10(a0)
    sd s11, tf_s11(a0)
    sd t3, tf_t3(a0)
    sd t4, tf_t4(a0)
    sd t5, tf_t5(a0)
    sd t6, tf_t6(a0)

    csrr t0, sscratch
    sd t0, tf_a0(a0)

    csrr t1, sepc
    sd t1, tf_epc(a0)

    ld sp, tf_kernel_sp(a0)
    ld tp, tf_kernel_hartid(a0)
    ld t1, tf_kernel_satp(a0)
    # csrw satp, t1
    # sfence.vma zero, zero
    ld t0, tf_kernel_trap(a0)
    jr t0

    .globl user_load
user_load:
        # userret(TRAPFRAME, pagetable)
        # switch from kernel to user.
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        # csrw satp, a1
        # sfence.vma zero, zero

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
        csrw sscratch, t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
        ld sp, 48(a0)
        ld gp, 56(a0)
        ld tp, 64(a0)
        ld t0, 72(a0)
        ld t1, 80(a0)
        ld t2, 88(a0)
        ld s0, 96(a0)
        ld s1, 104(a0)
        ld a1, 120(a0)
        ld a2, 128(a0)
        ld a3, 136(a0)
        ld a4, 144(a0)
        ld a5, 152(a0)
        ld a6, 160(a0)
        ld a7, 168(a0)
        ld s2, 176(a0)
        ld s3, 184(a0)
        ld s4, 192(a0)
        ld s5, 200(a0)
        ld s6, 208(a0)
        ld s7, 216(a0)
        ld s8, 224(a0)
        ld s9, 232(a0)
        ld s10, 240(a0)
        ld s11, 248(a0)
        ld t3, 256(a0)
        ld t4, 264(a0)
        ld t5, 272(a0)
        ld t6, 280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret