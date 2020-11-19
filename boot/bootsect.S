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

    call load_kernel
    call switch_to_protected
    jmp .

#include "./print.S"
#include "./print_hex.S"
#include "./disk.S"
#include "./gdt32.S"
#include "./print32.S"
#include "./switch_to_protected.S"

.code16
load_kernel:
    mov $msg_load_kernel, %bx
    call print
    call print_nl

    mov $KERNEL_OFFSET, %bx
    mov $SECTORS_TO_READ, %dh
    mov (boot_drive), %dl
    call disk_load
    ret

.code32
begin_protected:
    mov $msg_protected, %ebx
    call print_string32
    //call KERNEL_OFFSET
    jmp .

boot_drive:
    .byte 0
msg_real_mode:
    .asciz "Started in 16-bit Real Mode"
msg_load_kernel:
    .asciz "Loading kernel into memory"
msg_protected:
    .asciz "Landed in 32-bit Protected Mode"


.space 510-(.-_start)
.word 0xaa55
