# SPDX-License-Identifier: Apache-2.0-only
# Copyright (c) 2019-2022 @kiranmak @rohit-mp @bhaskar792 @shashank68

# This program sends New-IP, LBF contract, Legacy IP or Ping contract packet
# from the source to the destination provider by the users
# by default it sends New-IP packet
# mixed flow traffic with multiple sender and receivers can be obtained
# by default the the src is h1 and dst is h2
# the default packet count is 1
# the default source and destination type is ipv4
 
 
 
 
 
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


import argparse
import random
import string
import time
import os
import multiprocessing
from New_IP.setup import Setup
from New_IP.sender import Sender, LegacyIpSender
from New_IP.newip_hdr import LatencyBasedForwarding, Ping
from datetime import datetime


class LbfObj:
    def __init__(self, min_delay, max_delay, hops):
        # define main variables you want to store and use
        self.c_min_delay = int(min_delay)
        self.c_max_delay = int(max_delay)
        self.hops = int(hops)
        self.fib_delay = 0

    def get_lbf_params(self):
        return [self.c_min_delay, self.c_max_delay, 0, self.hops]

    def set_lbf_params(self, min_delay, max_delay, hops):
        self.c_min_delay = int(min_delay)
        self.c_max_delay = int(max_delay)
        self.hops = int(hops)


