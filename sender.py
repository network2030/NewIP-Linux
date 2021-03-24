from scapy.all import *
from newip_hdr import NewIP
from nest.routing.routing_helper import RoutingHelper

class sender:
    def __init__(self):
        conf.route.resync()

    def make_packet(self, dst_addr_type, dst_addr, content):
        self.pkt = Ether()/NewIP(dst_addr_type=dst_addr_type, dst=dst_addr)/content

    def populate_hdrs(self):        
        self.gw = conf.route.route(self.pkt[NewIP].dst)
        self.pkt[NewIP].src = self.gw[1]
        self.pkt[Ether].src = get_if_hwaddr(self.gw[0])
        self.pkt[Ether].dst = getmacbyip(self.gw[2])

    def send_packet(self):
        sendp(self.pkt, iface=self.gw[0], verbose=False)

    def show_packet(self):
        print('='*40)
        print('at sender egress')
        print('-'*40)
        self.pkt.show()
        print('='*40)
        print()
