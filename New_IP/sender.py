import time
from scapy.all import *
from New_IP.newip_hdr import LatencyBasedForwarding, ShippingSpec, NewIPOffset, MaxDelayForwarding, Ping
from enum import Enum 
from nest.engine import exec_subprocess

class NewIPAtype(Enum):
   NEWIP_V4  = 0
   NEWIP_V6  = 1
   NEWIP_8b  = 2
   NEWIP_16b = 3

class sender:
    def __init__(self):
        conf.route.resync()
        conf.route6.resync()
        self.contracts = None
        self.last_packet_ts = -1
        self.mac_broadcast = "ff:ff:ff:ff:ff:ff"
        self.mac_localhost = "00:00:00:00:00:00"

    def get_gw_mac(self, src_iface, dst, dst_addr_type):
        src_mac = None
        gw = None
        dst_mac = None

        src_mac = get_if_hwaddr(src_iface)
        if dst_addr_type == NewIPAtype.NEWIP_V4.value:
            gw = conf.route.route(dst)
            dst_mac = getmacbyip(gw[2])
        elif dst_addr_type == NewIPAtype.NEWIP_V6.value:
            gw = conf.route6.route(dst)
            dst_mac = getmacbyip6 (gw[2])

        # Fallback for populating mac address

        if (src_mac == self.mac_localhost or src_mac is None):
            get_src_mac_cmd = f"ip -o link | grep \"{src_iface}\" | awk '{{print $18}}'"
            src_mac = exec_subprocess(get_src_mac_cmd, output=True, shell=True)

        if (dst_mac == self.mac_broadcast or dst_mac is None):
            if dst_addr_type == NewIPAtype.NEWIP_V6:
                proto = "-6"
            else:
                proto = "-4"
            get_neighbor = f'ip {proto} neigh show default dev {src_iface}'
            value        = exec_subprocess(get_neighbor, output=True)
            dst_mac = value.split()[2]

        return src_mac, dst_mac

    def make_packet(self, src_addr_type, src_addr, dst_addr_type, dst_addr, content=""):
        self.content = content
        self.ship = ShippingSpec(src_addr_type=src_addr_type, src=src_addr,
                                 dst_addr_type=dst_addr_type, dst=dst_addr
                                 )

    def insert_contract(self, contract_type, params=[]):
        if self.contracts is None:
            # params['max_allowed_delay']
            if contract_type == 'max_delay_forwarding':
                if params == []:
                    params = [500]
                self.contracts = MaxDelayForwarding(
                    max_allowed_delay=params[0])
            elif contract_type == 'latency_based_forwarding':
                if params == []:
                    params = [0,0,0,0]
                self.contracts = LatencyBasedForwarding(
                    min_delay=params[0], max_delay = params[1], fib_todelay = params[2], fib_tohops = params[3])
            elif contract_type == 'ping_contract':
                ping_code = params[0] if params else 0
                self.contracts = Ping(code=ping_code)
        else:
            if contract_type == 'max_delay_forwarding':
                if params == []:
                    params = [500]
                self.contracts = self.contracts / \
                    MaxDelayForwarding(max_allowed_delay=params[0])
            elif contract_type == 'latency_based_forwarding':
                if params == []:
                    params = [0,0,0,0]
                self.contracts = self.contracts / \
                LatencyBasedForwarding(min_delay=params[0], max_delay = params[1], fib_todelay = params[2], fib_tohops = params[3])
            
            elif contract_type == 'ping_contract':
                ping_code = params[0] if params else 0
                self.contracts = self.contracts / Ping(code=ping_code)

    def send_packet(self, iface, show_pkt=False, count=1):
        self.offset = NewIPOffset()
        self.eth = Ether()
        # Create packet
        if self.contracts is None:
            self.pkt = self.eth/self.offset/self.ship/self.content
        else:
            self.pkt = self.eth/self.offset/self.ship/self.contracts/self.content
        # Update offsets
        self.pkt[NewIPOffset].shipping_offset = len(self.offset)
        if self.contracts:
            self.pkt[NewIPOffset].contract_offset = self.pkt[NewIPOffset].shipping_offset + \
            len(self.ship)
        else:
            self.pkt[NewIPOffset].contract_offset = 0
            # self.pkt[NewIPOffset].contract_offset = self.pkt[NewIPOffset].shipping_offset + \
            # len(self.ship)

        self.pkt[NewIPOffset].payload_offset = self.pkt[NewIPOffset].shipping_offset + \
            len(self.ship) + (len(self.contracts) if  self.contracts else 0)

        # Populate mac
        self.pkt[Ether].src, self.pkt[Ether].dst = self.get_gw_mac(iface, self.pkt[ShippingSpec].dst, self.pkt[ShippingSpec].dst_addr_type)

        if show_pkt:
            self.show_packet()

        self.last_packet_ts = time.time_ns()
        sendp(self.pkt, iface=iface, verbose=False, count=count)
        self.contracts = None


    def show_packet(self):
        print('='*40)
        print('at sender egress')
        print('-'*40)
        self.pkt.show()
        print('='*40)
        print()
