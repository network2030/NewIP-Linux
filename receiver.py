from scapy.all import *
from newip_hdr import NewIP
from nest.routing.routing_helper import RoutingHelper
# import pprint

class receiver:
    @staticmethod
    def process_pkt(pkt):
        print(pkt[NewIP].payload)
        print(pkt[Raw].load)

    def __init__(self):
        # self.pp = pprint.PrettyPrinter(indent=4)
        conf.route.resync()
        conf.sniff_promisc = 0
        
    def start (self, iface):
        pkts = sniff(iface=iface, filter='ether proto 0x88b6 and inbound', prn=lambda x: self.process_pkt(x), timeout=5)
