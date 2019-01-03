---
title: Batch Processing
categories:
 - User Guide
 - Background Info
layout: docs
---

# An Introduction to Batch Processing

When running jobs on Legion or Grace, users need to interact with the
batch system. For users unfamiliar with HPC environments, this can be a
way of working which is unfamiliar to them.

## What is a batch system?

On a large, multi-user machine like Legion many users compete for
relatively limited resources. There are two possible ways of organising
access to this resource: Either allow everyone to run anything they want
when they want but run the risk of people’s jobs interfering with each
other or else construct a system where users are allocated resources in
turn. This is called a "batch" system. In a batch system, users submit
their programs with a script to run them and a list of requirements and
these jobs are run when resources are available. On Legion, the order
jobs are run in is subject to a fair use policy which is discussed in
the scheduling policy section. On other sites, users may be billed for
their usage and most batch systems provide features for managing
accounting in this scenario.

When a user uses a batch system, they need to remember a number of
important things. The first is that (with some exceptions) their jobs
are not interactive. This means that a user must provide their
application with inputs in advance (and if they are a developer design
their program to operate in this manner). This means that some
applications are not suitable for running in a batch system
(visualisation for example). In most systems, each job is given a unique
ID by the scheduler and this ID is used when interacting with jobs once
they have been submitted. Once jobs have been submitted, users can log
out and their jobs will execute even though they are not logged in.

The second important thing to remember is that once a job has been
submitted, a user has little control of when the job is actually run,
because the time to completion (from submission) depends on how busy the
machine is. It is therefore necessary for users to plan ahead and submit
their jobs in a timely manner, rather than waiting until the last
minute.

## Basic commands

There are three basic commonly used commands in any batch system - one
for submitting jobs, one for checking the status of jobs and one for
deleting jobs. On Sun Grid Engine, these are qsub, qstat and qdel.

### qsub

The qsub command submits your job to the batch queue. 

```
qsub myscript.sh
``` 

You can override the settings in your script by specifying them
on the command-line, so for example if you want to change the name of
the job for this one instance of the job you can submit your script
with: 

```
qsub -N NewName myscript.sh
```

Or if you want to increase the wall-clock time to 24 hours:

```
qsub -l h_rt=24:0:0 myscript.sh
``` 

You can submit jobs with dependencies by using the `-hold_jid`
option. For example, the command below submits a job that won't run
until job 12345 has finished: 

```
qsub -hold_jid 12345 myscript.sh
```

You may specify node type (see [Resource Allocation](Resource_Allocation) section for more details)
with the `-ac allow=` flags as below: 

```
qsub -ac allow=XYZ myscript.sh
```

The example above would restrict the job to running on the older
nodes.

Note that for debugging purposes, it helps us if you have these options
inside your jobscript rather than passed in on the command line, if
possible. We can see your jobscript but not what command line you
submitted with.

### qstat

The qstat command shows the status of your jobs. By default, if you run
it with no options, it shows only your jobs (and no-one else’s). This
makes it easier to keep track of your jobs. If you want to get more
information on a particular job, note its job ID and then use the `-f` and
`-j` flags to get full output about that job:

```
`qstat -f -j 12345`
```

If you see that your job is in `Eqw` state then an error occurred before
your job could begin. You can see a truncated version of the error in
the output of `qstat -j` - this is often enough to tell what the problem
is if it is a file or directory not found.

You can get the full error with `qexplain`.

```
qexplain 12345
```

### qdel

The qdel command lets you delete a job from the queue. You need to
provide qdel with a job ID like so: 

```
qdel 12345
```

You can delete all your jobs with:

```
qdel '*'
```

If you wish to learn about additional commands, please run the command
"man qstat" and take note of the commands shown in the "SEE ALSO"
section of the manual page. Exit the manual page and then run the "man"
command on those.

If you cannot find the information you need in the man pages, then
contact us at <rc-support@ucl.ac.uk> for assistance.


