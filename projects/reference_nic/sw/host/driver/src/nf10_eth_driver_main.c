/* FIXME: Add proper comment headers. */
/* FIXME: Make function comment headers that of standard linux style. */
/* FIXME: Make naming conistent (pci_driver, probe, remove vs. nf10_netdev_ops... nf10_ prefix?? */
/* FIXME: replace tabs with 4 spaces. */

/* Documentation resources:
 * kernel/Documentation/DMA-API-HOWTO.txt
 * kernel/Documentation/PCI/pci.txt
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netdevice.h>
#include <linux/etherdevice.h>
#include <linux/proc_fs.h>
#include <linux/pci.h>
#include <net/genetlink.h>
#include <linux/dma-mapping.h>

#include "nf10_eth_driver.h"

#include "occp.h"
#include "ocdp.h"

/* Function prototypes. */
static int                      nf10_ndo_open(struct net_device *netdev);
static int                      nf10_ndo_stop(struct net_device *netdev);
static netdev_tx_t              nf10_ndo_start_xmit(struct sk_buff *skb, struct net_device *netdev);
static void                     nf10_ndo_tx_timeout(struct net_device *netdev);
static struct net_device_stats* nf10_ndo_get_stats(struct net_device *netdev);

char driver_name[] = "nf10_eth_driver";

/* Network devices to be registered with the kernel. */
struct net_device *nf10_netdev;

/* MMIO */
/* Like the DMA variables, probe() and remove() both use bar0_base_va, so need
 * to make global. FIXME: explore more elegant way of doing this. */
void __iomem 	*bar0_base_va;
unsigned int	bar0_size;

/* DMA */
/* *_dma_reg_* need these to be global for now since probe() and remobe() both use them.
 * FIXME: possible that we can do something more elegant. */
void 			*tx_dma_reg_va;	/* TX DMA region kernel virtual address. */
dma_addr_t		tx_dma_reg_pa;	/* TX DMA region physical address. */
void			*rx_dma_reg_va;	/* RX DMA region kernel virtual address. */
dma_addr_t		rx_dma_reg_pa;	/* RX DMA region physical address. */
struct dma_stream	tx_dma_stream;	/* To device. */
struct dma_stream	rx_dma_stream;	/* From device. */

/* DMA parameters. */
#define		DMA_BUF_SIZE	2048	/* Size of buffer for each DMA transfer. Property of the hardware. */
#define		DMA_FPGA_BUFS	4	/* Number of buffers on the FPGA side. Property of the hardware. */
#define		DMA_CPU_BUFS	8	/* Number of buffers on the CPU side. */

/* Total size of a DMA region (1 region for TX, 1 region for RX). */
#define 	DMA_REGION_SIZE	((DMA_BUF_SIZE + OCDP_METADATA_SIZE + sizeof(uint32_t)) * (DMA_CPU_BUFS))

/* Bundle of variables to keep track of a unidirectional DMA stream. */
struct dma_stream {
	uint8_t         *buffers;
	OcdpMetadata    *metadata;
	uint32_t        *flags;
	uint32_t        *doorbell;
	uint32_t        buf_index;
};

static const struct net_device_ops nf10_netdev_ops = {
    .ndo_open               = nf10_ndo_open,
    .ndo_stop               = nf10_ndo_stop,
    .ndo_start_xmit         = nf10_ndo_start_xmit,
    .ndo_tx_timeout         = nf10_ndo_tx_timeout,
    .ndo_get_stats          = nf10_ndo_get_stats,
};

/* OpenCPI */
#define WORKER_DP0	13
#define WORKER_DP1	14
#define WORKER_SMA0	2
#define WORKER_BIAS	3
#define WORKER_SMA1	4

/* FIXME: ought to think about this some more... what does timeout actually mean? */
#define OCCP_LOG_TIMEOUT	4

/* Define our attributes policy array. The array index is the attribute number,
 * and the value is a policy for that attribute type. The policy simply states
 * the type of data that attributes of that type are allowed to contain
 * (32-bit integer, null terminated string, etc.). Part of the definition of a
 * netlink operation is which policy array it uses. Then, when the generic 
 * netlink subsystem of the kernel receives a new netlink message for this
 * family, it first observes the operation, then uses the policy array 
 * associated with the operation to check each of the attributes in the message
 * of the operation. Note that, for each attribute, specifying a policy is
 * optional (although highly encouraged, even when attributes are structures or
 * arrays). */
static struct nla_policy genl_policy[NF10_GENL_A_MAX + 1] = {
	[NF10_GENL_A_MSG]	= { .type = NLA_NUL_STRING },
};

/* Define our own generic netlink family for the nf10_eth_driver. */
static struct genl_family genl_family = {
	.id		= GENL_ID_GENERATE,		/* Tells the Generic Netlink controller to choose a channel
							 * number for us when we register the family. This channel 
							 * number is then placed in the 'type' field of each
							 * packet's nlmsghdr. */
	.hdrsize	= 0,				/* Using 0 because there's no family specific header. */
	.name		= NF10_GENL_FAMILY_NAME,	/* User-space applications use this name to identify this
							 * channel. The generic netlink controller forms a mapping
							 * between this name and the channel number (ID). */
	.version	= NF10_GENL_FAMILY_VERSION,
	.maxattr	= NF10_GENL_A_MAX,		/* Maximum number of attributes this family supports. */
};

