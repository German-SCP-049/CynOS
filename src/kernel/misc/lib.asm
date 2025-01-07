[bits 32]

section .text
global halt
global chkcpuid
global chk64bit

halt:
    push ebp
    mov ebp, esp

    hlt
    jmp halt

    mov esp, ebp
    pop ebp
    ret

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

chk64bit:
    push ebp
    mov ebp, esp

    mov ecx, 0xC0000080
    rdmsr
    test eax, 1 << 8
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
