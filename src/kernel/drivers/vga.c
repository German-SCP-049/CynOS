#include <stdarg.h>
#include <cyn/vga.h>
#include <sys/io.h>

int putarg(const char* specifier, va_list args);
void newline(void);
void mvcurs(int x, int y);

struct VGATextMode {
    char* address;
    int x_pos;
    int y_pos;
    int color;
};

struct VGATextMode VIDEO = {
    (char*)0xb8000,
    0,
    0,
    YELLOW
};

void printf(const char* string, ...) {
    va_list args;
    va_start(args, string);

    while (*string != '\0') {
        if (*string == '%') {
            int specifier = putarg(string, args);
            string += specifier;
            va_arg(args, void*);
        } else {
            putchar(*string);
            string++;
        }
    }
    va_end(args);
}

void putchar(int ch) {
    int pos = (VIDEO.y_pos * TEXT_MODE_WIDTH + VIDEO.x_pos) * 2;

    if (ch == '\n') {
        newline();
    } else {
        VIDEO.address[pos] = (char)ch;
        VIDEO.address[pos + 1] = (char)VIDEO.color;
        if (VIDEO.x_pos == TEXT_MODE_WIDTH - 1) {
            newline();
        } else {
            VIDEO.x_pos++;
        }
    }
    mvcurs(VIDEO.x_pos, VIDEO.y_pos);
}

void newline(void) {
    if (VIDEO.y_pos == TEXT_MODE_HEIGHT - 1) {
        for (int y = 1; y < TEXT_MODE_HEIGHT; y++) {
            for (int x = 0; x < TEXT_MODE_WIDTH; x++) {
                char character = readc(x, y);
                mvpos(x, y - 1);
                putchar(character);
            } 
        }
        for (int x = 0; x < TEXT_MODE_WIDTH - 1; x++) {
            putchar(' ');
        }
        mvpos(0, VIDEO.y_pos);
    } else {
        mvpos(0, VIDEO.y_pos + 1);
    }
}

int putarg(const char* specifier, va_list args) {
    switch (*++specifier) {
        case 'd': ;
            int number = va_arg(args, int);
            char buffer[20];
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
            const char* string = (const char*)va_arg(args, const char*);
            printf(string);
            return 2;
            break;
    }
    return 0;
}

char readc(int x, int y) {
    int pos = (y * TEXT_MODE_WIDTH + x) * 2;
    return VIDEO.address[pos];
}

void mvpos(int x, int y) {
    VIDEO.x_pos = x;
    VIDEO.y_pos = y;
    mvcurs(x, y);
}

void chgcol(Color foreground, Color background) {
    VIDEO.color = (int)(foreground + (background * 16));
}

void mvcurs(int x, int y) {
    int pos = (y * TEXT_MODE_WIDTH + x);

	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t)(pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));
}

void chgcurs(CursorType type) {
    switch (type) {
        case BAR:
            outb(0x3D4, 0x0A);
	        outb(0x3D5, (inb(0x3D5) & 0xC0) | 0);
	        outb(0x3D4, 0x0B);
	        outb(0x3D5, (inb(0x3D5) & 0xE0) | 15);
            break;
        case LINE:
            outb(0x3D4, 0x0A);
	        outb(0x3D5, (inb(0x3D5) & 0xC0) | 14);
	        outb(0x3D4, 0x0B);
	        outb(0x3D5, (inb(0x3D5) & 0xE0) | 15);
    }
    
}

void disblcurs(void) {
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
}
