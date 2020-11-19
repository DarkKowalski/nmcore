#ifndef BOOT_CR_H
#define BOOT_CR_H

#define PAGE_PRESENT (1 << 0)
#define PAGE_WRITE   (1 << 1)

#define PAE (1 << 5)
#define PG  (1 << 31)

#define EFER_MSR  0xc0000080
#define LONG_MODE (1 << 8)

#endif
