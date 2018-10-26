---
title: Legion Quick Start
categories:
 - Legion
 - User Guide
 - Pages with bash scripts
layout: docs
---
This is a quick start guide to our clusters for users already familiar with
operating in an HPC environment.

## Accessing A Cluster

Before accessing the Legion cluster, it is necessary to [apply for an account](Account_Services). Once you have received
notification that your account has been created, you may log in via SSH
to:

 - *Legion:* legion.rc.ucl.ac.uk
 - *Myriad:* myriad.rc.ucl.ac.uk
 - *Grace:* grace.rc.ucl.ac.uk

Your username and password are the same as those for your central UCL
user id. Legion, Myriad, and Grace are only accessible from within UCL’s network. If you
need to access them from outside, you need to log in via Socrates, a
departmental machine, or install the IS VPN service.

More details on connecting to these services are provided on the [Accessing RC Systems](Accessing_RC_Systems) page.

## Managing data on the our clusters

Users on our clusters have access to three pools of storage. They have a home
directory which is mounted read only on the compute
nodes and therefore cannot be written to by running jobs. They have a
"scratch" area which is writable from jobs and intended for live data and job output.
There is a link to this area called "Scratch" within the user’s home
directory. Finally, within a job users have access to temporary local storage on the
nodes (environmental variable `$TMPDIR`) which is cleared at the end of
the job.

Legion has slow external network connections, so there is a dedicated transfer node with 10 gigabit network links to and
from Legion available at:

```
login05.external.legion.ucl.ac.uk
```

Transfers to Grace and Myriad may use any of the normal login nodes.

For more details on the fairly complicated data management structures
within Legion, see the [Managing Data on RC Systems](Managing_Data_on_RC_Systems) page.

## User Environment

Our clusters run an operating system based on Red Hat Enterprise Linux 7 with
the Son of Grid Engine batch scheduler. UCL-supported and provided
packages are made available to users through the use of the modules
system.

|    |   |
|:---|:--|
|`module avail`| lists available modules |
|`module load`| loads a module           |
|`module remove`| removes a module       |

The module system handles dependency and conflict information.

You can find out more about the modules system on Legion on the [RC Systems user environment](RC_Systems_user_environment) page.

## Compiling your code

We provide Intel and GNU compilers, and OpenMPI and Intel MPI
through the modules system, with the usual wrappers. For a full list of
the development tools available see here or in the development
tools/compilers sections of the modules system.

You can find out more about compiling code on a cluster on the [Compiling](Compiling) page.

## Job scheduling policy and projects

A fair-share resource allocation model has been implemented on all our clusters.
See [Resource Allocation](Resource Allocation) for more information and context.

## Submission scripts

Jobs submitted to the scheduler (with "qsub") are shell scripts with
directives preceded by `#$`.

```
#!/bin/bash -l

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per process.
#$ -l mem=1G

# Set the name of the job.
#$ -N SomeScience_1_16

# Select the MPI parallel environment and 16 processes.
#$ -pe mpi 16

# Select the project that this job will run under. (Only if you have
#  access to paid resources).
#$ -P <your_project_id>

# Set the working directory to somewhere in your scratch space.
#$ -wd /home/<your_UCL_id>/Scratch/output
```

You can then follow these directives with the commands your script would
execute. Legion supports a wide variety of job types and we would
strongly recommend you study the [example scripts](Example_Scripts).

Jobs can be controlled with `qsub` (submit job), `qstat` (list jobs) and
`qdel` (delete job). See the [Introduction to batch processing](Batch_Processing) page for more details.

## Testing jobs using Interactive Jobs

As well as batch access to the system, it is possible to run short, small jobs with
interactive access through the scheduler. These can be
requested though the `qrsh` command. You need to provide qrsh with the
same options you would include in your job submission script, so:

```
qrsh -pe mpi 8 -l mem=512M -l h_rt=2:0:0
```

Is functionally equivalent to: 

```
#!/bin/bash
#$ -S /bin/bash
#$ -pe mpi 8
#$ -l mem=512M
#$ -l h_rt=2:0:0
```

Except, of course, that the result of qrsh is an interactive
shell. For more details, see the [Interactive Jobs](Interactive Jobs) page.

# More information

 - [How the scheduler works](The_Scheduler)
 - [Example submission scripts](Example_Scripts)
 - [Acknowledging the use of our services in publications](Acknowledging_RC_Systems)
 - [Contact and support](Contact_and_Support)
 - [FAQ](FAQ)
 - [Known issues](Known_Issues)
 - [Reporting Problems](Reporting_problems)

