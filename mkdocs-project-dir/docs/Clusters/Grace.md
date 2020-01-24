---
title: Grace
layout: cluster
categories: missing-info
---
# Grace

Grace is a compute cluster designed for extensively parallel, multi-node batch-processing jobs, having high-bandwidth connections between each individual node.

## Accounts

Grace accounts can be applied for via the [Research Computing sign up process](Accounts.md).

As Grace is intended for multi-node jobs, users who specify that they will need to use multi-node jobs (e.g. with [MPI](Glossary.md#MPI)) will be given access to Grace.

## Logging in

Please use your UCL username and password to connect to Grace with an SSH client.

```
ssh uccaxxx@grace.rc.ucl.ac.uk
```

If using PuTTY, put `grace.rc.ucl.ac.uk` as the hostname and your
seven-character username (with no @ after) as the username when logging
in, eg. `uccaxxx`. When entering your password in PuTTY no characters or
bulletpoints will show on screen - this is normal.

If you are outside the UCL firewall you will need to follow the
instructions for [accessing services from outside UCL](Accessing_RC_Systems.md).

### Logging in to a specific node

You can access a specific Grace login node by using their dedicated addresses instead of the main `grace.rc.ucl.ac.uk` address, for example:

```
ssh uccaxxx@login01.ext.grace.ucl.ac.uk
ssh uccaxxx@login02.ext.grace.ucl.ac.uk
```

The main address will unpredictably direct you to either one of these (to balance load), so if you need multiple sessions on one, this lets you do that.

## Copying data onto Grace

You will need to use an SCP or SFTP client to copy data onto Grace.
Please refer to the page on [Managing Data on RC Systems](Managing_Data.md).

## Quotas

!!! danger
    This section has not been filled in.

## Job sizes and durations

For interactive jobs:

| Cores | Max. Duration |
|:-----:|:-------------:|
|  32   | 2h            |

For batch jobs:

| Cores   | Max. Duration |
|:-------:|:-------------:|
| 1-16    | 12h           |
| 16-256  | 48h           |
| 256-512 | 24h           |
| >512    | 12h           |

If you have a workload that requires longer jobs than this, you may be able to apply to our governance group for access to a longer queue. Applications will be expected to demonstrate that their work cannot be run using techniques like checkpointing that would allow their workload to be broken up into smaller parts. Please see the section on [Applying for special access](CRAG_Exceptions.md) for more details.

## Node types

Grace's compute capability comprises roughly 650 compute nodes each with two 8-core [Intel Xeon E5-2630v3 2.4GHz](https://ark.intel.com/content/www/us/en/ark/products/83356/intel-xeon-processor-e5-2630-v3-20m-cache-2-40-ghz.html) processors, 64 gigabytes of 2133MHz DDR4 RAM, 120GB hard drives, and an Intel TrueScale network.

Two nodes identical to these serve as the login nodes.