/* Functions of operations defined for our Generic Netlink family... */

/* A simple Echo command. 
 * Application sends us a message and we send it back to the application. */
int genl_cmd_echo(struct sk_buff *skb, struct genl_info *info)
{
	struct nlattr *na;
	char *msg;
	struct sk_buff *skb_reply;
	void *msg_reply;
	int err;

	if(info == NULL) {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): info arg is NULL\n");
		return -EINVAL;
	}

	/* Receive the message. */
	na = info->attrs[NF10_GENL_A_MSG];
	if(na) {
		msg = (char *)nla_data(na);
		if(msg == NULL) {
			printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): msg attribute has no data\n");
			return 0;
		} else
			printk(KERN_INFO "nf10_eth_driver: genl_cmd_echo(): received: %s\n", msg);
	} 
	else {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): no attributes in message\n");
		return 0;
	}

	/* Echo the message. */
	skb_reply = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
	if(skb_reply == NULL) {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): couldn't allocate the reply skb\n");
		return -ENOMEM;
	}

	msg_reply = genlmsg_put_reply(skb_reply, info, &genl_family, 0, NF10_GENL_C_ECHO);
	if(msg_reply == NULL) {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): genlmsg_put_reply returned NULL\n");
		/* FIXME: need to free data structures! */
		return 0; /* FIXME: What's the proper error code for this? */
	}

	err = nla_put_string(skb_reply, NF10_GENL_A_MSG, msg);
	if(err != 0) {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): couldn't add msg to reply\n");
		/* FIXME: need to free data structures! */
		return err;
	}

	genlmsg_end(skb_reply, msg_reply);

	err = genlmsg_reply(skb_reply, info);
	if(err != 0) {
		printk(KERN_WARNING "nf10_eth_driver: genl_cmd_echo(): couldn't send back reply\n");
		/* FIXME: need to free data structures! */
		return err;
	}

	/* FIXME: Is it necessary to free the skb_reply? */

	return 0;
}

/* DMA TX command. 
 * Application sends us a message to transmit to the device over DMA. */
int genl_cmd_dma_tx(struct sk_buff *skb, struct genl_info *info)
{
	struct nlattr 	*na;	
	void*		msg_data;
	size_t		msg_len;
	uint8_t		waited;

	/* FIXME: it's possible to call this function even when there's no hardware, need to check that 
	 * the right data structures have actually been initialized and so on... */ 
	
	if(info == NULL) {
		printk(KERN_WARNING "%s: genl_cmd_dma_tx(): info arg is NULL\n", driver_name);
		return -EINVAL;
	}
	
	/* Receive the message to transmit. */
	na = info->attrs[NF10_GENL_A_MSG];
	if(na) {
		if(nla_data(na) == NULL) {
			printk(KERN_WARNING "%s: genl_cmd_dma_tx(): msg attribute has no data\n", driver_name);
			return 0;
		}
	} 
	else {
		printk(KERN_WARNING "%s: genl_cmd_dma_tx(): no attributes in message\n", driver_name);
		return 0;
	}

	/* Wait for buffer to be free. */
	/* FIXME: actually in the case that the buffer is not free... let's instead send a msg
	 * to the user and exit this function. */
	waited = 0;
	while(tx_dma_stream.flags[tx_dma_stream.buf_index] == 0) {
		if(!waited)
			PDEBUG("genl_cmd_dma_tx(): waiting for buffer: %d\n", tx_dma_stream.buf_index);
		waited = 1;
	}

	PDEBUG("genl_cmd_dma_tx(): filling free buffer: %d\n", tx_dma_stream.buf_index);

	msg_data = nla_data(na);
	/* Cap the msg_len to DMA_BUF_SIZE. */
	msg_len = (nla_len(na) > DMA_BUF_SIZE) ? DMA_BUF_SIZE : nla_len(na);
	/* Presently the hardware requires that we send an integer number of DWORDS. */
	msg_len &= ~3;

	/* Copy message into buffer. */
	memcpy((void*)&tx_dma_stream.buffers[tx_dma_stream.buf_index * DMA_BUF_SIZE], msg_data, msg_len);	
	
	/* Fill out metadata. */
	tx_dma_stream.metadata[tx_dma_stream.buf_index].length = msg_len;
	tx_dma_stream.metadata[tx_dma_stream.buf_index].opCode = 0;	/* FIXME: needed? */	

	/* Set the buffer flag to full. */
	tx_dma_stream.flags[tx_dma_stream.buf_index] = 0;

	PDEBUG("genl_cmd_dma_tx(): DMA TX operation info:\n"
		"\tReceived msg:\t\t%s\n"
		"\tReceived msg length:\t%d\n"
		"\tTruncated msg length:\t%d\n"
		"\tUsing buffer number:\t%d\n",
		(char*)nla_data(na), nla_len(na), (uint32_t)msg_len, tx_dma_stream.buf_index);	

	/* Tell hardware we filled a buffer. */
	*tx_dma_stream.doorbell = 1;

	/* Update the buffer index. */
	if(++tx_dma_stream.buf_index == DMA_CPU_BUFS)
		tx_dma_stream.buf_index = 0;

	return 0;
}

/* DMA RX command. 
 * Receive data over DMA and send back to the application. */
