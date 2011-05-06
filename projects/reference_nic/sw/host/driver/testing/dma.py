#!/usr/bin/python

import sys
import random
import string
import subprocess

def usage(f = sys.stdout):
    print >> f, """
Usage: %(progname)s buffer_size iterations
""" % {
    "progname": sys.argv[0],
}

#buffer size
#number of times to go through the loop

if __name__ == "__main__":
    if(len(sys.argv) != 3):
        usage()
        sys.exit()

    buffer_size = int(sys.argv[1])
    iterations = int(sys.argv[2])

    error = False

    for i in range(0, iterations):
        strlen = random.randint(4, buffer_size)
        strlen = (strlen & (-1 << 2)) - 1

        random_string = "".join(random.choice(string.letters + string.digits) for i in xrange(strlen)) 
    
        subprocess.call("../bin/driver_ctrl dma_tx " + random_string, shell=True) 
        output = subprocess.check_output("../bin/driver_ctrl dma_rx", shell=True)
        output = output.strip()

        if(random_string != output):
            error = True
            print "ERROR: iteration: " + str(i) + " sent: " + random_string + " received: " + output

    if(error):
        print "DMA test failed."
