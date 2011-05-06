#!/usr/bin/python

import os
import sys

def usage(f = sys.stdout):
    print >> f, """
Usage: %(progname)s iterations
Loads and unloads the driver from the kernel iterations times.
""" % {
    "progname": sys.argv[0],
}

if __name__ == "__main__":
    if(len(sys.argv) != 2):
        usage()
        sys.exit()

    for i in range(int(sys.argv[1])):
        os.system("insmod ../bin/nf10_eth_driver.ko")
        os.system("rmmod nf10_eth_driver");