int genl_cmd_dma_rx(struct sk_buff *skb, struct genl_info *info)
{
	struct sk_buff *skb_reply;
	void *msg_reply;
	int err;

	/* Check arguments. */
	if(info == NULL) {
		printk(KERN_WARNING "%s: genl_cmd_dma_rx(): info arg is NULL\n", driver_name);
		return -EINVAL;
	}
	
	/* Prepare a reply. */
	skb_reply = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
	if(skb_reply == NULL) {
		printk(KERN_WARNING "%s: genl_cmd_dma_rx(): couldn't allocate the reply skb\n", driver_name);
		return -ENOMEM;
	}

	msg_reply = genlmsg_put_reply(skb_reply, info, &genl_family, 0, NF10_GENL_C_DMA_RX);
	if(msg_reply == NULL) {
		printk(KERN_WARNING "%s: genl_cmd_dma_rx(): genlmsg_put_reply returned NULL\n", driver_name);
		/* FIXME: need to free data structures! */
		return 0; /* FIXME: What's the proper error code for this? */
	}

	/* Check if buffer has something for us. */
	if(rx_dma_stream.flags[rx_dma_stream.buf_index] == 1) {
		err = nla_put(	skb_reply, 
				NF10_GENL_A_DMA_BUF, 
				rx_dma_stream.metadata[rx_dma_stream.buf_index].length, 
				(void*)&rx_dma_stream.buffers[rx_dma_stream.buf_index * DMA_BUF_SIZE]);
		if(err != 0) {
			printk(KERN_WARNING "%s: genl_cmd_dma_rx(): couldn't add DMA buffer to generic netlink msg\n", driver_name);
			/* FIXME: We need to free the allocated data structures! */
			return err;
		}

		/* Mark the buffer as empty. */
		rx_dma_stream.flags[rx_dma_stream.buf_index] = 0;
	
		PDEBUG("genl_cmd_dma_rx(): DMA RX operation info:\n"
			"\tBytes of data received:\t%d\n"
			"\tFrom buffer number:\t%d\n",
			rx_dma_stream.metadata[rx_dma_stream.buf_index].length, rx_dma_stream.buf_index);	

		/* Tell the hardware we emptied the buffer. */
		*rx_dma_stream.doorbell = 1;

		/* Update the buffer index. */
		if(++rx_dma_stream.buf_index == DMA_CPU_BUFS)
			rx_dma_stream.buf_index = 0;
	}
	else {
		PDEBUG("genl_cmd_dma_rx(): buffer number %d is empty\n", rx_dma_stream.buf_index);
	}

	genlmsg_end(skb_reply, msg_reply);

	err = genlmsg_reply(skb_reply, info);
	if(err != 0) {
		printk(KERN_WARNING "%s: genl_cmd_dma_rx(): couldn't send back reply\n", driver_name);
		/* FIXME: do we need to free allocated data structures here? */
		return err;
	}
	
	return 0;
}

/* Operations defined for our Generic Netlink family... */

/* Echo operation genl structure. */
struct genl_ops genl_ops_echo = {
	.cmd	= NF10_GENL_C_ECHO,
	.flags	= 0,
	.policy	= genl_policy,
	.doit	= genl_cmd_echo,
	.dumpit	= NULL,
};

/* DMA TX operation genl structure. */
struct genl_ops genl_ops_dma_tx = {
	.cmd	= NF10_GENL_C_DMA_TX,
	.flags	= 0,
	.policy	= genl_policy,
	.doit	= genl_cmd_dma_tx,
	.dumpit	= NULL,
};

/* DMA RX operation genl structure. */
struct genl_ops genl_ops_dma_rx = {
	.cmd	= NF10_GENL_C_DMA_RX,
	.flags	= 0,
	.policy	= genl_policy,
	.doit	= genl_cmd_dma_rx,
	.dumpit	= NULL,
};

static struct genl_ops *genl_all_ops[] = {
	&genl_ops_echo,
	&genl_ops_dma_tx,
	&genl_ops_dma_rx,
};

/* These are the IDs of the PCI devices that this Ethernet driver supports. */
static struct pci_device_id id_table[] = {
	{ PCI_DEVICE(PCI_VENDOR_ID_NF10, PCI_DEVICE_ID_NF10_REF_NIC), }, /* NetFPGA-10G Reference NIC. */
	{ 0, }
};
/* Creates a symbol used by depmod to tell the kernel that these devices 
 * are associated with this driver module. This is communicated via the 
 * /lib/modules/KVERSION/modules.pcimap file, written to by depmod. */
MODULE_DEVICE_TABLE(pci, id_table);

/* Define our net_device operations here. */
static int nf10_ndo_open(struct net_device *netdev)
{
	PDEBUG("nf10_ndo_open(): Opening net device\n");	

    /* Tell the kernel we're ready for transmitting packets. */
    netif_start_queue(netdev);

    return 0;
}

static int nf10_ndo_stop(struct net_device *netdev)
{
	PDEBUG("nf10_ndo_stop(): Closing net device\n");	

    /* Tell the kernel we can't transmit anymore. */
    netif_stop_queue(netdev);

    return 0;
}


