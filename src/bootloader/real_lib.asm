[bits 16]

print:
    push bp
    mov bp, sp
    mov ah, 0x0e
    jmp .loop

    .loop:
        mov al, [bx]
        cmp al, 0
        je .exit
        int 0x10
        inc bx
        jmp .loop

    .exit:
        mov sp, bp
        pop bp
        ret

new_line:
    push bp
    mov bp, sp
    mov ah, 0x0e
    mov al, 10
    int 0x10
    mov al, 13
    int 0x10
    mov sp, bp
    pop bp
    ret

input:
    push bp
    mov bp, sp
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    int 0x10
    mov sp, bp
    pop bp
    ret