#!/usr/bin/python

import os

ITERATIONS	= 10

for i in range(ITERATIONS):
	os.system("insmod ../bin/nf10_eth_driver.ko")
	os.system("rmmod nf10_eth_driver");