static netdev_tx_t nf10_ndo_start_xmit(struct sk_buff *skb, struct net_device *netdev)
{
    void *data;
    uint32_t len;
    int waited;
	
    PDEBUG("nf10_ndo_start_xmit(): Transmitting packet\n");	

    /* Get data and length. */
    data = (void*)skb->data;
    len = skb->len;

    /* FIXME: When hardware is ready, may need to insert code here to check that the length
     * is within the limits of what the hardware can handle. For now I'll just use this 
     * temporary check */
    /* Also wondering for len... if the preamble/FCS are included. */
    if(len < ETH_ZLEN || len > ETH_FRAME_LEN) {
        PDEBUG("nf10_ndo_start_xmit(): packet length %d out of bounds [%d, %d]\n", len, ETH_ZLEN, ETH_FRAME_LEN);
    }

    /* Check length against the DMA buffer size. */
    if(len > DMA_BUF_SIZE) {
        printk(KERN_ERR "%s: ERROR: nf10_ndo_start_xmit(): packet length %d greater than buffer size %d\n", driver_name, len, DMA_BUF_SIZE);
        dev_kfree_skb(skb);
        /* FIXME: not really sure of the right return value in this case... */
        return NETDEV_TX_OK;
    }

    /* Start the clock! */
    netdev->trans_start = jiffies;

    /* DMA the packet to the hardware. */

    /* Wait for buffer to be free. */
    /* FIXME: Want to use netif_{stop,wake}_queue functions, except that presently we have
     * no interrupts for tx, so we don't have a proper way to call netif_wake_queue aside
     * from setting a timer and a callback. For now... just wait. */
    waited = 0;
    while(tx_dma_stream.flags[tx_dma_stream.buf_index] == 0) {
        if(!waited)
            PDEBUG("nf10_ndo_start_xmit(): waiting for buffer: %d\n", tx_dma_stream.buf_index);
        waited = 1;
    }

    /* Presently the hardware requires that we send an integer number of DWORDS. Technically
     * speaking, as the hardware stands now, it is an error to send it anything not an 
     * integer number of DWORDS in length... so we'll report an error for now and proceed. */
    /* FIXME: update this when the hardware is fixed. */
    if( (len & ~3) != len ) {
        printk(KERN_ERR "%s: ERROR: nf10_ndo_start_xmit(): packet length %d not multiple of 4, truncating to %d\n", driver_name, len, len & ~3);
        len = len & ~3;
    }

    /* Copy message into buffer. */
    memcpy((void*)&tx_dma_stream.buffers[tx_dma_stream.buf_index * DMA_BUF_SIZE], data, len);

    /* Fill out metadata. */
    tx_dma_stream.metadata[tx_dma_stream.buf_index].length = len;
    tx_dma_stream.metadata[tx_dma_stream.buf_index].opCode = 0; /* FIXME: needed? */

    /* Set the buffer flag to full. */
    tx_dma_stream.flags[tx_dma_stream.buf_index] = 0;

    PDEBUG("nf10_ndo_start_xmit(): DMA TX operation info:\n"
        "\tReceived msg length:\t%d\n"
        "\tTruncated msg length:\t%d\n"
        "\tUsing buffer number:\t%d\n",
        skb->len, len, tx_dma_stream.buf_index);

    /* Tell hardware we filled a buffer. */
    *tx_dma_stream.doorbell = 1;

    /* Update the buffer index. */
    if(++tx_dma_stream.buf_index == DMA_CPU_BUFS)
        tx_dma_stream.buf_index = 0;

    return NETDEV_TX_OK;
}

static void nf10_ndo_tx_timeout(struct net_device *netdev)
{
    printk(KERN_WARNING "%s: WARNING: nf10_ndo_tx_timeout(): hit timeout!\n", driver_name);
}

static struct net_device_stats* nf10_ndo_get_stats(struct net_device *netdev)
{
	PDEBUG("nf10_ndo_get_stats(): Getting the stats\n");	
    
    /* FIXME: Implement me! */
    return &nf10_netdev->stats;
}


/* When the kernel finds a device with a vendor and device ID associated with this driver
 * it will invoke this function. The job of this function is really to initialize the 
 * device that the kernel has already found for us... so the name 'probe' is a bit of a
 * misnomer. */
