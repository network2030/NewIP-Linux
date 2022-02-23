import time
from scapy.all import *
from New_IP.sender import Sender
from New_IP.newip_hdr import (
    ShippingSpec,
    NewIPOffset,
    Ping,
)


class Receiver:
    @staticmethod
    def process_pkt(self, pkt, iface):
        if pkt[NewIPOffset].contract_offset != pkt[NewIPOffset].payload_offset:
            # Contract exists
            ship_layer = ShippingSpec(pkt[Raw].load)
            ship_payload = ship_layer[Raw].load
            # Check the type of contract
            if bytes(ship_payload)[:2] == b"\x00\x03":
                ping_contract = Ping(ship_payload)
                if ping_contract[Ping].code == 0:
                    # Ping request packet

                    # Get the sending timestamp
                    snder_ts = ping_contract[Ping].timestamp

                    # Send a response back
                    pong_sender = Sender()
                    pong_sender.make_packet(
                        src_addr_type=ship_layer.dst_addr_type,
                        src_addr=ship_layer.dst,
                        dst_addr_type=ship_layer.src_addr_type,
                        dst_addr=ship_layer.src,
                        content="PONG",
                    )
                    pong_sender.insert_contract("ping_contract", params=[1, snder_ts])
                    pong_sender.send_packet(iface=iface)
                else:
                    # Received a Ping reply
                    rtt = round(
                        time.time_ns() // 1000000 - ping_contract[Ping].timestamp, 4
                    )
                    print(
                        f"PING reply from {ship_layer.src} time={rtt}ms ttl={ping_contract[Ping].hops}"
                    )

        # print('Received Payload at ' + self.node.name + ' :')
        # if (self.verbose):
        #     print(pkt[Raw].load)

    def __init__(self, node, verbose=True):
        self.verbose = verbose
        conf.route.resync()
        conf.sniff_promisc = 0
        self.node = node

    def start(self, iface, timeout=20):
        if not isinstance(iface, str):
            iface = iface.name

        pkts = sniff(
            iface=iface,
            filter="ether proto 0x88b6 and inbound",
            prn=lambda x: self.process_pkt(self, x, iface),
            timeout=timeout,
        )
        if self.verbose:
            print("[INFO] " + str(len(pkts)) + " pkts received at " + self.node.name)
