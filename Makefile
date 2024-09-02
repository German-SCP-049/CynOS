CC := /usr/local/i386elfgcc/bin/i386-elf-gcc
CC++ := /usr/local/i386elfgcc/bin/i386-elf-g++
LD := /usr/local/i386elfgcc/bin/i386-elf-ld
OBJCP := /usr/local/i386elfgcc/bin/i386-elf-objcopy
AS := /usr/bin/nasm
WARNINGS := -Werror -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wstrict-prototypes -Wconversion
CFLAGS := -ffreestanding -m32 -g -c -I ./src/include $(WARNINGS)
DRIVERS_DIR := ./bin/drivers
KERNEL_DIR := ./bin/kernel
SRC_DIR := ./src

# Useful commands
.PHONY: all clean directories run_drive run_floppy

all: directories ./bin/os.bin run_drive

run_drive:
	@clear
	@qemu-system-x86_64 -drive format=raw,file=./bin/os.bin

run_floppy:
	@clear
	@qemu-system-x86_64 -drive format=raw,file=./bin/os.bin,if=floppy

clean:
	@clear
	@rm -rf ./bin/*

directories:
	@mkdir -p ./bin/bootloader ./bin/drivers ./bin/kernel

# Bootloader
./bin/bootloader/%.bin: ./src/bootloader/%.asm ./src/bootloader/real_lib.asm
	@$(AS) -f bin $< -o $@

./bin/bootloader/entry.o: ./src/bootloader/entry.asm
	@$(AS) $< -f elf -o $@

./bin/bootloader/bootloader.bin: ./bin/bootloader/stage_1.bin ./bin/bootloader/stage_2.bin
	@cat $^ > $@

# Kernel
./bin/kernel/%.o: ./src/kernel/%.c
	@$(CC) $(CFLAGS) $< -o $@

./bin/drivers/%.o: ./src/drivers/%.c
	@$(CC) $(CFLAGS) $< -o $@

./bin/drivers/%.o: ./src/drivers/%.asm
	@$(AS) -f elf $< -o $@

./bin/full_kernel.bin: ./bin/bootloader/entry.o ./bin/kernel/kernel.o ./bin/drivers/vga.o ./bin/drivers/io.o
	@$(LD) -o ./bin/full_kernel.elf -T linker.ld -Map=memory.map $^
	@$(OBJCP) -O binary ./bin/full_kernel.elf ./bin/full_kernel.bin

./bin/os.bin: ./bin/bootloader/bootloader.bin ./bin/full_kernel.bin
	@cat $^ > $@