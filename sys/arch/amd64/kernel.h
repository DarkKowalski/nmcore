#ifndef ARCH_AMD64_KERNEL_H
#define ARCH_AMD64_KERNEL_H
#include "cr.h"

/* Start macros must have the same value in the kernel linker script */
#define KERNEL_PHYSICAL_START 0x0000000000400000
#define KERNEL_VIRTUAL_START  0xFFFFFFFF80400000

#define KERNEL_GDT_ENTRY 1
#define KERNEL_CR0       (CR0_PAGING | CR0_PROTECTED_MODE_ENABLE | CR0_EXTENSION_TYPE)
#define KERNEL_CR4       (CR4_PHYSICAL_ADDRESS_EXTENSION)

#endif