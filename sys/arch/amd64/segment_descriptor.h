#ifndef ARCH_AMD64_SEGMENT_DESCRIPTOR_H
#define ARCH_AMD64_SEGMENT_DESCRIPTOR_H

/* Intel Programmer Manual
 * Volume 3: System Programming Guide
 * Chapter 2: System Architecture Overview
 * 3.4.5 Segment Descriptors
 */

#define SEGDES_ENTRY_SIZE 8 /* 64 bits */

/* Flags 52:55 */
#define SEGDES_FLAG_G   (1 << 3) /* Granularity */
#define SEGDES_FLAG_D_B (1 << 2) /* Default opeartion size */
#define SEGDES_FLAG_L   (1 << 1) /* 64-bit code segment (IA-32e mode only) */
#define SEGDES_FLAG_AVL (1 << 0) /* Avaliable for use by system software */

/* Access Byte 40:47 */
#define SEGDES_ACCESS_P (1 << 7) /* Segment present */
/* Descriptor privilege levels */
#define SEGDES_ACCESS_DPL_RING0 (0x0 << 5)
#define SEGDES_ACCESS_DPL_RING1 (0x1 << 5)
#define SEGDES_ACCESS_DPL_RING2 (0x2 << 5)
#define SEGDES_ACCESS_DPL_RING3 (0x3 << 5)
/* Descriptor type, clear = System, set = Code or Data */
#define SEGDES_ACCESS_S (1 << 4)
/* When S is clear: Table 3-2. System-Segment and Gate-Descriptor Types */
/* 32-bit Mode */
#define SEGDES_ACCESS_TYPE_16BIT_TSS_AVALIABLE  (0x1)
#define SEGDES_ACCESS_TYPE_LDT                  (0x2)
#define SEGDES_ACCESS_TYPE_16BIT_TSS_BUSY       (0x3)
#define SEGDES_ACCESS_TYPE_16BIT_CALL_GATE      (0x4)
#define SEGDES_ACCESS_TYPE_TASK_GATE            (0x5)
#define SEGDES_ACCESS_TYPE_16BIT_INTERRUPT_GATE (0x6)
#define SEGDES_ACCESS_TYPE_16BIT_TRAP_GATE      (0x7)
#define SEGDES_ACCESS_TYPE_32BIT_TSS_AVALIABLE  (0x9)
#define SEGDES_ACCESS_TYPE_32BIT_TSS_BUSY       (0xB)
#define SEGDES_ACCESS_TYPE_32BIT_CALL_GATE      (0xC)
#define SEGDES_ACCESS_TYPE_32BIT_INTERRUPT_GATE (0xE)
#define SEGDES_ACCESS_TYPE_32BIT_TRAP_GATE      (0xF)
/* IA-32e Mode */
/* SEGDES_ACCESS_TYPE_LDT is the same as 32-bit Mode version */
#define SEGDES_ACCESS_TYPE_64BIT_TSS_AVALIABLE (0x9)
#define SEGDES_ACCESS_TYPE_64BIT_TSS_BUSY      (0xB)
#define SEGDES_ACCESS_TYPE_CALL_GATE           (0xC)
#define SEGDES_ACCESS_TYPE_INTERRUPT_GATE      (0xE)
#define SEGDES_ACCESS_TYPE_TRAP_GATE           (0xF)
/* When S is set, clear = Data, set = Code */
#define SEGDES_ACCESS_TYPE_D_C (1 << 3)
/* Data: Expansion-direction, Code: Confroming */
#define SEGDES_ACCESS_TYPE_E_C (1 << 2)
/* Data: Write-enable, Code: Read-enable */
#define SEGDES_ACCESS_TYPE_W_R (1 << 1)
/* Data & Code: Accessed */
#define SEGDES_ACCESS_TYPE_A (1 << 0)

/* Segment Descriptor (64-bit) layout:
 * Part(bits)         (part-offset start:end)    global-offset start:end
 * Limit(16)          (0:15)                     0:15
 * Base(16)           (0:15)                     16:31
 * Base(8)            (16:23)                    32:39
 * Access Byte(8)     (0:7)                      40:47
 * Limit(4)           (16:19)                    48:51
 * Flags(4)           (0:3)                      52:55
 * Base(8)            (24:31)                    56:63
 */

#define DECLARE_SEGMENT_DESCRIPTOR(base, limit, flags, access)                 \
  (((((base) >> 24) & 0xFF) << 56) | /* Base(24:31)*/                          \
   (((flags)&0xF) << 52) |           /* Flags */                               \
   ((((limit) >> 16) & 0xF) << 48) | /* Limit(16:19)*/                         \
   (((access)&0xFF) << 40) |         /* Access Byte */                  \
   (((base)&0xFFF) << 16) |          /* Base(0:23) */                          \
   ((limit)&0xFFFF)                  /* Limit(0:15) */                         \
  )

#endif