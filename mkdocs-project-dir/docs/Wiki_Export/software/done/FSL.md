---
title: Running FSL on Legion
layout: docs
---

# FSL

The FMRIB Software Library is a set of tools for analysis and
visualization of FMRI, MRI and DTI brain imaging data. It is developed
by the FMRIB Analysis Group of the Nuffield Department of Clinical
Neurosciences at the University of Oxford. Versions 5.0.1 and 4.1.9 are
available on our clusters. FSL is intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer interactive tests on the
User Test Nodes. Output can be displayed using the slices program.

Before you can use FSL you need to load the FSL module and call FSL's
set up script. The procedure is slightly different for each version. 

For version 4.1.9: 

```
module unload compilers/intel/11.1/072  
module load compilers/gnu/4.4.0  
module load fsl/4.1.9/gnu.4.4.0  
source $FSLDIR/etc/fslconf/fsl.sh
``` 

For version 5.0.1:

```
module unload compilers/intel/11.1/072
module load compilers/gnu/4.6.3
module load fsl/5.0.1/gnu.4.6.3  
source $FSLDIR/etc/fslconf/fsl.sh
```

FSL 5 has been compiled using GCC 4.6.3 so that it can be used
in combination with R. FSL programs can now be run in command line mode
for example:

```
susan structural.nii.gz 2000 2 3 1 0 structural_susan.nii.gz
```

With FSL version 5 some programs (*e.g.* FEAT) can submit jobs
directly to the cluster and will do this by default. For other programs
you will need a job script. Here is an example job script for version 5 to
submit a batch job to the cluster:

```
#!/bin/bash -l

# Batch script to run FSL 5 example jobs on Legion 

# Request 1 hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:0:0

# Request 4 gigabyte of RAM.
#$ -l mem=4G

# Note: some FSL programs are multi-threaded eg FEAT and you will need to
# include a -l thr=<number of threads> directive as well.

# Set the name of the job.
#$ -N FSL_job1

# Select the project that this job will run under.
# Find <your_project_id> by running the command "groups"
#$ -P <your_project_id>

# Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to $HOME.
#
# Note: this directory MUST exist before your job starts!
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/FSL_output

# Setup FSL runtime environment

module unload compilers/intel/11.1/072
module load compilers/gnu/4.6.3
module load fsl/5.0.1/gnu.4.6.3
source $FSLDIR/etc/fslconf/fsl.sh

# Your work *must* be done in $TMPDIR 
cd $TMPDIR

# Run job - A simple example using the BET command on the supplied example 
#  data.

# Copy input files to $TMPDIR
cp /shared/ucl/apps/FSL/5.0.1/feeds/data/structural.nii.gz $TMPDIR
echo ""
echo "Running: bet structural.nii.gz structural_brain.nii"
echo ""
time bet structural.nii.gz structural_brain.nii

# Preferably, tar-up (archive) all output files onto the shared scratch area
tar zcvf $HOME/Scratch/FSL/files_from_job_$JOB_ID $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

This is available on Legion in: 

```
/shared/ucl/apps/FSL/5.0.1/run-fsl.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_id>` and 
`-wd /home/<your_UCL_id>/Scratch/FSL_output` SGE directives. You will also
need to change the FSL command in the example and may need to change the
memory, wallclock time and job name directives as well. The script can
be submitted using the simplest form of the qsub command, i.e.:

```
qsub run-fsl.sh
```

Output will be written to `$TMPDIR` and so will need to be copied
back to your `~/Scratch` directory - step 10 in the job script. A version
of the job script for FSL version 4 is available in: 

```
/shared/ucl/apps/FSL/4.1.9/run-fsl.sh
```

