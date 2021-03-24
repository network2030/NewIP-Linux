from nest.experiment import *
from nest.topology import *
from nest.routing.routing_helper import RoutingHelper
import nest.config as config

from scapy.all import *
from newip_hdr import NewIP

import multiprocessing
import os
import subprocess

from router import router
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

# Create interfaces

(r1_h1, h1_r1) = connect(r1, h1, interface1_name='r1_h1', interface2_name='h1_r1')
(r2_h2, h2_r2) = connect(r2, h2, interface1_name='r2_h2', interface2_name='h2_r2')
(r3_h3, h3_r3) = connect(r3, h3, interface1_name='r3_h3', interface2_name='h3_r3')
(r1_r2, r2_r1) = connect(r1, r2, interface1_name='r1_r2', interface2_name='r2_r1')
(r1_r3, r3_r1) = connect(r1, r3, interface1_name='r1_r3', interface2_name='r3_r1')

# Set Addresses

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

r1.enable_ip_forwarding()
r2.enable_ip_forwarding()
r3.enable_ip_forwarding()
RoutingHelper(protocol='rip').populate_routing_tables()

def router_proc(iface):
    router_obj = router()
    router_obj.start(iface=iface)

def receiver_proc(node, iface):
    receiver_obj = receiver(node)
    receiver_obj.start(iface=iface)

#TODO setup better way of sending pkts
def sender_proc():
    sender_obj = sender()
    sender_obj.make_packet(dst_addr_type='ipv4', dst_addr='10.0.2.2', content='msg for h2')
    sender_obj.populate_hdrs()
    # sender_obj.show_packet()
    sender_obj.send_packet()
    sender_obj.make_packet(dst_addr_type='ipv4', dst_addr='10.0.3.2', content='msg for h3')
    sender_obj.populate_hdrs()
    # sender_obj.show_packet()
    sender_obj.send_packet()

def setup_router(node, interfaces):
    with node:
        for interface in interfaces:
            os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)
            os.system('sudo ./xdp/newip_router/xdp_prog_user -d ' + interface.name)
            os.system('tc qdisc add dev ' + interface.name + ' ingress')
            os.system('tc filter add dev ' + interface.name + ' ingress bpf da obj ./xdp/newip_router/tc_prog_kern.o sec tc_router')

def setup_host(node, interfaces):
    with node:
        for interface in interfaces:
            os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)

# Setup xdp programs for bidirectional flow
#TODO discuss on showing or removing the output from xdp_loader and tc

setup_host(h1, [h1_r1])
setup_host(h2, [h2_r2])
setup_host(h3, [h3_r3])

setup_router(r1, [r1_h1, r1_r2, r1_r3])
setup_router(r2, [r2_h2, r2_r1])
setup_router(r3, [r3_h3, r3_r1])

with h2:
    receiver_process = multiprocessing.Process(target=receiver_proc, args=(h2, h2_r2,))
    receiver_process.start()
with h3:
    receiver_process = multiprocessing.Process(target=receiver_proc, args=(h3, h3_r3,))

    receiver_process.start()

# Ensure routers and receivers have started
time.sleep(1)

with h1:
    sender_process = multiprocessing.Process(target=sender_proc)
    sender_process.start()

sender_process.join()
receiver_process.join()
# XDP programs end when namespaces are deleted