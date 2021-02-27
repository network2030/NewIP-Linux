from scapy.all import *
from newip_hdr import NewIP
from nest.routing.routing_helper import RoutingHelper
# import pprint

class router:
    @staticmethod
    def process_pkt(pkt):
        gw = conf.route.route(pkt[NewIP].dst)
        pkt[Ether].src = get_if_hwaddr(gw[0])
        if gw[2] == '0.0.0.0':
            pkt[Ether].dst = getmacbyip(pkt[NewIP].dst)
        else:
            pkt[Ether].dst = getmacbyip(gw[2])
        print('='*40)
        print('at router egress')
        print('-'*40)
        pkt.show()
        print('='*40)
        print()
        sendp(pkt, iface=gw[0], verbose=False)

    def __init__(self):
        # self.pp = pprint.PrettyPrinter(indent=4)
        conf.route.resync()

    def start(self, iface):
        pkts = sniff(iface=iface, filter='ether proto 0x88b6 and inbound', prn=lambda x: self.process_pkt(x), timeout=5, store=0)
