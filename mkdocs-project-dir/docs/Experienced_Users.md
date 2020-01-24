---
layout: docs
---

# Quick Start Guide for Experienced HPC Users

## What Services are available?

### UCL
 * Grace/Kathleen - HPC, large parallel MPI jobs.
 * Myriad - High Throughput, GPU or large memory jobs.

### External
 * Thomas - MMM Hub Tier 2
 * Michael - Faraday Institution Tier 2


## How do I get access?

UCL services: Fill in the [sign-up form](Account_Services)

Tier 2 services: Contact your point of contact.

## How do I connect?

All connections are via SSH, and you use your UCL credentials to log in (external users will should use the `mmmXXXX` account with the SSH key they have provided to their point of contact),  UCL services can only be connected to by users inside the UCL network which may mean using the institutional VPN or "bouncing" off another UCL machine when [accessing them from outside the UCL network](howto#Logging-in-from-outside-the-UCL-firewall).  The Tier 2 services (Thomas and Michael) are externally accessible.

### Login hosts

|Service | General alias          | Direct login node addresses                                   |
|--------|------------------------|---------------------------------------------------------------|
|Grace   | `grace.rc.ucl.ac.uk`   | `login01.ext.grace.ucl.ac.uk` `login02.ext.grace.ucl.ac.uk`     |
|Kathleen| `kathleen.rc.ucl.ac.uk`| `login01.kathleen.rc.ucl.ac.uk` `login02.kathleen.rc.ucl.ac.uk` |
|Myriad  | `myriad.rc.ucl.ac.uk`  | `login12.myriad.rc.ucl.ac.uk` `login13.myriad.rc.ucl.ac.uk`     |
|Thomas  | `thomas.rc.ucl.ac.uk`  | `login03.thomas.rc.ucl.ac.uk` `login04.thomas.rc.ucl.ac.uk`     |
|Michael | `michael.rc.ucl.ac.uk` | `login10.michael.rc.ucl.ac.uk` `login11.michael.rc.ucl.ac.uk `  |

Generally you should connect to the general alias as this is load-balanced across the available login nodes, however if you use `screen` or `tmux` you will want to use the direct hostname so that you can reconnect to your session.

## Software stack

All UCL services use the same software stack based upon RHEL 7.x with a standardised set of packages, exposed to the user through environment modules (the `module` command).  By default this has a set of useful tools loaded, as well as the Intel compilers and MPI but users are free to change their own environment.

## Batch System

UCL services use Grid Engine to manage jobs.  This install is somewhat customised and so scripts for non-UCL services *may not work*.

We recommend that when launching MPI jobs you use our `gerun` parallel launcher which inherits settings from the job and launches the appropriate number of processes with the MPI implementation you have chosen.

### Script sections

#### Shebang

It's important that you add the `-l` option to bash in the shebang so that login scripts are parsed and the environment modules environment is set up.

```bash
#!/bin/bash -l
```

#### Resources you can request

##### Number of cores:

For MPI:
```bash
#$ -pe mpi <number of cores>
```

For threads:
```bash
#$ -pe smp <number of cores>
```

For single core jobs you don't need to request a number of cores.  For hybrid codes use the MPI example and set `OMP_NUM_THREADS` to control the number of threads per node.  `gerun` will launch the right number of processes in the right place if you use it.

##### Amount of RAM per core
```bash
#$ -l mem=<integer amount of RAM in G or M>
```

e.g. `#$ -l mem=4G` requests 4 gigabytes of RAM per core.

##### Run time:
```bash
#$ -l h_rt=<hours:minutes:seconds>
```

e.g. `#$ -l h_rt=48:00:00` requests 48 hours.

##### Working directory:

Either a specific working directory:

```bash
#$ -wd /path/to/working/directory
```

or the directory the script was submitted from:

```bash
#$ -cwd
```

##### GPUs (Myriad only):

```bash 
#$ -l gpu=<number of GPUs>
```

##### Enable Hyperthreads (Kathleen only):

```bash
#$ -l threads=1
```

With Hyperthreads enabled you need to request twice as many cores and then control threads vs MPI ranks with `OMP_NUM_THREADS`.  E.g. 

```bash
#$ -pe mpi 160
#$ -l threads=1
export OMP_NUM_THEADS=2
```

Would use 80 cores, with two threads (on Hyperthreads) per core.

##### Temporary local disk (every machine EXCEPT Kathleen):

```bash
#$ -l tmpdir=<size in G>
```

e.g. `#$ -l tmpdir=10G` requests 10 gigabytes of temporary local disk.

#### The rest of the script:

You need to load any module dependencies and the run the rest of your workflow.

We suggest using `gerun` as your parallel launcher rather than calling `mpriun` directly as `gerun` abstracts away a lot of the complexity between different version of MPI.  E.g. if you have requested 160 cores on your `#$ -pe...` line and your MPI program is called `test.exe` it should be sufficient to do:

```bash
gerun test.exe
```

To launch it correctly.

Job scripts can be submitted with `qsub`, jobs can be monitored with `qstat` and deleted with `qdel`.