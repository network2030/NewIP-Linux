from scapy.all import *


class NewIPOffset(Packet):
    name = 'New IP Offset'
    fields_desc = [
        ByteField('shipping_offset', 4),
        ByteField('contract_offset', 0),
        ByteField('payload_offset', 0),
        ByteField('type', 0),
    ]

    def mysummary(self):
        return self.sprintf('NewIP %NewIP.type%')


class ShippingSpec(Packet):
    name = 'New IP Shipping Spec'
    sh_addr_type = {
        0: 'ipv4',
        1: 'ipv6',
        2: '8bit'
    }
    sh_addr_cast = {
        0: 'unicast',
        1: 'coordcast',
        2: 'multicast',
        3: 'broadcast',
        4: 'groupcast'
    }
    contract_type = {
        0: 'payload',
        1: 'contract'
    }
    fields_desc = [

        # Shipping spec
        ByteEnumField('src_addr_type', 0, sh_addr_type),  # Source Address Type
        # Destination Address Type
        ByteEnumField('dst_addr_type', 0, sh_addr_type),
        ByteEnumField('addr_cast', 0, sh_addr_cast),  # Address Cast
        ByteEnumField('type', 0, contract_type),  # Type of next Field
        MultipleTypeField(  # Source Address
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
        MultipleTypeField(  # Destination Address
            [
                # IPv4
                (IPField('dst', '127.0.0.1'), lambda pkt: pkt.dst_addr_type == 0),
                # IPv6
                (IP6Field('dst', '::1'), lambda pkt: pkt.dst_addr_type == 1),
                # 8bit
                (ByteField('dst', '0'), lambda pkt: pkt.dst_addr_type == 2),
            ],
            IPField('dst', '127.0.0.1')
        ),
        # Contract spec
    ]

    def mysummary(self):
        return self.sprintf('NewIP %NewIP.type%')

class MaxDelayForwarding(Packet):
    name = 'Max Delay Forwarding Contract'
    fields_desc=[
        ShortField('contract_type', 1),
        ShortField('max_allowed_delay', 500),
        ShortField('delay_exp', 0),
    ]
        
# bind_layers(Ether, NewIP, type=0x88b6)
bind_layers(Ether, NewIPOffset, type=0x88b6)
bind_layers(NewIPOffset, ShippingSpec, type=1)
bind_layers(ShippingSpec, MaxDelayForwarding, type=1)
