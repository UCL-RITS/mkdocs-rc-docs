---
title: MMM Hub Young
layout: cluster
---
Young is the UK National Tier 2 High Performance Computing Hub in
Materials and Molecular Modelling, and replacement for Thomas. 
Young went into pilot on 3 Aug 2020.

## Applying for an account

Young accounts belong to you as an individual and are applied for
through your own institution's [Point of Contact](https://mmmhub.ac.uk/thomas).
You will need to supply an SSH public key, which is the only method used to log in.

## Creating an ssh key pair

An ssh key consists of a public and a private part, typically named
`id_rsa` and `id_rsa.pub` by default. The public part is what we need. You
must not share your private key with anyone else. You can copy it onto
multiple machines belonging to you so you can log in from all of them
(or you can have a separate pair for each machine).

### Creating an ssh key in Linux/Unix/Mac OS X

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
pick SSH-1** as that is a very old and insecure key type. As above, DSA is no 
longer accepted. The key must be at least 2048-bit.

If you are using Windows 10, then you probably have OpenSSH installed and could instead run ssh-keygen in a terminal per the Linux instructions and use the ssh command to log in instead of PuTTY. 

## Information for Points of Contact

Points of Contact have some tools they can use to manage users and
allocations, documented at [MMM Points of Contact](../Supplementary/Points_of_Contact.md).

## Logging in

You will be assigned a personal username and your SSH key pair will be
used to log in. External users will have a username in the form
`mmmxxxx` (where `xxxx` is a number) and UCL users will use their central username.

You ssh directly to:

```
young.rc.ucl.ac.uk
```

### SSH timeouts

Idle ssh sessions will be disconnected after 7 days.

## Using the system

Young is a batch system. The login nodes allow you to manage your
files, compile code and submit jobs. Very short (\<15mins) and
non-resource-intensive software tests can be run on the login nodes, but
anything more should be submitted as a job.

### Full user guide

Young has the same user environment as RC Support's other clusters, so
the [User guide](../index.md) is relevant and is a
good starting point for further information about how the environment
works. Any variations that Young has should be listed on this page.

### Submitting a job

