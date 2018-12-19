---
title: Running R 3.0.1 on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
<strong>This is an old orphaned page. If you got here from Google please
proceed to [R\_on\_Legion](R_on_Legion "wikilink") which you can reach
from [Applications](Applications "wikilink").</strong>

R version 3.0.1 and Bioconductor 2.12 are available on legion and can be
used in serial mode and shared memory parallel mode within single nodes
using at most twelve processors. A wide range of additional R packages
are also available. This version of R has been compiled with GCC 4.6.3
and the ATLAS high performance BLAS library. R is intended to be run
primarily within batch jobs however you may run short (less than 5
minutes execution time) interactive tests on the Login Nodes.

Before you can use R interactively, you need to load the R module using:
```

`module unload compilers/intel/11.1/072`  
`module unload mpi/qlogic/1.2.7/intel`  
`module unload mkl/10.2.5/035`  
`module load recommended/r`

``` Note: If you wish to use Python with R you cannot use the
recommended/python module as this is currently built using an older
version of GCC. Instead you need to use the Enthought Python
distribution. To do this use the following module commands: ```

`module unload compilers/intel/11.1/072`  
`module unload mpi/qlogic/1.2.7/intel`  
`module unload mkl/10.2.5/035`  
`module load recommended/r`  
`module load python/enthought/7.2-2`

``` The previous version of R (2.15.2) is also available and can be
used by replacing the: ```

`module load recommended/r`

``` with: ```

`module load recommended/r-old`

``` in the above sequence of module commands. You can check that the
modules are loaded using: ```

`module list`

``` You should now be able to start R normally.

To submit batch jobs to the cluster you will need a runscript. Here is a
simple example R runscript for serial jobs including comments:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a serial R job on Legion with the upgraded```<br />
```# software stack under SGE. This version works with the modules```<br />
```# environment upgraded in Feb 2012.```</p>
<p>```# R Version 3.0.1```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#    Change this to suit your requirements.```<br />
```#$ -l h_rt=0:10:0```</p>
<p>```# 3. Request 1 gigabyte of RAM. Change this to suit your requirements.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job. You can change this if you wish.```<br />
```#$ -N R_job_1```</p>
<p>```# 5. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to your $HOME.```<br />
```#```<br />
```# NOTE: this directory must exist.```<br />
```#```<br />
```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/R_output```</p>
<p>```# 7. Your work *must* be done in $TMPDIR ```<br />
```cd $TMPDIR```</p>
<p>```# 8. Run your R program.```<br />
```module unload compilers/intel/11.1/072```<br />
```module unload mpi/qlogic/1.2.7/intel```<br />
```module unload mkl/10.2.5/035```<br />
```module load recommended/r```</p>
<p>```R --no-save &lt; $R_input &gt; $R_output```</p>
<p>```# 9. Preferably, tar-up (archive) all output files onto the shared scratch area```<br />
```#    this will include the R_output file above.```<br />
```tar zcvf $HOME/Scratch/R_output/files_from_job_$JOB_ID.tgz $TMPDIR```</p>
<p>```# Make sure you have given enough time for the copy to complete!```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/R/R-3.0.1-ATLAS/share/run-R.sh`

```

Please copy if you wish and edit it to suit your jobs. You will need to
change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/R\_output* SGE directives and may need to
change the memory, wallclock time and job name directives as well. A
suitable qsub command to submit a single R job using this runscript
would be: ```

``qsub -v R_input=`pwd`/myR_job.R,R_output=myR_job.out run-R.sh``

```

where *myR\_job.R* is the file containing R commands and *myR\_job.out*
is the output file containing your results. In this example input, and
your runscript files are in your current working directory. The output
file is saved in the tar archive produced by the last command in the
runscript and will be in $HOME/Scratch/R\_output.

Here is an example runscript for running a shared memory parallel job:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an OpenMP threaded R job on Legion with the upgraded```<br />
```# software stack under SGE. Using the forech packages foreach(...) %dopar%```<br />
```# for example. ```</p>
<p>```# This version works with the modules environment upgraded in Feb 2012.```</p>
<p>```# R Version 3.0.1```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#    Change this to suit your requirements.```<br />
```#$ -l h_rt=0:10:0```</p>
<p>```# 3. Request 1 gigabyte of RAM. Change this to suit your requirements.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job. You can change this if you wish.```<br />
```#$ -N R_jobMC_2```</p>
<p>```# 5. Select 12 threads (the most possible on Legion). The number of threads here```<br />
```#    must equal the number of worker processes in the registerDoMC call in your```<br />
```#    R program.```<br />
```#$ -l thr=12```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_name></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```#```<br />
```# NOTE: this directory must exist.```<br />
```#```<br />
```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/R_output```</p>
<p>```# 8. Your work *must* be done in $TMPDIR ```<br />
```cd $TMPDIR```</p>
<p>```# 9. Run your R program.```<br />
```module unload compilers/intel/11.1/072```<br />
```module unload mpi/qlogic/1.2.7/intel```<br />
```module unload mkl/10.2.5/035```<br />
```module load recommended/r```</p>
<p>```R --no-save &lt; $R_input &gt; $R_output```</p>
<p>```# 10. Preferably, tar-up (archive) all output files onto the shared scratch area```<br />
```#    this will include the R_output file above.```<br />
```tar zcvf $HOME/Scratch/R_output/files_from_job_$JOB_ID.tgz $TMPDIR```</p>
<p>```# Make sure you have given enough time for the copy to complete!```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/R/R-3.0.1-ATLAS/share/run-R-MC.sh`

```

Again you may take a copy and modify to suit your jobs. You will need to
change the *-l thr=12* directive to match the number of R worker
processes, *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/R\_output* SGE directives and may need to
change the memory, wallclock time and job name directives as well. A
suitable qsub command to submit a single R job using this runscript
would be: ```

``qsub -v R_input=`pwd`/myR_job.R,R_output=myR_job.out run-R-MC.sh``

``` where *myR\_job.R* is the file containing R commands and
*myR\_job.out* is the output file containing your results. In this
example input, and your runscript files are in your current working
directory. The output file is saved in the directory specified by the
*-wd* SGE directive.

R can be used in more complicated ways including for example using one R
job to control the submission of other R jobs or submitting 1000s of
jobs using the SGE Array job facility. This is beyond the scope of this
introductory how to.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")