class lbf_forwarder:
    # define start of forwarder. the interval and pkt count.
    def __init__(self, min_delay=50, max_delay=60):
        self.min_delay = min_delay
        self.max_delay = max_delay
        self.set_args()
        self.parse_args()
        self.netObj = Setup()
        self.netObj.setup_topology()
        self.srcNode = []
        for src in self.src:
            self.srcNode.append(self.netObj.info_dict[src]["node"])
        self.dstNode = []
        for dst in self.dst:
            self.dstNode.append(self.netObj.info_dict[dst]["node"])
        recVerbose = True
        if self.pcapAll or self.pcapDst or self.pcapInterfaceList or self.pcapNodeList or self.useTcpReplay:
            self.pcapDirName = datetime.now().strftime("%Y_%m_%d-%I:%M:%S_%p")
            try:
                os.remove("./latest")
            except OSError:
                pass
            os.symlink(self.pcapDirName, "./latest")
        if self.pcap == "":
            if self.useTcpReplay:
                self.netObj.generate_pcap(
                    timeout=self.timeout,
                    nodelist=self.srcNode,
                    dir_name=self.pcapDirName,
                )
                recVerbose = False
            else:
                self.gen_pcap()

            self.netObj.start_receiver(
                timeout=self.timeout, nodeList=self.dstNode, verbose=recVerbose
            )
            self.start_forwarder()

        if self.useTcpReplay:
            self.replay()

    def gen_pcap(self):
        if self.pcapAll:
            self.netObj.generate_pcap(
                        timeout=self.timeout, dir_name=self.pcapDirName
                    )
        elif self.pcapDst:
            self.netObj.generate_pcap(
                timeout=self.timeout,
                nodelist=self.dstNode,
                dir_name=self.pcapDirName,
            )
        elif self.pcapInterfaceList:
            self.netObj.generate_pcap(
                timeout=self.timeout,
                interfaces=self.pcapInterfaceList,
                dir_name=self.pcapDirName,
            )
        elif self.pcapNodeList:
            self.netObj.generate_pcap(
                timeout=self.timeout,
                nodelist=self.pcapNodeList,
                dir_name=self.pcapDirName,
            )

    def set_args(self):
        self.parser = argparse.ArgumentParser()
        # Add long and short argument
        # example -i h1_r1 -st 8b -dt 8b -da h1 -sa h3 -s 30  -c 10
        # self.parser.add_argument("--interface", "-i", required=True,
        #                     help="set source address type")               Not required as we are specifying the src host and we only have 1 interface
        self.parser.add_argument("--ping", "-p", action="store_true", default=False)
        self.parser.add_argument(
            "--src-type",
            "-st",
            nargs="+",
            default=["ipv4"],
            help="set source address types",
        )
        self.parser.add_argument(
            "--src",
            "-sa",
            nargs="+",
            default=["h1"],
            help="set source hosts",
        )
        self.parser.add_argument(
            "--dst-type",
            "-dt",
            nargs="+",
            default=["ipv4"],
            help="set dst address types",
        )
        self.parser.add_argument(
            "--dst",
            "-da",
            nargs="+",
            default=["h2"],
            help="set destination hosts",
        )
        self.parser.add_argument(
            "--lbf-contract",
            "-lbf",
            nargs="*",
            help="Use lbf contract with min and max delay. usage -lbf min_delay max_delay",
        )
        self.parser.add_argument(
            "--legacy_ip",
            "-li",
            action="store_true",
            default=False,
            help="Send a legacy packet to destination",
        )
        self.parser.add_argument(
            "--timeout",
            "-t",
            type=int,
            default=10,
            help="timeout for receiver and pcap capture",
        )
        self.parser.add_argument(
            "--show-packet",
            "-sp",
            action="store_true",
            default=False,
            help="Show Packet",
        )
        self.parser.add_argument(
            "--pkt-count", "-c", type=int, default=1, help="number of pkts to send"
        )
        self.parser.add_argument(
            "--pkt-size", "-s", type=int, default=100, help="pkt size"
        )
        self.parser.add_argument(
            "--pcap-file",
            "-pf",
            default="",
            help="pcap file to be replayed, use with -tr",
        )

        self.parser.add_argument(
            "--pcap-all",
            "-pa",
            action="store_true",
            default=False,
            help="Capture pcap for all nodes",
        )
        self.parser.add_argument(
            "--pcap-dst",
            "-pd",
            action="store_true",
            default=False,
            help="Capture pcap for dst node",
        )
        self.parser.add_argument(
            "--pcap-interface-list",
            "-pil",
            action="append",
            default=None,
            help="Capture packets on this list of interface",
        )
        self.parser.add_argument(
            "--pcap-node-list",
            "-pnl",
            action="append",
            default=None,
            help="Capture packets on this list of nodes",
        )

        self.parser.add_argument(
            "--tcp-replay",
            "-tr",
            action="store_true",
            default=False,
            help="Use tcp-replay to send the packets",
        )
        # self.parser.add_argument("--limit",    "-lmt",   type=int,
        #                     default=100000,
        #                     help="limit the number of packets to be sent, use with --tcp-replay=true")
        self.parser.add_argument(
            "--loop",
            "-l",
            type=int,
            default=1,
            help="loop through the pcap file, use with --tcp-replay=true",
        )

        self.group = self.parser.add_mutually_exclusive_group()
        self.group.add_argument(
            "--packets-per-sec",
            "-pps",
            type=int,
            default=100,
            help="send given number of packets per second, use with --tcp-replay=true",
        )
        self.group.add_argument(
            "--Mbps",
            "-mbps",
            type=int,
            default=0,
            help="send at the specified rate in Mbps, use with --tcp-replay=true",
        )
        self.group.add_argument(
            "--topspeed",
            "-ts",
            action="store_true",
            default=False,
            help="send at the maximum rate, use with --tcp-replay=true",
        )

        self.parser.add_argument(
            "--statistics",
            "-stats",
            type=int,
            default=10,
            help="print stats after every given second, use with --tcp-replay=true",
        )

    def parse_args(self):
        # Read arguments from the command line
        args = self.parser.parse_args()
        valid_address_types = ["ipv4", "ipv6", "8bit"]
        self.src_addr_type = list(set(args.src_type))
        for addr_type in self.src_addr_type:
            if (addr_type not in valid_address_types):
                self.parser.error ("src address should be from ipv4, ipv6 or 8bit")

        self.dst_addr_type = args.dst_type
        for addr_type in self.dst_addr_type:
            if (addr_type not in valid_address_types):
                self.parser.error ("dst address should be from ipv4, ipv6 or 8bit")

        valid_hosts = ["h1", "h2", "h3"]
        self.src = list(set(args.src))
        for host in self.src:
            if (host not in valid_hosts):
                self.parser.error ("dst address should be from h1, h2 or h3")

        self.dst = list(set(args.dst))
        for host in self.dst:
            if (host not in valid_hosts):
                self.parser.error ("dst address should be from h1, h2 or h3")
        if ((args.lbf_contract is not None) and ((len(args.lbf_contract) % 2) != 0)):
            self.parser.error(
                "Either give no values for contract, or multiple of two, not {}.".format(
                    len(args.lbf_contract)
                )
            )

        self.ping = args.ping
        self.lbfList = args.lbf_contract
        self.legacy_ip = args.legacy_ip
        self.timeout = args.timeout
        self.showPacket = args.show_packet
        self.pktCount = args.pkt_count
        self.pktSize = args.pkt_size
        self.pcap = args.pcap_file

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

        # print("Set src-type to %s" % args.src_type)
        # print("Set dst-type to %s" % args.dst_type)
        # print("Set src to %s" % args.src)
        # print("Set dst to %s" % args.dst)
        # print("Set size to %d" % args.pkt_size)
        # print("Set cnt to %d" % args.pkt_count)

        # TODO: rename setup_obj to active_topo


    def pkt_fill(self, index):
        START = "pkt# %d " % (index)
        remaining = self.pktSize - len(START)
        chars = string.ascii_uppercase + string.digits
        return START + "".join(random.choice(chars) for _ in range(remaining))

    def create_lbf_pkt(self, sender, srcNode, dstNode, content):
        src_addr_type = random.choice(self.src_addr_type)
        dst_addr_type = random.choice(self.dst_addr_type)
        src_addr = self.netObj.info_dict[srcNode.name][src_addr_type]
        dst_addr = self.netObj.info_dict[dstNode.name][dst_addr_type]
        sender.make_packet(
            src_addr_type,
            src_addr,
            dst_addr_type,
            dst_addr,
            content,
        )

        if self.lbfList != None:
            hops = self.netObj.info_dict[srcNode.name]["hops"][dstNode.name]
            self.lbfObj = LbfObj(self.min_delay, self.max_delay, hops)

            if self.lbfList != []:
                rand_min_index = random.choice(range(0,len(self.lbfList),2))
                min_delay = self.lbfList[rand_min_index]
                max_delay = self.lbfList[rand_min_index + 1]

                self.lbfObj.set_lbf_params(min_delay, max_delay, hops)

            params = self.lbfObj.get_lbf_params()
            lbf_contract = LatencyBasedForwarding(min_delay = params[0], max_delay = params[1], fib_todelay = params[2], fib_tohops = params[3])
            sender.set_contract([lbf_contract])
            # self.sender.insert_contract("latency_based_forwarding", params)

    def create_ping_pkt(self, sender, srcNode, dstNode):
        src_addr_type = random.choice(self.src_addr_type)
        dst_addr_type = random.choice(self.dst_addr_type)
        src_addr = self.netObj.info_dict[srcNode.name][src_addr_type]
        dst_addr = self.netObj.info_dict[dstNode.name][dst_addr_type]
        sender.make_packet(
            src_addr_type,
            src_addr,
            dst_addr_type,
            dst_addr,
            "PING"
        )
        sending_ts = time.time_ns() // 1000000
        ping_contract = Ping(code= 0, timestamp=sending_ts)
        sender.set_contract([ping_contract])
    def create_legacyip_pkt(self, sender, srcNode, dstNode, content):
        addr_type = self.src_addr_type
        if ("8bit" in addr_type):
            addr_type.remove("8bit")
        addr_type = random.choice(addr_type)
        src_addr = self.netObj.info_dict[srcNode.name][addr_type]
        dst_addr = self.netObj.info_dict[dstNode.name][addr_type]
        sender.make_packet(
            src_addr=src_addr,
            dst_addr=dst_addr,
            content=content,
        )
    def sender_process (self, srcNode):
        with srcNode:
            if self.legacy_ip:
                sender = LegacyIpSender()
            else:
                sender = Sender()
            dstNode = self.dstNode
            if (srcNode in dstNode):
                dstNode.remove(srcNode)
            if dstNode:
                srcIf = srcNode._interfaces[0].name
                if self.useTcpReplay:
                    os.system(f"tc qdisc replace dev {srcIf} root pfifo")

                for index in range(max(int(self.pktCount/len(self.src)),1)):
                    rand_dst_node = random.choice(dstNode)

                    if self.ping:
                        self.create_ping_pkt(sender, srcNode, rand_dst_node)
                    elif self.legacy_ip:
                        self.create_legacyip_pkt(sender,srcNode, rand_dst_node, index)
                    else:
                        payload = self.pkt_fill(index)
                        self.create_lbf_pkt(sender, srcNode, rand_dst_node, payload)

                    sender.send_packet(iface=srcIf, show_pkt=self.showPacket)
    
    def start_forwarder(self):
        if self.ping:
            self.netObj.start_receiver(
                timeout=self.timeout, nodeList=self.srcNode, verbose=True
            )
        
        for srcNode in self.srcNode:
            sender_proc = multiprocessing.Process(target=self.sender_process,args=(srcNode,))
            sender_proc.start()
    def tcp_replay_process(self, srcNode, srcIf, replayFile):
        with srcNode:
            if self.trTopspeed:
                os.system(
                    f"sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --topspeed -i {srcIf} {replayFile} "
                )
            elif self.trMbps:
                os.system(
                    f"sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --Mbps={self.trMbps} -i {srcIf} {replayFile} "
                )
            else:
                os.system(
                    f"sudo timeout {self.timeout} tcpreplay --loop={self.trLoop} --stats={self.trStats} --pps={self.trPps} -i {srcIf} {replayFile} "
                )

    def replay(self):
        self.netObj.start_receiver(timeout=self.timeout, nodeList=self.dstNode)
        if self.pcap == "":
            print("waiting for receiver processes to end...")
            time.sleep(self.timeout)
        for srcNode in self.srcNode:
            srcIf = srcNode._interfaces[0].name
            if self.pcap == "":
                os.system(
                    f"cp {self.pcapDirName}/{srcIf}.pcap {self.pcapDirName}/replay_{srcIf}.pcap"
                )
                with srcNode:
                    os.system(f"tc qdisc replace dev {srcIf} root lbf")
                replayFile = f"{self.pcapDirName}/replay_{srcIf}.pcap"
            else:
                replayFile = self.pcap
            tcp_replay_proc = multiprocessing.Process(target=self.tcp_replay_process,args=(srcNode, srcIf, replayFile,))
            tcp_replay_proc.start()
            
            self.gen_pcap()


lbf_forwarder_obj = lbf_forwarder()
