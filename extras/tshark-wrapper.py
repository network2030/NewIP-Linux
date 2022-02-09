import argparse
import os
import json

class arg_parser:
    def __init__(self):          
        self.set_args()
        self.parse_args()
        

    def set_args(self):
        self.parser = argparse.ArgumentParser()

        self.parser.add_argument("--tshark-path", "-tp",
                            required=True,
                            help="Tshark path")
        self.parser.add_argument("--pcap-path", "-pp",
                            required=True,
                            help="Pcap path")


    def parse_args(self):
        args = self.parser.parse_args()

        self.tshark = args.tshark_path
        self.pcap = args.pcap_path

args = arg_parser()
tshark_path = args.tshark
pcap_path = args.pcap
# tshark_path = '../wireshark-ninja/run/tshark'
# pcap_path = 'pcap/h2_r2.pcap'

os.system (f'{tshark_path} -r {pcap_path} -T json > tshark.json')
os.system (f'{tshark_path} -r {pcap_path} > tshark.txt')

tshark_file = open('tshark.json')
data = json.load(tshark_file)
res_file = open('tshark.txt')
result_list = res_file.readlines()

for i in range(len(result_list)):
    min_delay = ""
    max_delay = ""
    payload = ""
    try:
        min_delay = data[i]['_source']['layers']['New IP Packet']['Latency Based Forwarding Contract']['newip.lbfcontract.min_delay']
        max_delay = data[i]['_source']['layers']['New IP Packet']['Latency Based Forwarding Contract']['newip.lbfcontract.max_delay']
        payload = bytes.fromhex(str(data[i]['_source']['layers']['data']['data.data'].replace(":","")[0:16])).decode('utf-8')
    except:
        min_delay = ""
    
    split_list = result_list[i].split("New IP",1)
    result_list[i] = split_list[0] + " min delay: " + min_delay + " max delay: " + max_delay + " payload: " + payload + " " + split_list[1]
    print(result_list[i])
