from setup import setup
from sender import sender

setup_obj = setup()
setup_obj.setup_topology (pcap=False)
setup_obj.start_receiver ()

with setup_obj.h1:
    sender_obj = sender()
    delay = 500
    
    sender_obj.make_packet(src_addr_type='ipv4', src_addr='10.0.1.2',
                            dst_addr_type='8bit', dst_addr=0b11, content='8bit to ipv4 from h1 to h3')
    sender_obj.send_packet(iface='h1_r1')

setup_obj.show_stats()