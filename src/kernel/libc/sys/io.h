/* 
 * CynOS <sys/io.h>
 */

#ifndef IO_H
#define IO_H
#include <stdint.h>

/* Sends byte to a port */
extern void outb(uint16_t port, uint8_t value);

/* Gets byte from a port */
extern uint8_t inb(uint16_t port);

#endif /* IO_H */
