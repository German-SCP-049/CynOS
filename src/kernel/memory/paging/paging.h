/*
 * Library for paging related operations
*/

#ifndef PAGING_H
#define PAGING_H

/* Enables paging flag in CR0 */
extern void setpagflag(void);

/* Disables paging flag in CR0 */
extern void rempagflag(void);

/* Enables PAE flag in CR4 */
extern void setpaeflag(void);

#ifdef x86_64

#define EXECUTE_DISABLE   (1ULL << 63) // If IA32_EFER.NXE = 1, execute disable; Ignore otherwise

/* Flags for Page Map Level 4 Table Entries */
typedef enum PML4EFlags {
    PML4E_PRESENT           = 1 << 0,  // Reference a page directory pointer table
    PML4E_READ_WRITE        = 1 << 1,  // Enables write
    PML4E_USER_ACCESS       = 1 << 2,  // Allows user mode
    PML4E_WRITE_THROUGH     = 1 << 3,  // Determines memory type
    PML4E_CACHE_DISABLE     = 1 << 4,  // Determines memory type
    PML4E_ACCESSED          = 1 << 5,  // Indicates whether entry has been used
    PML4E_RESTART           = 1 << 11, // Restart HLAT paging to regular paging
} PML4EFlags;

/* Flags for the Page Directory Pointer Table Entries to reference a Page Directory */
typedef enum PDPTEFlags {
    PDPTE_PRESENT           = 1 << 0,  // Reference a page directory
    PDPTE_READ_WRITE        = 1 << 1,  // Enables write
    PDPTE_USER_ACCESS       = 1 << 2,  // Allows user mode
    PDPTE_WRITE_THROUGH     = 1 << 3,  // Determines memory type
    PDPTE_CACHE_DISABLE     = 1 << 4,  // Determines memory type
    PDPTE_ACCESSED          = 1 << 5,  // Indicates whether entry has been used
    PDPTE_PAGE_SIZE         = 1 << 7,  // Must be 0, otherwise it will map a 1gb page
    PDPTE_RESTART           = 1 << 11, // Restart HLAT paging to regular paging
} PDPTEFlags;

/* Flags for 64 bit Page Directory Entries to reference a Page Table */
typedef enum PDEFlags {
    PDE_PRESENT           = 1 << 0,  // Reference a page table
    PDE_READ_WRITE        = 1 << 1,  // Enables write
    PDE_USER_ACCESS       = 1 << 2,  // Allows user mode
    PDE_WRITE_THROUGH     = 1 << 3,  // Determines memory type
    PDE_CACHE_DISABLE     = 1 << 4,  // Determines memory type
    PDE_ACCESSED          = 1 << 5,  // Indicates whether entry has been used
    PDE_PAGE_SIZE         = 1 << 7,  // Must be set to 0, otherwise maps 2mb page
    PDE_RESTART           = 1 << 11, // Restart HLAT paging to regular paging
} PDEFlags;

/* Flags for 64 bit Page Table Entries */
typedef enum PTEFlags {
    PTE_PRESENT           = 1 << 0,  // Reference a page
    PTE_READ_WRITE        = 1 << 1,  // Enables write
    PTE_USER_ACCESS       = 1 << 2,  // Allows user mode
    PTE_WRITE_THROUGH     = 1 << 3,  // Determines memory type
    PTE_CACHE_DISABLE     = 1 << 4,  // Determines memory type
    PTE_ACCESSED          = 1 << 5,  // Indicates whether entry has been used
    PTE_DIRTY             = 1 << 6,  // Indicates whether entry has been written to
    PTE_PAT               = 1 << 7,  // Determines memory type if PAT is supported
    PTE_GLOBAL            = 1 << 8,  // Determines if translation is global; Ignore otherwise
    PTE_RESTART           = 1 << 11, // Restart HLAT paging to regular paging
} PTEFlags;

/* Moves page directory address into CR3 */
extern void setpagreg(uint64_t page_directory);

/* Creates a new Page Map Level 4 Table */
void addpml4t(uint64_t* pml4_table, PML4EFlags flags);

/* Deletes a Page Map Level 4 Table */
void delpml4t(uint64_t* pml4_table);

/* Creates a new Page Directory Pointer Table */
void addpdpt(uint64_t* pml4_table, size_t index, uint64_t* pdpt, PDPTEFlags flags);

/* Deletes a Page Directory Pointer Table */
void delpdpt(uint64_t* pml4_table, size_t index, uint64_t* pdpt);

/* Creates a new 64 bit page directory */
void addpagedir(uint64_t* pdpt, size_t index, uint64_t* page_dir, PDEFlags flags);

/* Deletes a 64 bit page directory */
void delpagdir(uint64_t* pdpt, size_t index, uint64_t* page_dir);

/* Creates a new 64 bit page table */
void addpagtable(uint64_t* page_dir, size_t index, uint64_t* page_table, PTEFlags flags, uint64_t offset);

/* Deletes a 64 bit page table */
void delpagtable(uint64_t* page_dir, size_t index, uint64_t* page_table);

#else /* x86_64 */

/* Flags for 32 bit Page Directory Entries */
typedef enum PDEFlags {
    PDE_PRESENT           = 1 << 0, // Reference a page table
    PDE_READ_WRITE        = 1 << 1, // Enables write
    PDE_USER_ACCESS       = 1 << 2, // Allows user mode
    PDE_WRITE_THROUGH     = 1 << 3, // Determines memory type
    PDE_CACHE_DISABLE     = 1 << 4, // Determines memory type
    PDE_ACCESSED          = 1 << 5, // Indicates whether entry has been used
    PDE_PAGE_SIZE         = 1 << 7, // If CR4.PSE = 1, set to 0; Ignore otherwise
} PDEFlags;

/* Flags for 32 bit Page Table Entries */
typedef enum PTEFlags {
    PTE_PRESENT           = 1 << 0, // Reference a page
    PTE_READ_WRITE        = 1 << 1, // Enables write
    PTE_USER_ACCESS       = 1 << 2, // Allows user mode
    PTE_WRITE_THROUGH     = 1 << 3, // Determines memory type
    PTE_CACHE_DISABLE     = 1 << 4, // Determines memory type
    PTE_ACCESSED          = 1 << 5, // Indicates whether entry has been used
    PTE_DIRTY             = 1 << 6, // Indicates whether entry has been written to
    PTE_PAT               = 1 << 7, // Determines memory type if PAT is supported
    PTE_GLOBAL            = 1 << 8, // Determines if translation is global; Ignore otherwise
} PTEFlags;

/* Moves page directory address into CR3 */
extern void setpagreg(uint32_t page_directory);

/* Creates a new 32 bit page directory */
void addpagdir(uint32_t* page_dir, PDEFlags flags);

/* Deletes a 32 bit page directory */
void delpagdir(uint32_t* page_dir);

/* Creates a new 32 bit page table */
void addpagtable(uint32_t* page_dir, size_t index, uint32_t* page_table, PTEFlags flags, uint32_t offset);

/* Deletes a 32 bit page table */
void delpagtable(uint32_t* page_dir, size_t index, uint32_t* page_table);

#endif /* x86_64 */

#endif /* PAGING_H */
