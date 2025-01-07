CC := x86_64-elf-gcc
CC++ := x86_64-elf-g++
LD := x86_64-elf-ld
OBJCP := x86_64-elf-objcopy
AS := nasm
WARNINGS := -Werror -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
            -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wstrict-prototypes -Wconversion
CFLAGS := -ffreestanding -std=c99 -g -c -I src/kernel/libc $(WARNINGS)

# set to false to compile and run 32 bit code
x86_64 := true

BIN := bin
SRC := src
DIRECTORIES := $(patsubst $(SRC)/%, $(BIN)/%, $(shell find $(SRC) -type d -print))
BOOT_SRC := $(shell find $(SRC)/bootloader -name '*.c' -o -name '*.asm' -o -name '*.h')
KERN_SRC := $(shell find $(SRC)/kernel -name '*.c' -o -name '*.asm' -o -name '*.h')
KERN_OBJ := $(patsubst $(SRC)/%.c, $(BIN)/%.o, $(filter %.c,$(KERN_SRC))) \
			$(patsubst $(SRC)/%.asm, $(BIN)/%.o, $(filter %.asm,$(KERN_SRC)))

.PHONY: all run mkdir clean

all: compile run

run:
ifeq ($(x86_64), true)
	qemu-system-x86_64 -drive format=raw,file=$(BIN)/CynOS.bin
else
	qemu-system-i386 -drive format=raw,file=$(BIN)/CynOS.bin
endif

mkdir:
	mkdir -p $(DIRECTORIES)

clean:
	rm -rf $(BIN)/*

compile: mkdir cynos

$(BIN)/zeros.bin: $(SRC)/zeros.asm
	$(AS) -f bin $< -o $@

cynos: absolute_bootloader cyn_kernel $(BIN)/zeros.bin
	cat $(BIN)/bootloader/absolute_bootloader.bin $(BIN)/kernel/cyn_kernel.bin $(BIN)/zeros.bin > $(BIN)/CynOS.bin

$(BIN)/bootloader/%.bin: $(SRC)/bootloader/%.asm
ifeq ($(x86_64), true)
	$(AS) -f bin -D x86_64 -Werror $< -o $@
else
	$(AS) -f bin -Werror $< -o $@
endif

kernel_entry: $(SRC)/bootloader/entry.asm
	$(AS) $< -f elf -o $(BIN)/bootloader/entry.o

absolute_bootloader: $(BIN)/bootloader/stage1.bin $(BIN)/bootloader/stage2.bin $(BIN)/bootloader/stage3.bin
	cat $^ > $(BIN)/bootloader/absolute_bootloader.bin

cyn_kernel: $(KERN_OBJ)
ifeq ($(x86_64), true)
	$(LD) -o $(BIN)/kernel/$@.elf -T linker.ld -Map=memory.map -m elf_x86_64 $^
	$(OBJCP) -O binary $(BIN)/kernel/$@.elf $(BIN)/kernel/$@.bin
else
	$(LD) -o $(BIN)/kernel/$@.elf -T linker.ld -Map=memory.map -m elf_i386 $^
	$(OBJCP) -O binary $(BIN)/kernel/$@.elf $(BIN)/kernel/$@.bin
endif

$(BIN)/kernel/%.o: $(SRC)/kernel/%.asm $(SRC)/kernel/%.c
ifeq ($(x86_64), true)
	$(AS) -f elf64 -D x86_64 -g $(SRC)/kernel/$*.asm -Werror -o /tmp/asm.o
	$(CC) $(CFLAGS) -m64 -D x86_64 $(SRC)/kernel/$*.c -o /tmp/c.o
	$(LD) -r -m elf_x86_64 /tmp/asm.o /tmp/c.o -o $@
	rm /tmp/c.o /tmp/asm.o
else
	$(AS) -f elf $(SRC)/kernel/$*.asm -o /tmp/asm.o
	$(CC) $(CFLAGS) -m32 $(SRC)/kernel/$*.c -o /tmp/c.o
	$(LD) -r -m elf_i386 /tmp/asm.o /tmp/c.o -o $@
	rm /tmp/c.o /tmp/asm.o
endif

$(BIN)/kernel/%.o: $(SRC)/kernel/%.asm
ifeq ($(x86_64), true)
	$(AS) -f elf64 -D x86_64 -g -Werror $< -o $@
else
	$(AS) -f elf -g $< -o $@
endif

$(BIN)/kernel/%.o: $(SRC)/kernel/%.c
ifeq ($(x86_64), true)
	$(CC) $(CFLAGS) -m64 -D x86_64 $< -o $@
else
	$(CC) $(CFLAGS) -m32 $< -o $@
endif

$(BIN)/kernel/%.o: $(SRC)/kernel/%.cpp
ifeq ($(x86_64), true)
	$(CC++) $(CFLAGS) -m64 -D x86_64 $< -o $@
else
	$(CC++) $(CFLAGS) -m32 $< -o $@
endif
