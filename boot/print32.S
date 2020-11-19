#include "./include/vga.h"

.code32
print_string32:
    pusha
    mov $VIDEO_MEMORY, %edx

print_string32_loop:
    mov (%ebx), %al
    mov $WHITE_ON_BLACK, %ah

    cmp $0, %al
    je print_string32_done

    mov %ax, (%edx)
    add $1, %ebx
    add $2, %edx

    jmp print_string32_loop

print_string32_done:
    popa
    ret
