---
title: Kathleen
layout: cluster
categories: 
 - missing-info
 - needs-update
---
# Kathleen

Kathleen is a compute cluster designed for extensively parallel, multi-node batch-processing jobs, having high-bandwidth connections between each individual node. It is named after [Professor Dame Kathleen Lonsdale](https://en.wikipedia.org/wiki/Kathleen_Lonsdale), a pioneering chemist and activist, and was installed in December 2019. It went into service at the end of January 2020.

## Accounts

Kathleen accounts can be applied for via the [Research Computing sign up process](Accounts.md).

As Kathleen is intended for multi-node jobs, users who specify that they will need to use multi-node jobs (e.g. with [MPI](Glossary.md#MPI)) will be given access to Kathleen.

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
instructions for [Logging in from outside the UCL firewall](../../howto/#logging-in-from-outside-the-ucl-firewall).

### Logging in to a specific node

You can access a specific Kathleen login node by using their dedicated addresses instead of the main `kathleen.rc.ucl.ac.uk` address, for example:

```
ssh uccaxxx@login01.kathleen.rc.ucl.ac.uk
```

The main address will unpredictably direct you to either one of these (to balance load), so if you need multiple sessions on one, this lets you do that.

## Copying data onto Kathleen

You will need to use an SCP or SFTP client to copy data onto Kathleen.
Please refer to the page on [How do I transfer data onto the system?](../../howto/#how-do-i-transfer-data-onto-the-system).

## Quotas

On Kathleen you have a single 250GB quota by default which covers your home and Scratch. 

This is a hard quota: once you reach it, you will no longer be able to write more data. Keep an eye on it, as this will cause jobs to fail if they cannot create their .o or .e files at the start, or their output files partway through.

You can check your quota on Kathleen by running:

```
lquota
```

which will give you output similar to this:

```
     Storage        Used        Quota   % Used   Path
      lustre  146.19 MiB   250.00 GiB       0%   /home/uccaxxx
```

You can apply for quota increases using the form at [Additional Resource Requests](Additional_Resource_Requests.md).

Here are some tips for [managing your quota](../../howto/#managing-your-quota) and
finding where space is being used.

## Job sizes and durations

For interactive jobs:

| Cores | Max. Duration |
|:-----:|:-------------:|
|  40   | 12h           |

For batch jobs:

| Cores    | Max. Duration |
|:--------:|:-------------:|
| 1-40     | 12h           |
| 41-256   | 48h           |
| 257-512  | 24h           |
| 513-5760 | 12h           |

These are numbers of physical cores.

If you have a workload that requires longer jobs than this, you may be able to apply to our governance group for access to a longer queue. Applications will be expected to demonstrate that their work cannot be run using techniques like checkpointing that would allow their workload to be broken up into smaller parts. Please see the section on [Applying for special access](CRAG_Exceptions.md) for more details.

## Node types

Kathleen's compute capability comprises roughly 191 diskless compute nodes each with two 20-core [Intel Xeon Gold 6248 2.5GHz](https://ark.intel.com/content/www/us/en/ark/products/192446/intel-xeon-gold-6248-processor-27-5m-cache-2-50-ghz.html) processors, 189 gigabytes of 2933MHz DDR4 RAM, and an Intel OmniPath network.

Two nodes identical to these serve as the login nodes.

!!! warning
    Only one of the login nodes, `login01`, is available during the testing period.

## Hyperthreading

Kathleen has hyperthreading enabled and you can choose on a per-job basis whether you want to use it.

Hyperthreading lets you use two virtual cores instead of one physical core - some programs can take advantage of this. 

If you do not ask for hyperthreading, your job only uses one thread per core as normal.

```
# request hyperthreading in this job
#$ -l thr=1
```

## Diskless nodes

Kathleen nodes are diskless (have no local hard drives) - there is no `$TMPDIR` available on Kathleen, so you should not request `-l tmpfs=10G` in your jobscripts or your job will be rejected at submit time.

If you need temporary space, you should use somewhere in your Scratch.

