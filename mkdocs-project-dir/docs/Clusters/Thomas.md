---
title: MMM Thomas
layout: cluster
---
Thomas is the UK National Tier 2 High Performance Computing Hub in
Materials and Molecular Modelling.

!!! important "Thomas end of life"
    The Thomas cluster is being retired. Notable dates are:
     
    - **Monday 1 March 2021**: Job submission will be switched off this morning. Jobs 
      already in the queue may still run. Access to the login nodes will remain for 
      one month so you can retrieve data.
    - **Friday 5 March 2021**: Queues will be drained. Any jobs left will never run. 
    - **Thursday 1 April 2021**: Access to the login nodes will be removed and 
      all data will be deleted.

    Thomas has now been retired as an MMM Hub machine.
    A portion of Thomas is running for UCL users only until the end of 2021.
    7 June 2021: Thomas is now inside the UCL firewall, use VPN, Socrates or ssh.rc.ucl.ac.uk

## Applying for an account

UCL users can contact David Scanlon or Scott Woodley for access to 
the post-retirement portion of Thomas.

Thomas accounts belong to you as an individual and are applied for
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
thomas.rc.ucl.ac.uk
```

### SSH timeouts

Idle ssh sessions will be disconnected after 7 days.

## Using the system

Thomas is a batch system. The login nodes allow you to manage your
files, compile code and submit jobs. Very short (\<15mins) and
non-resource-intensive software tests can be run on the login nodes, but
anything more should be submitted as a job.

### Full user guide

Thomas has the same user environment as RC Support's other clusters, so
the [User guide](../index.md) is relevant and is a
good starting point for further information about how the environment
works. Any variations that Thomas has should be listed on this page.

### Submitting a job

Create a [jobscript](../Example_Jobscripts.md) for
non-interactive use and 
[submit your jobscript using qsub](../howto.md#how-do-i-submit-a-job-to-the-scheduler). 
Jobscripts must begin `#!/bin/bash -l` in order to run as a login shell 
and get your login environment and modules.

