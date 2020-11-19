#include "./include/cr.h"

.code32
switch_to_long:
    mov %cr0, %eax
    and $(0xffffffff ^ PG), %eax // clear PG bit
    mov %eax, %cr0

    /*
     * PML4T 0x1000
     * PDPT  0x2000
     * PDT   0x3000
     * PT    0x4000
     */
    
    mov $0x1000, %edi
    mov %edi, %cr3
    xor %eax, %eax
    mov $4096, %ecx
    rep stosl
    mov %cr3, %edi

    movl $(0x2000 | PAGE_PRESENT | PAGE_WRITE), (%edi)
    add $0x1000, %edi
    movl $(0x3000 | PAGE_PRESENT | PAGE_WRITE), (%edi)
    add $0x1000, %edi
    movl $(0x4000 | PAGE_PRESENT | PAGE_WRITE), (%edi)
    add $0x1000, %edi

    mov $(0x00000000 | PAGE_PRESENT | PAGE_WRITE), %ebx
    mov $512, %ecx

loop_set_entry:
    mov %ebx, (%edi)
    add $0x1000, %ebx
    add $8, %edi
    sub $1, %ecx
    cmp $0, %ecx
    jg loop_set_entry
    jmp init_long

init_long:
    mov %cr4, %eax
    or $(PAE), %eax
    mov %eax, %cr4

    mov $EFER_MSR, %ecx
    rdmsr
    or $(LONG_MODE), %eax
    wrmsr

    mov %cr0, %eax
    or $(PG), %eax
    mov %eax, %cr0

    lgdt (gdt64_descriptor)
    push $CODE_SEG64
    push $begin_long
    ret
