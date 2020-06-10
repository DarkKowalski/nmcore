#define ASM_FILE

#include "../../sizes.h"
#include "../../kernel.h"
#include "../generic/multiboot2.h"
#include "mmu.h"
#include "gdt.h"
#include "cr.h"
#include "msr.h"

.section .multiboot
/* Align 64 bits boundry */
.align 8
multiboot_header:
    /* Magic (u32)*/
    .long MULTIBOOT2_HEADER_MAGIC
    /* Architecture (u32) */
    .long MULTIBOOT_ARCHITECTURE_I386
    /* Header length (u32) */
    .long multiboot_header_end - multiboot_header
    /* Checksum (u32) */
    .long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

.align 8
    /* Tags are terminate by a tag of type 0 and size 8 */
    .short MULTIBOOT_HEADER_TAG_END
    /* Flags cannot be OPTIONAL */
    .short 0
    .long 8
multiboot_header_end:

.code32
.section .bss
.comm pml4, PML4_SIZE, PML4_ALIGNMENT
.comm low_pdpt, PDPT_SIZE, PDPT_ALIGNMENT
.comm high_pdpt, PDPT_SIZE, PDPT_ALIGNMENT
.comm low_page_directory_table, PAGE_DIRECTORY_SIZE, PAGE_DIRECTORY_ALIGNMENT
.comm high_page_directory_table, PAGE_DIRECTORY_SIZE, PAGE_DIRECTORY_ALIGNMENT
.comm tmp_stack, KERNEL_BOOT_STACK_SIZE, KERNEL_BOOT_STACK_ALIGNMENT

.data
.align GDT_TABLE_ALIGNMENT
gdt_table:
    .8byte GDT_FIRST_ENTRY
    .8byte GDT_KERNEL_ENTRY
gdt_table_end:
    .skip (GDT_TABLE_SIZE - (gdt_table_end - gdt_table))
gdt_ptr:
    .short GDT_TABLE_SIZE - 1
    .long  gdt_table

.section .text
.global _start
.type _start, @function
_start:
multiboot_entry:
    /* Setup stack pointer */
    movl $tmp_stack + KERNEL_BOOT_STACK_SIZE, %esp

    /* Setup two PDPTs */
    movl $low_pdpt, %eax
    or $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, pml4 + (PML4_ADDR_TO_ENTRY_INDEX(KERNEL_PHYSICAL_START) * PML4_ENTRY_SIZE)
    
    movl $high_pdpt, %eax
    or $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, pml4 + (PML4_ADDR_TO_ENTRY_INDEX(KERNEL_VIRTUAL_START) * PML4_ENTRY_SIZE)

    /* Setup two Page Directories */
    movl $low_page_directory_table, %eax
    or $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, low_pdpt + (PDPT_ADDR_TO_ENTRY_INDEX(KERNEL_PHYSICAL_START) * PDPT_ENTRY_SIZE)

    movl $high_page_directory_table, %eax
    or $(MMU_PRESENT | MMU_WRITABLE), %eax
    movl %eax, high_pdpt + (PDPT_ADDR_TO_ENTRY_INDEX(KERNEL_VIRTUAL_START) * PDPT_ENTRY_SIZE)
    
    /* %ecx contains current entry being set  */
    movl $0, %ecx
    /* %esi contains the number of pages to be set */
    movl $_kernel_physical_end, %esi
    shrl $TWO_MEGABYTES_SHIFT, %esi
    addl $1, %esi

page_directory_table_loop:
    movl $TWO_MEGABYTES, %eax
    mul %ecx
    or $(MMU_PRESENT | MMU_WRITABLE | MMU_PDE_TWO_MB), %eax
    movl %eax, low_page_directory_table(, %ecx, PAGE_DIRECTORY_ENTRY_SIZE)
    movl %eax, high_page_directory_table(, %ecx, PAGE_DIRECTORY_ENTRY_SIZE) 
    inc %ecx
    cmp %esi, %ecx
    jne page_directory_table_loop

    /* Setup CRs and EFER */
    movl $pml4, %eax
    movl %eax, %cr3
    movl $KERNEL_CR4, %eax
    movl %eax, %cr4
    movl $MSR_EFER, %ecx
    rdmsr
    or $MSR_EFER_LME, %eax
    wrmsr
    movl $KERNEL_CR0, %eax
    movl %eax, %cr0

    /* Setup GDTR */
    lgdt gdt_ptr
    /* %cs, %eip */
    ljmp $(KERNEL_GDT_ENTRY * GDT_ENTRY_SIZE), $_start64

    cli
    hlt

.code64
.global _start64
.type _start64, @function
_start64:

    /* Setup segment selectors */
    movw $0, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    
    /* Enter higher level kernel */
    call kernel_main

    /* If return from kernel:
     * 1. Clear interrupt enable in EFLAGS
     * 2. Wait for next interrupt with halt, de-facto locking up
     * 3. Loop until arriving of NMI
     */
    cli
lock_up:
    hlt
    jmp lock_up
_edata:
