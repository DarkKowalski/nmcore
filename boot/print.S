.code16
print:
    pusha

print_start:
    mov (%bx), %al
    cmp $0, %al
    je print_done // meet the trailing zero in the string

    mov $0x0e, %ah
    int $0x10

    add $1, %bx
    jmp print_start

print_done:
    popa
    ret

print_nl:
    pusha

    mov $0x0e, %ah
    mov $0x0a, %al // newline
    int $0x10
    mov $0x0d, %al // CR
    int $0x10

    popa
    ret


