[org 0x7c00]
[bits 16]

section .text
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp ; Sets up registers and stack

mov ah, 0x00
mov al, 0x03
int 0x10 ; Clears the screen

mov bx, message1
call print
call new_line
jmp LBA ; Loads stage 2 into memory

jmp $

%include "./src/bootloader/real_lib.asm"

STAGE_2_LOCATION equ 0x7e00

message1 db "AbsoluteBootloader: stage 1", 0
message2 db "Loading stage 2...", 0
message3 db "Loaded!", 0
disk_error_message db "Error while reading disk", 0
disk_error_message2 db "Trying again using CHS...", 0
disk_error_message3 db "Unable to read disk", 0

DATA_AP:
    db 0x16
    db 0
    dw 2 ; Amount of sectors to read
    dw STAGE_2_LOCATION ; Read to this address
    dw 0
    dd 1 ; Sector to begin from
    dd 0

LBA:
    mov bx, message2
    call print
    call new_line

    mov si, DATA_AP
    mov ah, 0x42
    mov dl, 0x80
    int 0x13
    
    jc CHS
    mov bx, message3
    call print
    call new_line
    jmp STAGE_2_LOCATION

CHS:
    mov bx, disk_error_message
    call print
    call new_line
    mov bx, disk_error_message2
    call print
    call new_line

    mov ah, 0x02
    mov al, 0x02 ; Amount of sectors to read
    mov bx, STAGE_2_LOCATION ; Read to this address
    mov ch, 0x00
    mov cl, 0x02 ; Sector to begin from
    mov dh, 0x00
    mov dl, 0x00
    int 0x13
    
    jc disk_error
    mov bx, message3
    call print
    call new_line
    mov dl, 1
    jmp STAGE_2_LOCATION

disk_error:
    mov bx, disk_error_message3
    call print

times 510-($-$$) db 0
db 0x55, 0xaa