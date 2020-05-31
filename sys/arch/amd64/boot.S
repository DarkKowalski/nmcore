#define ASM_FILE
#include "../generic/multiboot2.h"

/* 16KB stack size */
#define STACK_SIZE 0x4000

/* Framebuffer WxH=1024x768 Depth=32 */
#define FRAMEBUFFER_WIDTH 1024
#define FRAMEBUFFER_HEIGHT 768
#define FRAMEBUFFER_DEPTH 32

/* Get stack space ready */
.section .bss
stack_bottom:
.skip STACK_SIZE
stack_top:

.section .text
.global _start, start
start:
_start:
    jmp multiboot_entry

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
address_tag_start:
    /* Type (u16) */
    .short MULTIBOOT_HEADER_TAG_ADDRESS
    /* Flags (u16) */
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    /* Size (u32) */
    .long address_tag_end - address_tag_start
    /* Header address (u32) */
    .long multiboot_header
    /* Load address (u32) */
    .long _start
    /* Load end address (u32) */
    .long _edata
    /* Bss end address (u32) */
    .long _end
address_tag_end:
entry_address_tag_start:
    /* Type (u16)*/
    .short MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
    /* Flags (u16) */
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    /* Size (u32) */
    .long entry_address_tag_end - entry_address_tag_start
    /* Entry address (u32) */
    .long multiboot_entry
entry_address_tag_end:
framebuffer_tag_start:
    /* Type (u16) */
    .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
    /* Flags (u16) */
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    /* Size (u32) */
    .long framebuffer_tag_end - framebuffer_tag_start
    /* Width (u32) */
    .long FRAMEBUFFER_WIDTH
    /* Height (u32) */
    .long FRAMEBUFFER_HEIGHT
    /* Depth (u32) */
    .long FRAMEBUFFER_DEPTH
framebuffer_tag_end:
    /* Tags are terminate by a tag of type 0 and size 8 */
    .short MULTIBOOT_HEADER_TAG_END
    /* Flags cannot be OPTIONAL */
    .short 0
    .long 8
multiboot_header_end:
multiboot_entry:
    /* Set stack pointer */
    movl $stack_top, %esp

    /* Clear EFLAGS */
    pushl $0
    popf

    /* Push the pointer to the Multiboot2 information structure */
    pushl %ebx
    /* Push Multiboot2 magic value */
    pushl %eax

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



