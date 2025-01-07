[bits 32]

section .text
global setpagreg
global setpagflag
global rempagflag
global setpaeflag

setpagflag:
    push ebp
    mov ebp, esp

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    mov esp, ebp
    pop ebp
    ret

rempagflag:
    push ebp
    mov ebp, esp

    mov eax, cr0
    and eax, (1 << 31) - 1
    mov cr0, eax

    mov esp, ebp
    pop ebp
    ret

setpaeflag:
    push ebp
    mov ebp, esp

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov esp, ebp
    pop ebp
    ret

%ifdef x86_64

[bits 64]

setpagreg:
    push rbp
    mov rbp, rsp

    mov rax, rdi
    mov cr3, rax

    mov rsp, rbp
    pop rbp
    ret

%else

[bits 32]

setpagreg:
    push ebp
    mov ebp, esp

    mov eax, [esp+8]
    mov cr3, eax

    mov esp, ebp
    pop ebp
    ret

%endif
