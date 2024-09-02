[bits 32]

section .text
global outb
global inb

outb:
    push ebp
    mov ebp, esp

    mov dx, [ebp+8]     ; Port
    mov al, [ebp+12]    ; Value
    out dx, al          ; Sends value to port

    mov esp, ebp
    pop ebp
    ret

inb:
    push ebp
    mov ebp, esp

    mov dx, [ebp+8]     ; Port
    in al, dx           ; Recives value from port

    mov esp, ebp
    pop ebp
    ret