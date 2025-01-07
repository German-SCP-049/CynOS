[org 0x8200]
[bits 32]

setup64:
    mov eax, cr0
    and eax, (1 << 31) - 1
    mov cr0, eax

    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd

    mov edi, cr3
    mov dword [edi], 0x2003
    add edi, 0x1000
    mov dword [edi], 0x3003
    add edi, 0x1000
    mov dword [edi], 0x4003
    add edi, 0x1000

    mov ebx, 0x00000003
    mov ecx, 512

    .SetEntry:
        mov dword [edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop .SetEntry

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    cli
    lgdt [GDT64.POINTER]

    jmp GDT64.CODE:main64

jmp $

%include "./src/bootloader/bootgdt.asm"

KERNEL_LOCATION equ 0x8400

[bits 64]
main64:
    mov ax, GDT64.DATA
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    jmp KERNEL_LOCATION

times 512-($-$$) db 0
