#ifndef ARCH_AMD64_MSR_H
#define ARCH_AMD64_MSR_H

/* Model Specific Register : Extended Feature Enable Register */
#define MSR_EFER     0xC0000080 /* MSR Number */
#define MSR_EFER_LME (1 << 8)   /* Long Mode Enable */

#endif