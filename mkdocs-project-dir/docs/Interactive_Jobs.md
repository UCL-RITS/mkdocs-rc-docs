---
title: Interactive Job Sessions
categories:
 - User Guide
layout: docs
---

# Interactive Job Sessions

For an interactive session, you reserve some compute nodes via the
scheduler and then are logged in live, just like on the login nodes.
These can be used for live visualisation, software debugging, or to work up a script to run
your program without having to submit each attempt separately to the
queue and wait for it to complete.

## Requesting Access

You will be granted an interactive shell after running a command that
checks with the scheduler whether the resources you wish to use in your
tests/analysis are available. Interactive sessions are requested using the qrsh command. 
It typically takes the form:

```
qrsh -pe mpi 8 -l mem=512M,h_rt=2:00:00 -now no
```

In this example you are asking to run eight parallel processes
within an MPI environment, 512MB RAM per process, for a period of two
hours.

All job types we support on the system are supported via an interactive
session (see our [examples section](Example_Jobscripts.md)).
Likewise, all qsub options are supported like regular job submission
with the difference that with qrsh they must be given at the command
line, and not with any job script (or via -@).

In addition the `-now` option is useful when a cluster is busy. 
By default qrsh and qlogin jobs will run on the next scheduling
cycle or give up. The `-now no` option tells it to keep waiting
until it gets scheduled. Pressing Ctrl+C (i.e. the control key
and the C key at the same time) will safely cancel the request
if it doesn't seem to be able to get you a session.

More resources can be found here:

* [Moodle](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846689) (UCL users)
* [Mediacentral](https://mediacentral.ucl.ac.uk/Play/98393) (non-UCL users)

## Interactive X sessions

You can get an interactive X session from the head node of the job back
to the login node. The way to do this is to run the `qrsh` command in the
following generic fashion:

```
qrsh <options> <command> <arguments to <command>>
```

Where `<command>` is either a command to launch an X terminal like
Xterm or Mrxvt or a GUI application like XMGrace or GaussView.

To make effective use of the X forwarding you will need to have logged
in to the login node with ssh -X or some equivalent method. Here is an
example of how you can get a X terminal session with the qrsh command:

```
qrsh -l mem=512M,h_rt=0:30:0 \
   "/shared/ucl/apps/mrxvt/0.5.4/bin/mrxvt -title 'User Test Node'"
```

## Working on the nodes

 If you want to run a command on one of your other allocated nodes, you
can use a standard `ssh` command from the interactive session: 
```
ssh <hostname> <command> [args]
```
to access other nodes within your allocation. Note that you are not
able to `ssh` directly from the login node.

In the above, `<hostname>` can be obtained by inspecting the file
`$TMPDIR/machines`.

## GPU test nodes

You can also run GPU jobs interactively simply by adding the `-l gpu=1`
or `-l gpu=2` options to the qrsh command as normal.

For more information, please contact us on <rc-support@ucl.ac.uk>

