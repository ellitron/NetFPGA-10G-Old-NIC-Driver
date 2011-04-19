#ifndef NF10_ETH_DRIVER_H
#define NF10_ETH_DRIVER_H

/* Useful debug print macro. Turned on/off with DRIVER_DEBUG macro fed to gcc. */
#undef PDEBUG
#ifdef DRIVER_DEBUG
#	ifdef __KERNEL__
#		define PDEBUG(fmt, args...) printk(KERN_DEBUG "nf10_eth_driver: DEBUG: " fmt, ## args)
#	else
#		define PDEBUG(fmt, args...) fprintf(stderr, fmt, ## args)
#	endif
#else
#	define PDEBUG(fmt, args...)
#endif

/* PCI device IDs for the NetFPGA-10G platform and related designs. */
#define PCI_VENDOR_ID_NF10		0x10ee	/* Vendor ID used for all NetFPGA-10G designs. */
#define PCI_DEVICE_ID_NF10_REF_NIC	0x4243	/* Device ID used for the NetFPGA-10G reference NIC design. */

/* NF10's Generic Netlink family settings. */
#define NF10_GENL_FAMILY_NAME           "NF10_ETH_DRIVER"
#define NF10_GENL_FAMILY_VERSION        1

#define BAR_0	0

/* Attributes that can be attached to our netlink messages. */
enum {
        NF10_GENL_A_UNSPEC,
        NF10_GENL_A_MSG,
	NF10_GENL_A_DMA_BUF,	

        __NF10_GENL_A_MAX,
};

#define NF10_GENL_A_MAX (__NF10_GENL_A_MAX - 1)

/* Commands defined for our generic netlink interface. */
enum {
        NF10_GENL_C_UNSPEC,
        NF10_GENL_C_ECHO,
	NF10_GENL_C_DMA_TX,
	NF10_GENL_C_DMA_RX,

        __NF10_GENL_C_MAX,
};

#define NF10_GENL_C_MAX (__NF10_GENL_C_MAX - 1)

#endif /* NF10_ETH_DRIVER_H */
