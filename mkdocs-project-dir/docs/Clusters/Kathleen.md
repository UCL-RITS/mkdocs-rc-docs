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

Kathleen accounts can be applied for via the [Research Computing sign up process](../Account_Services.md).

As Kathleen is intended for multi-node jobs, users who specify that they will need to use multi-node jobs (e.g. with [MPI](../Supplementary/Glossary.md#MPI)) will be given access to Kathleen.

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
instructions for [Logging in from outside the UCL firewall](../howto.md#logging-in-from-outside-the-ucl-firewall).

### Logging in to a specific node

You can access a specific Kathleen login node by using their dedicated addresses instead of the main `kathleen.rc.ucl.ac.uk` address, for example:

```
ssh uccaxxx@login01.kathleen.rc.ucl.ac.uk
```

The main address will unpredictably direct you to either one of these (to balance load), so if you need multiple sessions on one, this lets you do that.

## Copying data onto Kathleen

You will need to use an SCP or SFTP client to copy data onto Kathleen.
Please refer to the page on [How do I transfer data onto the system?](../howto.md#how-do-i-transfer-data-onto-the-system)

You can connect directly in both directions between Grace and Kathleen.

If you find you cannot connect directly from one cluster to another, this is 
generally because of firewalls in between and so you need to use [tunnelling with the scp command](../howto.md#single-step-logins-using-tunnelling).

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

You can apply for quota increases using the form at [Additional Resource Requests](../Additional_Resource_Requests.md).

Here are some tips for [managing your quota](../howto.md#managing-your-quota) and
finding where space is being used.

## Job sizes and durations

Please consider that Kathleen nodes have 40 physical cores - 2 nodes is 80 cores. Jobs do not share nodes, so although asking for 41 cores is possible, it means you are wasting the other 39 cores on your second node!

For interactive and batch jobs:

| Cores    | Max. Duration |
|:--------:|:-------------:|
| 41-240   | 48h           |
| 241-480  | 24h           |
| 481-5760 | 12h           |

These are numbers of physical cores.

If you have a workload that requires longer jobs than this, you may be able to apply to our governance group for access to a longer queue. Applications will be expected to demonstrate that their work cannot be run using techniques like checkpointing that would allow their workload to be broken up into smaller parts. Please see the section on [Additional Resource Requests](../Additional_Resource_Requests.md) for more details.

## Node types

Kathleen's compute capability comprises 192 diskless compute nodes each with two 20-core [Intel Xeon Gold 6248 2.5GHz](https://ark.intel.com/content/www/us/en/ark/products/192446/intel-xeon-gold-6248-processor-27-5m-cache-2-50-ghz.html) processors, 192 gigabytes of 2933MHz DDR4 RAM, and an Intel OmniPath network.

Two nodes identical to these, but with two 1 terabyte hard-disk drives added, serve as the login nodes.

## Hyperthreading

Kathleen has hyperthreading enabled and you can choose on a per-job basis whether you want to use it.

Hyperthreading lets you use two virtual cores instead of one physical core - some programs can take advantage of this. 

If you do not ask for hyperthreading, your job only uses one thread per core as normal.

The `-l threads=` request is not a true/false setting, instead you are telling the scheduler
you want one slot to block one virtual cpu instead of the normal situation where it blocks two.
If you have a script with a threads request and want to override it on the command line or set
it back to normal, the usual case is `-l threads=2`. (Setting threads to 0 does not disable
hyperthreading!)

```
# request hyperthreading in this job
#$ -l threads=1

# request the number of virtual cores
#$ -pe mpi 160

# request 2G RAM per virtual core
#$ -l mem=2G

# set number of OpenMP threads being used per MPI process 
export OMP_NUM_THREADS=2
```

This job would be using 80 physical cores, using 80 MPI processes each of which would create two threads (on Hyperthreads).

Note that memory requests are now per virtual core with hyperthreading enabled. 
If you asked for `#$ -l mem=4G`on a node with 80 virtual cores and 192G RAM then 
you are requiring 320G RAM in total which will not fit on that node and so you 
would be given a sparse process layout across more nodes to meet this requirement.

```
# request hyperthreading in this job
#$ -l threads=1

# request the number of virtual cores
#$ -pe mpi 160

# request 2G RAM per virtual core
#$ -l mem=2G

# set number of OpenMP threads being used per MPI process
# (a whole node's worth)
export OMP_NUM_THREADS=80
```

This job would still be using 80 physical cores, but would use one MPI process per node which would create 80 threads on the node (on Hyperthreads).

## Diskless nodes

Kathleen nodes are diskless (have no local hard drives) - there is no `$TMPDIR` available on Kathleen, so you should not request `-l tmpfs=10G` in your jobscripts or your job will be rejected at submit time.

If you need temporary space, you should use somewhere in your Scratch.

## Loading and unloading modules

Kathleen has a newer version of `modulecmd` which tries to manage module dependencies automatically by loading or unloading prerequisites for you whenever possible.

If you get an error like this:

```
[uccaxxx@login01.kathleen ~]$ module unload compilers mpi
Unloading compilers/intel/2018/update3
  ERROR: compilers/intel/2018/update3 cannot be unloaded due to a prereq.
    HINT: Might try "module unload default-modules/2018" first.

Unloading mpi/intel/2018/update3/intel
  ERROR: mpi/intel/2018/update3/intel cannot be unloaded due to a prereq.
    HINT: Might try "module unload default-modules/2018" first.
```

You can use the `-f` option to force the module change. It will carry it out and warn you about modules it thinks are dependent.

```
[uccaxxx@login01.kathleen ~]$ module unload -f compilers mpi
Unloading compilers/intel/2018/update3
  WARNING: Dependent default-modules/2018 is loaded

Unloading mpi/intel/2018/update3/intel
  WARNING: Dependent default-modules/2018 is loaded
```

Otherwise you will need to unload `default-modules/2018` to swap compiler and MPI module, but that will leave you without `gerun` in your path. You can then do either of these things:

```
# load everything that was in default-modules except the compiler and mpi
module unload default-modules/2018
module load rcps-core/1.0.0
module load whatever
```
or
```
# just reload gerun
module unload default-modules/2018
module load gerun
module load whatever
```

