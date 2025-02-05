---
layout: docs
---

# Quick Start Guide for Experienced HPC Users

## What Services are available?

### UCL
 * Kathleen - HPC, large parallel MPI jobs.
 * Myriad - High Throughput, GPU or large memory jobs.

### External
 * Young - MMM Hub Tier 2
 * Michael - Faraday Institution Tier 2


## How do I get access?

UCL services: Fill in the [sign-up form](Account_Services.md)

Tier 2 services: Contact your point of contact.

## How do I connect?

All connections are via SSH, and you use your UCL credentials to log in (external users should use the `mmmXXXX` account with the SSH key they have provided to their point of contact). UCL services can only be connected to by users inside the UCL network which may mean using the institutional VPN or "bouncing" off another UCL machine when [accessing them from outside the UCL network](howto.md#logging-in-from-outside-the-ucl-firewall). The Tier 2 services (Michael and Young) are externally accessible.

### Login hosts

|Service | General alias          | Direct login node addresses                                   |
|--------|------------------------|---------------------------------------------------------------|
|Kathleen| `kathleen.rc.ucl.ac.uk`| `login01.kathleen.rc.ucl.ac.uk` `login02.kathleen.rc.ucl.ac.uk` |
|Myriad  | `myriad.rc.ucl.ac.uk`  | `login12.myriad.rc.ucl.ac.uk` `login13.myriad.rc.ucl.ac.uk`     |
|Young   | `young.rc.ucl.ac.uk`   | `login01.young.rc.ucl.ac.uk` `login02.young.rc.ucl.ac.uk `      |
|Michael | `michael.rc.ucl.ac.uk` | `login10.michael.rc.ucl.ac.uk` `login11.michael.rc.ucl.ac.uk `  |

Generally you should connect to the general alias as this is load-balanced across the available login nodes, however if you use `screen` or `tmux` you will want to use the direct hostname so that you can reconnect to your session.

Please be aware that login nodes are shared resources, so users should not run memory intensive jobs nor jobs with long runtimes in the login node. Doing so may negatively impact the performance of the login node for other users. Hence, identified culprit user processes are systematically killed.

## Software stack

All UCL services use the same software stack based upon RHEL 7.x with a standardised set of packages, exposed to the user through environment modules (the `module` command). By default this has a set of useful tools loaded, as well as the Intel compilers and MPI but users are free to change their own environment.

## Batch System

UCL services use Grid Engine to manage jobs. This install is somewhat customised and so scripts for non-UCL services *may not work*.

We recommend that when launching MPI jobs you use our `gerun` parallel launcher instead of `mpirun` as it inherits settings from the job and launches the appropriate number of processes with the MPI implementation you have chosen. It abstracts away a lot of the complexity between different version of MPI.

```
# using gerun
gerun myMPIprogram

# using mpirun when a machinefile is needed (eg Intel MPI)
mpirun -np $NSLOTS -machinefile $PE_HOSTFILE myMPIprogram
```

`$NSLOTS` is an environment variable containing the value you gave to `-pe mpi` so you do not need to re-specify it.

### Troubleshooting gerun

If you need to see what `gerun` is doing because something is not working as expected, look at the error file for your job, default name `$JOBNAME.e$JOB_ID`. It will contain debug information from `gerun` about where it ran and the exact `mpirun` command it used. 

You may need to use `mpirun` directly with different options if your program has sufficiently complex process placement requirements, or is using something like GlobalArrays and requires a different process layout than it is being given.

### Script sections

#### Shebang

It's important that you add the `-l` option to bash in the shebang so that login scripts are parsed and the environment modules environment is set up. `#!` must be the first two characters in the file, no previous white space.

```bash
#!/bin/bash -l
```

#### Resources you can request

##### Number of cores

For MPI:
```bash
#$ -pe mpi <number of cores>
```

For threads:
```bash
#$ -pe smp <number of cores>
```

For single core jobs you don't need to request a number of cores. For hybrid codes use the MPI example and set `OMP_NUM_THREADS` to control the number of threads per node. `gerun` will launch the right number of processes in the right place if you use it.

##### Amount of RAM per core
```bash
#$ -l mem=<integer amount of RAM in G or M>
```

e.g. `#$ -l mem=4G` requests 4 gigabytes of RAM per core.

##### Run time
```bash
#$ -l h_rt=<hours:minutes:seconds>
```

e.g. `#$ -l h_rt=48:00:00` requests 48 hours.

##### Working directory

Either a specific working directory:

```bash
#$ -wd /path/to/working/directory
```

or the directory the script was submitted from:

```bash
#$ -cwd
```

##### GPUs (Myriad only)

```bash 
#$ -l gpu=<number of GPUs>
```

##### Enable Hyperthreads (Kathleen only)

```bash
#$ -l threads=1
```

The `-l threads=` request is not a true/false setting, instead you are telling the scheduler
you want one slot to block one virtual cpu instead of the normal situation where it blocks two.
If you have a script with a threads request and want to override it on the command line or set
it back to normal, the usual case is `-l threads=2`. (Setting threads to 0 does not disable
hyperthreading!)

With Hyperthreads enabled you need to request twice as many cores and then control threads vs MPI ranks with `OMP_NUM_THREADS`. E.g. 

```bash
#$ -pe mpi 160
#$ -l threads=1
export OMP_NUM_THREADS=2
```

Would use 80 cores, with two threads (on Hyperthreads) per core. If you use `gerun` to launch your MPI process, it will take care of the division for you, but if you're using `mpirun` or `mpiexec` directly, you'll have to take care to use the correct number of MPI ranks per node yourself.

Note that memory requests are now per virtual core with hyperthreading enabled. 
If you asked for `#$ -l mem=4G`on a node with 80 virtual cores and 192G RAM then 
you are requiring 320G RAM in total which will not fit on that node and so you 
would be given a sparse process layout across more nodes to meet this requirement.

##### Temporary local disk (every machine EXCEPT Kathleen)

```bash
#$ -l tmpdir=<size in G>
```

e.g. `#$ -l tmpdir=10G` requests 10 gigabytes of temporary local disk.

#### The rest of the script

You need to load any module dependencies, set up any custom environment variables or paths you need and then run the rest of your workflow.

### Submitting your jobscript

Job scripts can be submitted with `qsub`, jobs can be monitored with `qstat` and deleted with `qdel`.


### Interactive jobs

If you need to run an interactive job, possibly with X forwarding, you can do so using `qrsh`. Please see our page on [interactive jobs](Interactive_Jobs.md) for more details.
