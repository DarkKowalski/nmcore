.code16
print_hex:
    pusha
    mov $0, %cx // index

hex_loop:
    cmp $4, %cx
    je hex_end

    mov %dx, %ax
    and $0x000f, %ax // mask
    add $0x30, %al   // add 0x30 to N to convert it to ASCII "N"
    cmp $0x39, %al   // if > 9, use "A" to "F"
    jle hex_step2
    add $7, %al      // ASCII "A" is 65, 65 - 58 = 7
hex_step2:
    mov $hex_out, %bx      // base
    add $5, %bx            // + length
    sub %cx, %bx
    mov %al, (%bx)         // copy to memory
    ror $4, %dx            // data is in %dx

    add $1, %cx
    jmp hex_loop

hex_end:
    mov $hex_out, %bx
    call print
    
    popa
    ret

hex_out:
    .asciz "0x0000" // reverse space 