/* 
 * Driver for the VGA text buffer
 */

#ifndef VGA_H
#define VGA_H

#define TEXT_MODE_HEIGHT 25
#define TEXT_MODE_WIDTH 80

/* Colors for chgcol() */
typedef enum Color {
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    PURPLE,
    BROWN,
    GRAY,
    DARK_GRAY,
    LIGHT_BLUE,
    LIGHT_GREEN,
    LIGHT_CYAN,
    LIGHT_RED,
    LIGHT_PURPLE,
    YELLOW,
    WHITE,
} Color;

/* Cursor types for chgcurs() */
typedef enum CursorType {
    BAR,
    LINE,
} CursorType;

#ifndef STDIO_H

/* Prints a formatted string */
void printf(const char* string, ...);

/* Prints a character */
void putchar(int ch);

#endif /* STDIO_H */

/* Reads a character from specified position */
char readc(int x, int y);

/* Moves current position of the VGA text buffer */
void mvpos(int x, int y);

/* Changes the color of the VGA output */
void chgcol(Color foreground, Color background);

/* Changes the cursor type */
void chgcurs(CursorType type);

/* Disables the cursor */
void disblcurs(void);

#endif /* VGA_H */
