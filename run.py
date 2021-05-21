from nest.experiment import *
from nest.topology import *
from nest.routing.routing_helper import RoutingHelper
import nest.config as config

from scapy.all import *

import multiprocessing
import os
import subprocess

# from router import router
from receiver import receiver
from sender import sender

config.set_value('assign_random_names', False)
# config.set_value('delete_namespaces_on_termination', False)

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

# Verify no errors in xdp programs
if os.system('make -C xdp/newip_router/') != 0:
    exit()

# Create nodes

#h = host
h1 = Node('h1')
h2 = Node('h2')
h3 = Node('h3')
#r = router
r1 = Node('r1')
r2 = Node('r2')
r3 = Node('r3')

r1.enable_ip_forwarding()
r2.enable_ip_forwarding()
r3.enable_ip_forwarding()

# Create interfaces
(r1_h1, h1_r1) = connect(r1, h1, interface1_name='r1_h1', interface2_name='h1_r1')
(r2_h2, h2_r2) = connect(r2, h2, interface1_name='r2_h2', interface2_name='h2_r2')
(r3_h3, h3_r3) = connect(r3, h3, interface1_name='r3_h3', interface2_name='h3_r3')
(r1_r2, r2_r1) = connect(r1, r2, interface1_name='r1_r2', interface2_name='r2_r1')
(r1_r3, r3_r1) = connect(r1, r3, interface1_name='r1_r3', interface2_name='r3_r1')

# Set IPv4 Addresses
h1_r1.set_address('10.0.1.2/24')
r1_h1.set_address('10.0.1.1/24')
h2_r2.set_address('10.0.2.2/24')
r2_h2.set_address('10.0.2.1/24')
h3_r3.set_address('10.0.3.2/24')
r3_h3.set_address('10.0.3.1/24')
r1_r2.set_address('10.0.4.1/24')
r2_r1.set_address('10.0.4.2/24')
r1_r3.set_address('10.0.5.1/24')
r3_r1.set_address('10.0.5.2/24')

RoutingHelper(protocol='rip').populate_routing_tables()

# Set IPv6 Addresses
h1_r1.set_address('10::1:2/122')
r1_h1.set_address('10::1:1/122')
h2_r2.set_address('10::2:2/122')
r2_h2.set_address('10::2:1/122')
h3_r3.set_address('10::3:2/122')
r3_h3.set_address('10::3:1/122')
r1_r2.set_address('10::4:1/122')
r2_r1.set_address('10::4:2/122')
r1_r3.set_address('10::5:1/122')
r3_r1.set_address('10::5:2/122')

RoutingHelper(protocol='rip').populate_routing_tables()

# Create 'routing table' for 8bit address
static_redirect_8b = {
    'r1': {
        1: 'r1_h1',
        2: 'r1_r2',
        3: 'r1_r3',
    },
    'r2': {
        1: 'r2_r1',
        2: 'r2_h2',
        3: 'r2_r1',
    },
    'r3': {
        1: 'r3_r1',
        2: 'r3_r1',
        3: 'r3_h3',
    },
    'h1': {
        2: 'h1_r1',
        3: 'h1_r1',
    },
    'h2': {
        1: 'h2_r2',
        2: 'h2_r2',
    },
    'h3': {
        1: 'h3_r3',
        2: 'h3_r3',
    },
}


def router_proc(iface):
    router_obj = router()
    router_obj.start(iface=iface)


def receiver_proc(node, iface):
    receiver_obj = receiver(node)
    receiver_obj.start(iface=iface)


def sender_proc(node):
    # IPv4 to IPv4
    sender_obj = sender()
    sender_obj.make_packet(src_addr_type='ipv4', src_addr='10.0.1.2', dst_addr_type='ipv4',
                           dst_addr='10.0.2.2', content='ipv4 to ipv4 from h1 to h2')
    sender_obj.insert_contract(contract_type='max_delay_forwarding', params=[400])
    sender_obj.send_packet(iface='h1_r1', show_pkt=True)

    # IPv4 to IPv6
    # sender_obj.make_packet(src_addr_type='ipv4', src_addr='10.0.1.2',
    #                        dst_addr_type='ipv6', dst_addr='10::3:2', content='ipv4 to ipv6 from h1 to h3')
    # sender_obj.send_packet(iface='h1_r1')

    # # 8bit to 8bit
    # sender_obj.make_packet(src_addr_type='8bit', src_addr=0b1,
    #                        dst_addr_type='8bit', dst_addr=0b10, content='8bit to 8bit from h1 to h2')
    # sender_obj.send_packet(iface='h1_r1')

    # # 8bit to IPv4
    # sender_obj.make_packet(src_addr_type='8bit', src_addr=0b1,
    #                        dst_addr_type='ipv4', dst_addr='10.0.3.2', content='8bit to ipv4 from h1 to h3')
    # sender_obj.send_packet(iface='h1_r1')


def setup_router(node, interfaces):
    route = ''
    for key, value in static_redirect_8b[node.name].items():
        # TODO verify if extra '-' at end is ok
        route = route + str(key) + '_' + value + '-'
    with node:
        for interface in interfaces:
            os.system(
                './xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)
            os.system('sudo ./xdp/newip_router/xdp_prog_user --filename ' +
                      route + ' -d ' + interface.name)
            os.system('tc qdisc add dev ' + interface.name + ' ingress')
            os.system('tc filter add dev ' + interface.name +
                      ' ingress bpf da obj ./xdp/newip_router/tc_prog_kern.o sec tc_router')


def setup_host(node, interfaces):
    with node:
        for interface in interfaces:
            os.system(
                './xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)

# Setup xdp programs for bidirectional flow
# TODO discuss on showing or removing the output from xdp_loader and tc

setup_host(h1, [h1_r1])
setup_host(h2, [h2_r2])
setup_host(h3, [h3_r3])

setup_router(r1, [r1_h1, r1_r2, r1_r3])
setup_router(r2, [r2_h2, r2_r1])
setup_router(r3, [r3_h3, r3_r1])

with h2:
    receiver_process = multiprocessing.Process(
        target=receiver_proc, args=(h2, h2_r2,))
    receiver_process.start()
with h3:
    receiver_process = multiprocessing.Process(
        target=receiver_proc, args=(h3, h3_r3,))
    receiver_process.start()

# Ensure routers and receivers have started
time.sleep(1)

with h1:
    sender_process = multiprocessing.Process(
        target=sender_proc, args=(h1,))
    sender_process.start()
sender_process.join()
receiver_process.join()
# XDP programs end when namespaces are deleted

# with r1:
#     conf.route.resync()
#     conf.route6.resync()
#     print(conf.route)
#     print(conf.route6)