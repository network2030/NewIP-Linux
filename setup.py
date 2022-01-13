from nest.experiment import *
from nest.topology import *
from nest.routing.routing_helper import RoutingHelper
import nest.config as config

from scapy.all import *

import multiprocessing
import os
import subprocess

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

# from router import router
from receiver import receiver
from sender import sender

def tcpdump_proc (interface, timeout):
    os.system (f'timeout {timeout} tcpdump -i ' + interface.name + ' -w ' + interface.name +'.pcap' + ' ether proto 0x88b6')

def receiver_proc(node, iface, timeout):
    receiver_obj = receiver(node)
    receiver_obj.start(iface=iface, timeout=timeout)

def setup_host(node, interfaces, pcap, timeout):
    with node:
        for interface in interfaces:
            os.system(
                './xdp/newip_router/xdp_loader --progsec xdp_pass --filename ./xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)
            os.system('tc qdisc replace dev ' + interface.name + ' root lbf')
            if pcap:
                tcpdump_process = multiprocessing.Process (target = tcpdump_proc, args=(interface,timeout,))
                tcpdump_process.start ()

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

def setup_router(node, interfaces, pcap, timeout):
    route = ''
    for key, value in static_redirect_8b[node.name].items():
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
            os.system('tc qdisc replace dev ' + interface.name + ' root lbf')
            if pcap:
                tcpdump_process = multiprocessing.Process (target = tcpdump_proc, args=(interface,timeout,))
                tcpdump_process.start ()

class setup:
    def __init__(self, timeout = 10):
        self.timeout = timeout

    def start_receiver (self):
        with self.h2:
            receiver_process = multiprocessing.Process(
                target=receiver_proc, args=(self.h2, self.h2_r2, self.timeout,))
            receiver_process.start()
        with self.h3:
            receiver_process = multiprocessing.Process(
                target=receiver_proc, args=(self.h3, self.h3_r3, self.timeout,))
            receiver_process.start()
        # Ensure routers and receivers have started
        time.sleep(1)


    def setup_topology(self, pcap = True, routing = "quagga", buildLbf = False):
        config.set_value('assign_random_names', False)
        # config.set_value('delete_namespaces_on_termination', False)
        # config.set_value("routing_logs", True)
        if routing == "quagga" or routing == "frr":
            config.set_value("routing_suite", routing)
        else :
            print ('routing suite not supported')
            exit()

        # Verify no errors in xdp programs
        if os.system('make -C xdp/newip_router/') != 0:
            exit()

        # Verify no errors in qdisc
        if (buildLbf or subprocess.Popen('lsmod | grep "sch_lbf"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()[0] == b''):
            if os.system('cd lbf; ./install-module') != 0: 
                exit()
            if os.system('cd lbf; ./install-tc-support') != 0: 
                exit()
        # Create nodes

        #h = host
        self.h1 = Node('h1')
        self.h2 = Node('h2')
        self.h3 = Node('h3')
        #r = router
        self.r1 = Router('r1')
        self.r2 = Router('r2')
        self.r3 = Router('r3')

        # Create interfaces
        (self.r1_h1, self.h1_r1) = connect(self.r1, self.h1, interface1_name='r1_h1', interface2_name='h1_r1')
        (self.r2_h2, self.h2_r2) = connect(self.r2, self.h2, interface1_name='r2_h2', interface2_name='h2_r2')
        (self.r3_h3, self.h3_r3) = connect(self.r3, self.h3, interface1_name='r3_h3', interface2_name='h3_r3')
        (self.r1_r2, self.r2_r1) = connect(self.r1, self.r2, interface1_name='r1_r2', interface2_name='r2_r1')
        (self.r1_r3, self.r3_r1) = connect(self.r1, self.r3, interface1_name='r1_r3', interface2_name='r3_r1')

        # Set IPv4 Addresses
        self.h1_r1.set_address('10.0.1.2/24')
        self.r1_h1.set_address('10.0.1.1/24')
        self.h2_r2.set_address('10.0.2.2/24')
        self.r2_h2.set_address('10.0.2.1/24')
        self.h3_r3.set_address('10.0.3.2/24')
        self.r3_h3.set_address('10.0.3.1/24')
        self.r1_r2.set_address('10.0.4.1/24')
        self.r2_r1.set_address('10.0.4.2/24')
        self.r1_r3.set_address('10.0.5.1/24')
        self.r3_r1.set_address('10.0.5.2/24')

        RoutingHelper(protocol='rip').populate_routing_tables()

        # Set IPv6 Addresses
        self.h1_r1.set_address('10::1:2/122')
        self.r1_h1.set_address('10::1:1/122')
        self.h2_r2.set_address('10::2:2/122')
        self.r2_h2.set_address('10::2:1/122')
        self.h3_r3.set_address('10::3:2/122')
        self.r3_h3.set_address('10::3:1/122')
        self.r1_r2.set_address('10::4:1/122')
        self.r2_r1.set_address('10::4:2/122')
        self.r1_r3.set_address('10::5:1/122')
        self.r3_r1.set_address('10::5:2/122')

        RoutingHelper(protocol='rip').populate_routing_tables()

        setup_host(self.h1, [self.h1_r1], pcap, self.timeout)
        setup_host(self.h2, [self.h2_r2], pcap, self.timeout)
        setup_host(self.h3, [self.h3_r3], pcap, self.timeout)
        setup_router(self.r1, [self.r1_h1, self.r1_r2, self.r1_r3], pcap, self.timeout)
        setup_router(self.r2, [self.r2_h2, self.r2_r1], pcap, self.timeout)
        setup_router(self.r3, [self.r3_h3, self.r3_r1], pcap, self.timeout)

    def show_stats (self):
        with self.h1:
            print('--h1--')
            os.system('tc -s qdisc show')
        with self.h2:
            print('--h2--')
            os.system('tc -s qdisc show')
        with self.h3:
            print('--h3--')
            os.system('tc -s qdisc show')
        with self.r1:
            print('--r1_r2--')
            os.system('tc -s qdisc show dev r1_r2')
            print('--r1_r3--')
            os.system('tc -s qdisc show dev r1_r3')
        with self.r2:
            print('--r2_h2--')
            os.system('tc -s qdisc show dev r2_h2')
        with self.r3:
            print('--r3_h3--')
            os.system('tc -s qdisc show dev r3_h3')