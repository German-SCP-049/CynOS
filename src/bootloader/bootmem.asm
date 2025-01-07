[bits 16]

section .text
ENTRY_COUNT equ 0x5000
ERROR_MESSAGE db "Error reading memory", 10, 0

make_mem_map:
    mov di, 0x5004
    xor ebx, ebx
    xor bp, bp
    mov [es:di + 20], dword 1
    mov eax, 0xE820
    mov ecx, 24
    mov edx, 0x0534D4150
    int 0x15
    jc short .memory_error

    mov edx, 0x0534D4150
    cmp eax, edx
    jne short .memory_error

    test ebx, ebx
    je short .memory_error
    jmp short .begin

    .loop:
        mov eax, 0xE820
        mov [es:di + 20], dword 1
        mov ecx, 24
        int 0x15
        jc short .finish
        mov edx, 0x0534D4150

    .begin:
        jcxz .skip
        cmp cl, 20
        jbe short .success
        test byte [es:di + 20], 1
        je short .skip

    .success:
        mov ecx, [es:di + 8]
        or ecx, [es:di + 12]
        jz short .skip
        inc bp
        add di, 24

    .skip:
        test ebx, ebx
        jne short .loop

    .finish:
        mov [es:ENTRY_COUNT], bp
        clc
        ret

    .memory_error:
        mov bx, ERROR_MESSAGE
        call print
        stc
        ret
