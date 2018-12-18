---
title: Managing Data on RC Systems
categories:
 - Legion
 - Pages with bash scripts
 - User Guide
layout: docs
---
# Managing Data on Research Computing Systems

This section contains information about storage hierarchy in RC systems
and the ways in which you can move data in and out of them.

These services should not be used to store data for which you have
obligations under the UK Data Protection Act 1998. For further
information and advice, please see:

<http://www.ico.org.uk/for_organisations/data_protection/the_guide>

At some point, you are going to need to copy input files on to our
systems and copy your results back to your local machine or to a backup
elsewhere. (It is good practice to always make your own backups). First
we give generic instructions for doing so - do also check the
machine-specific information on this page for details about things like
dedicated transfer nodes, different file storage areas and quotas.

## Copying files using Linux or Mac OS X

You can use the command-line utilities scp, sftp or rsync to copy your
data about.

Note that as our systems use Linux, you can use these instructions to
copy data between systems (e.g. from Legion to Myriad) as well as from
your own computer to a system.

### scp

This will copy a data file from somewhere on your local machine to a
specified location on the remote
machine.

```
scp <local_data_file> <remote_user_id>@<remote_hostname>:<remote_path>
```

This will do the reverse, copying from the remote machine to your local
machine. (Run from your local
machine).

```
scp <remote_user_id>@<remote_hostname>:<remote_path><remote_data_file> <local_path>
```

To copy a whole directory with all its contents, use the `-r`
option:

```
scp -r <local_directory> <remote_user_id>@<remote_hostname>:<remote_path>
```

### sftp

You can use sftp to log in to the remote machine, navigate through
directories and use put and get to copy files from and to your local
machine. `lcd` and `lls` are local equivalents of `cd` and `ls` so you
can navigate through your local directories as you go.

```
sftp <remote_user_id>@<remote_hostname>  
cd <remote_path>  
get <remote_file>  
lcd <local_path>  
put <local_file>
```

### rsync

Rsync is used to remotely synchronise directories, so can be used to
only copy files which have changed. Have a look at the man pages as
there are many options.

## Copying files using Windows and WinSCP

WinSCP is a graphical client that you can use for scp or sftp.

1.  The login/create new session screen will open if this is the first
    time you are using WinSCP.
2.  You can choose SFTP or SCP as the file protocol. If you have an
    unstable connection with one, you may wish to try the other. SCP is
    probably generally better.
3.  Fill in the hostname of the machine you wish to connect to, your
    username and password.
4.  Click Save and give your settings a useful name.
5.  You'll then be shown your list of Stored sessions, which will have
    the one you just created.
6.  Select the session and click Login.

## Transferring files from outside the UCL firewall