Create a [jobscript](../Example_Jobscripts.md) for
non-interactive use and 
[submit your jobscript using qsub](../howto.md#how-do-i-submit-a-job-to-the-scheduler). 
Jobscripts must begin `#!/bin/bash -l` in order to run as a login shell 
and get your login environment and modules.

A job on Young must also specify what type of job it is (Gold, Free,
Test) and the project it is being submitted for. 
(See [Budgets and allocations](#budgets-and-allocations) below.)

#### Memory requests

Note: the memory you request is always per core, not the total amount.
If you ask for 192GB RAM and 40 cores, that may run on 40 nodes using
only one core per node. This allows you to have sparse process placement
when you do actually need that much RAM per process.

Young also has [high memory nodes](#node-types), where a job like this may run.

### Monitoring a job

In addition to [qstat](../howto.md#how-do-i-monitor-a-job), `nodesforjob
$JOB_ID` can be useful to see what proportion of cpu/memory/swap is
being used on the nodes a certain job is running on.

`qexplain $JOB_ID` will show you the full error for a job that is in
`Eqw` status.

### Useful utilities

As well as `nodesforjob`, there are the following utilities which can
help you find information about your jobs after they have run.

  - `jobhist` - shows your job history for the last 24hrs by default,
    including start and end times and the head node it ran on. You can
    view a longer history by specifying `--hours=100` for example.
  - `scriptfor $JOB_ID` - show the script that was submitted for the
    given job.

These utilities live in GitHub at
<https://github.com/UCL-RITS/go-clustertools> and
<https://github.com/UCL-RITS/rcps-cluster-scripts>

## Software

Young mounts the [RC Systems software stack](../../Installed_Software_Lists/General_Software_Lists).

Have a look at [Software Guides](../../Software_Guides/Other_Software) for specific
information on running some applications, including example scripts. The
list there is not exhaustive. 

Access to software is managed through the use of modules.

  - `module avail` shows all modules available.
  - `module list` shows modules currently loaded.

Access to licensed software may vary based on your host institution and
project.

### Loading and unloading modules

Young has a newer version of `modulecmd` which tries to manage module
dependencies automatically by loading or unloading prerequisites for you 
whenever possible.

If you get an error like this:

```
[uccaxxx@login01 ~]$ module unload compilers mpi
Unloading compilers/intel/2018/update3
  ERROR: compilers/intel/2018/update3 cannot be unloaded due to a prereq.
    HINT: Might try "module unload default-modules/2018" first.

Unloading mpi/intel/2018/update3/intel
  ERROR: mpi/intel/2018/update3/intel cannot be unloaded due to a prereq.
    HINT: Might try "module unload default-modules/2018" first.
```

You can use the `-f` option to force the module change. It will carry it out 
and warn you about modules it thinks are dependent.

```
[uccaxxx@login01 ~]$ module unload -f compilers mpi
Unloading compilers/intel/2018/update3
  WARNING: Dependent default-modules/2018 is loaded

Unloading mpi/intel/2018/update3/intel
  WARNING: Dependent default-modules/2018 is loaded
```

### Requesting software installs

To request software installs, email us at the [support address below](#Support) or open an issue on our
[GitHub](https://github.com/UCL-RITS/rcps-buildscripts/issues). You can
see what software has already been requested in the Github issues and
can add a comment if you're also interested in something already
requested.

### Installing your own software

You may install software in your own space. Please look at
[Compiling](Compiling) for tips.

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

  - **CASTEP**: You/your group leader need to have 
    [signed up for a CASTEP license](http://www.castep.org/CASTEP/GettingCASTEP).
    Send us an acceptance email, or we can ask them to verify you have a
    license. You will then be added to the reserved application group
    `lgcastep`. If you are a member of UKCP you are already covered by a
    license and just need to tell us when you request access.
  - **CRYSTAL**: You/your group leader need to have signed up for an
    Academic license. Crystal Solutions will send an email saying an
    account has been upgraded to "Academic UK" - forward that to us
    along with confirmation from the group leader that you should be in
    their group. You will be added to the `legcryst` group.
  - **DL\_POLY**: has individual licenses for specific versions.
    [Sign up at DL\_POLY's website](http://www.scd.stfc.ac.uk//research/app/ccg/software/DL_POLY/40526.aspx)
    and send us the acceptance email they give you. We will add you to
    the appropriate version's reserved application group, eg `lgdlp408`.
  - **Gaussian**: not currently accessible for non-UCL institutions. UCL
    having a site license and another institute having a site license
    does not allow users from the other institute to run Gaussian on
    UCL-owned hardware.
  - **VASP**: When you request access you need to send us the name and
    email of the main VASP license holder along with the license number.
    We will then ask VASP if we can add you, and on confirmation can do
    so. We will add you to the `legvasp` reserved application group. You
    may also install your own copy in your home, and we provide a simple
    [build script on Github](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/vasp_individual_install)
    (tested with VASP 5.4.4, no patches). You need to download the VASP
    source code and then you can run the script following the
    instructions at the top.
  - **Molpro**: Only UCL users are licensed to use our central copy and 
    can request to be added to the `lgmolpro` reserved application group.

## Suggested job sizes

The target job sizes for Young are 2-5 nodes. Jobs
larger than this may have a longer queue time and are better suited to
ARCHER, and single node jobs may be more suited to your local
facilities.

## Maximum job resources

| Cores | Max wallclock |
| ----- | ------------- |
| 5120   | 48hrs         |

These are numbers of physical cores: multiply by two for virtual cores 
with [hyperthreads](#hyperthreading).

On Young, interactive sessions using qrsh have the same wallclock limit
as other jobs.

Jobs on Young **do not share nodes**. This means that if you request
less than 40 cores, your job is still taking up an entire node and no
other jobs can run on it, but some of the cores are idle. Whenever
possible, request a number of cores that is a multiple of 40 for full
usage of your nodes.

There is a superqueue for use in exceptional circumstances that will
allow access to a larger number of cores outside the nonblocking
interconnect zones, going across the interconnect between blocks. A
third of each CU is accessible this way, roughly approximating a 1:1
connection. Access to the superqueue for larger jobs must be applied
for: contact the support address below for details.

Some normal multi-node jobs will use the superqueue - this is to make it
easier for larger jobs to be scheduled, as otherwise they can have very
long waits if every CU is half full.


### Preventing a job from running cross-CU

If your job must run within a single CU, you can request the parallel environment as `-pe wss` instead of `-pe mpi` (`wss` standing for 'wants single switch'). This will increase your queue times. It is suggested you only do this for benchmarking or if performance is being greatly affected by running in the superqueue.

[ back to top](#top "wikilink")

## Node types

Young has three types of node: standard nodes, big memory nodes, and really 
big memory nodes. Note those last have only 36 cores per node, not 40.

| Type  | Cores per node | RAM per node | tmpfs | Nodes |
| ----- | -------------- | ------------ | ----- | ----- |
| C     | 40             | 192G         | None  | 576   |
| Y     | 40             | 1.5T         | None  | 3     |
| Z     | 36             | 3.0T         | None  | 3     |

These are numbers of physical cores: multiply by two for virtual cores with
hyperthreading. 

### Restricting to one node type

The scheduler will schedule your job on the relevant nodetype 
based on the resources you request, but if you really need to specify 
the nodetype yourself, use:

```
# Only run on Z-type nodes
#$ -ac allow=Z
```

## Hyperthreading

Young has hyperthreading enabled and you can choose on a per-job basis 
whether you want to use it.

Hyperthreading lets you use two virtual cores instead of one physical 
core - some programs can take advantage of this.

If you do not ask for hyperthreading, your job only uses one thread per core as normal.

```
# request hyperthreading in this job
#$ -l threads=1

# request the number of virtual cores
#$ -pe mpi 160

# set number of OpenMP threads being used per MPI process
export OMP_NUM_THREADS=2
```

This job would be using 80 physical cores, using 80 MPI processes each of 
which would create two threads (on Hyperthreads).

```
# request hyperthreading in this job
#$ -l threads=1

# request the number of virtual cores
#$ -pe mpi 160

# set number of OpenMP threads being used per MPI process
# (a whole node's worth)
export OMP_NUM_THREADS=80
```

This job would still be using 80 physical cores, but would use one MPI 
process per node which would create 80 threads on the node (on Hyperthreads).

## Diskless nodes

Young nodes are diskless (have no local hard drives) - there is no `$TMPDIR` 
available, so you should not request `-l tmpfs=10G` in your 
jobscripts or your job will be rejected at submit time.

If you need temporary space, you should use somewhere in your Scratch.


## Disk quotas

You have one per-user quota, with a default amount of 250GB - this is the total across home and Scratch.

  - `lquota` shows you your quota and total usage (twice).
  - `request_quota` is how you request a quota increase.

If you go over quota, you will no longer be able to create new files and your jobs will fail as they cannot write.

Quota increases may be granted without further approval, depending on size and how full the 
filesystem is. Otherwise they may need to go to the MMM Hub User Group for approval.

[ back to top](#top "wikilink")


## Budgets and allocations

We have enabled Gold for allocation management. Jobs that are run under
a project budget have higher priority than free non-budgeted jobs. All
jobs need to specify what project they belong to, whether they are paid
or free.

To see the name of your project(s) and how much allocation that budget
has, run the command `budgets`.

```
budgets  
Project  Machines Balance   
-------- -------- --------  
UCL_Test ANY      22781.89

```

Pilot users temporarily have access to a project for their institution,
eg. Imperial\_pilot. These will be deactivated after the pilot and no 
longer show up.

!!! info
    1 Gold unit is 1 hour of using 1 virtual processor core (= 0.5 physical core).

Since Young has [hyperthreading](#hyperthreading), a job asking for 40 
physical cores and one asking for 80 virtual cores with hyperthreading 
on both cost the same amount: 80 Gold.


### Subprojects

You might be in a subproject that does not itself have an allocation,
but instead takes allocation from a different project:

```
Project       Machines Balance
--------      -------- --------
UCL_physM        ANY   474999.70  
UCL_physM_Bowler ANY        0.00
```

In this case, you submit jobs using the subproject (`UCL_physM_Bowler`
here) even though it says it has 0 budget and it takes Gold from the
superproject.

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

#### Troubleshooting: Unable to verify sufficient material worth

```
Unable to run job: Rejected by policyjsv
Reason:Unable to verify sufficient material worth to submit this job:
Insufficient balance to reserve job
```

This means you don't have enough Gold to cover the
cores ⨉ wallclock time cost of the job you are trying to submit. You need
to wait for queued jobs to finish and return unused Gold to your
project, or submit a smaller/shorter job. Note that array jobs have to
cover the whole cost of all the tasks at submit time.

### Job deletion

If you `qdel` a submitted Gold job, the reserved Gold will be made
available again. This is done by a cron job that runs every 15 minutes,
so you may not see it back instantly.


## Support

Email <rc-support@ucl.ac.uk> with any support queries. It will be helpful
to include Young in the subject along with some descriptive text about
the type of problem, and you should mention your username in the body.


