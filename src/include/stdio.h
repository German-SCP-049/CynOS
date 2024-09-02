/* 
 * Custom stdio.h that you know from normal C
 */

#ifndef STDIO_H
#define STDIO_H

/* Prints a formatted string */
void printf(const char* string, ...);

/* Prints a character */
void putchar(int ch);

#endif /* STDIO_H */