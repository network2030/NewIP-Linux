from scapy.all import *
from newip_hdr import NewIP
# from pyroute2 import IPRoute
from nest.routing.routing_helper import RoutingHelper
# import pprint

class sender:
    def __init__(self):
        # self.ipr = IPRoute()
        # self.pp = pprint.PrettyPrinter(indent=4)
        conf.route.resync()

    def make_packet(self, dst_addr_type, dst_addr, content):
        self.pkt = Ether()/NewIP(dst_addr_type=dst_addr_type, dst=dst_addr)/content

    def populate_hdrs(self):
        # routes = self.ipr.get_routes(dst=self.pkt[NewIP].dst)
        # self.pkt[NewIP].src = routes[0]['attrs'][3][1]

        # rta_prefsrc = routes[0]['attrs'][3][1]  # preferred source ip address
        # rta_oif = routes[0]['attrs'][2][1]  # output interface index
        # ip_neigh = self.ipr.neigh('dump')

        # dst_mac = None
        # for neigh in ip_neigh:
        #     if neigh['ifindex'] == rta_oif:
        #         dst_mac = neigh['attrs'][1][1]
        #         break
        # if(dst_mac == None):
        #     print('something went wrong')
        # self.pkt[Ether].dst = dst_mac
        # self.pkt[Ether].src = getmacbyip(rta_prefsrc)
        # print(rta_prefsrc)
        
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
