#include "./include/offset.h"
#include "./include/size.h"

.global _start
.bss
.align 4
stack_bottom:
    .space BOOT_STACK_SIZE
stack_top:

.text
.code16
_start:
    mov %dl, (boot_drive)
    mov stack_top, %bp
    mov %bp, %sp

    mov $msg_real_mode, %bx
    call print
    call print_nl

    call load_setup
    push $SETUP_OFFSET
    ret
    jmp .

#include "./print.S"
#include "./print_hex.S"
#include "./disk.S"

.code16
load_setup:
    mov $msg_load_setup, %bx
    call print
    call print_nl

    mov $SETUP_OFFSET, %bx
    mov $SETUP_SECTORS_TO_READ, %dh
    mov (boot_drive), %dl
    call disk_load
    ret

boot_drive:
    .byte 0
msg_real_mode:
    .asciz "Started in 16-bit Real Mode"
msg_load_setup:
    .asciz "Loading setting up procedures into memory"

.space 510-(.-_start)
.word 0xaa55
