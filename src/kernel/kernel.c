#include <stdio.h>
#include <cyn/vga.h>

void print_info(void);

void main(void) {
    init_text_vga();
    print_info();
    return;
}

void print_info() {
    printf("  ____                    \n");
    printf(" / ___|  _    _   _____   \n");
    printf("| |     | |  | | |  _  |  \n");
    printf("| |___  | |__| | | | | |  \n");
    printf(" \\____|  \\_   /  |_| |_|\n");
    printf("_______  _/ / ____________\n");
    printf("        |_/               \n");
    move_pos(25, 0);
    change_color(White, Black);
    printf("  _____     _____   "); move_pos(25, 1);
    printf(" / ___ \\   / ____| "); move_pos(25, 2);
    printf("| |   | | | |____   "); move_pos(25, 3);
    printf("| |   | |  \\____ \\"); move_pos(25, 4);
    printf("| |___| |   ____| | "); move_pos(25, 5);
    printf(" \\_____/   |_____/ "); move_pos(0, 8);
    change_color(Yellow, Black);
    printf("screen size : %dx%d\n", TEXT_MODE_WIDTH, TEXT_MODE_HEIGHT);
}
