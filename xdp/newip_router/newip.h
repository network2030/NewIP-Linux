#include <linux/types.h>

struct newiphdr
{
    __u8 src_addr_type;
    __u8 dst_addr_type;
    __u8 addr_cast;
    __u8 dummy;
    __u32 src;
    __u32 dst;
};

struct meta_info
{
    __u32 ifindex;
    __u32 dummy;
};