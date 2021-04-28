#include <linux/types.h>
#include <linux/in6.h>

struct newiphdrType
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