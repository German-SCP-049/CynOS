#include <stdio.h>
#include <stdarg.h>
#include <cyn/vga.h>
#include <sys/io.h>

int print_arg(const char* specifier, va_list args);
void new_line(void);
void move_cursor(int x, int y);

typedef struct VGATextMode {
    char* address;
    int x_pos;
    int y_pos;
    int color;
} VGATextMode;

VGATextMode VIDEO;

void init_text_vga(void) {
    VIDEO.address = (char*)0xb8000;
    VIDEO.x_pos = 0;
    VIDEO.y_pos = 0;
    VIDEO.color = Yellow;
}

void printf(const char* string, ...) {
    va_list args;
    va_start(args, string);

    while (*string != '\0') {
        if (*string == '%') {
            int specifier = print_arg(string, args);
            string += specifier;
            va_arg(args, void*);
        } else {
            putchar(*string);
            string++;
        }
    }
    va_end(args);
}

void move_pos(int x, int y) {
    VIDEO.x_pos = x;
    VIDEO.y_pos = y;
    move_cursor(x, y);
}

void change_color(Color foreground, Color background) {
    VIDEO.color = (int)(foreground + (background * 16));
}

void change_cursor(CursorType type) {
    switch (type) {
        case Bar:
            outb(0x3D4, 0x0A);
	        outb(0x3D5, (inb(0x3D5) & 0xC0) | 0);
	        outb(0x3D4, 0x0B);
	        outb(0x3D5, (inb(0x3D5) & 0xE0) | 15);
            break;
        case Line:
            outb(0x3D4, 0x0A);
	        outb(0x3D5, (inb(0x3D5) & 0xC0) | 14);
	        outb(0x3D4, 0x0B);
	        outb(0x3D5, (inb(0x3D5) & 0xE0) | 15);
    }
    
}

void disable_cursor(void) {
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
}

void putchar(int ch) {
    int pos = (VIDEO.y_pos * TEXT_MODE_WIDTH + VIDEO.x_pos) * 2;

    if (ch == '\n') {
        new_line();
    } else {
        VIDEO.address[pos] = (char)ch;
        VIDEO.address[pos + 1] = (char)VIDEO.color;
        if (VIDEO.x_pos == TEXT_MODE_WIDTH - 1) {
            new_line();
        } else {
            VIDEO.x_pos++;
        }
    }
    move_cursor(VIDEO.x_pos, VIDEO.y_pos);
}

char read_char(int x, int y) {
    int pos = (y * TEXT_MODE_WIDTH + x) * 2;
    return VIDEO.address[pos];
}

int print_arg(const char* specifier, va_list args) {
    switch (*++specifier) {
        case 'd': ;
            int number = va_arg(args, int);
            char buffer[12];
            int index = 0;

            if (number < 0) {
                putchar('-');
                number = -number;
            }
            if (number == 0) {
                putchar('0');
            }

            while (number > 0) {
                buffer[index++] = (char)('0' + (number % 10));
                number /= 10;
            }
            for (int i = index - 1; i >= 0; i--) {
                putchar(buffer[i]);
            }
            return 2;
            break;
        case 'c': ;
            int character = va_arg(args, int);
            putchar(character);
            return 2;
            break;
        case 's': ;
            const char* string = (char*)va_arg(args, int);
            printf(string);
            return 2;
            break;
    }
    return 0;
}

void new_line(void) {
    if (VIDEO.y_pos == 24) {
        for (int y = 1; y < TEXT_MODE_HEIGHT; y++) {
            for (int x = 0; x < TEXT_MODE_WIDTH; x++) {
                char character = read_char(x, y);
                move_pos(x, y - 1);
                putchar(character);
            } 
        }
        for (int x = 0; x < TEXT_MODE_WIDTH; x++) {
            putchar(' ');
        }
        move_pos(0, VIDEO.y_pos);
    } else {
        move_pos(0, VIDEO.y_pos + 1);
    }
}

void move_cursor(int x, int y) {
    int pos = (y * TEXT_MODE_WIDTH + x);

	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}
