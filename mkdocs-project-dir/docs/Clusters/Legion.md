---
title: Legion
layout: cluster
---
# Legion

Legion is our older high-throughput cluster, that supports a small collection of research-group-owned groups of nodes, and nodes that were formerly research-group-owned but are now generally available for research workloads.

## Accounts

## Logging in

Please use your UCL username and password to connect to Legion with an SSH client.

```
ssh uccaxxx@legion.rc.ucl.ac.uk
```

If using PuTTY, put `legion.rc.ucl.ac.uk` as the hostname and your
seven-character username (with no @ after) as the username when logging
in, eg. `uccaxxx`. When entering your password in PuTTY no characters or
bulletpoints will show on screen - this is normal.

If you are outside the UCL firewall you will need to follow the
instructions for [Logging in from outside the UCL firewall](../howto.md#logging-in-from-outside-the-ucl-firewall).

### Logging in to a specific node

!!! Note
    We are currently awaiting assignment of hostnames for logging in to specific nodes, from the ISD Networks group.

## Copying data onto Legion

You will need to use an SCP or SFTP client to copy data onto Legion.
Please refer to the page on [How do I transfer data onto the system?](../howto.md#how-do-i-transfer-data-onto-the-system)

Due to a lack of available networking hardware to connect Legion to the rest of the UCL network, the connections to the login nodes can only get a theoretical maximum of 1 gigabit/second (128 megabytes/second). There is a single node which has a faster connection (10x), available by connecting to `transfer.legion.rc.ucl.ac.uk`. When transferring data from a source with a fast connection, like another cluster or a website, this address should be used in place of either the main Legion address or a specific login node address, to get the best transfer speed.

## Quotas

!!! danger
    This section has not been filled in.

## Job sizes

For interactive jobs:

| Cores    | Max. Duration |
|:--------:|:-------------:|
|  1-16    | 2h            |

For batch jobs:

| Cores       | Max. Duration |
|:-----------:|:-------------:|
| 1           | 72h           |
| 2-256       | 48h           |
| 16-256      | 48h           |
| 256-512[^1] | 24h           |
| >512[^1]    | 12h           |

[^1] While the scheduler will allow you to submit a job of this size, it is unlikely to ever be run.

Note that nodes owned by research groups have a job duration limit of 7 days for users **in those research groups**.

If you have a workload that requires longer jobs than this, you may be able to apply to our governance group for access to a longer queue. Applications will be expected to demonstrate that their work cannot be run using techniques like checkpointing that would allow their workload to be broken up into smaller parts. Please see the section on [Applying for Additional Resources](../Additional_Resource_Requests.md) for more details.

## Node types

As Legion has been added to in small quantities at many times, it has many types of node. They all have two Sandy Bridge or Ivy Bridge processors. Most have 16 cores and 64GB of RAM. The exceptions are the single GPU node, which has only 12 cores and 8GB of RAM, the single Q-class node, which has 32 cores and 500GB of RAM, and the 6 T-class nodes, which have 32 cores and 1.5TB of RAM.

<!--
| Class | Processor                       | RAM | Disk | Network |
|:-----:|:-------------------------------:|:---:|:----:|:-------:|
| Q     | 2 ⨉ Intel Xeon E5-4620 0 @ 2.20GHz
| S     | 2 ⨉ Intel Xeon E5-2650 v2 @ 2.60GHz | 
| T     | 2 ⨉ Intel Xeon E5-4620 0 @ 2.20GHz
| U     | 2 ⨉ Intel Xeon E5-2650 v2 @ 2.60GHz | 


-->

