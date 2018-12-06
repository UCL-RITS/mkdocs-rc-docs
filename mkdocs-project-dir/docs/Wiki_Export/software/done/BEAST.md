---
title: BEAST
categories:
 - Bash script pages
layout: docs
---

# BEAST

BEAST is an application for Bayesian MCMC analysis of molecular
sequences orientated towards rooted, time-measured phylogenies inferred
using strict or relaxed molecular clock models. It can be used as a
method of reconstructing phylogenies but is also a framework for testing
evolutionary hypotheses without conditioning on a single tree topology.

The installation on Legion includes the extra applications Tracer and
FigTree. Currently BEAST on Legion doesn't work with the BEAGLE
high-performance library. BEAST is intended to be run primarily within
batch jobs however you may run short (less than 5 minutes execution
time) interactive tests on the Login Nodes and longer interactive tests
on the User Test Nodes.

To use BEAST, Tracer and FigTree you need to load the following modules before running any of the applications:

```
module load java/1.6.0_32
module load beast/1.7.4
```

Here is an example run script for submitting batch jobs to the cluster:

```
#!/bin/bash -l

# Batch script to run an OpenMP threaded BEAST job on Legion with the upgraded
# software stack under SGE. 

# This version works with the modules environment upgraded in Feb 2012.

# BEAST Version 1.7.4

# Request 15 minutes of wallclock time (format hours:minutes:seconds).
#    Change this to suit your requirements.
#$ -l h_rt=0:15:0

# Request 1 gigabyte of RAM. Change this to suit your requirements.
#$ -l mem=1G

# Set the name of the job. You can change this if you wish.
#$ -N BEAST_job_1

# Select 4 threads (the most possible on Legion is 12). NOTE: BEAST currently
# can only use 1 thread per partition.
#$ -l thr=4

# Select the project that this job will run under.
# Find <your_project_id> by running the command "groups"
#$ -P <your_project_id>

# Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to $HOME.
#
# NOTE: this directory must exist.
#
# Replace "<your_UCL_id>" with your UCL user ID :) 
#$ -wd /home/<your_UCL_id>/Scratch/BEAST

# Your work *must* be done in $TMPDIR 
cd $TMPDIR

# Load correct modules for BEAST
module load java/1.6.0_32
module load beast/1.7.4

# Copy input XML file to TMPDIR and run BEAST 
cp $infile .
beast_infile=`basename $infile`
echo "Running BEAST with $OMP_NUM_THREADS threads ..."
beast -threads $OMP_NUM_THREADS $beast_infile

# Preferably, tar-up (archive) all output files onto the shared scratch area
#    this will include the R_output file above.
tar zcvf $HOME/Scratch/BEAST/files_from_job_$JOB_ID $TMPDIR
```

A copy of this runscript is available on Legion in:

```
/shared/ucl/apps/BEAST/run-beast.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_id>` and `-wd /home/<your_UCL_id>/Scratch/BEAST` grid engine directives. You may also
need to change the `-l thr=4`, `-l mem=1G` and `-l h_rt=0:15:0`
directives. Submit the script using a qsub command like: 

```
qsub -v infile=`pwd`/gopher.xml run-beast.sh
``` 

replacing `gopher.xml` with your BEAST XML file. Output will be
written to $TMPDIR and so will need to be copied back to your `~/Scratch`
directory.

