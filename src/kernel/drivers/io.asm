[bits 32]

section .text
global outb
global inb

%ifdef x86_64

[bits 64]

outb:
    push rbp
    mov rbp, rsp

    mov dx, di
    mov al, sil
    out dx, al

    mov rsp, rbp
    pop rbp
    ret

inb:
    push rbp
    mov rbp, rsp

    mov dx, di
    in al, dx

    mov rsp, rbp
    pop rbp
    ret

%else

[bits 32]

outb:
    push ebp
    mov ebp, esp

    mov dx, [ebp+8]
    mov al, [ebp+12]
    out dx, al

    mov esp, ebp
    pop ebp
    ret

inb:
    push ebp
    mov ebp, esp

    mov dx, [ebp+8]
    in al, dx

    mov esp, ebp
    pop ebp
    ret

%endif