static int probe(struct pci_dev *pdev, const struct pci_device_id *id)
{	
    /* OpenCPI */
    OccpSpace 	*occp;
    OcdpProperties	*dp0_props;
    OcdpProperties	*dp1_props;
    uint32_t	*sma0_props;
    uint32_t	*sma1_props;
    uint32_t	*bias_props;
    OccpWorkerRegisters 
            *dp0_regs,
            *dp1_regs,
            *sma0_regs,
            *sma1_regs,
            *bias_regs;

    int err;

	PDEBUG("probe(): entering probe() with vendor_id: 0x%4x and device_id: 0x%4x\n", id->vendor, id->device);	
	
    /* Enable the device. pci_enable_device() will do the following (ref. PCI/pci.txt kernel doc):
	 * 	- wake up the device if it was in suspended state
	 * 	- allocate I/O and memory regions of the device (if BIOS did not)
	 * 	- allocate an IRQ (if BIOS did not) */
	err = pci_enable_device(pdev);
	if(err) {
		PDEBUG("probe(): pci_enable_device failed with error code: %d\n", err);	
		return err;
	}

	/* Enable DMA functionality for the device. 
	 * pci_set_master() does this by (ref. PCI/pci.txt kernel doc) setting the bus master bit
	 * in the PCI_COMMAND register. pci_clear_master() will disable DMA by clearing the bit. 
	 * This function also sets the latency timer value if necessary. */
	pci_set_master(pdev);

	/* Mark BAR0 MMIO region as reserved by this driver. */
	err = pci_request_region(pdev, BAR_0, driver_name); 
	if(err) {
		printk(KERN_ERR "%s: ERROR: probe(): could not reserve BAR0 memory-mapped I/O region\n", driver_name);
		pci_disable_device(pdev);
		return err;
	}
	
	/* Remap BAR0 MMIO region into our address space. */
	bar0_base_va = pci_ioremap_bar(pdev, BAR_0);
	if(bar0_base_va == NULL) {
		printk(KERN_ERR "%s: ERROR: probe(): could not remap BAR0 memory-mapped I/O region into our address space\n", driver_name);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);
		/* FIXME: is this the right error code? */
		return -ENOMEM;
	}
	
	/* Take note of the size. */
	bar0_size = pci_resource_len(pdev, BAR_0);

	/* Check to make sure it's as large as we expect it to be. */
	if(!(bar0_size >= sizeof(OccpSpace))) {
		printk(KERN_ERR "%s: ERROR: probe(): expected BAR0 memory-mapped I/O region to be at least %lu bytes in size, but it is only %d bytes\n", driver_name, sizeof(OccpSpace), bar0_size);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return -1;	
	}

	PDEBUG("probe(): successfully mapped BAR0 MMIO region:\n"
		"\tBAR0: Virtual address:\t\t0x%016llx\n"
		"\tBAR0: Physical address:\t\t0x%016llx\n"
		"\tBAR0 Size:\t\t\t%d\n",
		/* FIXME: typcasting might throw warnings on 32-bit systems... */
		(uint64_t)bar0_base_va, (uint64_t)pci_resource_start(pdev, BAR_0), bar0_size);

	/* Negotiate with the kernel where we can allocate DMA-capable memory regions.
	 * We do this with a call to dma_set_mask. Through this function we inform
	 * the kernel of what physical memory addresses our device is capable of 
	 * addressing via DMA. Through the function's return value, the kernel
	 * informs us of whether or not this machine's DMA controller is capable of
	 * supporting our request. A return value of 0 completes the "handshake" and
	 * all further DMA memory allocations will come from this region, set by the
	 * mask. */
	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
	if(err) {
		printk(KERN_ERR "%s: ERROR: probe(): this machine's DMA controller does not support the DMA address limitations of this device\n", driver_name);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}

	/* Since future DMA memory allocations will be coherent regions with the CPU
	 * cache, we must additionally call dma_set_coherent_mask, which performs the
	 * same negotiation process. It is guaranteed to work for a region equal to 
	 * or smaller than that which we agreed upon with dma_set_mask... but we check
	 * its return value just in case. */
	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
	if(err) {
		printk(KERN_ERR "%s: ERROR: probe(): this machine's DMA controller does not support the coherent DMA address limitations of this device\n", driver_name);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}

	/* Allocate TX DMA region. */
	tx_dma_reg_va = dma_alloc_coherent(&pdev->dev, DMA_REGION_SIZE, &tx_dma_reg_pa, GFP_KERNEL);
	if(tx_dma_reg_va == NULL) {
		printk(KERN_ERR "nf10_eth_driver: ERROR: probe(): failed to allocate TX DMA region\n");
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}

	/* Allocate RX DMA region. */
	rx_dma_reg_va = dma_alloc_coherent(&pdev->dev, DMA_REGION_SIZE, &rx_dma_reg_pa, GFP_KERNEL);
	if(rx_dma_reg_va == NULL) {
		/* FIXME: replace all nf10_eth_driver with driver_name string in format. */
		printk(KERN_ERR "nf10_eth_driver: ERROR: probe(): failed to allocate RX DMA region\n");
		dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, tx_dma_reg_va, tx_dma_reg_pa);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}

	/* FIXME: Should I zero the memory? */

	/* FIXME: Insert a check to make sure that the memory regions really are in the lower
	 * 32-bits of the address space. */

	PDEBUG("probe(): successfully allocated the TX and RX DMA regions:\n"
		"\tTX Region: Virtual address:\t0x%016llx\n"
		"\tTX Region: Physical address:\t0x%016llx\n"
		"\tTX Region Size:\t\t\t%lu\n"
		"\tRX Region: Virtual address:\t0x%016llx\n"
		"\tRX Region: Physical address:\t0x%016llx\n"
		"\tRX Region Size:\t\t\t%lu\n",
		/* FIXME: typcasting might throw warnings on 32-bit systems... */
		(uint64_t)tx_dma_reg_va, (uint64_t)tx_dma_reg_pa, DMA_REGION_SIZE,
		(uint64_t)rx_dma_reg_va, (uint64_t)rx_dma_reg_pa, DMA_REGION_SIZE);

	/* Now we begin to structure the BAR0 MMIO region as the set of control and status
	 * registers that it is. Once we setup this structure, then we proceed to reset,
	 * initialize, and then start the hardware components. */

	occp 		= (OccpSpace *)bar0_base_va;

	dp0_props	= (OcdpProperties *)occp->config[WORKER_DP0];
	dp1_props	= (OcdpProperties *)occp->config[WORKER_DP1];
	sma0_props	= (uint32_t *)occp->config[WORKER_SMA0];
	sma1_props	= (uint32_t *)occp->config[WORKER_SMA1];
	bias_props	= (uint32_t *)occp->config[WORKER_BIAS];
		
	dp0_regs	= &occp->worker[WORKER_DP0].control,
	dp1_regs	= &occp->worker[WORKER_DP1].control,
	sma0_regs	= &occp->worker[WORKER_SMA0].control,
	sma1_regs	= &occp->worker[WORKER_SMA1].control,
	bias_regs	= &occp->worker[WORKER_BIAS].control;

	/* Reset workers. */

	/* Assert reset. */
	dp0_regs->control	= OCCP_LOG_TIMEOUT;
	dp1_regs->control	= OCCP_LOG_TIMEOUT;
	sma0_regs->control	= OCCP_LOG_TIMEOUT;
	sma1_regs->control	= OCCP_LOG_TIMEOUT;
	bias_regs->control	= OCCP_LOG_TIMEOUT;	

	/* Write memory barrier. */
	wmb();

	/* Take out of reset. */
	dp0_regs->control	= OCCP_CONTROL_ENABLE | OCCP_LOG_TIMEOUT;	
	dp1_regs->control	= OCCP_CONTROL_ENABLE | OCCP_LOG_TIMEOUT;
	sma0_regs->control	= OCCP_CONTROL_ENABLE | OCCP_LOG_TIMEOUT;
	sma1_regs->control	= OCCP_CONTROL_ENABLE | OCCP_LOG_TIMEOUT;	
	bias_regs->control	= OCCP_CONTROL_ENABLE | OCCP_LOG_TIMEOUT;

	/* Read/Write memory barrier. */
	mb();

	/* Initialize workers. */

	/* FIXME: need to double check everything below for problems with ooe. */

	if(dp0_regs->initialize != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker initialization failure for DP0\n", driver_name);
		err = -1;
	}
	
	if(dp1_regs->initialize != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker initialization failure for DP1\n", driver_name);
		err = -1;
	}

	if(sma0_regs->initialize != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker initialization failure for SMA0\n", driver_name);
		err = -1;
	}

	if(sma1_regs->initialize != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker initialization failure for SMA1\n", driver_name);
		err = -1;
	}

	if(bias_regs->initialize != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker initialization failure for bias worker\n", driver_name);
		err = -1;
	}
	
	if(err) {
		dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, rx_dma_reg_va, rx_dma_reg_pa);
		dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, tx_dma_reg_va, tx_dma_reg_pa);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}

	mb();

	/* Configure workers. */

	*sma0_props = 1;
	*bias_props = 0;
	*sma1_props = 2;

	tx_dma_stream.buffers	= (uint8_t *)tx_dma_reg_va;
	tx_dma_stream.metadata	= (OcdpMetadata *)(tx_dma_stream.buffers + DMA_CPU_BUFS * DMA_BUF_SIZE);
	tx_dma_stream.flags	= (uint32_t *)(tx_dma_stream.metadata + DMA_CPU_BUFS);
	tx_dma_stream.doorbell	= &dp0_props->nRemoteDone; 
	tx_dma_stream.buf_index	= 0;
	memset((void*)tx_dma_stream.flags, 1, DMA_CPU_BUFS * sizeof(uint32_t));

	dp0_props->nLocalBuffers 	= DMA_FPGA_BUFS;
	dp0_props->nRemoteBuffers 	= DMA_CPU_BUFS;
	dp0_props->localBufferBase 	= 0;
	dp0_props->localMetadataBase 	= DMA_FPGA_BUFS * DMA_BUF_SIZE;
	dp0_props->localBufferSize 	= DMA_BUF_SIZE;
	dp0_props->localMetadataSize 	= sizeof(OcdpMetadata);
	dp0_props->memoryBytes		= 32*1024; /* FIXME: What is this?? */
	dp0_props->remoteBufferBase	= (uint32_t)tx_dma_reg_pa;
	dp0_props->remoteMetadataBase	= (uint32_t)tx_dma_reg_pa + DMA_CPU_BUFS * DMA_BUF_SIZE;
	dp0_props->remoteBufferSize	= DMA_BUF_SIZE;
	dp0_props->remoteMetadataSize	= sizeof(OcdpMetadata);
	dp0_props->remoteFlagBase	= (uint32_t)tx_dma_reg_pa + (DMA_BUF_SIZE + sizeof(OcdpMetadata)) * DMA_CPU_BUFS;
	dp0_props->remoteFlagPitch	= sizeof(uint32_t);
	dp0_props->control		= OCDP_CONTROL(OCDP_CONTROL_CONSUMER, OCDP_ACTIVE_MESSAGE);

	rx_dma_stream.buffers	= (uint8_t *)rx_dma_reg_va;
	rx_dma_stream.metadata	= (OcdpMetadata *)(rx_dma_stream.buffers + DMA_CPU_BUFS * DMA_BUF_SIZE);
	rx_dma_stream.flags	= (uint32_t *)(rx_dma_stream.metadata + DMA_CPU_BUFS);
	rx_dma_stream.doorbell	= &dp1_props->nRemoteDone; 
	rx_dma_stream.buf_index	= 0;
	memset((void*)rx_dma_stream.flags, 0, DMA_CPU_BUFS * sizeof(uint32_t));

	dp1_props->nLocalBuffers 	= DMA_FPGA_BUFS;
	dp1_props->nRemoteBuffers 	= DMA_CPU_BUFS;
	dp1_props->localBufferBase 	= 0;
	dp1_props->localMetadataBase 	= DMA_FPGA_BUFS * DMA_BUF_SIZE;
	dp1_props->localBufferSize 	= DMA_BUF_SIZE;
	dp1_props->localMetadataSize 	= sizeof(OcdpMetadata);
	dp1_props->memoryBytes		= 32*1024; /* FIXME: What is this?? */
	dp1_props->remoteBufferBase	= (uint32_t)rx_dma_reg_pa;
	dp1_props->remoteMetadataBase	= (uint32_t)rx_dma_reg_pa + DMA_CPU_BUFS * DMA_BUF_SIZE;
	dp1_props->remoteBufferSize	= DMA_BUF_SIZE;
	dp1_props->remoteMetadataSize	= sizeof(OcdpMetadata);
	dp1_props->remoteFlagBase	= (uint32_t)rx_dma_reg_pa + (DMA_BUF_SIZE + sizeof(OcdpMetadata)) * DMA_CPU_BUFS;
	dp1_props->remoteFlagPitch	= sizeof(uint32_t);
	dp1_props->control		= OCDP_CONTROL(OCDP_CONTROL_PRODUCER, OCDP_ACTIVE_MESSAGE);
	
	mb();

	PDEBUG("probe(): configured dataplane OCPI workers:\n"
		"\tTX path dataplane properties (dp0, worker %d):\n"
		"\t\tnLocalBuffers:\t\t%d\n"
		"\t\tnRemoteBuffers:\t\t%d\n"
		"\t\tlocalBufferBase:\t0x%08x\n"
		"\t\tlocalMetadataBase:\t0x%08x\n"
		"\t\tlocalBufferSize:\t%d\n"
		"\t\tlocalMetadataSize:\t%d\n"
		"\t\tmemoryBytes:\t\t%d\n"
		"\t\tremoteBufferBase:\t0x%08x\n"
		"\t\tremoteMetadataBase:\t0x%08x\n"
		"\t\tremoteBufferSize:\t%d\n"
		"\t\tremoteMetadataSize:\t%d\n"
		"\t\tremoteFlagBase:\t\t0x%08x\n"
		"\t\tremoteFlagPitch:\t%d\n"
		"\tRX path dataplane properties (dp1, worker %d):\n"
		"\t\tnLocalBuffers:\t\t%d\n"
		"\t\tnRemoteBuffers:\t\t%d\n"
		"\t\tlocalBufferBase:\t0x%08x\n"
		"\t\tlocalMetadataBase:\t0x%08x\n"
		"\t\tlocalBufferSize:\t%d\n"
		"\t\tlocalMetadataSize:\t%d\n"
		"\t\tmemoryBytes:\t\t%d\n"
		"\t\tremoteBufferBase:\t0x%08x\n"
		"\t\tremoteMetadataBase:\t0x%08x\n"
		"\t\tremoteBufferSize:\t%d\n"
		"\t\tremoteMetadataSize:\t%d\n"
		"\t\tremoteFlagBase:\t\t0x%08x\n"
		"\t\tremoteFlagPitch:\t%d\n",
		WORKER_DP0,
		dp0_props->nLocalBuffers,
		dp0_props->nRemoteBuffers,
		dp0_props->localBufferBase,
		dp0_props->localMetadataBase,
		dp0_props->localBufferSize,
		dp0_props->localMetadataSize,
		dp0_props->memoryBytes,
		dp0_props->remoteBufferBase,
		dp0_props->remoteMetadataBase,
		dp0_props->remoteBufferSize,
		dp0_props->remoteMetadataSize,
		dp0_props->remoteFlagBase,
		dp0_props->remoteFlagPitch,
		WORKER_DP1,
		dp1_props->nLocalBuffers,
		dp1_props->nRemoteBuffers,
		dp1_props->localBufferBase,
		dp1_props->localMetadataBase,
		dp1_props->localBufferSize,
		dp1_props->localMetadataSize,
		dp1_props->memoryBytes,
		dp1_props->remoteBufferBase,
		dp1_props->remoteMetadataBase,
		dp1_props->remoteBufferSize,
		dp1_props->remoteMetadataSize,
		dp1_props->remoteFlagBase,
		dp1_props->remoteFlagPitch);

	/* Start workers. */

	if(dp0_regs->start != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker start failure for DP0\n", driver_name);
		err = -1;
	}
	
	if(dp1_regs->start != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker start failure for DP1\n", driver_name);
		err = -1;
	}

	if(sma0_regs->start != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker start failure for SMA0\n", driver_name);
		err = -1;
	}

	if(sma1_regs->start != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker start failure for SMA1\n", driver_name);
		err = -1;
	}

	if(bias_regs->start != OCCP_SUCCESS_RESULT) {
		printk(KERN_ERR "%s: ERROR: probe(): OpenCPI worker start failure for bias worker\n", driver_name);
		err = -1;
	}
	
	if(err) {
		dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, rx_dma_reg_va, rx_dma_reg_pa);
		dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, tx_dma_reg_va, tx_dma_reg_pa);
		iounmap(bar0_base_va);
		pci_release_region(pdev, BAR_0);
		pci_disable_device(pdev);	
		return err;
	}
    


	return err;
}


