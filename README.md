# New-IP

## Setup

This repository uses [libbpf](https://github.com/libbpf/libbpf/) as a git-submodule. After cloning, run:

```bash
git submodule update --init
```

[nest](https://gitlab.com/nitk-nest/nest/-/blob/master/INSTALL.md) python package is used to help setup network topologies and populate routing tables. You can follow the installation instructions [here](https://gitlab.com/nitk-nest/nest/-/blob/master/INSTALL.md)

Python package [scapy](https://scapy.net/) is required for New-IP packet generation which can installed with:
```bash
sudo apt install python3-scapy
```
Dependencies for XDP can be installed by going through [this document](https://github.com/xdp-project/xdp-tutorial/blob/master/setup_dependencies.org)

## Running

To run an example based on the nest topology, just run:

```bash
sudo python3 example_v4-v6.py
```

from the home directory. This will compile the necessary xdp programs as well.

## Provided examples
- example_v4-v6.py: Sends packet from IPv4 address to IPv6 address.
- example_v4-8bit.py: Sends packet from IPv4 address to 8bit address.
- example_max-latency.py: Sends a packet with LBF contract with just the max latency of 800ms.
- example_lbf.py: Sends a packet with LBF contract with min latency 500ms and max latency 800ms.

## Wireshark Setup
Note: Uncomment line number 22 in receiver.py to enable pcap generation

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
