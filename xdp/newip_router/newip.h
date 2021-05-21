#include <linux/types.h>

struct newip_offset
{
    __u8 shipping_offset;
    __u8 contract_offset;
    __u8 payload_offset;
    __u8 type;
};

struct shipping_spec
{
    __u8 src_addr_type;
    __u8 dst_addr_type;
    __u8 addr_cast;
    __u8 type;
};
// src and dst are accessed outside the struct

struct max_delay_forwarding
{
    __u32 contract_type;
    __u32 max_allowed_delay;
    __u32 delay_exp;
};

struct meta_info
{
    __u32 ifindex;
    struct max_delay_forwarding contract;
};