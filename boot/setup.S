.code16
setup:
    call switch_to_protected

#include "./gdt32.S"
#include "./print32.S"
#include "./switch_to_protected.S"
#include "./gdt64.S"
#include "./switch_to_long.S"

.code32
begin_protected:
    mov $msg_protected, %ebx
    call print_string32
    call switch_to_long
    jmp .

.code64
begin_long:
    mov $msg_long, %ebx
    call print_string32
    jmp .

msg_protected:
    .asciz "Landed in 32-bit Protected Mode"
msg_long:
    .asciz "Landed in 64-bit Long Mode"

.space 2048-(.-setup)