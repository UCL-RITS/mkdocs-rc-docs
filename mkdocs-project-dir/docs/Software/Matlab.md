---
title: MATLAB
layout: docs
---

MATLAB is a numerical computing environment and proprietary programming language developed by MathWorks.

Our MATLAB installs include all the toolboxes included in UCL's Total Academic Headcount-Campus licence plus the Matlab Distributed Computing Server. We also have the NAG toolbox for Matlab available.

You can submit single node multi-threaded MATLAB jobs or single node jobs which use the Parallel Computing Toolbox and Matlab's Distributed Computing Server. Please note that these currently will not work across multiple nodes, so all types of MATLAB jobs can only use one node.

You can submit jobs to Myriad and Legion from MATLAB running on your own desktop or laptop.

## Setup

You need to load MATLAB once from a login node before you can submit any jobs. This allows it to set up your `~/.matlab` directory as a symbolic link to `~/Scratch/.matlab` so that the compute nodes can write to it.

```
# on a login node
module load xorg-utils/X11R7.7
module load matlab/full/r2018b/9.5
``` 

You can run `module avail matlab` to see all the available installed versions.

## Single node multi-threaded batch jobs

This is the simplest way to start using MATLAB on the cluster.

You will need a .m file containing the MATLAB commands you want to carry out.

Here is an example jobscript which you would submit using the `qsub` command, after you have loaded the MATLAB module once on a login node as mentioned in [Setup](#setup):

```
#!/bin/bash -l

# Batch script to run a multi-threaded MATLAB job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per core. 
#$ -l mem=1G

# Request 15 gigabytes of TMPDIR space (default is 10 GB)
#$ -l tmpfs=15G

# Request 12 threads (which will use 12 cores). 
# On Myriad you could set the number of threads to a maximum of 36. 
#$ -pe smp 12

# Request one MATLAB licence - makes sure your job doesn't start 
# running until sufficient licenses are free.
#$ -l matlab=1

# Set the name of the job.
#$ -N Matlab_multiThreadedJob1

# Set the working directory to somewhere in your scratch space.
# This is a necessary step as compute nodes cannot write to $HOME.
# Replace "<your_UCL_id>" with your UCL user ID.
# This directory must already exist.
#$ -wd /home/<your_UCL_id>/Scratch/Matlab_examples

# Your work should be done in $TMPDIR
cd $TMPDIR

module load xorg-utils/X11R7.7
module load matlab/full/r2018b/9.5
# outputs the modules you have loaded
module list

# Optional: copy your script and any other files into $TMPDIR.
# This is only practical if you have a small number of files.
# If you do not copy them in, you must always refer to them using a
# full path so they can be found, eg. ~/Scratch/Matlab_examples/analyse.m

cp ~/Scratch/Matlab_examples/myMatlabJob.m $TMPDIR
cp ~/Scratch/Matlab_examples/initialise.m $TMPDIR
cp ~/Scratch/Matlab_examples/analyse.m $TMPDIR

# These echoes output what you are about to run
echo ""
echo "Running matlab -nosplash -nodisplay < myMatlabJob.m ..."
echo ""

matlab -nosplash -nodesktop -nodisplay < myMatlabJob.m
# Or if you did not copy your files:
# matlab -nosplash -nodesktop -nodisplay < ~/Scratch/Matlab_examples/myMatlabJob.m
```

Alternative syntax:
Instead of using Unix input redirection like this:
```
matlab -nosplash -nodesktop -nodisplay < $Matlab_infile
```
you can also do:
```
matlab -nosplash -nodesktop -nodisplay -r $Matlab_infile
```

### Run without the JVM to reduce overhead

You can give the `-nojvm` option to tell MATLAB to run without the Java Virtual Machine. This will speed up startup time, possibly execution time, and remove some memory overhead, but will prevent you using any tools that require Java (eg, tools that use the Java API for I/O and networking like URLREAD, or call Java object methods). 

### Run single-threaded

Most of the time, MATLAB will create many threads and use them as it wishes. If you know your job is entirely single-threaded, you can force MATLAB to run with only one thread on one core, which will allow you to have more jobs running at once. 

To request one core only, set `#$ -pe smp 1` in your jobscript.

Run MATLAB like this:
```
matlab -nosplash -nodesktop -nodisplay -nojvm -singleCompThread < $Matlab_infile
```

The `-singleCompThread` forces MATLAB to run single-threaded, and the `-nojvm` tells it to run without the Java Virtual Machine, as above. 


## Using the MATLAB GUI interactively

You can run MATLAB interactively for short amounts of time on the login nodes (please do not do this if your work will be resource-intensive). You can also run it interactively in a `qrsh` session on the compute nodes.

Launching with `matlab` will give you the full graphical user interface - you will need to have logged in to the cluster with X-forwarding on for this to work. 

Launching with `matlab -nodesktop -nodisplay` will give you the MATLAB terminal.


## Submitting jobs using the Distributed Computing Server (DCS)

## Submitting jobs from your workstation/laptop


## Running MATLAB on GPUs


