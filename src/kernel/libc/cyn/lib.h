/*
 * General use library
*/

#ifndef LIB_H
#define LIB_H

/* Loops the hlt instruction */
extern void halt(void);

/* Returns whether or not the cpuid instruction
   is available */
extern int chkcpuid(void);

/* Returns whether or not long mode is active */
extern int chk64bit(void);

#endif /* LIB_H */