Jobs no longer need to specify what type of job it is (Gold, Free,
Test) or the project it is being submitted for. 
(See [Budgets and allocations](#budgets-and-allocations) below.)

#### Memory requests

Note: the memory you request is always per core, not the total amount.
If you ask for 128GB RAM and 24 cores, that will run on 24 nodes using
only one core per node. This allows you to have sparse process placement
when you do actually need that much RAM per process.

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

Thomas mounts the [RC Systems software stack](../../Installed_Software_Lists/General_Software_Lists).

Have a look at [Software Guides](../../Software_Guides/Other_Software) for specific
information on running some applications, including example scripts. The
list there is not exhaustive. 

Access to software is managed through the use of modules.

  - `module avail` shows all modules available.
  - `module list` shows modules currently loaded.

Access to licensed software may vary based on your host institution and
project.

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
  - **VASP**: When you request access you need to send us the email
    address you are named on a VASP license using. You can also send 
    name and email of the main VASP license holder along with the license 
    number if you wish. We will then check in the VASP portal if we can 
    add you. We will add you to the `legvasp5` or `legvasp6` reserved 
    application groups depending on which versions you are licensed for. 
    You may also install your own copy in your home, and we provide a simple
    [build script on Github](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/vasp_individual_install)
    (tested with VASP 5.4.4, no patches). You need to download the VASP
    source code and then you can run the script following the
    instructions at the top.
  - **Molpro**: Only UCL users are licensed to use our central copy and 
    can request to be added to the `lgmolpro` reserved application group.

## Suggested job sizes

The target job sizes for Thomas are 48-120 cores (2-5 nodes). Jobs
larger than this may have a longer queue time and are better suited to
ARCHER, and single node jobs may be more suited to your local
facilities.

## Maximum job resources

| Cores | Max wallclock |
| ----- | ------------- |
| 864   | 48hrs         |

On Thomas, interactive sessions using qrsh have the same wallclock limit
as other jobs.

Nodes in Thomas are 24 cores, 128G RAM. The default maximum jobsize is
864 cores, to remain within the 36-node 1:1 nonblocking interconnect
zones.

Jobs on Thomas **do not share nodes**. This means that if you request
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

### Queue names

On Thomas, users do not submit directly to queues - the scheduler
assigns your job to one based on the resources it requested. The queues
have somewhat unorthodox names as they are only used internally, and do
not directly map to particular job types.

### Preventing a job from running cross-CU

If your job must run within a single CU, you can request the parallel environment as `-pe wss` instead of `-pe mpi` (`wss` standing for 'wants single switch'). This will increase your queue times. It is suggested you only do this for benchmarking or if performance is being greatly affected by running in the superqueue.

[ back to top](#top "wikilink")

## Node types

Thomas has one type of node.

| Type  | Cores per node | RAM per node | tmpfs | Nodes |
| ----- | -------------- | ------------ | ----- | ----- |
| K     | 24             | 128G         | 100G  | 705   |

Here are the processors each node type has:

  -  K: Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz

(If you ever need to check this, you can include `cat /proc/cpuinfo` in your jobscript so 
you get it in your job's .o file for the exact node your job ran on. You will get an entry
for every core).

## Disk quotas

Quotas were enabled on Thomas on 29 May 2019. You have one per-user quota, with a default amount of 250GB - this is the total across home and Scratch.

  - `lquota` shows you your quota and total usage (twice).
  - `request_quota` is how you request a quota increase.

If you go over quota, you will no longer be able to create new files and your jobs will fail as they cannot write.

Quota increases may be granted without further approval, depending on size and how full the filesystem is. Otherwise they may need to go to the Thomas User Group for approval.

[ back to top](#top "wikilink")


## Budgets and allocations

There is no more Gold on Thomas. Jobs should now be submitted without specifying
any `-P` or `-A` entries in your jobscript.

!!! info
    1 Gold unit is 1 hour of using 1 processor core.


#### Troubleshooting: Unable to verify membership in project / Uninitialized value

```
Unable to run job: Rejected by policyjsv 
Reason:Unable to verify sufficient material worth to submit this job: 
Unable to verify membership of mmmxxxx in the UCL_Example project
```

This error from `qsub` can mean that you aren't in the project you are trying to 
submit to, but also happens when the Gold daemon is not running. 

Remove the `-P` and `-A` lines from your jobscript and submit jobs without any
project specified.

```
Use of uninitialized value in print at /opt/gold/bin/mybalance line 60, <GBALANCE> line 1.
Failed sending message: (Unable to connect to socket (Connection refused)).
```

The Gold database is uncontactable.

Remove the `-P` and `-A` lines from your jobscript and submit jobs without any
project specified.


## The Tier 2 SAFE

SAFE is a service administration platform used by ARCHER and various of the Tier 2 sites. As a user, you can use it to do some management of your details and view your usage across all systems that send data to SAFE.

### See your usage data in SAFE

If you wish, you can claim your Thomas account as belonging to you in the Tier 2 SAFE. This lets you view some individual usage reports, and if you have other Tier 2 accounts that also use SAFE, you use the same login information.

* You need to login at https://safe.epcc.ed.ac.uk or create a new Tier2 SAFE account if you do not have one.
    * If creating a new account, you will be asked to create a password - this is for the SAFE login only and has no link to your Thomas account.
* On Thomas, run `hashclaim`. This will give you a link to claim your Thomas username's usage data.
* Visit this link when logged in to SAFE and it will tell you this account has been added to your SAFE account, and username@Thomas will now be visible in the 'Login accounts' menu at the top.
* Choosing that account will take you to a page where you can view your individual usage reports.

If you do not claim your account, then SAFE only contains username/job usage information with no information about who owns that username. Points of Contact can use it to allocate Gold to your budgets.

### Update your SSH key via SAFE

SAFE also gives you a second mechanism for changing your SSH key - changing the key you have associated with your SAFE account will automatically create a request for us to add that key to your Thomas account. (We still need to act on it, so it won't update immediately).

## Support

Email <rc-support@ucl.ac.uk> with any support queries. It will be helpful
to include Thomas in the subject along with some descriptive text about
the type of problem, and you should mention your username in the body.

## Notional costs

EPSRC contributed to the hardware, so there are two numbers to use for notional costs:

* Cost per core hour excluding hardware (to be charged on EPSRC grants): 0.6 pence / core hour
* Cost per core hour including hardware cost (to be charged on non-EPSRC grants): 1.5 pence / core hour

Non-grant-funded projects should use the second figure.

## Acknowledging the use of Thomas in publications

All work arising from this facility should be properly acknowledged in
presentations and papers with the following text:

"We are grateful to the UK Materials and Molecular Modelling Hub for
computational resources, which is partially funded by EPSRC
(EP/P020194/1 and EP/T022213/1)"

### MCC

When publishing work that benefited from resources allocated by the MCC:
please include the following acknowledgment:

"Via our membership of the UK's HEC Materials Chemistry Consortium,
which is funded by EPSRC (EP/L000202), this work used the UK Materials
and Molecular Modelling Hub for computational resources, MMM Hub, which
is partially funded by EPSRC (EP/P020194 and EP/T022213)"

### UKCP

When publishing work that benefited from 
[resources allocated by UKCP](http://www.ukcp.ac.uk/pmwiki.php/UKCP/Acknowledgement),
please include:

"We are grateful for computational support from the UK Materials and
Molecular Modelling Hub, which is partially funded by EPSRC
(EP/P020194 and EP/T022213), for which access was obtained via the UKCP 
consortium and funded by EPSRC grant ref EP/P022561/1"

