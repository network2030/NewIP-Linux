from nest.experiment import *
from nest.topology import *
from nest.routing.routing_helper import RoutingHelper
import nest.config as config

from scapy.all import *
from newip_hdr import NewIP
# from pyroute2 import IPRoute

import multiprocessing
import os
import pprint
import subprocess
import time

from router import router
from receiver import receiver
from sender import sender

config.set_value('assign_random_names', False)
# config.set_value('delete_namespaces_on_termination', False)

# Topology
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

# Complete Topology
#
#                     r2 -- i3 -- h2
#                    /
#                  i2
#                 /
#   h1 -- i1 -- r1 
#                 \
#                  i4
#                    \
#                     r3 -- i5 -- h3
#
####

# Create nodes

#h = host
h1 = Node('h1')
h2 = Node('h2')
h3 = Node('h3')
#r = router
r1 = Node('r1')
r2 = Node('r2')
r3 = Node('r3')

#i = intermediate
i1 = Node('i1')
i2 = Node('i2')
i3 = Node('i3')
i4 = Node('i4')
i5 = Node('i5')

# Create interfaces

# (r1_h1, h1_r1) = connect(r1, h1, interface1_name='r1_h1', interface2_name='h1_r1')
# (r2_h2, h2_r2) = connect(r2, h2, interface1_name='r2_h2', interface2_name='h2_r2')
# (r3_h3, h3_r3) = connect(r3, h3, interface1_name='r3_h3', interface2_name='h3_r3')
# (r1_r2, r2_r1) = connect(r1, r2, interface1_name='r1_r2', interface2_name='r2_r1')
# (r1_r3, r3_r1) = connect(r1, r3, interface1_name='r1_r3', interface2_name='r3_r1')

(h1_i1, i1_h1) = connect(h1, i1, interface1_name='h1_i1', interface2_name='i1_h1')
(r1_i1, i1_r1) = connect(r1, i1, interface1_name='r1_i1', interface2_name='i1_r1')
(r1_i2, i2_r1) = connect(r1, i2, interface1_name='r1_i2', interface2_name='i2_r1')
(r2_i2, i2_r2) = connect(r2, i2, interface1_name='r2_i2', interface2_name='i2_r2')
(r2_i3, i3_r2) = connect(r2, i3, interface1_name='r2_i3', interface2_name='i3_r2')
(h2_i3, i3_h2) = connect(h2, i3, interface1_name='h2_i3', interface2_name='i3_h2')
(r1_i4, i4_r1) = connect(r1, i4, interface1_name='r1_i4', interface2_name='i4_r1')
(r3_i4, i4_r3) = connect(r3, i4, interface1_name='r3_i4', interface2_name='i4_r3')
(r3_i5, i5_r3) = connect(r3, i5, interface1_name='r3_i5', interface2_name='i5_r3')
(h3_i5, i5_h3) = connect(h3, i5, interface1_name='h3_i5', interface2_name='i5_h3')

# Set Addresses

# h1_r1.set_address('10.0.1.2/24')
# r1_h1.set_address('10.0.1.1/24')
# h2_r2.set_address('10.0.2.2/24')
# r2_h2.set_address('10.0.2.1/24')
# h3_r3.set_address('10.0.3.2/24')
# r3_h3.set_address('10.0.3.1/24')
# r1_r2.set_address('10.0.4.1/24')
# r2_r1.set_address('10.0.4.2/24')
# r1_r3.set_address('10.0.5.1/24')
# r3_r1.set_address('10.0.5.2/24')

h1_i1.set_address('10.0.1.2/24')
i1_h1.set_address('10.0.1.1/24')
h2_i3.set_address('10.0.2.2/24')
i3_h2.set_address('10.0.2.1/24')
h3_i5.set_address('10.0.3.2/24')
i5_h3.set_address('10.0.3.1/24')
i1_r1.set_address('10.0.4.1/24')
r1_i1.set_address('10.0.4.2/24')
i3_r2.set_address('10.0.5.1/24')
r2_i3.set_address('10.0.5.2/24')
i5_r3.set_address('10.0.6.1/24')
r3_i5.set_address('10.0.6.2/24')
i2_r2.set_address('10.0.7.1/24')
r2_i2.set_address('10.0.7.2/24')
i4_r3.set_address('10.0.8.1/24')
r3_i4.set_address('10.0.8.2/24')
i2_r1.set_address('10.0.9.1/24')
r1_i2.set_address('10.0.9.2/24')
i4_r1.set_address('10.0.10.1/24')
r1_i4.set_address('10.0.10.2/24')

