#include <stddef.h>
#include <stdint.h>
#include <cyn/lib.h>
#include "paging.h"

#ifdef x86_64

void addpml4t(uint64_t* pml4_table, PML4EFlags flags) {
    for (int i = 0; i < 512; i++) {
        pml4_table[i] = 0x0 | (flags);
    }
}

void delpml4t(uint64_t* pml4_table) {
    for (int i = 0; i < 512; i++) {
        pml4_table[i] = 0x0;
    }
}

void addpdpt(uint64_t* pml4_table, size_t index, uint64_t* pdpt, PDPTEFlags flags) {
    for (size_t i = 0; i < 512; i++) {
        pdpt[i] = 0x0 | (flags);
    }
    pml4_table[index] = ((uint64_t)pdpt) | (PML4E_PRESENT + PML4E_READ_WRITE);
}

void delpdpt(uint64_t* pml4_table, size_t index, uint64_t* pdpt) {
    for (size_t i = 0; i < 512; i++) {
        pdpt[i] = 0x0;
    }
    pml4_table[index] = ((uint64_t)pdpt);
}

void addpagedir(uint64_t* pdpt, size_t index, uint64_t* page_dir, PDEFlags flags) {
    for (size_t i = 0; i < 512; i++) {
        page_dir[i] = 0x0 | (flags);
    }
    pdpt[index] = ((uint64_t)page_dir) | (PDPTE_PRESENT + PDPTE_READ_WRITE);
}

void delpagdir(uint64_t* pdpt, size_t index, uint64_t* page_dir) {
    for (size_t i = 0; i < 512; i++) {
        page_dir[i] = 0x0;
    }
    pdpt[index] = ((uint64_t)page_dir);
}

void addpagtable(uint64_t* page_dir, size_t index, uint64_t* page_table, PTEFlags flags, uint64_t offset) {
    for (size_t i = 0; i < 512; i++) {
        page_table[i] = (offset + (i * 0x1000)) | (flags);
    }
    page_dir[index] = ((uint64_t)page_table) | (PDE_PRESENT + PDE_READ_WRITE);
}

void delpagtable(uint64_t* page_dir, size_t index, uint64_t* page_table) {
    for (size_t i = 0; i < 512; i++) {
        page_table[i] = 0x0;
    }
    page_dir[index] = ((uint64_t)page_table);
}

#else /* x86_64 */

void addpagdir(uint32_t* page_dir, PDEFlags flags) {
    for (int i = 0; i < 1024; i++) {
        page_dir[i] = 0x0 | (flags);
    }
}

void delpagdir(uint32_t* page_dir) {
    for (int i = 0; i < 1024; i++) {
        page_dir[i] = 0x0;
    }
}

void addpagtable(uint32_t* page_dir, size_t index, uint32_t* page_table, PTEFlags flags, uint32_t offset) {
    for (size_t i = 0; i < 1024; i++) {
        page_table[i] = (offset + (i * 0x1000)) | (flags);
    }
    page_dir[index] = ((uint32_t)page_table) | (PDE_PRESENT + PDE_READ_WRITE);
}

void delpagtable(uint32_t* page_dir, size_t index, uint32_t* page_table) {
    for (size_t i = 0; i < 1024; i++) {
        page_table[i] = 0x0;
    }
    page_dir[index] = ((uint32_t)page_table);
}

#endif /* x86_64 */
