---
title: Research Computing Platforms
layout: docs
---
We provide access to three computing clusters: [Legion](Legion), [Myriad](Myriad), and [Grace](Grace)
([What is a computing cluster?](Cluster_Computing)). All UCL
researchers are eligible to use these platforms on a fair share basis
and at no cost. This page provides a brief overview of our computing
services and their technical specifications.

We support [Aristotle](Aristotle), which provides a limited interactive Linux environment to
support training.

We also host [Thomas](Thomas) and [Michael](Michael), clusters associated with the UK National Tier 2 High Performance Computing
Hub in Materials and Molecular Modelling.

## Legion

Legion is our general-use cluster. It contains nodes of different types,
some specialist hardware, and nodes belonging to research groups. You
can run serial or parallel jobs on it, and the combinations of resources
you may request depend on the node type.

### Legion technical specs

The Legion cluster nodes have several different types.

Type T:

  - 6 Dell 2U R820 large memory or fat nodes - four socket, eight cores
    per processor
  - Each node has 32 cores at 48GB RAM per core
  - Each node can work as a 32 core SMP system with 1.5TB of RAM
  - 2TB local disk per node (1536G available for tmpfs)

Type U:

  - Exact hardware may vary, as these are bought in sections
  - 160 Dell C6220 nodes (4 nodes per 2u) - dual processor, eight cores
    per processor
  - 2560 cores, at 4GB RAM per core (64GB per node)
  - Each node can work as a 16 core SMP device with 64GB of RAM
  - 108 nodes are also connected with Infiniband configured as three 36
    node 'islands'
  - 1TB of local disk per node (792G available for tmpfs)

Type X:

  - 144 Dell C6100 nodes (4 nodes per 2u) - dual processor, six cores
    per processor
  - 1728 cores, as 2GB RAM per core (24GB per node)
  - Organized into 6 Computational Units of 288 cores
  - Each server can function as a 12 core SMP device
  - QDR InfiniPath chip-to-chip connectivity
  - 250GB of local disk per server (173G available for tmpfs)

Type Y:

  - 108 Dell C6100 nodes (4 nodes per 2u) - dual processor, six cores
    per processor
  - 1296 cores, each with 2GB RAM (24GB per node)
  - Each server can function as a 12 core SMP device
  - 500GB of local disk per server (406G available for tmpfs)

Type Z:

  - 4 Dell C6100 nodes (4 nodes in 2u) - dual processor, six cores per
    processor
  - 48 cores, each with 4GB RAM (48GB per node)
  - Each server can function as a 12 core SMP device
  - 500GB of local disk per server (173G available for tmpfs)

Type P GPU:

  - 1 node - dual processor, six cores per processor
  - Each server with 12 CPU cores and 1 NVIDIA K40c GPU card
  - Each card having 2880 CUDA cores and 11GB RAM
  - Each server can function as a 12 core SMP device
  - 932GB of local disk per server (112G available for tmpfs)

Type V GPU:

  - 8 Dell C6100 nodes (4 nodes per 2u) - dual processor, six cores per
    processor
  - Each server with 12 CPU cores and two M2070 GPU cards
  - Each card having 448 CUDA cores and 6GB RAM
  - Each server can function as a 12 core SMP device
  - 500GB of local disk per server (358G available for tmpfs)

Type S (experimental MIC nodes):

  - 10 Dell 2U R720 nodes - two socket, 8 or 16 cores per processor
  - Nodes have 16 CPU cores and two Xeon Phi 7120p MICs
  - Nodes can work as a 16 core SMP device with 64GB of RAM
  - 2TB of local disk per node (1536G available for tmpfs)
  - Operating system is Red Hat Linux 6

The cluster is coupled to a large-scale high-performance file system:

  - 342TB of RAID 6 storage
  - Uses Lustre Cluster File System
  - 4 servers to stripe data across the disks and 2 servers to store the
    metadata
  - Aggregate speed of 6GB/s for Read/Writes
  - Please note that this file system is for active data and not archive
    data. It should be used **for temporary storage only**.

## Myriad

