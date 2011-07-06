/* FIXME: Add proper comment headers. */
/* NOTE: This program utilizes the libnl-3.0 library for generic netlink functions.
 * You must install this library before compiling (http://www.infradead.org/~tgr/libnl/). */

/* Header files provided by libnl (probably in /usr/local/include). */
#include <netlink/netlink.h>
#include <netlink/genl/genl.h>
#include <netlink/genl/ctrl.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <getopt.h>

#include "nf10_eth_driver.h"

static int driver_connect(void);
static void driver_disconnect(void);

struct nl_sock *nf10_genl_sock;
int nf10_genl_family;

static int driver_connect()
{
    int err;

    nf10_genl_sock = nl_socket_alloc();
    if(nf10_genl_sock == NULL) {
        printf("nf10_reg_lib: ERROR: driver_connect(): could not allocate netlink socket\n");
        return -1;
    }

    err = genl_connect(nf10_genl_sock);
    if(err != 0) {
        printf("nf10_reg_lib: ERROR: driver_connect(): could not connect to driver over generic netlink socket\n");
        nl_socket_free(nf10_genl_sock);
        return err;
    }

    nf10_genl_family = genl_ctrl_resolve(nf10_genl_sock, NF10_GENL_FAMILY_NAME);
    if(nf10_genl_family < 0) {
        printf("nf10_reg_lib: ERROR: driver_connect(): could not resolve generic netlink family channel number\n");
        nl_socket_free(nf10_genl_sock);
        return -1;
    }

    return 0;
}

static void driver_disconnect()
{
    nl_socket_free(nf10_genl_sock);
}

static int nf10_reg_rd_recv_msg_cb(struct nl_msg *msg, void *arg)
{
    struct nlmsghdr *nlh;
    struct nlattr   *na;
    struct nlattr   *attrs[NF10_GENL_A_MAX + 1];
    uint32_t        val;

    nlh = nlmsg_hdr(msg);

    genlmsg_parse(nlh, 0, attrs, NF10_GENL_A_MAX, 0);

    na = attrs[NF10_GENL_A_REGVAL32];
    if(na) {
        if(nla_data(na) == NULL)
            printf("nf10_reg_lib: ERROR: nf10_reg_rd_recv_msg_cb(): got NULL REGVAL32 generic netlink attribute\n");
        else 
            return *(uint32_t*)nla_data(na);
    } else 
        printf("nf10_reg_lib: ERROR: nf10_reg_rd_recv_msg_cb(): driver didn't send back a register value\n");

    return -1;
}

uint32_t nf10_reg_rd(uint32_t addr)
{
    struct nl_msg   *msg;
    int err;   
    uint32_t val; 

    err = driver_connect();
    if(err != 0) {
        printf("nf10_reg_lib: ERROR: nf10_reg_rd(): failed to connect to the driver\n");
        return -1;
    }

    msg = nlmsg_alloc();
    if(msg == NULL) {
        printf("nf10_reg_lib: ERROR: nf10_reg_rd(): could not allocate new netlink message\n");
        driver_disconnect();
        return -1;
    }

    /* genlmsg_put will fill in the fields of the nlmsghdr and the genlmsghdr. */
    genlmsg_put(msg, NL_AUTO_PID, NL_AUTO_SEQ, nf10_genl_family, 0, 0,
            NF10_GENL_C_REG_RD, NF10_GENL_FAMILY_VERSION);

    nla_put_u32(msg, NF10_GENL_A_ADDR32, addr);

    /* nl_send_auto will automatically fill in the PID and the sequence number,
     * and also add an NLM_F_REQUEST flag. It will also add an NLM_F_ACK
     * flag unless the netlink socket has the NL_NO_AUTO_ACK flag set. */
    nl_send_auto(nf10_genl_sock, msg);

    nlmsg_free(msg);

    nl_socket_modify_cb(nf10_genl_sock, NL_CB_VALID, NL_CB_CUSTOM, nf10_reg_rd_recv_msg_cb, NULL);
    
    val = nl_recvmsgs_default(nf10_genl_sock);

    driver_disconnect();    

    return val;
}

static int nf10_reg_wr_recv_ack_cb(struct nl_msg *msg, void *arg)
{
    return 0;
}

int nf10_reg_wr(uint32_t addr, uint32_t val)
{
    struct nl_msg   *msg;
    int err;    

    err = driver_connect();
    if(err != 0) {
        printf("nf10_reg_lib: ERROR: nf10_reg_wr(): failed to connect to the driver\n");
        return err;
    }

    msg = nlmsg_alloc();
    if(msg == NULL) {
        printf("nf10_reg_lib: ERROR: nf10_reg_wr(): could not allocate new netlink message\n");
        driver_disconnect();
        return -1;
    }

    /* genlmsg_put will fill in the fields of the nlmsghdr and the genlmsghdr. */
    genlmsg_put(msg, NL_AUTO_PID, NL_AUTO_SEQ, nf10_genl_family, 0, 0,
            NF10_GENL_C_REG_WR, NF10_GENL_FAMILY_VERSION);

    nla_put_u32(msg, NF10_GENL_A_ADDR32, addr);
    nla_put_u32(msg, NF10_GENL_A_REGVAL32, val);

    /* nl_send_auto will automatically fill in the PID and the sequence number,
     * and also add an NLM_F_REQUEST flag. It will also add an NLM_F_ACK
     * flag unless the netlink socket has the NL_NO_AUTO_ACK flag set. */
    nl_send_auto(nf10_genl_sock, msg);

    nlmsg_free(msg);

    nl_socket_modify_cb(nf10_genl_sock, NL_CB_ACK, NL_CB_CUSTOM, nf10_reg_wr_recv_ack_cb, NULL);

    /* FIXME: this function will return even if there's no ACK in the buffer. I.E. it doesn't
     * seem to wait for the ACK to be received... Ideally we'd have the behavior that getting an 
     * ACK tells us everything is OK, otherwise we time out on waiting for an ACK and tell this
     * to the user. */
    nl_recvmsgs_default(nf10_genl_sock);

    driver_disconnect();    
}
