# New-IP

## Setup

This repository uses [libbpf](https://github.com/libbpf/libbpf/) as a git-submodule. After cloning, run:

```bash
git submodule update --init
```

[nest](https://gitlab.com/nitk-nest/nest/-/blob/master/INSTALL.md) python package is used to help setup network topologies and populate routing tables. You can follow the installation instructions [here](https://gitlab.com/nitk-nest/nest/-/blob/master/INSTALL.md)

Dependencies for XDP can be installed by going through [this document](https://github.com/xdp-project/xdp-tutorial/blob/master/setup_dependencies.org)

## Running

To run an experiment based on the nest topology, just run:

```bash
sudo python3 run.py
```

from the home directory. This will compile the necessary xdp programs as well.
