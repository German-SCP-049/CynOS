[org 0x8400]
[bits 32]

section .text
extern main
global _start

_start:
    call main
    jmp $
