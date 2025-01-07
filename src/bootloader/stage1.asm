[org 0x7C00]
[bits 16]

section .text
jmp 0x0000:boot

boot:
    cli
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov bp, boot
    mov sp, bp
    sti

    call clear_screen
    mov bx, MESSAGE1
    call print
    mov bx, MESSAGE2
    call print

    jmp read_disk

jmp $

%include "./src/bootloader/bootlib.asm"

[bits 16]

STAGE2_LOCATION equ 0x7E00

MESSAGE1 db "AbsoluteBootloader: STAGE 1", 10, 0
MESSAGE2 db "Loading stage 2...", 10, 0
MESSAGE3 db "Loaded!", 10, 0
DISK_ERROR_MESSAGE db "Unable to read disk", 10, 0

read_disk:
    .LBA:
        clc
        mov ah, 0x42
        mov dl, 0x80
        mov si, .DAP
        int 0x13
    
        jc .CHS
        mov bx, MESSAGE3
        call print
        jmp STAGE2_LOCATION

        .DAP:
            db 0x16
            db 0
            dw 3
            dw STAGE2_LOCATION
            dw 0
            dd 1
            dd 0

    .CHS:
        clc
        mov ah, 0x02
        mov al, 0x03
        mov bx, STAGE2_LOCATION
        mov ch, 0x00
        mov cl, 0x02
        mov dh, 0x00
        mov dl, 0x00
        int 0x13
    
        jc .disk_error
        mov bx, MESSAGE3
        call print
        mov dl, 1
        jmp STAGE2_LOCATION

    .disk_error:
        mov bx, DISK_ERROR_MESSAGE
        call print

times 510-($-$$) db 0
db 0x55, 0xAA
