from scapy.all import *
from newip_hdr import ShippingSpec, NewIPOffset, MaxDelayForwarding, LatencyBasedForwarding
from nest.routing.routing_helper import RoutingHelper

class receiver:

    @staticmethod
    def process_pkt(self, pkt):
        # print('Received Payload at ' + self.node.name + ' :')
        print(pkt[Raw].load)
        pass

    def __init__(self, node):
        conf.route.resync()
        conf.sniff_promisc = 0
        self.node = node
        
    def start (self, iface):
        pkts = sniff(iface=iface.name, filter='ether proto 0x88b6 and inbound', prn=lambda x: self.process_pkt(self, x), timeout=5)
        print('(probably lesser than actual) ' + str(len(pkts)) + 'pkts received at ' + self.node.name)
        # Uncomment the line below to generate pcap files for receiver nodess
        # wrpcap('NewIP.pcap ' + str(self.node),pkts)