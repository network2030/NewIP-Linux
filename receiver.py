from tabnanny import verbose
from scapy.all import *
from newip_hdr import ShippingSpec, NewIPOffset, MaxDelayForwarding, LatencyBasedForwarding
from nest.routing.routing_helper import RoutingHelper

class receiver:

    @staticmethod
    def process_pkt(self, pkt):
        pass
        # print('Received Payload at ' + self.node.name + ' :')
        # if (self.verbose):
        #     print(pkt[Raw].load)

    def __init__(self, node, verbose = True):
        self.verbose = verbose
        conf.route.resync()
        conf.sniff_promisc = 0
        self.node = node
        
    def start (self, iface, timeout):
        pkts = sniff(iface=iface.name, filter='ether proto 0x88b6 and inbound', prn=lambda x: self.process_pkt(self, x), timeout=timeout)
        if (self.verbose):
            print('[INFO] ' + str(len(pkts)) + ' pkts received at ' + self.node.name)
        # Uncomment the line below to generate pcap files for receiver nodess
        # wrpcap('NewIP.pcap ' + str(self.node),pkts)