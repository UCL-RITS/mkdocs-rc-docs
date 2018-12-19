---
title: Running Stata/MP on Legion
layout: docs
---
A sixteen user licence of Stata/MP Release 12 the multicore version of
the Stata statistics, data management, and graphics system is installed
on Legion. The licence we have supports Stata running on up to four
cores per job.

Stata is intended to be run primarily within batch jobs however you may
short (less than 5 minutes execution time) interactive tests on the
Login Nodes and longer tests on the Usertest Nodes. Before you can run
Stata, you need to load the Stata module: ```

`module load stata/12`

``` You can check that the module is loaded using: ```

`module list`

``` You should now be able to use Stata interactively using either:
```

`stata-mp`

``` for a command line interface or: ```

`xstata-mp`

``` for the GUI interface. Note: this version requires an X server
running on your local computer.

To submit batch jobs to the cluster you will need a runscript. Here is a
simple example Stata runscript including comments:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a Stata/MP job on Legion with the upgraded```</p>
<p>```# software stack under SGE.```</p>
<p>```#```</p>
<p>```# May 2012```</p>
<p>```#```</p>
<p>```# Based on openmp.sh by:```</p>
<p>```#```</p>
<p>```# Owain Kenway, Research Computing, 16/Sept/2010```</p>
<p>```#$ -S /bin/bash```</p>
<p>```# 1. Request 12 hours of wallclock time (format hours:minutes:seconds).```</p>
<p>```#$ -l h_rt=12:0:0```</p>
<p>```# 2. Request 4 gigabyte of RAM.```</p>
<p>```#$ -l mem=4G```</p>
<p>```# 3. Set the name of the job.```</p>
<p>```#$ -N Stata_job1```</p>
<p>```# 4. Select  4 OpenMP threads (the most possible with Stata/MP on Legion).```</p>
<p>```#$ -l thr=4```</p>
<p>```# 5. Select the project that this job will run under.```</p>
<p>```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```</p>
<p>```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space. This is```</p>
<p>```# a necessary step with the upgraded software stack as compute nodes cannot```</p>
<p>```# write to $HOME.```</p>
<p>```#```</p>
<p>```# Note: this directory MUST exist before your job starts!```</p>
<p>```#```</p>
<p>```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```</p>
<p>```#$ -wd /home/```<your_UCL_id>```/Scratch/Stata_output```</p>
<p>```# 7. Set up Stata/MP environment```</p>
<p>```#```</p>
<p>```# Your work must be done in $TMPDIR```</p>
<p>```cd $TMPDIR```</p>
<p>```module load stata/12```</p>
<p>```# 8. Run Stata do file```</p>
<p>```cp $dofile $TMPDIR```</p>
<p>```stata-mp -b do $dofile ```</p>
<p>```# 9. Preferably, tar-up (archive) all output files onto the shared scratch area```</p>
<p>```tar zcvf $HOME/Scratch/Stata_output/files_from_job_$JOB_ID $TMPDIR```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/StataMP/share/run-stata-mp.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/Stata\_output* SGE directives and may need
to change the *-l thr=4* number of threads, memory, wallclock time and
job name directives as well. A suitable qsub command to submit a Stata
job to process the do file *myDofile.do* located in your current
directory would be: ```

``qsub -v dofile=`pwd`/myDofile run-stata-mp.sh``

``` Output from this job will be written to a file called
*myDofile.log* which will be saved in the tar archive
*files\_from\_job\_$JOB\_ID* in your Scratch area.

The example runscript can be modified to submit 1000s of Stata jobs
using the SGE Array job facility. See the [Legion User
Guide](Legion_User_Guide "wikilink") for examples of array job
runscripts.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")