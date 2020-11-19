disk_load:
    pusha
    push %dx

    mov $0x02, %ah // read mode
    mov %dh, %al   // sectors to read
    mov $0x02, %cl // 0x01 is the boot sector, 0x02 is the first avaliable sector

    mov $0, %ch    // cylinder
    mov $0, %dh    // head number

    int $0x13
    jc disk_error

    pop %dx
    cmp %dh, %al
    jne sector_error
    popa
    ret

disk_error:
    mov $msg_disk_error, %bx
    call print
    call print_nl
    mov %ah, %dh  // %ah = error code, %dl = disk drive that dropped the error
    call print_hex
    jmp disk_loop

sector_error:
    mov $msg_sector_error, %bx
    call print

disk_loop:
    jmp .

msg_disk_error:
    .asciz "Disk read error"
msg_sector_error:
    .asciz "Incorrect number of sectors to read"
