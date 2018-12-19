---
title: Running TopHat on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
TopHat is a fast splice junction mapper for RNA-Seq reads. It aligns
RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput
short read aligner Bowtie, and then analyzes the mapping results to
identify splice junctions between exons. The version installed on Legion
is TopHat 2.0.9.

TopHat is intended to be run primarily within batch jobs however you may
run short (less than 5 minutes execution time) interactive tests on the
Login Nodes and longer interactive tests on the User Test Nodes.

Before you run TopHat you will need to remove and load the following
modules: ```

`module unload compilers/intel/11.1/072`  
`module unload mkl/10.2.5/035`  
`module unload compilers/intel/11.1/072`  
`module load compilers/gnu/4.6.3`  
`module load bowtie2/2.1.0`  
`module load python/enthought/7.2-2`  
`module load boost/1.54.0/gnu.4.6.3`  
`module load samtools/0.1.19`  
`module load tophat/2.0.9`

``` You can now run the TopHat pipline. Here is an example run
script for submitting batch jobs to the cluster:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an OpenMP threaded TopHat job on Legion with the upgraded```<br />
```# software stack under SGE. Using the fprovided test data as an example.```</p>
<p>```# This version works with the modules environment upgraded in Feb 2012.```</p>
<p>```# TopHat Version 2.0.9```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#    Change this to suit your requirements.```<br />
```#$ -l h_rt=0:10:0```</p>
<p>```# 3. Request 1 gigabyte of RAM. Change this to suit your requirements.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job. You can change this if you wish.```<br />
```#$ -N TopHat_jobMC_4```</p>
<p>```# 5. Select 4 threads (The max number is 12). The number of threads here```<br />
```#    must equal the number of threads on the -p option below.```<br />
```#$ -l thr=4```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_id></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```#```<br />
```# NOTE: this directory must exist.```<br />
```#```<br />
```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/TopHat_output```</p>
<p>```# 8. Your work *must* be done in $TMPDIR ```</p>
<p>```cp test_data.tar.gz $TMPDIR```<br />
```cd $TMPDIR```</p>
<p>```# 9. Run the TopHat pipeline```<br />
```module unload compilers/intel/11.1/072```<br />
```module unload mkl/10.2.5/035```<br />
```module unload compilers/intel/11.1/072```<br />
```module load compilers/gnu/4.6.3```<br />
```module load bowtie2/2.1.0```<br />
```module load python/enthought/7.2-2```<br />
```module load boost/1.54.0/gnu.4.6.3```<br />
```module load samtools/0.1.19```<br />
```module load tophat/2.0.9```</p>
<p>```tar xvzf test_data.tar.gz```<br />
```cd test_data```<br />
```tophat -r 20 -p 4 test_ref reads_1.fq reads_2.fq```</p>
<p>```# 10. Preferably, tar-up (archive) all output files onto the shared scratch area```<br />
```#    - ignore the input files by only taring the tophat_out directory.```<br />
```tar zcvf $HOME/Scratch/TopHat_output/files_from_job_$JOB_ID.tgz $TMPDIR/test_data/tophat_out```</p>
<p>```# Make sure you have given enough time for the copy to complete!```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/TopHat/run-tophat.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_id>* and *-wd
/home/<your_UCL_id>/Scratch/TopHat\_output* SGE directives. You will
also need to change the tophat command in the example and may need to
change the memory, wallclock time and job name directives as well. The
script can be submitted using the simplest form of the qsub command ie:
```

`qsub run-tophat.sh`

``` Output will be written to *$TMPDIR* and so will need to be
copied back to your ~/Scratch directory - step 10 in the runscript.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")