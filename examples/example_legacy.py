from New_IP.setup import Setup
from New_IP.sender import LegacyIpSender

setup_obj = Setup()
setup_obj.setup_topology()
setup_obj.start_receiver()

with setup_obj.h1:
    sender_obj = LegacyIpSender()

    # IPv4 to IPv6
    sender_obj.make_packet(
        src_addr="10.0.1.2",
        dst_addr="10.0.2.2",
        content="Legacy IP packet",
    )
    sender_obj.send_packet(iface="h1_r1", show_pkt=True)