---
title: MMM Michael
categories:
 - Michael
 - Tier 2
layout: docs
---
# Michael

Michael is an extension to the UCL-hosted Hub for Materials and
Molecular Modelling, an EPSRC-funded Tier 2 system providing large scale
computation to UK researchers; and delivers computational capability for
the Faraday Institution, a national institute for electrochemical energy
storage science and technology.

## Applying for an account

Michael accounts belong to you as an individual and are applied for via
[David Scanlon](http://davidscanlon.com/?page_id=5) who is the point of 
contact for Michael.

You will need to supply an SSH public key, which is the only method used
to log in.

## Creating an ssh key pair

An ssh key consists of a public and a private part, typically named
id\_rsa and id\_rsa.pub by default. The public part is what we need. You
must not share your private key with anyone else. You can copy it onto
multiple machines belonging to you so you can log in from all of them
(or you can have a separate pair for each machine).

### Creating an ssh key in Linux/Unix/macOS

```
ssh-keygen -t rsa
```

The defaults should give you a reasonable key. If you prefer to use
ed25519 instead, and/or longer keys, you can. You can also tell it
to create one with a different name, so it doesn't overwrite any
existing key.

  - Do not use DSA as OpenSSH 7.0 has deprecated it
    and does not use it by default on client or server. 
    We no longer accept DSA keys.

You will be asked to add a passphrase for your key. A blank passphrase
is not recommended; if you use one please make sure that no one else
ever has access to your local computer account. How often you are asked
for a passphrase depends on how long your local ssh agent keeps it.

You may need to run `ssh-add` to add the key to your agent so you can
use it. If you aren't sure what keys your agent can see, running
`ssh-add -L` will show all the public parts of the keys it is aware of.

### Creating an ssh key in Windows

Have a look at [Key-Based SSH Logins With PuTTY](https://devops.ionos.com/tutorials/use-ssh-keys-with-putty-on-windows/#create-new-public-and-private-keys) which has
step-by-step instructions. You can choose whether to use Pageant or not
to manage your key. You can again pick RSA, ED25519, ECDSA etc **but do not
pick SSH-1** as that is an old and insecure key type. As above, DSA is no 
longer accepted. The key must be at least 2048-bit.

If you are using Windows 10, then you probably have OpenSSH installed and could instead run ssh-keygen in a terminal per the Linux instructions and use the ssh command to log in instead of PuTTY.

## Information for Points of Contact

Points of Contact have some tools they can use to manage users and
allocations, documented at [MMM Points of Contact](../Supplementary/Points_of_Contact.md).

## Logging in

You will be assigned a personal username and your SSH key pair will be
used to log in. External users will have a username in the form
`mmmxxxx` (where `xxxx` is a number) and UCL users will use their central username.

You connect with ssh directly to:

```
michael.rc.ucl.ac.uk
```

### SSH timeouts

Idle ssh sessions will be disconnected after 7 days.

## Using the system

Michael is a batch system. The login nodes allow you to manage your
files, compile code and submit jobs. Very short (\<15mins) and
non-resource-intensive software tests can be run on the login nodes, but
anything more should be submitted as a job.

## Full user guide

Michael has the same user environment as RC Support's other clusters, so
the [User guide](../index.md) is relevant and is a
good starting point for further information about how the environment
works. Any variations that Michael has should be listed on this page.

## Submitting a job

Create a [job script](../Example_Jobscripts.md) for
non-interactive use and [submit your jobscript using qsub](../howto.md#how-do-i-submit-a-job-to-the-scheduler). 
Jobscripts must begin `#!/bin/bash -l` in order to run as a login shell
 and get your login environment and modules.

A job on Michael must also specify what type of job it is (Gold, Free,
Test) and the project it is being submitted for. (See [Budgets and allocations](#budgets-and-allocations) below).

### Memory requests

Note: the memory you request is always per core, not the total amount.
If you ask for 128G RAM and 24 cores, that will run on 24 nodes using
only one core per node. This allows you to have sparse process placement
when you do actually need that much RAM per process.

## Monitoring a job

In addition to [qstat](../howto.md#how-do-i-monitor-a-job), `nodesforjob
$JOB_ID` can be useful to see what proportion of cpu/memory/swap is
being used on the nodes a certain job is running on.

`qexplain $JOB_ID` will show you the full error for a job that is in
`Eqw` status.

## Useful utilities

As well as `nodesforjob`, there are the following utilities which can
help you find information about your jobs after they have run.

  - `jobhist` - shows your job history for the last 24hrs by default,
    including start and end times and the head node it ran on. You can
    view a longer history by specifying `--hours=100` for example.
  - `scriptfor $JOB_ID` - show the script that was submitted for the
    given job.

These utilities live in GitHub at
<https://github.com/UCL-ARC/go-clustertools> and
<https://github.com/UCL-ARC/rcps-cluster-scripts>

## Software

Michael mounts the [RC Systems software stack](../Installed_Software_Lists/module-packages.md).

Have a look at [Software Guides](../Software_Guides/Other_Software.md) for specific
information on running some applications, including example scripts. The
list there is not exhaustive.

Access to software is managed through the use of modules.

  - `module avail` shows all modules available.
  - `module list` shows modules currently loaded.

Access to licensed software may vary based on your host institution and
project.

### Requesting software installs

To request software installs, email us at the [support address
below](#support) or open an issue on our
[GitHub](https://github.com/UCL-ARC/rcps-buildscripts/issues). You can
see what software has already been requested in the Github issues and
can add a comment if you're also interested in something already
requested.

### Installing your own software

You may install software in your own space. Please look at
[Compiling Your Code](../Supplementary/Compiling_Your_Code.md) for tips.

### Maintaining a piece of software for a group

It is possible for people to be given central areas to install software
that they wish to make available to everyone or to a select group -
generally because they are the developers or if they wish to use
multiple versions or developer versions. The people given install access
would then be responsible for managing and maintaining these installs.

### Licensed software

Reserved application groups exist for software that requires them. The
group name will begin with `leg` or `lg`. After we add you to one of
these groups, the central group change will happen overnight. You can
check your groups with the `groups` command.

Please let us know your username when you ask to be added to a group.

  - **CASTEP**: You/your group leader need to have [signed up for a CASTEP license](https://www.castep.org/get_castep).
    Send us an acceptance email, or we can ask them to verify you have a
    license. You will then be added to the reserved application group
    `lgcastep`. If you are a member of UKCP you are already covered by a
    license and just need to tell us when you request access.
  - **CRYSTAL**: You/your group leader need to have signed up for an
    Academic license. Crystal Solutions will send an email saying an
    account has been upgraded to "Academic UK" - forward that to us
    along with confirmation from the group leader that you should be in
    their group. You will be added to the `legcryst` group.
  - **DL\_POLY**: has individual licenses for specific versions. [Sign up at DL\_POLY's website](https://www.ccp5.ac.uk/dl_poly/)
    and send us the acceptance email they give you. We will add you to
    the appropriate version's reserved application group, eg `lgdlp408`.
  - **Gaussian**: not currently accessible for non-UCL institutions. UCL
    having a site license and another institute having a site license
    does not allow users from the other institute to run Gaussian on
    UCL-owned hardware.
  - **VASP**: When you request access you need to send us the email
    address you are named on a VASP license using. You can also send 
    name and email of the main VASP license holder along with the license 
    number if you wish. We will then check in the VASP portal if we can 
    add you. We will add you to the `legvasp5` or `legvasp6` reserved 
    application groups depending on which versions you are licensed for. 
    You may also install your own copy in your home, and we provide a simple
    [build script on Github](https://github.com/UCL-ARC/rcps-buildscripts/blob/master/vasp_individual_install)
    (tested with VASP 5.4.4, no patches). You need to download the VASP
    source code and then you can run the script following the
    instructions at the top.
  - **Molpro**: Only UCL users are licensed to use our central copy and
    can request to be added to the `lgmolpro` reserved application group.

## Suggested job sizes on original Michael

The target job sizes for original Michael K-type nodes are 48-120 cores (2-5 nodes). Jobs
larger than this may have a longer queue time and are better suited to
ARCHER, and single node jobs may be more suited to your local facilities.

## Maximum job resources on original Michael

| Cores | Max wallclock |
| ----- | ------------- |
| 864   | 48hrs         |
|       |               |

On Michael, interactive sessions using qrsh have the same wallclock
limit as other jobs.

The K-type nodes in Michael are 24 cores, 128GB RAM. The default maximum jobsize is
864 cores, to remain within the 36-node 1:1 nonblocking interconnect
zones.

Jobs on Michael **do not share nodes**. This means that if you request
less than 24 cores, your job is still taking up an entire node and no
other jobs can run on it, but some of the cores are idle. Whenever
possible, request a number of cores that is a multiple of 24 for full
usage of your nodes.

There is a superqueue for use in exceptional circumstances that will
allow access to a larger number of cores outside the nonblocking
interconnect zones, going across the 3:1 interconnect between blocks. A
third of each CU is accessible this way, roughly approximating a 1:1
connection. Access to the superqueue for larger jobs must be applied
for: contact the support address below for details.

Some normal multi-node jobs will use the superqueue - this is to make it
easier for larger jobs to be scheduled, as otherwise they can have very
long waits if every CU is half full.  

## 2020 Michael expansion

At the end of March 2020, Michael was expanded to include a new set of nodes. The old Michael nodes are the K-type nodes, while the new ones are the A-type nodes. The node name will look like `node-a14a-001` or `node-k10a-001`.

The Michael expansion consists of 208 compute nodes each with two 20-core Intel Xeon Gold 6248 2.5GHz processors, 192 gigabytes of 2933MHz DDR4 RAM, 1TB disk, and an Intel OmniPath network. Expansion nodes have two Hyperthreads available.

These are arranged in two 32-node CUs (a and b) and four 36-node CUs (c to f). Jobs are restricted to running either within a CU (all nodes connected to the same switch) or across CUs using only the bottom third of nodes attached to each switch. This approximates 1:1 blocking on a cluster that does not have it.

## Maximum job resources on Michael expansion

Please consider that Michael's A-type nodes have 40 physical cores - 2 nodes is 80 cores. Jobs do not share nodes, so although asking for 41 cores is possible, it means you are wasting the other 39 cores on your second node!

| Cores    | Max. Duration |
|:--------:|:-------------:|
| 2800     | 48h           |

These are numbers of physical cores: multiply by two for virtual cores with hyperthreads.

## Hyperthreading

The A-type nodes have hyperthreading enabled and you can choose on a per-job basis whether you want to use it.

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


## Choosing node types

Given the difference in core count on the original and expansion Michael nodes, we strongly suggest you always specify which type of node you intend your job to run on, to avoid unintentionally wasting cores if your total number does not cleanly fit on that node size.

The old nodes are K-type while the new nodes with hyperthreading are A-type. Jobs never run across a mix of node types - it will be all K nodes or all A nodes.

To specify node type in your jobscript, add either:
```
# run on original 24-core nodes
#$ -ac allow=K
```
or
```
# run on expansion 40-core hyperthread-enabled nodes
#$ -ac allow=A
```


### Queue names

On Michael, users do not submit directly to queues - the scheduler
assigns your job to one based on the resources it requested. The queues
have somewhat unorthodox names as they are only used internally, and do
not directly map to particular job types.

### Preventing a job from running cross-CU

If your job must run within a single CU, you can request the parallel environment as `-pe wss` instead of `-pe mpi` (`wss` standing for 'wants single switch'). This will increase your queue times. It is suggested you only do this for benchmarking or if performance is being greatly affected by running in the superqueue.


## Disk quotas

You have per-user quotas for home and Scratch.

  - home: 100G quota, backed up, no increases available
  - Scratch: 250G quota by default, not backed up, increases possible

  - `lquota` shows you your quota and total usage (twice).
  - `request_quota` is how you request a quota increase.

If you go over quota, you will no longer be able to create new files and your jobs will fail as they cannot write.

Quota increases may be granted without further approval, depending on size and how full the filesystem is. Otherwise they may need to go to the Michael User Group for approval.

## Budgets and allocations

We have enabled Gold for allocation management. Jobs that are run under
a project budget have higher priority than free non-budgeted jobs. All
jobs need to specify what project they belong to, whether they are paid
or free.

To see the name of your project(s) and how much allocation that budget
has, run the command `budgets`.

```
$ budgets  
Project      Machines Balance
--------     -------- --------
Faraday_Test ANY      22781.89
```

### Submitting a job under a project

To submit a paid job that will take Gold from a particular project
budget, add this to your jobscript:

```
#$ -P Gold
#$ -A MyProject
```

To submit a free job that will not use up any Gold, use this instead:

```
#$ -P Free
#$ -A MyProject
```

You can also submit testing jobs that will not use up any Gold, and will
have higher priority than normal free jobs, but are limited to 2 nodes
(48 cores) and 1 hour of
walltime:

```
#$ -P Test
#$ -A MyProject
```

#### Troubleshooting: Unable to verify membership in policyjsv project

```
Unable to run job: Rejected by policyjsv
Unable to verify membership of `<username>` in the policyjsv project
```

You asked for a Free job but didn't specify `#$ -A MyProject` in your
jobscript.

#### Troubleshooting: Unable to verify membership in project / Uninitialized value

```
Unable to run job: Rejected by policyjsv  
Reason:Unable to verify sufficient material worth to submit this job:  
Unable to verify membership of mmmxxxx in the UCL_Example project
```

This error from `qsub` can mean that you aren't in the project you are trying to submit to, but also happens when the Gold daemon is not running.           

```
Use of uninitialized value in print at /opt/gold/bin/mybalance line 60, <GBALANCE> line 1.
Failed sending message: (Unable to connect to socket (Connection refused)).
```

If you also get this error from the `budgets` command, then the Gold daemon is definitely not running and you should contact rc-support.

### Gold charging

When you submit a job, it will reserve the total number of core hours
that the job script is asking for. When the job ends, the Gold will move
from 'reserved' into charged. If the job doesn't run for the full time
it asked for, the unused reserved portion will be refunded after the job
ends. You cannot submit a job that you do not have the budget to
run.

#### Gold costs of A-type nodes

The A-type nodes have twice the peak theoretical performance of the K-type nodes. A 24-core job lasting an hour costs 24 Gold on the K-type nodes. A 40-physical-core job lasting one hour costs 80 Gold on the A-type nodes. An 80-virtual-core job on the A-type nodes also costs 80 Gold.

#### Troubleshooting: Unable to verify sufficient material worth

```
Unable to run job: Rejected by policyjsv
Reason:Unable to verify sufficient material worth to submit this job:
Insufficient balance to reserve job
```

This means you don't have enough Gold to cover the
cores\*wallclock time cost of the job you are trying to submit. You need
to wait for queued jobs to finish and return unused Gold to your
project, or submit a smaller/shorter job. Note that array jobs have to
cover the whole cost of all the tasks at submit time.

### Job deletion

If you `qdel` a submitted Gold job, the reserved Gold will be made
available again. This is done by a cron job that runs every 15 minutes,
so you may not see it back instantly.

### Reporting Gold usage

There are a few commands that everyone can run that report Gold usage for
their entire project, broken down by user. See 
[Reporting from Gold](../Supplementary/Points_of_Contact.md#reporting-from-gold).

## Support

Email <rc-support@ucl.ac.uk> with any support queries. It will be helpful
to include Michael in the subject along with some descriptive text about
the type of problem, and you should mention your username in the body.

## Acknowledging the use of Michael in publications

 To acknowledge this facility please include the following test in presentations 
 and papers: "used the Michael Supercomputer (FIRG030)."