Myriad is our high-I/O, high-throughput cluster. It contains nodes of a
few different types including GPUs. It runs jobs that will run within a
single node rather than multi-node parallel jobs.

### Myriad technical specs

Myriad consists of Lenovo SD530 nodes. There are two login nodes and two
transfer nodes.

There are three types of compute nodes:

Type H:

  - Lenovo SD530 Standard Nodes
  - 2 x Intel Xeon Gold 6140 18C 140W 2.3GHz Processor (36 cores total)
  - 12 x 16GB TruDDR4 RDIMM (192 GB total)
  - 1 x 2TB 7.2K SATA HDD
  - 1 x Mellanox ConnectX-5 EDR/100Gb IB single port VPI HCA

Type I high memory:

  - Lenovo SD530 High Memory Nodes
  - 2 x Intel Xeon Gold 6140 18C 140W 2.3GHz Processor (36 cores total)
  - 24 x 64GB TruDDR4 RDIMM (1.5TB total)
  - 1 x 2TB 7.2K SAS HDD
  - 1 x Mellanox ConnectX-4 2x100Gb/EDR IB VPI Adapter

Type J GPU:

  - Lenovo SD530 GPU Nodes
  - 2 x Intel Xeon Gold 6140 18C 140W 2.3GHz Processor (36 cores total)
  - 2 x nVidia Tesla P100 Adapter
  - 12 x 16GB TruDDR4 RDIMM (192 GB total)
  - 1 x 2TB 7.2K SATA HDD
  - 1 x Mellanox ConnectX-5 EDR/100Gb IB single port VPI HCA

Filesystem:

  - Lenovo Lustre storage
  - 200TB home
  - 1PB Scratch
  - 2 MDS servers
  - 2 OSS servers
  - Mellanox ConnectX-4 2x100Gb/EDR InfiniBand storage network

## Grace

Grace is intended for large multinode parallel jobs. As per CRAG policy,
jobs that require less than 32 cores are subject to a dramatic priority
penalty.

### Grace technical specs

Grace consists of 684 identical Lenovo NeXtScale nodes connected by
non-blocking Intel TrueScale QDR Infiniband to each other and a 1.1
PetaByte DDN Lustre storage appliance. Four of the nodes are used as
login and admin nodes. The remainder are available for running jobs.

Each node has the following specs:

  - 2x 8 core Intel Xeon E5-2630v3 processors (16 cores total)
  - 64 Gigabytes of RAM
  - 120 Gigabyte SSD for OS and TMPDIR
  - Intel TrueScale QDR Infiniband adaptor

## Thomas

Thomas is the UK National Tier 2 High Performance Computing Hub in
Materials and Molecular Modelling, a domain-specific multi-institute
machine hosted by UCL.

  - [Further details about Thomas](Thomas)

### Thomas technical specs

Thomas consists of 720 Lenovo Intel x86-64 nodes, giving 17.2k cores in
total, with Intel OmniPath interconnect (1:1 nonblocking in 36 node
blocks, 3:1 between blocks and across the system).

Each node has the following specs:

  - 2 x 12 core Intel Broadwell processors (24 cores total)
  - 128GB RAM
  - 120GB SSD

## Aristotle

Aristotle is a teaching machine, usable by everyone. It does not have a
batch system - you run programs directly on the nodes and share
resources with all other users. Use with consideration\!

### Aristotle technical specs

  - 4x 16 core Dell servers with Intel(R) Xeon(R) CPU E5-2650 v2
  - 64 gigabytes of RAM per node
  - RedHat 7.2
  - No Infiniband so MPI may only be used within a node

### How do I apply for an account?

Please apply at [Account Services](Account_Services) for
everything other than Thomas - you will be approved for a Legion and
Myriad account. You will be approved for a Grace account if the
resources you request meet the requirements.

For Thomas, see [Applying for a Thomas account](Thomas#Applying_for_an_account).

### Access to Aristotle

Everyone with a UCL account has access to Aristotle. Login via SSH to:

```
aristotle.rc.ucl.ac.uk
```

