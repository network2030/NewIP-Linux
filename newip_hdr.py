from scapy.all import *

class NewIP(Packet):
    name = 'New IP'
    sh_addr_type={
        1: 'ipv4',
        2: 'ipv6',
        3: 'other'
    }
    sh_addr_cast={
        1: 'unicast',
        2: 'coordcast',
        3: 'multicast',
        4: 'broadcast',
        5: 'groupcast'
    }
    fields_desc=[
        ByteEnumField('src_addr_type', 1, sh_addr_type),
        ByteEnumField('dst_addr_type', 1, sh_addr_type),
        ByteEnumField('addr_cast', 1, sh_addr_cast),
        ByteEnumField('dummy', 1, sh_addr_cast),
        IPField('src', '127.0.0.1'),
        IPField('dst', '127.0.0.1')
        # ConditionalField(SourceIPField('src', 'dst'), lambda pkt: pkt.src_addr_type == 1),
        # ConditionalField(DestIPField('dst', '127.0.0.1'), lambda pkt: pkt.dst_addr_type == 1),
        # ConditionalField(SourceIP6Field('src', 'dst'), lambda pkt: pkt.src_addr_type == 2),
        # ConditionalField(DestIP6Field('dst', '::1'), lambda pkt: pkt.dst_addr_type == 2)
    ]

    def mysummary(self):
        return self.sprintf("NewIP %NewIP.type%")


bind_layers(Ether, NewIP, type=0x88b6)