static void remove(struct pci_dev *pdev)
{
	PDEBUG("remove(): entering remove()\n");
	
	dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, rx_dma_reg_va, rx_dma_reg_pa);
	dma_free_coherent(&pdev->dev, DMA_REGION_SIZE, tx_dma_reg_va, tx_dma_reg_pa);
	iounmap(bar0_base_va);
	pci_release_region(pdev, BAR_0);
	pci_disable_device(pdev);	
}

static struct pci_driver pci_driver = {
	.name		= "nf10_eth_driver pci_driver",
	.id_table	= id_table,
	.probe		= probe,
	.remove		= remove,
};

/* Called to fill @buf when user reads our file in /proc. */
int read_proc(char *buf, char **start, off_t offset, int count, int *eof, void *data)
{
	unsigned int c;
	int i;
	
	c = sprintf(buf, "NetFPGA-10G Ethernet Driver\n-----------------------------\n");
	c += sprintf(&buf[c], "TX Flags:\n");	

	for(i=0; i<DMA_CPU_BUFS; i++)
		c += sprintf(&buf[c], "\t%d:\t0x%08x\n", i, tx_dma_stream.flags[i]);

	c += sprintf(&buf[c], "RX Flags:\n");
	
	for(i=0; i<DMA_CPU_BUFS; i++)
		c += sprintf(&buf[c], "\t%d:\t0x%08x\n", i, rx_dma_stream.flags[i]);
	

	*eof = 1;
	return c; 
}

