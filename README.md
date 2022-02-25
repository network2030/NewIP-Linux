# New-IP

## Setup

### Machine details
```
OS: Ubuntu 21.10
Kernel-Version: 5.13.0-23-generic
Python Version: 3.9.7
ip -V : ip utility, iproute2-5.9.0, libbpf 0.4.0
ping -V: ping from iputils 20210202
```
### Preliminary steps
```
sudo apt update
sudo apt upgrade
sudo apt install git python3-pip
```

### Install XDP
```
sudo apt install clang llvm libelf-dev libpcap-dev gcc-multilib build-essential
sudo apt install linux-tools-$(uname -r)
sudo apt install linux-headers-$(uname -r)
sudo apt install linux-tools-common linux-tools-generic
```

### Install quagga
```
sudo apt install quagga quagga-doc
```

### New IP
Disable secure boot to install kernel modules
```
sudo apt install python3-scapy flex bison
git clone https://github.com/mohittahiliani/New-IP
cd New-IP
sudo python3 -m pip install -e . 
```

### Run example
```
cd examples
sudo python3 example_lbf.py
```

[nest](https://gitlab.com/nitk-nest/nest/-/blob/master/INSTALL.md) python package is used to help setup network topologies and populate routing tables.

Python package [scapy](https://scapy.net/) is required for New-IP packet generation

## Running

To run an example with IPv4 source and IPv6 dst, just run:

```bash
sudo python3 example_v4-v6.py
```

from the examples directory. This will compile the necessary xdp programs as well for the first run.

## Provided examples
- example_v4-v4.py: Sends packet from IPv4 address to IPv4 address
- example_v4-v6.py: Sends packet from IPv4 address to IPv6 address.
- example_v4-8bit.py: Sends packet from IPv4 address to 8bit address.
- example_max-latency.py: Sends a packet with LBF contract with just the max latency of 800ms.
- example_lbf.py: Sends a packet with LBF contract with min latency 500ms and max latency 800ms.
- example_legacy.py: Sends legacy packets
- example_ping.py: Runs New IP's Ping contract based ping
- lbf_forwarder.py: CLI based Application with lots of features. For help ```sudo python3 lbf_forwarder.py --help```

## Wireshark Setup

Steps for New IP Wireshark:
1. Install Git:
```bash
sudo apt install git
```

2. Install source repository
```bash
git clone https://gitlab.com/ameyanrd/wireshark.git
```

3. Switch the newip branch
```bash
cd wireshark
git switch newip
```

4. Make wireshark-ninja repo
```bash
cd ../
mkdir wireshark-ninja
cd wireshark-ninja
```

5. Install dependencies
```bash
sudo apt install cmake ninja-build gcc g++ libglib2.0-dev libpcap-dev libgcrypt20-dev libc-ares-dev flex bison qttools5-dev qtbase5-dev qtmultimedia5-dev
```

6. cmake and ninja
```bash
cmake -G Ninja ../wireshark
ninja
```

7. Open the New IP capture
```bash
./run/wireshark <pcap filename>
```
Sample Wireshark result and pcap available here:
https://drive.google.com/drive/folders/1aZUx08u1NWxoJv4vY4X5rR-M-PUUI0pK?usp=sharing
