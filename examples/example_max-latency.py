# SPDX-License-Identifier: Apache-2.0-only
# Copyright (c) 2019-2022 @rohit-mp @bhaskar792 @deeptadevkota

# This program sends the LBF contract packet from h1 to h2
# with only max delay as 800ms
# The source address type is ipv4
# The destination address type is ipv6




# TOPOLOGY
#
#               r2 ---- h2
#              /
#             /
#   h1 ---- r1
#             \
#              \
#               r3 ---- h3
#
####


from New_IP.setup import Setup
from New_IP.sender import Sender
from New_IP.newip_hdr import LatencyBasedForwarding

setup_obj = Setup()
setup_obj.setup_topology()
setup_obj.start_receiver()

with setup_obj.h1:
    sender_obj = Sender()

    sender_obj.make_packet(
        src_addr_type="ipv4",
        src_addr="10.0.1.2",
        dst_addr_type="ipv6",
        dst_addr="10::2:2",
        content="ipv4 to ipv6 from h1 to h2 more latency",
    )
    # sender_obj.insert_contract(
    #     contract_type="latency_based_forwarding", params=[0, 800, 300, 3]
    # )  # min_delay, max_delay, fib_todelay, fib_tohops
    lbf_contract = LatencyBasedForwarding(min_delay = 0, max_delay = 800, fib_todelay = 0, fib_tohops = 3)
    sender_obj.set_contract ([lbf_contract])
    sender_obj.send_packet(iface="h1_r1", show_pkt=True)

# setup_obj.show_stats()
