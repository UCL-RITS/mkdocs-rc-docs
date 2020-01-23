---
title: Kathleen
layout: cluster
categories: 
 - missing-info
 - needs-update
---
# Kathleen

Kathleen is a compute cluster designed for extensively parallel, multi-node batch-processing jobs, having high-bandwidth connections between each individual node. It is named after [Professor Dame Kathleen Lonsdale](https://en.wikipedia.org/wiki/Kathleen_Lonsdale), a pioneering chemist and activist, and was installed in December 2019.

!!! info
    Kathleen is currently in testing, and is only available to certain users as part of the testing process. Some of the information below may be incomplete and may change between now and the shift to full service.

## Accounts

<!-- Kathleen accounts can be applied for via the [Research Computing sign up process](Accounts.md).

As Kathleen is intended for multi-node jobs, users who specify that they will need to use multi-node jobs (e.g. with [MPI](Glossary.md#MPI)) will be given access to Kathleen.

-->
Kathleen is only currently available to users who we have contacted as part of the testing process. We expect the system to move to general service in February 2020.

## Logging in

Please use your UCL username and password to connect to Kathleen with an SSH client.

```
ssh uccaxxx@kathleen.rc.ucl.ac.uk
```

If using PuTTY, put `kathleen.rc.ucl.ac.uk` as the hostname and your
seven-character username (with no @ after) as the username when logging
in, eg. `uccaxxx`. When entering your password in PuTTY no characters or
bulletpoints will show on screen - this is normal.

If you are outside the UCL firewall you will need to follow the
instructions for [accessing services from outside UCL](Accessing_RC_Systems.md).

### Logging in to a specific node

You can access a specific Kathleen login node by using their dedicated addresses instead of the main `kathleen.rc.ucl.ac.uk` address, for example:

```
ssh uccaxxx@login01.kathleen.rc.ucl.ac.uk
```

The main address will unpredictably direct you to either one of these (to balance load), so if you need multiple sessions on one, this lets you do that.

## Copying data onto Kathleen

You will need to use an SCP or SFTP client to copy data onto Kathleen.
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

Kathleen's compute capability comprises roughly 650 compute nodes each with two 8-core [Intel Xeon E5-2630v3 2.4GHz](https://ark.intel.com/content/www/us/en/ark/products/83356/intel-xeon-processor-e5-2630-v3-20m-cache-2-40-ghz.html) processors, 64 gigabytes of 2133MHz DDR4 RAM, 120GB hard drives, and an Intel TrueScale network.

Two nodes identical to these serve as the login nodes.

!!! warning
    Only one of the login nodes, `login01`, is available during the testing period.

