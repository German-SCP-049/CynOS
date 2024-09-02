/* 
 * Provides functions related to the VGA text buffer
 */

#ifndef VGA_H
#define VGA_H

#define TEXT_MODE_HEIGHT 25
#define TEXT_MODE_WIDTH 80

/* Colors for change_color() */
typedef enum Color {
    Black,
    Blue,
    Green,
    Cyan,
    Red,
    Purple,
    Brown,
    Gray,
    DarkGray,
    LightBlue,
    LightGreen,
    LightCyan,
    LightRed,
    LightPurple,
    Yellow,
    White,
} Color;

/* Cursor types for change_cursor() */
typedef enum CursorType {
    Bar,
    Line,
} CursorType;

/* Allows interaction with the VGA text buffer */
void init_text_vga(void);

/* Moves current position of the VGA text buffer */
void move_pos(int x, int y);

/* Changes the color of the VGA output */
void change_color(Color foreground, Color background);

/* Reads a character from specified position */
char read_char(int x, int y);

/* Changes the cursor type */
void change_cursor(CursorType type);

/* Disables the cursor */
void disable_cursor(void);

#endif /* VGA_H */