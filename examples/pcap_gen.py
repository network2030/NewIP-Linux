# Sending LBF contract packet with min delay as 500ms and max delay as 800ms

from New_IP.setup import setup
from New_IP.sender import sender
import os
import time

receiver_timeout = 8
setup_obj = setup(timeout=receiver_timeout)
setup_obj.setup_topology(pcap=True, buildLbf=False, routing="quagga")
setup_obj.start_receiver()
sender_obj = sender()
with setup_obj.h1:
    # Wireshark will capture packets after it has passed through the qdisc at h1
    # After passing through the qdisc, parameters will get changed
    # To avoid changing the parameters we dont use LBF qdisc for generating the packets
    os.system("tc qdisc replace dev h1_r1 root pfifo")
    for i in range(0, 90, 9):

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv6",
            dst_addr="10::2:2",
            content=f"5--6 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 6, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)

        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv6",
            dst_addr="10::2:2",
            content=f"5--8 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 8, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv6",
            dst_addr="10::2:2",
            content=f"5--10 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 10, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        # ipv4 to ipv4
        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv4",
            dst_addr="10.0.2.2",
            content=f"5--6 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 6, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv4",
            dst_addr="10.0.2.2",
            content=f"5--8 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 8, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="ipv4",
            dst_addr="10.0.2.2",
            content=f"5--10 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 10, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        # ipv4 to 8bit
        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="8bit",
            dst_addr=0b10,
            content=f"5--6 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 6, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="8bit",
            dst_addr=0b10,
            content=f"5--8 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 8, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)
        i += 1

        sender_obj.make_packet(
            src_addr_type="ipv4",
            src_addr="10.0.1.2",
            dst_addr_type="8bit",
            dst_addr=0b10,
            content=f"5--10 number: {i}",
        )
        sender_obj.insert_contract(
            contract_type="latency_based_forwarding", params=[5, 10, 0, 3]
        )  # min_delay, max_delay, fib_todelay, fib_tohops
        sender_obj.send_packet(iface="h1_r1", show_pkt=False)

# rename h1_r1.pcap to avoid overwriting while generating pcap during pcap replay
print(f"waiting for receiver to finish for {receiver_timeout}s")
time.sleep(receiver_timeout)
os.system("cp h1_r1.pcap replay.pcap")
