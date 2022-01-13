from setup import setup
from sender import sender
import os

setup_obj = setup(timeout=2)
setup_obj.setup_topology (pcap=True,routing='quagga')
setup_obj.start_receiver ()

with setup_obj.h1:
    sender_obj = sender()
    # os.system ("ping 10.0.2.2")
    delay = 500
    
    # IPv4 to IPv6
    sender_obj.make_packet(src_addr_type='ipv4', src_addr='10.0.1.2',
                        dst_addr_type='ipv4', dst_addr='10.0.2.2', content='ipv4 to ipv4 from h1 to h2')
    sender_obj.send_packet(iface='h1_r1', show_pkt=True)

setup_obj.show_stats()