#include <cyn/vga.h>
#include <cyn/mem.h>
#include <cyn/lib.h>

void putinfo(void);

void main(void) {
    initmem();
    putinfo();
    halt();
}

void putinfo() {
    printf("  ____                    \n");
    printf(" / ___|  _    _   _____   \n");
    printf("| |     | |  | | |  _  |  \n");
    printf("| |___  | |__| | | | | |  \n");
    printf(" \\____|  \\_   /  |_| |_|\n");
    printf("_______  _/ / ____________\n");
    printf("        |_/               \n");
    mvpos(25, 0);
    chgcol(WHITE, BLACK);
    printf("  _____     _____   "); mvpos(25, 1);
    printf(" / ___ \\   / ____| "); mvpos(25, 2);
    printf("| |   | | | |____   "); mvpos(25, 3);
    printf("| |   | |  \\____ \\"); mvpos(25, 4);
    printf("| |___| |   ____| | "); mvpos(25, 5);
    printf(" \\_____/   |_____/ "); mvpos(0, 8);
    chgcol(YELLOW, BLACK);
    printf("Screen size : %dx%d\n", TEXT_MODE_WIDTH, TEXT_MODE_HEIGHT);
    mvpos(23, 8);
    for (int i = 0; i < 16; i++) {
        if (i == 8) {
            mvpos(23, 9);
        }
        chgcol(BLACK, i);
        printf("  ");
    }
    chgcol(YELLOW, BLACK);
    mvpos(0, 9);
    printf("Memory size : %dMB\n", getmem() / (1024 * 1024));
    printf("64 bit mode : ");
    if (chk64bit()) {
        printf("true\n");
    } else {
        printf("false\n");
    }
}
