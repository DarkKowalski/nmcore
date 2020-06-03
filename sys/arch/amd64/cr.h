#ifndef ARCH_AMD64_CR_H
#define ARCH_AMD64_CR_H

/* Intel Programmer Manual
 * Volume 3: System Programming Guide
 * Chapter 2: System Architecture Overview
 * 2.5 Control Registers
 */

/* CR0*/
#define CR0_PROTECTED_MODE_ENABLE (1 << 0)
#define CR0_MONITOR_COPROCESSOR   (1 << 1)
#define CR0_EMULATION             (1 << 2)
#define CR0_TASK_SWITCHED         (1 << 3)
#define CR0_EXTENSION_TYPE        (1 << 4)
#define CR0_NUMERIC_ERROR         (1 << 5)
#define CR0_WRITE_PROTECT         (1 << 16)
#define CR0_ALIGNMENT_MASK        (1 << 18)
#define CR0_NOT_WRITE_THROUGH     (1 << 29)
#define CR0_CACHE_DISABLE         (1 << 30)
#define CR0_PAGING                (1 << 31)

#define CR0_PG CR0_PROTECTED_MODE_ENABLE
#define CR0_CD CR0_CACHE_DISABLE
#define CR0_NW CR0_NOT_WRITE_THROUGH
#define CR0_AM CR0_ALIGNMENT_MASK
#define CR0_WP CR0_WRITE_PROTECT
#define CR0_NE CR0_NUMERIC_ERROR
#define CR0_ET CR0_EXTENSION_TYPE
#define CR0_TS CR0_TASK_SWITCHED
#define CR0_EM CR0_EMULATION
#define CR0_MP CR0_MONITOR_COPROCESSOR
#define CR0_PE CR0_PROTECTED_MODE_ENABLE

/* CR3 */
#define CR3_PAGE_LEVEL_WRITE_THROUGH (1 << 3)
#define CR3_PAGE_LEVEL_CACHE_DISABLE (1 << 4)

#define CR3_PCD CR3_PAGE_LEVEL_CACHE_DISABLE
#define CR3_PWT CR3_PAGE_LEVEL_WRITE_THROUGH

/* CR4 */
#define CR4_VIRTUAL_8086_MODE_EXTENSIONS          (1 << 0)
#define CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS     (1 << 1)
#define CR4_TIME_STAMP_DISABLE                    (1 << 2)
#define CR4_DEBUGGING_EXTENSIONS                  (1 << 3)
#define CR4_PAGE_SIZE_EXTENSIONS                  (1 << 4)
#define CR4_PHYSICAL_ADDRESS_EXTENSION            (1 << 5)
#define CR4_MACHINE_CHECK_ENABLE                  (1 << 6)
#define CR4_PAGE_GLOBAL_ENABLE                    (1 << 7)
#define CR4_PERFORMANCE_MONITORING_COUNTER_ENABLE (1 << 8)
#define CR4_OPERATING_SYSTEM_SUPPORT_FOR_FXSAVE_AND_FXRSTOR_INSTRUCTIONS       \
  (1 << 9)
#define CR4_OPERATING_SYSTEM_SUPPORT_FOR_UNMASKED_SIMD_FLOATING_POINT_EXCEPTIONS \
  (1 << 10)
#define CR4_USER_MODE_INSTRUCTION_PREVENTION                 (1 << 11)
#define CR4_57_BIT_LINEAR_ADDRESSES                          (1 << 12)
#define CR4_VMX_ENABLE_BIT                                   (1 << 13)
#define CR4_SMX_ENABLE_BIT                                   (1 << 14)
#define CR4_FSGSBASE_ENABLE_BIT                              (1 << 16)
#define CR4_PCID_ENABLE_BIT                                  (1 << 17)
#define CR4_XSAVE_AND_PROCESSOR_EXTENDED_STATES_ENABLE_BIT   (1 << 18)
#define CR4_SMEP_ENABLE_BIT                                  (1 << 20)
#define CR4_SMAP_ENABLE_BIT                                  (1 << 21)
#define CR4_ENABLE_PROTECTION_KEYS_FOR_USER_MODE_PAGES       (1 << 22)
#define CR4_CONTROL_FLOW_ENFORCEMENT_TECHNOLOGY              (1 << 23)
#define CR4_ENABLE_PROTECTION_KEYS_FOR_SUPERVISOR_MODE_PAGES (1 << 24)

#define CR4_VME CR4_VIRTUAL_8086_MODE_EXTENSIONS
#define CR4_PVI CR4_PROTECTED_MODE_VIRTUAL_INTERRUPTS
#define CR4_TSD CR4_TIME_STAMP_DISABLE
#define CR4_DE  CR4_DEBUGGING_EXTENSIONS
#define CR4_PSE CR4_PAGE_SIZE_EXTENSIONS
#define CR4_PAE CR4_PHYSICAL_ADDRESS_EXTENSION
#define CR4_MCE CR4_MACHINE_CHECK_ENABLE
#define CR4_PGE CR4_PAGE_GLOBAL_ENABLE
#define CR4_PCE CR4_PERFORMANCE_MONITORING_COUNTER_ENABLE
#define CR4_OSFXSR                                                             \
  CR4_OPERATING_SYSTEM_SUPPORT_FOR_FXSAVE_AND_FXRSTOR_INSTRUCTIONS
#define CR4_OSXMMEXCPT                                                         \
  CR4_OPERATING_SYSTEM_SUPPORT_FOR_UNMASKED_SIMD_FLOATING_POINT_EXCEPTIONS
#define CR4_UMIP     CR4_USER_MODE_INSTRUCTION_PREVENTION
#define CR4_LA57     CR4_57_BIT_LINEAR_ADDRESSES
#define CR4_VMXE     CR4_VMX_ENABLE_BIT
#define CR4_SMXE     CR4_SMX_ENABLE_BIT
#define CR4_FSGSBASE CR4_FSGSBASE_ENABLE_BIT
#define CR4_PCIDE    CR4_PCID_ENABLE_BIT
#define CR4_OSXSAVE  CR4_XSAVE_AND_PROCESSOR_EXTENDED_STATES_ENABLE_BIT
#define CR4_SMEP     CR4_SMEP_ENABLE_BIT
#define CR4_SMAP     CR4_SMAP_ENABLE_BIT
#define CR4_PKE      CR4_ENABLE_PROTECTION_KEYS_FOR_USER_MODE_PAGES
#define CR4_CET      CR4_CONTROL_FLOW_ENFORCEMENT_TECHNOLOGY
#define CR4_PKS      CR4_ENABLE_PROTECTION_KEYS_FOR_SUPERVISOR_MODE_PAGES

/* CR8 */
#define CR8_TASK_PRIORITY_LEVEL(level) (0xF & (level))
#define CR8_TPL(value)                 CR8_TASK_PRIORITY_LEVEL(value)

#endif