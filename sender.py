from scapy.all import *
from newip_hdr import NewIP
from nest.routing.routing_helper import RoutingHelper


class sender:
    def __init__(self):
        conf.route.resync()
        conf.route6.resync()

    def make_packet(self, src_addr_type, src_addr, dst_addr_type, dst_addr, content):
        self.pkt = Ether()/NewIP(src_addr_type=src_addr_type, src=src_addr,
                                 dst_addr_type=dst_addr_type, dst=dst_addr)/content

    def send_packet(self, iface, show_pkt=False):
        #Populate src mac
        self.pkt[Ether].src = get_if_hwaddr(iface)
        #Populate dst mac
        gw = None
        if self.pkt[NewIP].dst_addr_type == 0:
            gw = conf.route.route(self.pkt[NewIP].dst)
        elif self.pkt[NewIP].dst_addr_type == 1:
            gw = conf.route6.route(self.pkt[NewIP].dst)
        if self.pkt[NewIP].dst_addr_type == 0:
            self.pkt[Ether].dst = getmacbyip(gw[2])
        elif self.pkt[NewIP].dst_addr_type == 1:
            self.pkt[Ether].dst = getmacbyip6(gw[2])

        if show_pkt:
            self.show_packet()
        sendp(self.pkt, iface=iface, verbose=False)

    def show_packet(self):
        print('='*40)
        print('at sender egress')
        print('-'*40)
        self.pkt.show()
        print('='*40)
        print()
