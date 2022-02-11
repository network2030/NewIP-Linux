import argparse
import random
import string
import time
import os
from setup import setup
from sender import sender
from datetime import datetime

class lbfObj:
    def __init__(self, min_delay, max_delay, hops):
        #define main variables you want to store and use
        self.c_min_delay = int(min_delay)
        self.c_max_delay = int(max_delay)
        self.hops      = int(hops)
        self.fib_delay = 0

    def get(self):
        return [self.c_min_delay, self.c_max_delay, 0, self.hops]

    def set(self, min_delay, max_delay, hops):
        self.c_min_delay = int(min_delay)
        self.c_max_delay = int(max_delay)
        self.hops      = int(hops)

class lbf_forwarder:
    #define start of forwarder. the interval and pkt count.
    def __init__(self, min_delay = 50, max_delay = 60):
        self.min_delay = min_delay
        self.max_delay = max_delay
        self.set_args()
        self.parse_args()
        self.netObj = setup()
        self.netObj.setup_topology ()
        # set LBF. Hops are specific to topology. user dont set it
        self.hops = self.netObj.info_dict[self.src]['hops'][self.dst]

        self.srcNode = self.netObj.info_dict[self.src]['node']
        self.dstNode = self.netObj.info_dict[self.dst]['node']
        self.srcIf = self.srcNode._interfaces[0].name
        recVerbose = True
        self.pcapDirName = str(datetime.now()).replace(" ","-")
        if (self.useTcpReplay):
            self.netObj.generate_pcap (timeout=self.timeout, nodelist=[self.srcNode], dir_name=self.pcapDirName)
            recVerbose = False
        else :
            if (self.pcapAll):
                self.netObj.generate_pcap(timeout=self.timeout, dir_name=self.pcapDirName)
            elif (self.pcapDst):
                self.netObj.generate_pcap (timeout=self.timeout, nodelist=[self.dstNode], dir_name=self.pcapDirName)
            elif (self.pcapInterfaceList):
                self.netObj.generate_pcap (timeout=self.timeout, interfaces=self.pcapInterfaceList, dir_name=self.pcapDirName)
            elif (self.pcapNodeList):
                self.netObj.generate_pcap (timeout=self.timeout, nodelist=self.pcapNodeList, dir_name=self.pcapDirName)
        
        self.netObj.start_receiver (timeout=self.timeout, nodeList=[self.dstNode], verbose=recVerbose)

        self.start_forwarder()

        if (self.useTcpReplay):
            self.replay()

    def set_args(self):
        self.parser = argparse.ArgumentParser()
        # Add long and short argument
        # example -i h1_r1 -st 8b -dt 8b -da h1 -sa h3 -s 30  -c 10
        # self.parser.add_argument("--interface", "-i", required=True,
        #                     help="set source address type")               Not required as we are specifying the src host and we only have 1 interface
        self.parser.add_argument("--src-type", "-st",
                            choices={'8bit','ipv4', 'ipv6'},
                            default='ipv4',
                            help="set source address type")
        self.parser.add_argument("--src",      "-sa",
                            choices={'h1','h2', 'h3'},
                            default='h1',
                            help="set source host")
        self.parser.add_argument("--dst-type", "-dt",
                            choices={'8bit','ipv4', 'ipv6'},
                            default='ipv4',
                            help="set dst address type")
        self.parser.add_argument("--dst",      "-da",
                            choices={'h1','h2', 'h3'},
                            default='h2',
                            help="set destination host")
        self.parser.add_argument("--lbf-contract",    "-lbf",   action='store', nargs="*",
                            help="Use lbf contract with min and max delay. usage -lbf min_delay max_delay")
        self.parser.add_argument("--timeout",     "-t",   type=int,
                            default = 5,
                            help="timeout for receiver and pcap capture")
        self.parser.add_argument("--show-packet",     "-sp", action='store_true',
                            default = False,
                            help="Show Packet")
        self.parser.add_argument("--pkt-count",    "-c",   type=int,
                            default=1,
                            help="number of pkts to send")
        self.parser.add_argument("--pkt-size",     "-s",   type=int,
                            default = 100,
                            help="pkt size")
        
        self.parser.add_argument("--pcap-all",    "-pa",   action='store_true',
                            default=False,
                            help="Capture pcap for all nodes")
        self.parser.add_argument("--pcap-dst",    "-pd",   action='store_true',
                            default=False,
                            help="Capture pcap for dst node")
        self.parser.add_argument("--pcap-interface-list",    "-pil",   action='append',
                            default=None,
                            help="Capture packets on this list of interface")
        self.parser.add_argument("--pcap-node-list",    "-pnl",   action='append',
                            default=None,
                            help="Capture packets on this list of nodes")
        
        self.parser.add_argument("--tcp-replay",    "-tr",   action='store_true',
                            default=False,
                            help="Use tcp-replay to send the packets")
        # self.parser.add_argument("--limit",    "-lmt",   type=int,
        #                     default=100000,
        #                     help="limit the number of packets to be sent, use with --tcp-replay=true")
        self.parser.add_argument("--loop",    "-l",   type=int,
                            default=1,
                            help="loop through the pcap file, use with --tcp-replay=true")
        
        self.group = self.parser.add_mutually_exclusive_group()
        self.group.add_argument("--packets-per-sec",    "-pps",   type=int,
                            default=100,
                            help="send given number of packets per second, use with --tcp-replay=true")
        self.group.add_argument("--Mbps",    "-mbps",   type=int,
                            default=0,
                            help="send at the specified rate in Mbps, use with --tcp-replay=true")
        self.group.add_argument("--topspeed",    "-ts",   action='store_true',
                            default=False,
                            help="send at the maximum rate, use with --tcp-replay=true")
            
        self.parser.add_argument("--statistics",    "-stats",   type=int,
                            default=10,
                            help="print stats after every given second, use with --tcp-replay=true")

    def parse_args(self):
        # Read arguments from the command line
        args = self.parser.parse_args()

        self.src_addr_type = args.src_type
        self.dst_addr_type = args.dst_type
        self.src = args.src
        self.dst = args.dst
        if args.lbf_contract is not None and len(args.lbf_contract) not in (0, 2):
            self.parser.error('Either give no values for contract, or two, not {}.'.format(len(args.lbf_contract)))
        self.lbfList = args.lbf_contract
        self.timeout = args.timeout
        self.showPacket = args.show_packet
        self.pktCount = args.pkt_count
        self.pktSize = args.pkt_size

        self.pcapAll = args.pcap_all
        self.pcapDst = args.pcap_dst
        self.pcapNodeList = args.pcap_node_list
        self.pcapInterfaceList = args.pcap_interface_list

        self.useTcpReplay = args.tcp_replay
        # self.trLimit = args.limit
        self.trLoop = args.loop
        self.trPps = args.packets_per_sec
        self.trMbps = args.Mbps
        self.trTopspeed = args.topspeed
        self.trStats = args.statistics
        
        self.size = args.pkt_size
        self.count = args.pkt_count

        #print("Set src-type to %s" % args.src_type)
        #print("Set dst-type to %s" % args.dst_type)
        #print("Set src to %s" % args.src)
        #print("Set dst to %s" % args.dst)
        #print("Set size to %d" % args.pkt_size)
        #print("Set cnt to %d" % args.pkt_count)

        # TODO: rename setup_obj to active_topo
        
    # do it once. calling random over and over is waste of time.
    def pkt_fill(self):
        START = 'pkt# %d ' % (self.pktCount)
        remaining = self.pktSize - len(START)
        chars=string.ascii_uppercase + string.digits
        return START + ''.join(random.choice(chars) for _ in range(remaining))



    def create_lbf_pkt (self):

        content = self.pkt_fill()
        self.sender.make_packet(self.src_addr_type, self.src_addr,
                               self.dst_addr_type, self.dst_addr, content)
        if (self.lbfList != None):
            self.lbfObj = lbfObj(self.min_delay, self.max_delay, self.hops)

            if (self.lbfList != []):
                self.lbfObj.set (self.lbfList[0], self.lbfList[1], self.hops)

            params = self.lbfObj.get()
            self.sender.insert_contract('latency_based_forwarding', params)
 

    def start_forwarder (self):
        # pkt_fill(self.count, self.size):      // TODO check this
        self.src_addr = self.netObj.info_dict[self.src][self.src_addr_type]
        self.dst_addr = self.netObj.info_dict[self.dst][self.dst_addr_type]
        self.sender = sender ()
        self.create_lbf_pkt () 
        with self.srcNode:
            if self.useTcpReplay:
                os.system (f'tc qdisc replace dev {self.srcIf} root pfifo')
            self.sender.send_packet(iface=self.srcIf, show_pkt=self.showPacket)

    def replay (self):
        print("waiting for receiver processes to end...")
        time.sleep(self.timeout)
        os.system (f'cp {self.pcapDirName}/{self.srcIf}.pcap {self.pcapDirName}/replay.pcap')
        with self.srcNode:
            os.system (f'tc qdisc replace dev {self.srcIf} root lbf') 
        self.netObj.start_receiver (timeout=self.timeout, nodeList=[self.dstNode])

        if (self.pcapAll):
            self.netObj.generate_pcap(timeout=self.timeout, dir_name=self.pcapDirName)
        elif (self.pcapDst):
            self.netObj.generate_pcap (timeout=self.timeout, nodelist=[self.dstNode], dir_name=self.pcapDirName)
        elif (self.pcapInterfaceList):
            self.netObj.generate_pcap (timeout=self.timeout, interfaces=self.pcapInterfaceList, dir_name=self.pcapDirName)
        elif (self.pcapNodeList):
            self.netObj.generate_pcap (timeout=self.timeout, nodelist=self.pcapNodeList, dir_name=self.pcapDirName)

        replayFile  = f'{self.pcapDirName}/replay.pcap'

        with self.srcNode:
            if (self.trTopspeed):
                os.system(f'sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --topspeed -i {self.srcIf} {replayFile} ')
            elif (self.trMbps):
                os.system(f'sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --Mbps={self.trMbps} -i {self.srcIf} {replayFile} ')
            else:
                os.system(f'sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --pps={self.trPps} -i {self.srcIf} {replayFile} ')


lbf_forwarder_obj = lbf_forwarder()
