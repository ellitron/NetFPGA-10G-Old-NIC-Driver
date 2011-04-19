obj-m			:= nf10_eth_driver.o
nf10_eth_driver-objs	:= nf10_eth_driver_main.o

ifeq ($(DRIVER_DEBUG),y)
	DEBFLAGS = -O -g -DDRIVER_DEBUG
else
	DEBFLAGS = -O2
endif

EXTRA_CFLAGS	+= $(DEBFLAGS)

KVERSION=$(shell uname -r)

all:	nf10_eth_driver driver_ctrl

nf10_eth_driver:
	$(MAKE) -C /lib/modules/$(KVERSION)/build SUBDIRS=$(shell pwd) modules

# FIXME: need to make this smarter / little more professional looking...
driver_ctrl:
	gcc driver_ctrl.c -lnl -lnl-genl -o driver_ctrl

modules_install:
	$(MAKE) -C /lib/modules/$(KVERSION)/build SUBDIRS=$(shell pwd) modules_install

clean:
	rm -rf *.o *~ core .depend modules.order Module.symvers .*.cmd *.ko *.mod.c .*.o.d .tmp_versions

