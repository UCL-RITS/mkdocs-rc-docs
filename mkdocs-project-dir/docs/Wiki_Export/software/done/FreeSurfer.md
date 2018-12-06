---
title: FreeSurfer
categories:
 - Bash script pages
layout: docs
---

# FreeSurfer

FreeSurfer is a set of tools for analysis and visualization of
structural and functional brain imaging data. Version 5.3.0 is available
on Legion (an older version 5.1.0 is also available). FreeSurfer s
intended to be run primarily within batch jobs however you may run short
(less than 5 minutes execution time) interactive tests on the Login
Nodes and longer interactive tests on the User Test Nodes.

Before you can use FreeSurfer you need to load the FreeSurfer module and
set an environment variable to point to your subjects directory: 

```
module load freesurfer/5.3.0  
export SUBJECTS_DIR=~/Scratch/<some-directory>
```

This directory needs to be in your Scratch space so the compute
nodes have write access to it.

The latest version of FreeSurfer supports OpenMP. Here is an example
runscript to submit a batch job to the cluster using 4 threads:

```
#!/bin/bash -l

# Batch script to run a serial FreeSurfer job on Legion with the upgraded
# software stack under SGE. This version works with the modules
# environment upgraded in Feb 2012.

# FreeSurfer Version 5.3.0
# Nov 2013
# This version of FreeSurfer supports OpenMP

# Request 1 hour of wallclock time (format hours:minutes:seconds).
#    Change this to suit your requirements.
#$ -l h_rt=1:00:0

# Request 15 gigabyte of RAM for the whole job. Change this to suit your 
#    requirements.
#$ -l mem=15G

# Set the name of the job. You can change this if you wish.
#$ -N FreeSurfer_job_1m

# Select 4 threads (the most possible on the majority of Legion is 12). 
#$ -l thr=4

# Select the project that this job will run under.
# Find <your_project_id> by running the command "groups"
#$ -P <your_project_id>

# Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to your $HOME.
#
# NOTE: this directory must exist.
#
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/FreeSurfer_output

# Your work *must* be done in $TMPDIR 
cd $TMPDIR

# Load FreeSurfer module and point to your subjects directory.
module load freesurfer/5.3.0
export SUBJECTS_DIR=~/Scratch/PADDINGTON

# Run FreeSurfer programs - replace with your command(s)
#time recon-all -i $SUBJECTS_DIR/30432.n.nii -subjid 30432 -autorecon1 -cw256
time recon-all -subjid 30432 -autorecon1 -cw256
```

This is available on Legion in:

```
/shared/ucl/apps/FreeSurfer/run-freesurfer.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_id>` and `-wd /home/<your_UCL_id>/Scratch/FreeSurfer_output` SGE directives and set
the `SUBJECTS_DIR` variable to the path to your subjects directory. You
will also need to change the FreeSurfer command in the example and may
need to change the memory, wallclock time, number of threads and job
name directives as well. The script can be submitted using the simplest
form of the qsub command ie: 

```
qsub run-freesurfer.sh
```

Output files and logs will be written to your subjects
directory.

