# Sending LBF contract packet with min delay as 500ms and max delay as 800ms

from New_IP.setup import setup
from New_IP.sender import sender
import os

setup_obj = setup()
setup_obj.setup_topology(buildLbf=False, routing="quagga")
setup_obj.start_receiver()

replay_file = "pcap/r1_h1.pcap"

# useful tcpreplay parameters
# --loop=x: loop through the pcap x times
# --pps=x: packets per sec
# --mbps=x: replay at given mbps
# --topspeed: replay as fast as possible
# --stats=number: print stats every 'number' seconds
# --limit=number: Limit the number of packets to send.
with setup_obj.h1:
    os.system(f"sudo tcpreplay --pps=100 -l 1 -i h1_r1 {replay_file}")
    # os.system('ping 10.0.2.2')


# setup_obj.show_stats()
