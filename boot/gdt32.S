#define CODE_SEG (gdt_code - gdt_start)
#define DATA_SEG (gdt_data - gdt_start)

gdt_start:
    .long 0
    .long 0
gdt_code:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0
gdt_data:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start -1 // size
    .long gdt_start              // address
