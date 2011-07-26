#!/usr/bin/python

#///////////////////////////////////////////////////////////////////////
#
#   Description:
#
#   Expected System State:
# 
#   Revision history:
#       2011/07/22 Jonathan Ellithorpe: Initial check-in
#
#///////////////////////////////////////////////////////////////////////

import re
import sys
import random
import string
import struct
import subprocess
import socket
import time

def usage(f = sys.stdout):
    print >> f, """
Usage: %(progname)s pair1 pair2
    pair1   - 2 digit #. Each digit represents a port.
    pair2   - 2 digit #. Each digit represents a port.

Example:
    %(progname)s 12 34
        Means 1<->2, and 3<->4
""" % {
    "progname": sys.argv[0],
}

if __name__ == "__main__":
    if(len(sys.argv) != 3):
        usage()
        sys.exit()

    pair1_1 = int(sys.argv[1][0])
    pair1_2 = int(sys.argv[1][1])
    pair2_1 = int(sys.argv[2][0])
    pair2_2 = int(sys.argv[2][1])
 
    pairs = ((pair1_1, pair1_2), (pair2_1, pair2_2))
 
    # Insert the driver.
    subprocess.call("sudo insmod ../../bin/nf10_eth_driver.ko", shell=True)

    # Bring up the interfaces
    subprocess.call("for i in 0 1 2 3; do sudo ifconfig nf$i 10.0.$i.1/24; done", shell=True)

    # Use random proto number in the Ethernet packets.
    proto = 0x1234

    # Create the raw sockets.
    nf0_sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, proto)
    nf0_sock.bind(("nf0",proto))
    nf1_sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, proto)
    nf1_sock.bind(("nf1",proto))
    nf2_sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, proto)
    nf2_sock.bind(("nf2",proto))
    nf3_sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, proto)
    nf3_sock.bind(("nf3",proto))

    socks = (nf0_sock, nf1_sock, nf2_sock, nf3_sock)

    # Write down the MAC addresses
    nf0_mac = nf0_sock.getsockname()[4]
    nf1_mac = nf1_sock.getsockname()[4]
    nf2_mac = nf2_sock.getsockname()[4]
    nf3_mac = nf3_sock.getsockname()[4]

    macs = (nf0_mac, nf1_mac, nf2_mac, nf3_mac)

    # For each pair
    for i in range(0, 2):
        # Test one way
        

        # Test the other way

    srcAddr = hwAddr
    dstAddr = "\x01\x02\x03\x04\x05\x06"
    ethData = "here is some data for an ethernet packet"

    txFrame = struct.pack("!6s6sh",dstAddr,srcAddr,proto) + ethData

    time.sleep(16)
    
    print "Tx[%d]: "%len(ethData) + string.join(["%02x"%ord(b) for b in ethData]," ") 
           
    nf0s.send(txFrame)

    nf1s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, proto)
    nf1s.bind(("nf1",proto))

    rxFrame = nf1s.recv(2048)

    dstAddr,srcAddr,proto = struct.unpack("!6s6sh",rxFrame[:14])
    ethData = rxFrame[14:]

    print "Rx[%d]: "%len(ethData) + string.join(["%02x"%ord(b) for b in ethData]," ")

    nf0s.close()
    nf1s.close()

    # Remove the driver.
    subprocess.call("sudo rmmod nf10_eth_driver", shell=True);


