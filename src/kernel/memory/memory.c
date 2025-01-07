#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <cyn/mem.h>
#include <cyn/lib.h>
#include "paging/paging.h"

typedef struct MapEntry {
    uint64_t base;
    uint64_t size;
    uint32_t type;
    uint32_t reserved;
} MapEntry;

MapEntry* MEMORY_MAP = (MapEntry*)0x5004;
uint32_t ENTRY_COUNT;
size_t USABLE_MEMORY;

void initmem(void) {
    ENTRY_COUNT = *(uint32_t*)0x5000;

    for (uint32_t i = 0; i < ENTRY_COUNT; i++) {
        if (MEMORY_MAP[i].type == 1) {
            USABLE_MEMORY += (size_t)MEMORY_MAP[i].size;
        }
    }

    #ifndef x86_64

    addpagdir((uint32_t*)0x2000, PDE_READ_WRITE);
    addpagtable((uint32_t*)0x2000, 0, (uint32_t*)0x3000, (PTE_PRESENT + PTE_READ_WRITE), 0);
    addpagtable((uint32_t*)0x2000, 1, (uint32_t*)0x4000, (PTE_PRESENT + PTE_READ_WRITE), 4000);
    setpagreg(0x2000);
    setpagflag();

    #endif /* x86_64 */

}

size_t getmem(void) {
    return USABLE_MEMORY;
}

void putmap(void) {
    printf("Amount of entries: %d\n", ENTRY_COUNT);

    for (uint32_t i = 0; i < ENTRY_COUNT; i++) {
        printf("Entry %d:\n", i);
        printf("    Base = %d\n", MEMORY_MAP[i].base);
        printf("    Size = %d\n", MEMORY_MAP[i].size);
        printf("    Type = %d\n", MEMORY_MAP[i].type);
    }
}