To transfer files when you are outside UCL's network, you can use the
[IS VPN](http://www.ucl.ac.uk/isd/staff/network/vpn), which will allow
you to ssh directly into Legion or login05 as if you were inside the
network, without having to go via Socrates first.

If not using the VPN, you will need to do some form of ssh tunnelling -
read on.

## Single-step login on Linux or Mac OS X using tunnelling

Inside your `~/.ssh` directory on your local machine, add the below to
your config file (or create a file called config if you don't already
have one).

Generically, it should be of this form where <name> can be anything you
want to call this
entry.

```
Host <name>  
   User <your.username>  
   HostName <full.hostname>  
   proxyCommand ssh -W <full.hostname>:22 <your.username>@socrates.ucl.ac.uk
```

Here are some examples - you can have as many of these as you need in
your config
file.

```
Host legion  
   User <your.username>  
   HostName legion.rc.ucl.ac.uk  
   proxyCommand ssh -W legion.rc.ucl.ac.uk:22 <your.username>@socrates.ucl.ac.uk

Host login05  
   User <your.username>  
   HostName login05.external.legion.ucl.ac.uk  
   proxyCommand ssh -W login05.external.legion.ucl.ac.uk:22 <your.username>@socrates.ucl.ac.uk

Host aristotle  
   User <your.username>  
   HostName aristotle.rc.ucl.ac.uk  
   proxyCommand ssh -W aristotle.rc.ucl.ac.uk:22 <your.username>@socrates.ucl.ac.uk
```

You can now just do `ssh legion` or `scp aristotle` and you will go
through Socrates. You'll be asked for login details twice since you're
logging in to two machines. (Socrates uses central UCL credentials).

## Single-step login on Windows using tunnelling

WinSCP can also set up SSH tunnels.

1.  Create a new session as before, and tick the *Advanced options* box
    in the bottom left corner.
2.  Select *Connection \> Tunnel* from the left pane.
3.  Tick the *Connect through SSH tunnel* box and enter the hostname of
    the gateway you are tunnelling through, for example
    `socrates.ucl.ac.uk`
4.  Fill in your username and password for that host. (Central UCL ones
    for Socrates).
5.  Select *Session* from the left pane and fill in the hostname you
    want to end up on after the tunnel.
6.  Fill in your username and password for that host and set the file
    protocol to SCP.
7.  Save your settings with a useful name.

# Managing your quota

To check your quota, run the command `lquota`. (Note: not currently
available on Grace or Thomas - see below). Also useful is `du`, giving
you information about your disk usage. For example, `du -ch <dir>` 
will give you a summary of the sizes of directory tree and
subtrees, in human-readable sizes, with a total at the bottom. 
`du -h --max-depth=1` will show you the totals for all top-level directories
relative to where you are, plus the grand total. These can help you
track down the locations of large amounts of data if you need to reduce
your disk usage.

To check your quota on Grace and Thomas, please run `quota_check`. This
is part of the `userscripts` module which is loaded by default.

Quotas for Lustre storage on Legion are automatically checked: if you
use more than your quota for 14 days continuously, you will be prevented
from submitting more jobs.

We can increase quotas on-demand for small amounts, but for large
amounts of storage (typically ~1TB or larger), a request must be
submitted as described [on the "Additional Resource Requests" page](Additional_Resource_Requests).

Please contact <rc-support@ucl.ac.uk> for more information.

# Accessing Research Data Storage

To access data stored in Research Data Storage, you can use scp to
transfer data to/from the RC Services machine. Here is a guide on
[Connecting to Research Data Services](Connecting_to_Research_Data_Services "wikilink").

# Legion-specific information

To transfer your data to and from Legion in the most efficient manner,
you must have a basic understanding of the bandwidth limitations of the
machine.

The entire system is limited by a 10Gb ethernet connection to UCL's
network. If you find a significantly lower throughput, this may be
caused by a bottleneck along the path between Legion and the machine you
are trying to send the data to/from.

Login and compute nodes are individually connected to the network via
1Gb/s links. This means that the maximum theoretical throughput that you
can expect from any node in Legion is 125MB/s. Taking into account
protocol overheads, you should see a maximum throughput of around
100MB/s on each node.

For this reason we have to make the distinction between transferring
large and modest amounts of data.

## Transferring modest amounts of data

You can use Legion's login nodes to transfer modest amounts of data.

Please bear in mind that there is no limit on the number of users that
can be logged in to the Login nodes. Their activity may cause your data
transfer rates to drop (as yours may affect theirs). If you need to
transfer large amounts of data or need more reliable transfer rates, we
recommend that you do so within a batch job, as described in the
following section.

If you are running scp from your local machine, use
`legion.rc.ucl.ac.uk` as the hostname and you will transfer via the
login nodes.

## Dedicated transfer node

Legion provides a dedicated transfer node with ten gigabit network
connections to the UCL network and to Legion. To access this node, log
in via scp, sftp or ssh to:

```
login05.external.legion.ucl.ac.uk
```

Please note that you cannot submit or view the status of your compute
jobs on this node - it is only available for data transfer.

## Legion's storage architecture and hierarchy

Legion has three types of storage with distinct levels of performance,
volatility and reliability:

### Home directories ($HOME)

  - Smaller amount of storage
  - Backed up
  - Read-only access from compute nodes

This storage has currently a hard quota of 50GB per user. It is the most
reliable. But due to contention between several users it has very high
performance variability. You can read and write to it from the login
nodes, but only read access is granted from the compute nodes. The
rationale for this stems from the fact that it cannot withstand large
amounts of Input/Output such as that which happens within a large
cluster like Legion. This is also to make sure that only important data
is backed up as otherwise there would be excessive load on the backup
system both in terms of performance and capacity.

### Shared scratch area ($HOME/Scratch)

  - Larger storage
  - Not backed up
  - Writable by compute nodes

The `Scratch` entry in your home directory is a symbolic link to the Lustre file system attached to
Legion. This storage has very high throughput on individual files and
allows separate processes on different machines to open the same file
for I/O simultaneously. Due to its complexity, it performs very poorly
when handling large amounts of small files. For example, running the
“find” command on a directory within `$HOME/Scratch` has much poorer
performance than running in a directory stored under `$HOME`. Again, due
to its complexity, it is prone to failure and may have to be completely
reformatted if file system errors build up. Therefore, we give no
guarantee that data stored on this file system is safe and strongly
recommend that you save any important data as soon as possible to your
$HOME directory via login nodes or any other external backup storage.

Scratch and its underlying hardware are of vital importance for the good
operation of the cluster in terms of I/O performance. Because this
resource is scarce, the
[CRAG](http://www.ucl.ac.uk/isd/about/governance/research-it/crag) has
enforced usage quotas, to be reviewed monthly. The use of Scratch is now
subject to the following policies:

  - All users will be granted an initial Scratch quota. Users are free
    to work within this quota but should note that files stored in their
    Scratch directory are NOT backed up and should therefore be
    considered ‘at risk’.

  - Users may request increases in their Scratch quota by [submitting a
    form](https://wiki.rc.ucl.ac.uk/wiki/Legion_Priority_Access) to
    <rc-support@ucl.ac.uk>. They will be required to explain why they
    need an increase from a technical and computational point of view.

  - The Scratch quota will be implemented as a soft quota so users will
    be able to temporarily exceed their quota for a short period. This
    period is set to 14 days by default.

  - When a user exceeds their Scratch quota a warning is added to their
    Legion Message of the Day (MOTD) and an email is sent to their UCL
    email address. The warnings will display how much they are over
    quota, how long they have to reduce their usage and what will happen
    if they fail to reduce their usage.

  - While a user continues to use more than their Scratch quota
    subsequent warning emails will be sent by the system every day.

  - If a user reduces their usage of Scratch to below their quota within
    the 14 day grace period, no further action will be taken.

  - At the end of the 14 day grace period if a user hasn't reduced their
    Scratch usage to below their quota, the system will stop the user
    from submitting any jobs until their Scratch usage is below their
    quota.

  - In addition to user Scratch quotas there will be an overall limit on
    Lustre usage of 75% of total space, in order to ensure performance
    is maintained. If this limit is exceeded, ALL Legion users will be
    informed by email to their UCL email address of the risk to Lustre
    and requested to delete or move unwanted or currently unused files.

### Local node scratch area (`$TMPDIR`)

  - Only exists during your job
  - Fastest access as is local

This storage resides on the hard drive installed in the compute nodes.
It is only accessible temporarily throughout the duration of the job you
have submitted and only within each of the compute nodes assigned to
you. The path to this storage is set at run time in the `$TMPDIR`
environment variable. This variable is set only within a shell generated
by the SGE scheduler, and the path therein is unique to the node and job
you are running. Once your job has completed the `$TMPDIR` directory is
deleted on each node, so make sure that you have given enough wall clock
time to allow data to be transferred back to your scratch area. Note
that in parallel jobs running *N* slots (processes) only the main node (
slot 1 ) can be scripted as the remaining *N*-1 ones are just used to run
compute processes without shell interaction - this means that your
parallel program should only write to this local storage on process 1
(or 0, depending on the programming language). Users may automate the
transfer of data from $TMPDIR to their scratch area by adding the
directive `#Local2Scratch` to their job script.

The amount of space available in $TMPDIR is controlled on a per node
basis by the `#$ -l tmpfs` grid engine directive. This is to stop jobs
interfering with each other by running out of disk space. If this
directive is omitted from job scripts, then a default of 10 Gigabytes
per node will be allocated to the job. For example to request 15 GB
include the following in the job script: 

```
#$ -l tmpfs=15G
``` 

The following diagram illustrates how these various levels of storage
relate to login and compute nodes:

![Storage\_diagram.jpeg](Storage_diagram.jpeg "Storage_diagram.jpeg")

## Transferring files to or from Legion using a batch job

**Note: we recommend using the dedicated transfer node, as explained
above, to perform large transfers. This method should only be used if
the transfer node is unavailable for some reason.**

Using a batch job you can transfer multiple files or sections of a file
simultaneously via each compute node directly onto Lustre, maximising
the use of 10Gb/s link that connects Legion to the UCL network.

You can use the scp or sftp commands on Legion to do file transfers
between Legion and some remote machine of your choice, but both of these
commands need to log in to the remote machine, and they need to do this
WITHOUT any need for interactive input, i.e. without needing you to
supply a password.

The recommended method of doing this is to use RSA based authentication,
i.e. using an SSH public/private key pair, generated by (for example)
the Unix command `ssh-keygen`.

### Setting up the necessary Authentication Keys

If you already have such a key pair for other purposes (e.g. for
password-less login to Legion from your desktop machine), then all you
need to do is to copy the private key file `id_rsa` into the `~/.ssh`
directory in your Legion home directory (making sure that it is readable
only by you), and also copy the contents of the public key file
`id_rsa.pub` into the file

`authorized_keys`

in the `~/.ssh` directory on your remote machine.

If you haven't generated an SSH key pair before, simply run this command
on Legion:

```
ssh-keygen -t rsa
```

pressing return when it asks for passphrase. This will generate
the key pair in the following two files in the directory .ssh in your
Legion home directory:

`id_rsa` (the private key)

and

`id_rsa.pub` (the public key)

Finally, you need to copy the contents of the public key `id_rsa.pub`
into the file `authorized_keys` (creating it first if necessary), in the
`.ssh` directory under your home directory on your remote machine.

Note that, in general, the private key is in the .ssh directory of the
machine you are making the SSH connection FROM, and the public key is in
the `~/.ssh` directory of the machine you are connecting TO. You may well wish to
connect between your remote machine and Legion in BOTH directions, e.g.
to both SSH into Legion, and to allow Legion to do an scp/sftp file
transfer to your remote machine: in this case you will have both public
and private keys in the `.ssh` directories on both machines, thus allowing
password-less connection in both directions.

In the above description it is assumed that you are using a remote Unix
machine; this method also works with a remote Windows machine, though
the location of the `.ssh` directory is different, and may depend on your
version of Windows.

### Using SCP or SFTP without interactive input in a batch job

Having set up the SSH keys as described above, you can now use scp or
sftp to do file transfer within a batch job. For instance, you could use
an scp command like this: 

```
scp my_results <my_remote_userid>@<my_remote_hostname>:legion_files/my_results
```

This will copy your Legion file `my_results` into a file of the
same name in the directory `legion_files` on your remote machine
`<my_remote_hostname>`. Note that the directory `legion_files` must already
exist.

Similarly, you could copy a data file from `legion_files` on your remote
machine to Legion, but with one caviat - your `$HOME` directory in Legion
is read-only, as viewed by the worker nodes\! You must therefore copy
your data to `$HOME/Scratch`:

```
scp <my_remote_userid>@<my_remote_hostname>:legion_files/my_results $HOME/Scratch/my_results
```

Either of these commands should be embedded in a simple job
script like the one in the example below, which should be submitted
using qsub (remember to supply your correct consortium and project for
the job): 

```
#!/bin/bash -l  
#$ -N Data_transfer  
#$ -l h_rt=1:0:0  
#$ -l mem=1G  
#$ -P <your_project_name>  
#$ -wd /home/<your_user_id>/Scratch  
<scp_command>
```

You can also use sftp to do a similar job, though in this case
the situation is complicated by the fact that sftp normally takes its
commands interactively.

To get round this, supply the sftp commands with a file called
`sftp\_script` in your home directory, like this: 

```
cd legion_files  
put my_results  
exit
``` 

and then supply this script name to the sftp command using the
-b option, like this:

```
sftp -b sftp_script <my_remote_userid>@<my_remote_hostname>
```

This command will perform the same transfer as the first scp
example above, and should be submitted as a batch job using a similar
job script to the one shown.

As usual, please contact research-computing@ucl.ac.uk if you need any
assistance with doing this.


# Iridis-Specific Information

The Iridis service was discontinued on 31 July 2015, and all the data it
held in UCL user home directories was copied to Legion, into a read-only
storage area only accessible from the Legion transfer node, login05:
```

`/imports/iridis/`<username>

``` This data was kept available until 18th April 2016.