void nf10_netdev_init(struct net_device *netdev)
{
	PDEBUG("nf10_netdev_init(): Initializing nf10_netdev\n");	
   
    ether_setup(netdev);

    netdev->netdev_ops = &nf10_netdev_ops;

    netdev->watchdog_timeo = 5 * HZ;
    
    /* FIXME: Need to pull real MAC address from hardware. */
    memcpy(netdev->dev_addr, "\0NET10", ETH_ALEN);
}

/* Initialization. */
static int __init nf10_eth_driver_init(void)
{
	int err;
	int i;	

	/* Register the pci_driver. */
	err = pci_register_driver(&pci_driver);
	if(err != 0) {
		printk(KERN_ERR "nf10_eth_driver: ERROR: nf10_eth_driver_init(): failed to register pci_driver\n");
		return err;
	}

    /* Allocate the network interfaces. */
    nf10_netdev = alloc_netdev(0, "nf%d", nf10_netdev_init);
    if(nf10_netdev == NULL) {
		printk(KERN_ERR "nf10_eth_driver: ERROR: nf10_eth_driver_init(): failed to allocate net_device\n");
		pci_unregister_driver(&pci_driver);
        return -ENOMEM;
    }
    
    /* Register the network interfaces. */
    err = register_netdev(nf10_netdev);
    if(err != 0) {
		printk(KERN_ERR "nf10_eth_driver: ERROR: nf10_eth_driver_init(): failed to register net_device\n");
		free_netdev(nf10_netdev);
        pci_unregister_driver(&pci_driver);
        return err;
    }

	/* Register our Generic Netlink family. */
	err = genl_register_family(&genl_family);
	if(err != 0) {
		printk(KERN_ERR "nf10_eth_driver: ERROR: nf10_eth_driver_init(): GENL family registration failed\n");
		unregister_netdev(nf10_netdev);
        free_netdev(nf10_netdev);
        pci_unregister_driver(&pci_driver);
		return err;
	}

	/* Register operations with our Generic Netlink family. */
	for(i = 0; i < ARRAY_SIZE(genl_all_ops); i++) {
		err = genl_register_ops(&genl_family, genl_all_ops[i]);
		if(err != 0) {
			genl_unregister_family(&genl_family);
		    unregister_netdev(nf10_netdev);
            free_netdev(nf10_netdev);
			pci_unregister_driver(&pci_driver);
			return err;
		}
	}

	/* FIXME: Do we need to check for error on create_proc_read_entry? */
	create_proc_read_entry("driver/nf10_eth_driver", 0, NULL, read_proc, NULL);

	printk(KERN_INFO "nf10_eth_driver: NetFPGA-10G Ethernet Driver Loaded.\n");
	
	return 0;
}

/* Deconstruction. */
static void __exit nf10_eth_driver_exit(void)
{
	int err;

	pci_unregister_driver(&pci_driver);

	err = genl_unregister_family(&genl_family);
	if(err != 0)
		printk(KERN_ERR "nf10_eth_driver: ERROR: nf10_eth_driver_exit(): failed to unregister GENL family\n");

	remove_proc_entry("driver/nf10_eth_driver", NULL);
	
	printk(KERN_INFO "nf10_eth_driver: NetFPGA-10G Ethernet Driver Unloaded.\n");
}

module_init(nf10_eth_driver_init);
module_exit(nf10_eth_driver_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Jonathan Ellithorpe");
MODULE_DESCRIPTION("A simple Ethernet driver for the NetFPGA-10G platform.");

