#ifndef ARCH_AMD64_GDT_H
#define ARCH_AMD64_GDT_H

/* Intel Programmer Manual
 * Volume 3: System Programming Guide
 * Chapter 2: System Architecture Overview
 * 2.1.1 Global and Local Descriptor Tables
 * Chapter 3: Protected-Mode Memory Management
 * 3.4.5 Segment Descriptors
 * And https://wiki.osdev.org/GDT has a consise diagram
 */

#include "segment_descriptor.h"

/* Mark as Code or Data */
#define DECLARE_GDT_ENTRY(base, limit, flags, access)                          \
    DECLARE_SEGMENT_DESCRIPTOR((base), (limit), (flags),                       \
                               ((access) | SEGDES_ACCESS_S))

#define GDT_KERNEL_ENTRY                                                       \
    DECLARE_GDT_ENTRY(                                                         \
        0, 0,          /* Base, Limit*/                                        \
        SEGDES_FLAG_L, /* 64-bit segment */                                    \
        (SEGDES_ACCESS_P | SEGDES_ACCESS_DPL_RING0 |                           \
         SEGDES_ACCESS_TYPE_D_C) /* Present + Ring0 + Code Segment */          \
    )

/* Should never be accessed with, that will cause a GP fault */
#define GDT_FIRST_ENTRY     0
#define GDT_ENTRY_SIZE      8
#define GDT_TABLE_ALIGNMENT (0x1000) /* 4096 Bytes */
#define GDT_TABLE_SIZE      (0x800)  /* 2048 Bytes */

#endif