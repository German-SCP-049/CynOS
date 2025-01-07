[org 0x7E00]
[bits 16]

section .text
main16:
    call clear_screen
    mov bx, MESSAGE1
    call print

    call read_disk
    call make_mem_map
    call clear_screen

    cli
    lgdt [GDT32.POINTER]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp GDT32.CODE:main32

jmp $

%include "./src/bootloader/bootlib.asm"
%include "./src/bootloader/bootmem.asm"
%include "./src/bootloader/bootgdt.asm"

[bits 16]

STAGE3_LOCATION equ 0x8200
KERNEL_LOCATION equ 0x8400

MESSAGE1 db "AbsoluteBootloader: STAGE 2", 10, 0
MESSAGE2 db "Loading kernel...", 10, 0
MESSAGE3 db "Loaded!", 10, 0
DISK_ERROR_MESSAGE db "Unable to read disk", 10, 0

read_disk:
    .LBA:
        clc
        mov bx, MESSAGE2
        call print

        mov si, .DAP
        mov ah, 0x42
        mov dl, 0x80
        int 0x13
    
        jc .CHS
        mov bx, MESSAGE3
        call print
        ret

        .DAP:
            db 0x16
            db 0
            dw 10 ; Amount of sectors to read
            dw KERNEL_LOCATION ; Read to this address
            dw 0
            dd 4 ; Sector to begin from
            dd 0

    .CHS:
        clc
        mov ah, 0x02
        mov al, 0x30 ; Amount of sectors to read
        mov bx, KERNEL_LOCATION ; Read to this address
        mov ch, 0x00
        mov cl, 0x04 ; Sector to begin from
        mov dh, 0x00
        mov dl, 0x00
        int 0x13
    
        jc .disk_error
        mov bx, MESSAGE3
        call print
        mov dl, 1
        ret

    .disk_error:
        mov bx, DISK_ERROR_MESSAGE
        call print

[bits 32]
main32:
    mov ax, GDT32.DATA
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x090000
    mov esp, ebp

    %ifdef x86_64

    call chk64bit
    cmp eax, 1
    je STAGE3_LOCATION

    %endif

    jmp KERNEL_LOCATION

times 1024-($-$$) db 0
