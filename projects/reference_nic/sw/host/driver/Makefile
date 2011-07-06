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
	cp $(BUILD)/$(DATE)/*.ko $(BIN)/
	cp $(BUILD)/$(DATE)/driver_ctrl $(BIN)/
	cp $(BUILD)/$(DATE)/*.so.* $(BIN)/

clean:
	rm -rf $(BUILD)/* $(BIN)/*

