from scapy.all import *
from newip_hdr import NewIP
from nest.routing.routing_helper import RoutingHelper

class sender:
    def __init__(self):
        conf.route.resync()
        conf.route6.resync()

    def make_packet(self, dst_addr_type, dst_addr, content, src_addr_type = None, src_addr = None):   
        if (src_addr_type and src_addr is not None):
            self.pkt = Ether()/NewIP(src_addr_type = src_addr_type, src = src_addr, dst_addr_type=dst_addr_type, dst=dst_addr)/content   
        elif (src_addr_type and src_addr is None):
            self.pkt = Ether()/NewIP(src_addr_type = src_addr_type, dst_addr_type=dst_addr_type, dst=dst_addr)/content
        else:
            self.pkt = Ether()/NewIP(dst_addr_type=dst_addr_type, dst=dst_addr)/content

    def populate_hdrs(self):        
        self.gw = None
        if self.pkt[NewIP].dst_addr_type == 0:
            self.gw = conf.route.route(self.pkt[NewIP].dst)

        elif self.pkt[NewIP].dst_addr_type == 1:
            self.gw = conf.route6.route(self.pkt[NewIP].dst)

        self.pkt[NewIP].src = self.gw[1]
        self.pkt[Ether].src = get_if_hwaddr(self.gw[0])

        if self.pkt[NewIP].dst_addr_type == 0:
            self.pkt[Ether].dst = getmacbyip(self.gw[2])
        elif self.pkt[NewIP].dst_addr_type == 1:
            self.pkt[Ether].dst = getmacbyip6(self.gw[2])

    def send_packet(self, interface = None):
        if (interface):
            sendp(self.pkt, iface=interface, verbose=False)
        else:
            sendp(self.pkt, iface=self.gw[0], verbose=False)
    def get_iface(self, dst):
        gw = conf.route.route(dst)
        return gw[0]
    def show_packet(self):
        print('='*40)
        print('at sender egress')
        print('-'*40)
        self.pkt.show()
        print('='*40)
        print()
