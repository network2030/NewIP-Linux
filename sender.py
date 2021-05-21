from scapy.all import *
from newip_hdr import ShippingSpec, NewIPOffset, MaxDelayForwarding
from nest.routing.routing_helper import RoutingHelper


class sender:
    def __init__(self):
        conf.route.resync()
        conf.route6.resync()
        self.contracts = None

    def make_packet(self, src_addr_type, src_addr, dst_addr_type, dst_addr, content):
        self.content = content
        # self.pkt = ShippingSpec(src_addr_type=src_addr_type, src=src_addr,
        #                         dst_addr_type=dst_addr_type, dst=dst_addr)
        self.ship = ShippingSpec(src_addr_type=src_addr_type, src=src_addr,
                                 dst_addr_type=dst_addr_type, dst=dst_addr)

    def insert_contract(self, contract_type, params):
        if self.contracts is None:
            # params['max_allowed_delay']
            if contract_type == 'max_delay_forwarding':
                if params == []:
                    params = [500]
                self.contracts = MaxDelayForwarding(
                    max_allowed_delay=params[0])
        else:
            if contract_type == 'max_delay_forwarding':
                if params == []:
                    params = [500]
                self.contracts = self.contracts / \
                    MaxDelayForwarding(max_allowed_delay=params[0])

    def send_packet(self, iface, show_pkt=False):
        self.offset = NewIPOffset()
        self.eth = Ether()
        # Create packet
        if self.contracts is None:
            self.pkt = self.eth/self.offset/self.ship/self.content
        else:
            self.pkt = self.eth/self.offset/self.ship/self.contracts/self.content
        # Update offsets
        self.pkt[NewIPOffset].shipping_offset = len(self.offset)
        self.pkt[NewIPOffset].contract_offset = self.pkt[NewIPOffset].shipping_offset + \
            len(self.ship)
        if self.contracts is None:
            self.pkt[NewIPOffset].payload_offset = self.pkt[NewIPOffset].contract_offset
        else:
            self.pkt[NewIPOffset].payload_offset = self.pkt[NewIPOffset].contract_offset + \
                len(self.contracts)
        # Populate src mac
        self.pkt[Ether].src = get_if_hwaddr(iface)
        # Populate dst mac
        gw = None
        if self.pkt[ShippingSpec].dst_addr_type == 0:
            gw = conf.route.route(self.pkt[ShippingSpec].dst)
        elif self.pkt[ShippingSpec].dst_addr_type == 1:
            gw = conf.route6.route(self.pkt[ShippingSpec].dst)
        if self.pkt[ShippingSpec].dst_addr_type == 0:
            self.pkt[Ether].dst = getmacbyip(gw[2])
        elif self.pkt[ShippingSpec].dst_addr_type == 1:
            self.pkt[Ether].dst = getmacbyip6(gw[2])

        if show_pkt:
            self.show_packet()
        sendp(self.pkt, iface=iface, verbose=False)
        self.contracts = None

    def show_packet(self):
        print('='*40)
        print('at sender egress')
        print('-'*40)
        self.pkt.show()
        print('='*40)
        print()
