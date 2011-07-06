SRC			= src
BUILD		= build
BIN			= bin
ROOT		:= $(shell pwd)
DATE		:= $(shell date +%Y%m%d_%H%M)

DRIVER_DEBUG    = y
export DRIVER_DEBUG

all:
	cp -r $(SRC)/ $(BUILD)/$(DATE)
	$(MAKE) -C $(BUILD)/$(DATE)
	cp $(BUILD)/$(DATE)/nf10_eth_driver.ko $(BIN)/
	cp $(BUILD)/$(DATE)/driver_ctrl $(BIN)/
	cp $(BUILD)/$(DATE)/libnf10reg.so.1.0 $(BIN)/

install:
	cp $(BIN)/libnf10reg.so.1.0 /usr/local/lib
	ln -sf /usr/local/lib/libnf10reg.so.1.0 /usr/local/lib/libnf10reg.so
	ln -sf /usr/local/lib/libnf10reg.so.1.0 /usr/local/lib/libnf10reg.so.1

clean:
	rm -rf $(BUILD)/* $(BIN)/*