r1.enable_ip_forwarding()
r2.enable_ip_forwarding()
r3.enable_ip_forwarding()
i1.enable_ip_forwarding()
i2.enable_ip_forwarding()
i3.enable_ip_forwarding()
i4.enable_ip_forwarding()
i5.enable_ip_forwarding()
RoutingHelper(protocol='rip').populate_routing_tables()

pp = pprint.PrettyPrinter(indent=4)

def router_proc(iface):
    router_obj = router()
    router_obj.start(iface=iface)

def receiver_proc(node_name, iface):
    receiver_obj = receiver(node_name)
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

# Verify no errors in xdp programs
if os.system('make -C xdp/newip_router/') != 0:
    exit()

# Setup xdp programs for bidirectional flow
#TODO discuss on showing or removing the output from xdp_loader
# with h1:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h1_r1')
# with h2:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h2_r2')
# with h3:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h3_r3')
# with r1:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_h1')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_h1')
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_r2')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_r2')
# with r2:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r2_r1')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r2_r1')
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r2_h2')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r2_h2')
# with r3:
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r3_r1')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r3_r1')
#     os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r3_h3')
#     os.system('sudo ./xdp/newip_router/xdp_prog_user -d r3_h3')

with h1:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h1_i1')
with h2:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h2_i3')
with h3:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h3_i5')
with r1:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_i1')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_i1')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_i2')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_i2')
with r2:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r2_i2')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r2_i2')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r2_i3')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r2_i3')
with r3:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r3_i4')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r3_i4')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r3_i5')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r3_i5')
with i1:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i1_h1')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i1_r1')
with i2:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i2_r1')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i2_r2')
with i3:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i3_r2')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i3_h2')
with i4:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i4_r1')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i4_r3')
with i5:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i5_r3')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev i5_h3')

# Setup tc qdisc and rules
# with r1:
#     os.system('tc qdisc add dev r1_h1 ingress')
#     os.system('tc filter add dev r1_h1 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev r1_r2')
# with r2:
#     os.system('tc qdisc add dev r2_r1 ingress')
#     os.system('tc filter add dev r2_r1 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev r2_h2')
with i1:
    os.system('tc qdisc add dev i1_h1 ingress')
    os.system('tc filter add dev i1_h1 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev i1_r1')
with i2:
    os.system('tc qdisc add dev i2_r1 ingress')
    os.system('tc filter add dev i2_r1 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev i2_r2')
with i3:
    os.system('tc qdisc add dev i3_r2 ingress')
    os.system('tc filter add dev i3_r2 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev i3_h2')
    os.system('tc qdisc replace dev i3_h2 root pie')
with i4:
    os.system('tc qdisc add dev i4_r1 ingress')
    os.system('tc filter add dev i4_r1 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev i4_r3')
with i5:
    os.system('tc qdisc add dev i5_r3 ingress')
    os.system('tc filter add dev i5_r3 parent ffff: protocol 0x88b6 matchall action mirred egress redirect dev i5_h3')

with h2:
    receiver_process = multiprocessing.Process(target=receiver_proc, args=('h2', 'h2_i3',))
    receiver_process.start()
with h3:
    receiver_process = multiprocessing.Process(target=receiver_proc, args=('h3', 'h3_i5',))
    receiver_process.start()

# Ensure routers and receivers have started
time.sleep(1)

with h1:
    sender_process = multiprocessing.Process(target=sender_proc)
    sender_process.start()

sender_process.join()
receiver_process.join()
# XDP programs end when namespaces are deleted