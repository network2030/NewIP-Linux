## New IP on Linux (Proof of Concept)

### Introduction
New IP-Linux sandbox is a lightweight packet processing environment that implements packet format as per specification defined below. NewIP packet format has a flexible routing header called shipping spec, and an extensible set of service primitives called contract spec. This testbed enables experimentation and evaluation of  different type of addressing schemes and service primitives in the network.

- R. Li, K. Makhijani and L. Dong, "New IP: A Data Packet Framework to Evolve the Internet : Invited Paper," 2020 IEEE 21st International Conference on High Performance Switching and Routing (HPSR), 2020, pp. 1-8, doi:10.1109/HPSR48589.2020.9098996. [Get it from here](https://github.com/network2030/NewIP-Linux/blob/gh-pages/docs/New_IP_A_Data_Packet_Framework_to_Evolve_the_Internet__Invited_Paper.pdf)

- K. Makhijani and L. Dong, "Asymmetric Addressing Structures in Limited Domain Networks," 2021 IEEE 22nd International Conference on High Performance Switching and Routing (HPSR), 2021, pp. 1-7, doi:10.1109/HPSR52026.2021.9481811. [Get it from here](https://github.com/network2030/NewIP-Linux/blob/af45f890eaba49ede769fa3e3621ef3a4807e2c5/docs/Asymmetric_Addressing_Structures_in_Limited_Domain_Networks.pdf)

New IP uses a simple [Network Stack Tester (NeST)](https://nest.nitk.ac.in) environment based on network namespaces. NeST leverages all the facilities provided under linux such as routing and forwarding to create multi-node topologies on a single machine for faster testing and development of network features. In this case the entire network stack.

- Shanthanu S. Rai, Narayan G., Dhanasekhar M., Leslie Monis, and Mohit P. Tahiliani. 2020. NeST: Network Stack Tester. In <i>Proceedings of the Applied Networking Research Workshop</i> (<i>ANRW '20</i>). Association for Computing Machinery, New York, NY, USA, 32–37. DOI:https://doi.org/10.1145/3404868.3406670

### Tutorial Details
Schedule: 7th March 2022, 3:30 PM-5:00 PM
Tutorial #3 : New IP Sandbox: Leveraging Linux for the design of applications using New IP open platform
Location:  https://www.icin-conference.org/tutorials/

#### Slides for the tutorial are posted here

- [New IP Overview - Part 1](https://github.com/network2030/NewIP-Linux/blob/ab0cbf5ebe328be039748ac68fdd8719deac0ff7/docs/New%20IP%20Tutorial%20--Part-1.pptx)
- [Network Stack Tester - Part 2](https://github.com/network2030/NewIP-Linux/blob/ab0cbf5ebe328be039748ac68fdd8719deac0ff7/docs/New%20IP%20Tutorial%20--Part-2.pptx)
- [Implementation and Demo - Part 3](docs/New%20IP%20Tutorial%20--Part-3.pptx)
- [Extensible Scenarios and Future Work - Part 4](docs/New%20IP%20Tutorial%20--Part-4.pptx)

[Single Deck](docs/New%20IP%20Tutorial%20ICIN.pdf)

#### Repository

https://github.com/network2030/NewIP-Linux
- use branch: [icin_tut](https://github.com/network2030/NewIP-Linux/tree/icin_tut)

## Getting Started

[NeST - Network Stack Test Environment](https://nest.nitk.ac.in/docs/v0.4/index.html)

[NewIP-Linux](https://github.com/network2030/NewIP-Linux/blob/main/README.md)

### VM
1. Download pre-built VM from [here](https://drive.google.com/drive/folders/1uof-qs2wgyl7aOU_f7PJKpNefmmtrXkE?usp=sharing)
1. Ready to use Cloud VMs through ssh ([Instructions](https://docs.google.com/document/d/1WVCEnBaZavxaX8zWaXKuq77cEM6ZY1MBALQHSTlSLeE/edit?usp=sharing))
