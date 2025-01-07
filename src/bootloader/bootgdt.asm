[bits 16]

section .text
; Access bits
ACCESSED    equ 1 << 0
RW          equ 1 << 1
DC          equ 1 << 2
EXECUTE     equ 1 << 3
NOT_SYS     equ 1 << 4
DPL1        equ 1 << 5
DPL2        equ 1 << 6
PRESENT     equ 1 << 7

; Flag bits
LONG_MODE   equ 1 << 5
SIZE32      equ 1 << 6
GRAN_4KB    equ 1 << 7

GDT32:
    .NULL: equ $ - GDT32
        dq 0x00
    .CODE: equ $ - GDT32
        dd 0xffff
        db 0x00
        db PRESENT | NOT_SYS | EXECUTE | RW
        db GRAN_4KB | SIZE32 | 0xF
        db 0x00
    .DATA: equ $ - GDT32
        dd 0xffff
        db 0x00
        db PRESENT | NOT_SYS | RW
        db GRAN_4KB | SIZE32 | 0xF
        db 0x00
    .POINTER:
        dw $ - GDT32 - 1
        dq GDT32

[bits 32]

GDT64:
    .NULL: equ $ - GDT64
        dq 0x00
    .CODE: equ $ - GDT64
        dd 0xFFFF
        db 0x00
        db PRESENT | NOT_SYS | EXECUTE | RW
        db GRAN_4KB | LONG_MODE | 0xF
        db 0x00
    .DATA: equ $ - GDT64
        dd 0xFFFF
        db 0x00
        db PRESENT | NOT_SYS | RW
        db GRAN_4KB | LONG_MODE | 0xF
        db 0x00
    .POINTER:
        dw $ - GDT64 - 1
        dq GDT64
