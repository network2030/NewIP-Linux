/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

// The parsing helper functions from the packet01 lesson have moved here
#include "../common/parsing_helpers.h"
#include "../common/rewrite_helpers.h"

/* Defines xdp_stats_map */
#include "../common/xdp_stats_kern_user.h"
#include "../common/xdp_stats_kern.h"

#include "newip.h"
#include <stdio.h>

#ifndef memcpy
#define memcpy(dest, src, n) __builtin_memcpy((dest), (src), (n))
#endif

struct bpf_map_def SEC("maps") tx_port = {
	.type = BPF_MAP_TYPE_DEVMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 256,
};

#define AF_INET 2
#define AF_INET6 10
#define IPV6_FLOWINFO_MASK bpf_htonl(0x0FFFFFFF)

#define ETH_P_NEWIP 0x88b6

/* Solution to packet03/assignment-4 */
SEC("xdp_router")
int xdp_router_func(struct xdp_md *ctx)
{
	struct meta_info *meta;
	int ret;

	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(*meta));
	if (ret < 0){
		return XDP_ABORTED;
	}

	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct bpf_fib_lookup fib_params = {};
	struct ethhdr *eth = data;
	struct newiphdr *newiph;
	__u16 h_proto;
	__u64 nh_off;
	int rc;
	int action = XDP_PASS;

	nh_off = sizeof(*eth);
	if (data + nh_off > data_end)
	{
		action = XDP_DROP;
		goto out;
	}

	h_proto = eth->h_proto;
	if (h_proto == bpf_htons(ETH_P_NEWIP))
	{
		newiph = data + nh_off;
		if (newiph + 1 > data_end)
		{
			action = XDP_DROP;
			goto out;
		}

		fib_params.family = AF_INET;
		fib_params.tot_len = sizeof(*newiph);
		fib_params.ipv4_src = newiph->src;
		fib_params.ipv4_dst = newiph->dst;
	}
	else
	{
		goto out;
	}

	fib_params.ifindex = ctx->ingress_ifindex;

	rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params), 0);
	switch (rc)
	{
	case BPF_FIB_LKUP_RET_SUCCESS: /* lookup successful */
		/* Only New-IP packets will reach this point */
		memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
		memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
		action = bpf_redirect_map(&tx_port, fib_params.ifindex, 0);
		meta = (void *)(unsigned long)ctx->data_meta;
		if(meta + 1 > data){
			return XDP_ABORTED;
		}
		meta->ifindex = fib_params.ifindex;
		action = XDP_PASS;
		break;
	case BPF_FIB_LKUP_RET_BLACKHOLE:   /* dest is blackholed; can be dropped */
	case BPF_FIB_LKUP_RET_UNREACHABLE: /* dest is unreachable; can be dropped */
	case BPF_FIB_LKUP_RET_PROHIBIT:	   /* dest not allowed; can be dropped */
		action = XDP_DROP;
		break;
	case BPF_FIB_LKUP_RET_NOT_FWDED:	/* packet is not forwarded */
	case BPF_FIB_LKUP_RET_FWD_DISABLED: /* fwding is not enabled on ingress */
	case BPF_FIB_LKUP_RET_UNSUPP_LWT:	/* fwd requires encapsulation */
	case BPF_FIB_LKUP_RET_NO_NEIGH:		/* no neighbor entry for nh */
	case BPF_FIB_LKUP_RET_FRAG_NEEDED:	/* fragmentation required to fwd */
		/* PASS */
		break;
	}

out:
	return xdp_stats_record_action(ctx, action);
}

SEC("xdp_pass")
int xdp_pass_func(struct xdp_md *ctx)
{
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
