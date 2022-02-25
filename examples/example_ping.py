from New_IP.setup import Setup
from New_IP.sender import Sender
from New_IP.newip_hdr import Ping
import time

setup_obj = Setup()
setup_obj.setup_topology()
setup_obj.start_receiver()

with setup_obj.h1:
    sender_obj = Sender()
    sending_ts = time.time_ns() // 1000000
    ping_contract = Ping(code=0, timestamp=sending_ts)

    # IPv4 to IPv6
    sender_obj.make_packet(
        src_addr_type="ipv4",
        src_addr="10.0.1.2",
        dst_addr_type="ipv4",
        dst_addr="10.0.2.2",
        content="PING",
    )
    sender_obj.set_contract([ping_contract])
    sender_obj.send_packet(iface="h1_r1", show_pkt=True)