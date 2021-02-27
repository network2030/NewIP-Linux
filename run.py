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

# TOPOLOGY
#
#               h2
#              /
#             /
#   h1 ---- r1
#             \
#              \
#               h3
#
####

# Create nodes

#h = host
h1 = Node('h1')
h2 = Node('h2')
h3 = Node('h3')
#r = router
r1 = Node('r1')

# Create interfaces

(r1_h1, h1_r1) = connect(r1, h1, interface1_name='r1_h1', interface2_name='h1_r1')
(r1_h2, h2_r1) = connect(r1, h2, interface1_name='r1_h2', interface2_name='h2_r1')
(r1_h3, h3_r1) = connect(r1, h3, interface1_name='r1_h3', interface2_name='h3_r1')

# Set Addresses

h1_r1.set_address('10.0.1.2/24')
r1_h1.set_address('10.0.1.1/24')

h2_r1.set_address('10.0.2.2/24')
r1_h2.set_address('10.0.2.1/24')

h3_r1.set_address('10.0.3.2/24')
r1_h3.set_address('10.0.3.1/24')

# h3_r1.set_address('2001:db8:3333:4444:5555:6666:7777:8888')
# r1_h3.set_address('2001:db8:3333:4444:CCCC:DDDD:EEEE:FFFF')

r1.enable_ip_forwarding()
RoutingHelper(protocol='rip').populate_routing_tables()

pp = pprint.PrettyPrinter(indent=4)

def router_proc():
    router_obj = router()
    router_obj.start(iface='r1_h1')

def receiver_proc():
    receiver_obj = receiver()
    receiver_obj.start(iface='h2_r1')


def sender_proc():
    sender_obj = sender()
    sender_obj.make_packet(dst_addr_type='ipv4', dst_addr='10.0.2.2')
    sender_obj.populate_hdrs()
    sender_obj.show_packet()
    sender_obj.send_packet()

os.system('make -C xdp/newip_router/')
with h1:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h1_r1')
with h2:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev h2_r1')
with r1:
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_h1')
    os.system('./xdp/newip_router/xdp_loader --progsec xdp_router --filename ./xdp/newip_router/xdp_prog_kern.o --dev r1_h2')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_h1')
    os.system('sudo ./xdp/newip_router/xdp_prog_user -d r1_h2')

with h2:
    receiver_process = multiprocessing.Process(target=receiver_proc)
    receiver_process.start()

# with r1:
#     router_process = multiprocessing.Process(target=router_proc)
#     router_process.start()

# Ensure routers and receivers have started
time.sleep(1)

with h1:
    sender_process = multiprocessing.Process(target=sender_proc)
    sender_process.start()

sender_process.join()
# router_process.join()
receiver_process.join()