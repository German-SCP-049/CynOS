/*
 * Library for setting up and interacting with memory
 */

#ifndef MEM_H
#define MEM_H
#include <stddef.h>

/* Sets up memory */
void initmem(void);

/* Gets all memory that can be used */
size_t getmem(void);

/* Prints all memory map entrys */
void putmap(void);

#endif /* MEM_H */
