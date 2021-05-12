from scapy.all import *

class NewIP(Packet):
    name = 'New IP'
    sh_addr_type={
        0: 'ipv4',
        1: 'ipv6',
        2: '8bit'
    }
    sh_addr_cast={
        1: 'unicast',
        2: 'coordcast',
        3: 'multicast',
        4: 'broadcast',
        5: 'groupcast'
    }
    fields_desc=[
        ByteEnumField('src_addr_type', 0, sh_addr_type), # Source Address Type
        ByteEnumField('dst_addr_type', 0, sh_addr_type), # Destination Address Type
        ByteEnumField('addr_cast', 1, sh_addr_cast), # Address Cast
        ByteEnumField('dummy', 1, sh_addr_cast), # Space holder
        MultipleTypeField(# Source Address
            [
                # IPv4
                (IPField('src', '127.0.0.1'), lambda pkt: pkt.src_addr_type == 0),
                # IPv6
                (IP6Field('src', '::1'), lambda pkt: pkt.src_addr_type == 1),
                # 8bit
                (ByteField('src', '0'), lambda pkt: pkt.src_addr_type == 2),
            ],
            IPField('src', '127.0.0.1')
        ),
        MultipleTypeField(# Destination Address
            [
                # IPv4
                (IPField('dst', '127.0.0.1'), lambda pkt: pkt.dst_addr_type == 0),
                # IPv6
                (IP6Field('dst', '::1'), lambda pkt: pkt.dst_addr_type == 1),
                # 8bit
                (ByteField('dst', '0'), lambda pkt: pkt.dst_addr_type == 2),
            ],
            IPField('dst', '127.0.0.1')
        )
    ]

    def mysummary(self):
        return self.sprintf('NewIP %NewIP.type%')


bind_layers(Ether, NewIP, type=0x88b6)
