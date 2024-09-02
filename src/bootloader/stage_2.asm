[org 0x7e00]
[bits 16]

section .text
mov ah, 0x00
mov al, 0x03
int 0x10 ; Clears the screen

mov bx, message1
call print
call new_line

call LBA ; Read kernel into memory

mov ah, 0x00
mov al, 0x03
int 0x10 ; Clears the screen again

cli
lgdt [GDT_descriptor] ; Load the Global Descriptor Table
mov eax, cr0
or eax, 1
mov cr0, eax ; Enable A20 line
jmp CODE_SEG:enter_pm ; 32 bits here we come!

jmp $

%include "./src/bootloader/real_lib.asm"

KERNEL_LOCATION equ 0x1000
CODE_SEG equ GDT_code - GDT
DATA_SEG equ GDT_data - GDT

message1 db "AbsoluteBootloader: stage 2", 0
message2 db "Loading kernel...", 0
message3 db "Loaded!", 0
disk_error_message db "Error while reading disk", 0
disk_error_message2 db "Trying again using CHS...", 0
disk_error_message3 db "Unable to read disk", 0

DATA_AP:
    db 0x16
    db 0
    dw 5 ; Amount of sectors to read
    dw KERNEL_LOCATION ; Read to this address
    dw 0
    dd 3 ; Sector to begin from
    dd 0

GDT:
GDT_null:
    dq 0x00
GDT_code:
    dw 0xffff
    dw 0x00
    db 0x00
    db 0b10011010
    db 0b11001111
    db 0x00
GDT_data:
    dw 0xffff
    dw 0x00
    db 0x00
    db 0b10010010
    db 0b11001111
    db 0x00
GDT_end:

GDT_descriptor:
    dw GDT_end - GDT - 1
    dd GDT

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
    ret

CHS:
    mov bx, disk_error_message
    call print
    call new_line
    mov bx, disk_error_message2
    call print
    call new_line

    mov ah, 0x02
    mov al, 0x30 ; Amount of sectors to read
    mov bx, KERNEL_LOCATION ; Read to this address
    mov ch, 0x00
    mov cl, 0x04 ; Sector to begin from
    mov dh, 0x00
    mov dl, 0x00
    int 0x13
    
    jc disk_error
    mov bx, message3
    call print
    call new_line
    mov dl, 1
    ret

disk_error:
    mov bx, disk_error_message3
    call print

[bits 32]
enter_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x090000
    mov esp, ebp

    jmp KERNEL_LOCATION

times 1024-($-$$) db 0