#include <linux/types.h>

struct newiphdr
{
    __u8 src_addr_type;
    __u8 dst_addr_type;
    __u8 addr_cast;
    __u8 dummy;
};
// src and dst are accessed outside the struct

struct meta_info
{
    __u32 ifindex;
    __u32 dummy;
};