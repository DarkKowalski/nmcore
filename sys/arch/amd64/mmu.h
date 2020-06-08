#ifndef ARCH_AMD64_MMU_H
#define ARCH_AMD64_MMU_H

/* Intel Programmer Manual
 * Volume 3: System Programming Guide
 * Chapter 3: Protected-mode memory management
 * Chapter 4: Paging
 */

/* Linear-Address Translation to a 4-KByte Page using 4-Level Paging:
 * Linear Address
 * 47:39 | 38:30         | 29:21     | 20:12 | 11:0
 * PML4  | Directory Ptr | Directory | Table | Offset
 * CR3 holds the base of PML4
 */

/* Page Map Level 4*/
#define PML4_SIZE                      0x1000
#define PML4_ALIGNMENT                 0x1000
#define PML4_ENTRY_SIZE                8
#define PML4_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 39) & 0x1FF)

/* Page-Directory-Pointer Table */
#define PDPT_SIZE                      0x1000
#define PDPT_ALIGNMENT                 0x1000
#define PDPT_ENTRY_SIZE                8
#define PDPT_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 30) & 0x1FF)

/* Page-Directory */
#define PAGE_DIRECTORY_SIZE                      0x1000
#define PAGE_DIRECTORY_ALIGNMENT                 0x1000
#define PAGE_DIRECTORY_ENTRY_SIZE                8
#define PAGE_DIRECTORY_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 21) & 0x1FF)

/* Page Table */
#define PAGE_TABLE_SIZE                      0x1000
#define PAGE_TABLE_ALIGNMENT                 0x1000
#define PAGE_TABLE_ENTRY_SIZE                8
#define PAGE_TABLE_ADDR_TO_ENTRY_INDEX(addr) (((addr) >> 12) & 0x1FF)

#endif