[bits 16]

section .text
; Prints a string stored in bx. Add a 10 byte to print new line
print:
    push bp
    mov bp, sp
    mov ah, 0x0E
    jmp .loop

    .loop:
        mov al, [bx]
        cmp al, 0
        je .exit

        cmp al, 10
        je .new_line
        
        int 0x10
        inc bx
        jmp .loop
    
    .new_line:
        int 0x10
        mov al, 13
        int 0x10

    .exit:
        mov sp, bp
        pop bp
        ret

; Takes in one character input, stores it in al, then prints it to screen
input:
    push bp
    mov bp, sp

    mov ah, 0
    int 0x16
    mov ah, 0x0E
    int 0x10

    mov sp, bp
    pop bp
    ret

; Clears the screen
clear_screen:
    push bp
    mov bp, sp

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov sp, bp
    pop bp
    ret

[bits 32]

; Returns 1 or 0 whether cpuid is available
chkcpuid:
    push ebp
    mov ebp, esp

    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax

    popfd
    pushfd
    pop eax
    xor eax, ecx
    shr eax, 21
    and eax, 1
    push ecx
    popfd

    test eax, eax
    jz .nocpuid

    mov eax, 1
    mov esp, ebp
    pop ebp
    ret

    .nocpuid:
        mov eax, 0
        mov esp, ebp
        pop ebp
        ret

; Returns 1 or 0 whether 64 bit mode is available
chk64bit:
    push ebp
    mov ebp, esp

    call chkcpuid
    cmp eax, 0
    je .no64bit

    mov eax, 1 << 31
    cpuid
    cmp eax, (1 << 31) + (1 < 0)
    jb .no64bit

    mov eax, (1 << 31) + 1
    cpuid
    test edx, 1 << 29
    jz .no64bit

    mov eax, 1
    mov esp, ebp
    pop ebp
    ret

    .no64bit:
        mov eax, 0
        mov esp, ebp
        pop ebp
        ret
