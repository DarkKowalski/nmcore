#define CODE_SEG64 (gdt64_code - gdt64_start)
#define DATA_SEG64 (gdt64_data - gdt64_start)

gdt64_start:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0
    .byte 1
    .byte 0
gdt64_code:
    .word 0
    .word 0
    .byte 0
    .byte 0b10011010
    .byte 0b10101111
    .byte 0
gdt64_data:
    .word 0
    .word 0
    .byte 0
    .byte 0b10010010
    .byte 0
    .byte 0
gdt64_end:

gdt64_descriptor:
    .word gdt64_end - gdt64_start - 1
    .quad gdt64_start