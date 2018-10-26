---
title: Michael
categories:
 - Michael
 - Tier 2
layout: docs
---
Michael is an extension to the UCL-hosted Hub for Materials and
Molecular Modelling, an EPSRC-funded Tier 2 system providing large scale
computation to UK researchers; and delivers computational capability for
the Faraday Institution, a national institute for electrochemical energy
storage science and technology.

## Applying for an account

Michael accounts belong to you as an individual and are applied for via
David Scanlon who is the point of contact for Michael.

You will need to supply an SSH public key, which is the only method used
to log in.

## Creating an ssh key pair

An ssh key consists of a public and a private part, typically named
id\_rsa and id\_rsa.pub by default. The public part is what we need. You
must not share your private key with anyone else. You can copy it onto
multiple machines belonging to you so you can log in from all of them
(or you can have a separate pair for each machine).

### Creating an ssh key in Linux/Unix/Mac OS X

```
ssh-keygen -t rsa
```

The defaults should give you a reasonable key. If you prefer to use
ECDSA or ED25519 instead, and longer keys, you can. You can also tell it
to create one with a different name, so it doesn't overwrite any
existing key.

  - We strongly suggest you not use DSA as OpenSSH 7.0 has deprecated it
    and does not use it by default on client or server. Michael
    currently accepts them but that may change.

You will be asked to add a passphrase for your key. A blank passphrase
is not recommended; if you use one please make sure that no one else
ever has access to your local computer account. How often you are asked
for a passphrase depends on how long your local ssh agent keeps it.

You may need to run `ssh-add` to add the key to your agent so you can
use it. If you aren't sure what keys your agent can see, running
`ssh-add -L` will show all the public parts of the keys it is aware of.

## Creating an ssh key in Windows

Have a look at [Key-Based SSH Logins With PuTTY](https://www.howtoforge.com/ssh_key_based_logins_putty) which has
step-by-step instructions. You can choose whether to use Pageant or not
to manage your key. You can again pick RSA, DSA, ECDSA etc **but do not
pick SSH-1** as that is a very old and insecure key type.

## Information for Points of Contact

Points of Contact have some tools they can use to manage users and
allocations, documented at [Points of
Contact](Points_of_Contact "wikilink").

## Logging in

You will be assigned a personal username and your SSH key pair will be
used to log in. External users will have a username in the form
`mmmxxxx` and UCL users will use their central username.

You connect with ssh directly to:

```
michael.rc.ucl.ac.uk
```

## SSH timeouts

Idle ssh sessions will be disconnected after 7 days.

# Using the system

Michael is a batch system. The login nodes allow you to manage your
files, compile code and submit jobs. Very short (\<15mins) and
non-resource-intensive software tests can be run on the login nodes, but
anything more should be submitted as a job.

## Full user guide

Michael has the same user environment as RC Support's other clusters, so
the [User Guide](User Guide) is relevant and is a
good starting point for further information about how the environment
works. Any variations that Michael has should be listed on this page.

## Submitting a job

Create a [job script](Example_Submission_Scripts) for
non-interactive use and submit it using
[qsub](Batch_Processing). Jobscripts must begin `#!/bin/bash
-l` in order to run as a login shell and get your login environment and
modules.

A job on Michael must also specify what type of job it is (Gold, Free,
Test) and the project it is being submitted for. (See [Budgets and allocations](#Budgets_and_allocations) below).

### Memory requests

Note: the memory you request is always per core, not the total amount.
If you ask for 128G RAM and 24 cores, that will run on 24 nodes using
only one core per node. This allows you to have sparse process placement
when you do actually need that much RAM per process.

## Monitoring a job

In addition to [qstat](Batch_Processing), `nodesforjob
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
<https://github.com/UCL-RITS/go-clustertools> and
<https://github.com/UCL-RITS/rcps-cluster-scripts>

# Software

Michael mounts the [RC Systems software stack](Software).

Have a look at [Applications](Applications) for specific
information on running some applications, including example scripts. The
list there is not exhaustive.

Access to software is managed through the use of modules.

  - `module avail` shows all modules available.
  - `module list` shows modules currently loaded.

Access to licensed software may vary based on your host institution and
project.

## Requesting software installs

To request software installs, email us at the [support address
below](#Support) or open an issue on our
[GitHub](https://github.com/UCL-RITS/rcps-buildscripts/issues). You can
see what software has already been requested in the Github issues and
can add a comment if you're also interested in something already
requested.

## Installing your own software

You may install software in your own space. Please look at
[Compiling](Compiling) for tips.

## Maintaining a piece of software for a group

It is possible for people to be given central areas to install software
that they wish to make available to everyone or to a select group -
generally because they are the developers or if they wish to use
multiple versions or developer versions. The people given install access
would then be responsible for managing and maintaining these installs.

## Licensed software

Reserved application groups exist for software that requires them. The
group name will begin with `leg` or `lg`. After we add you to one of
these groups, the central group change will happen overnight. You can
check your groups with the `groups` command.

Please let us know your username when you ask to be added to a group.

  - **CASTEP**: You/your group leader need to have [signed up for a CASTEP license](http://ccpforge.cse.rl.ac.uk/gf/project/castep/).
    Send us an acceptance email, or we can ask them to verify you have a
    license. You will then be added to the reserved application group
    `lgcastep`. If you are a member of UKCP you are already covered by a
    license and just need to tell us when you request access.
  - **CRYSTAL**: You/your group leader need to have signed up for an
    Academic license. Crystal Solutions will send an email saying an
    account has been upgraded to "Academic UK" - forward that to us
    along with confirmation from the group leader that you should be in
    their group. You will be added to the `legcryst` group.
  - **DL\_POLY**: has individual licenses for specific versions. [Sign up at DL\_POLY's website](http://www.scd.stfc.ac.uk//research/app/ccg/software/DL_POLY/40526.aspx)
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

## Suggested job sizes

The target job sizes for Michael are 48-120 cores (2-5 nodes). Jobs
larger than this may have a longer queue time and are better suited to
ARCHER, and single node jobs may be more suited to your local
facilities.

## Maximum job resources

| Cores | Max wallclock |
| ----- | ------------- |
| 864   | 48hrs         |
|       |               |

On Michael, interactive sessions using qrsh have the same wallclock
limit as other jobs.

Nodes in Michael are 24 cores, 128GB RAM. The default maximum jobsize is
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

### Troubleshooting: Unable to verify membership of username in the policyjsv project

```
Unable to run job: Rejected by policyjsv
Unable to verify membership of `<username>` in the policyjsv project
```

You asked for a Free job but didn't specify `#$ -A MyProject` in your
jobscript.

## Gold charging

When you submit a job, it will reserve the total number of core hours
that the job script is asking for. When the job ends, the Gold will move
from 'reserved' into charged. If the job doesn't run for the full time
it asked for, the unused reserved portion will be refunded after the job
ends. You cannot submit a job that you do not have the budget to
run.

### Troubleshooting: Unable to verify sufficient material worth to submit this job

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

## Support

Email <rc-support@ucl.ac.uk> with any support queries. It will be helpful
to include Michael in the subject along with some descriptive text about
the type of problem, and you should mention your username in the body.

