from nest.experiment import *
from nest.topology import *
from nest.routing.routing_helper import RoutingHelper
import nest.config as config

from scapy.all import *

import multiprocessing
import os
import subprocess

from New_IP.receiver import receiver

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

def tcpdump_proc (interface, timeout, dirName):
    os.system (f'timeout {timeout} tcpdump -i ' + interface.name + f' -w {dirName}/' + interface.name +'.pcap' + ' ether proto 0x88b6' + f' >>  {dirName}/tcpdump_logs.txt 2>&1')

def receiver_proc(node, iface, timeout, pkt_sender, verbose = True):
    receiver_obj = receiver(node, verbose)
    receiver_obj.start(iface=iface, timeout=timeout, pkt_sender=pkt_sender)

def setup_host(node, interfaces):
    with node:
        for interface in interfaces:
            os.system(
                '../xdp/newip_router/xdp_loader  --quiet --progsec xdp_pass --filename ../xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)
            os.system('tc qdisc replace dev ' + interface.name + ' root lbf')

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

def setup_router(node, interfaces):
    route = ''
    for key, value in static_redirect_8b[node.name].items():
        route = route + str(key) + '_' + value + '-'
    with node:
        for interface in interfaces:
            os.system(
                '../xdp/newip_router/xdp_loader --quiet --progsec xdp_router --filename ../xdp/newip_router/xdp_prog_kern.o --dev ' + interface.name)
            os.system('sudo ../xdp/newip_router/xdp_prog_user --quiet --filename ' +
                    route + ' -d ' + interface.name)
            os.system('tc qdisc add dev ' + interface.name + ' ingress')
            os.system('tc filter add dev ' + interface.name +
                    ' ingress bpf da obj ../xdp/newip_router/tc_prog_kern.o sec tc_router')
            os.system('tc qdisc replace dev ' + interface.name + ' root lbf')

class setup:
    def __init__(self):
        pass

    def start_receiver (self, timeout = 5, verbose = True, nodeList=[], pkt_sender=None):
        if not nodeList:
            nodeList = self.hostNodes
        for node in nodeList:
            for interface in node._interfaces:
                with node:
                    receiver_process = multiprocessing.Process(
                        target=receiver_proc, args=(node, interface, timeout, pkt_sender, verbose,))
                    receiver_process.start()

        # Ensure routers and receivers have started
        time.sleep(1)
    
    def generate_pcap (self, interfaces=[], timeout = 5, nodelist = [],dir_name = "pcap"):
        current_directory = os.getcwd()       
        final_directory = os.path.join(current_directory, dir_name)
        if os.path.exists(final_directory) == False:
            os.makedirs(final_directory, mode=0o777)
        if interfaces:
            nodelist = []
        nodes = self.nodes
        if nodelist:
            nodes = nodelist
        for node in nodes:
            with node:
                for interface in node._interfaces:
                    if((interface.name in interfaces) or not interfaces):
                        tcpdump_process = multiprocessing.Process (target = tcpdump_proc, args=(interface,timeout,dir_name))
                        tcpdump_process.start ()



    def setup_topology(self, routing = "quagga", buildLbf = False):
        config.set_value('assign_random_names', False)
        # config.set_value('delete_namespaces_on_termination', False)
        # config.set_value("routing_logs", True)
        if routing == "quagga" or routing == "frr":
            config.set_value("routing_suite", routing)
        else :
            print ('routing suite not supported')
            exit()

        # Verify no errors in xdp programs
        if os.system('make -C ../xdp/newip_router/') != 0:
            exit()

        # Verify no errors in qdisc
        if (buildLbf or subprocess.Popen('lsmod | grep "sch_lbf"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()[0] == b''):
            if os.system('cd ../lbf; ./install-module') != 0: 
                exit()
            if os.system('cd ../lbf; ./install-tc-support') != 0: 
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
        self.nodes = [self.h1, self.h2, self.h3, self.r1, self.r2, self.r3]
        self.hostNodes = [self.h1, self.h2, self.h3]
        self.routerNodes = [self.r1, self.r2, self.r3]

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

        setup_host(self.h1, [self.h1_r1])
        setup_host(self.h2, [self.h2_r2])
        setup_host(self.h3, [self.h3_r3])
        setup_router(self.r1, [self.r1_h1, self.r1_r2, self.r1_r3])
        setup_router(self.r2, [self.r2_h2, self.r2_r1])
        setup_router(self.r3, [self.r3_h3, self.r3_r1])

        # TODO automate building this dict
        self.info_dict = {
            'h1':
            {
                'ipv4': '10.0.1.2',
                'ipv6': '10::1:2',
                '8bit': 0b01,
                'hops': {
                    'h1': 0,
                    'h2': 3,
                    'h3': 3
                },
                'node': self.h1
            },
            'h2':
            {
                'ipv4': '10.0.2.2',
                'ipv6': '10::2:2',
                '8bit': 0b10,
                'hops': {
                    'h1': 3,
                    'h2': 0,
                    'h3': 4
                },
                'node': self.h2
            },
            'h3':
            {
                'ipv4': '10.0.3.2',
                'ipv6': '10::3:2',
                '8bit': 0b11,
                'hops': {
                    'h1': 3,
                    'h2': 4,
                    'h3': 0
                },
                'node': self.h3
            }
        }

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