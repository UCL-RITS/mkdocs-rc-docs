---
title: Running Gaussian 03 on Legion
layout: docs
---
Gaussian 03 (G03) revision E.01 is available on legion and currently can
be used in serial mode and shared memory parallel mode within single
nodes using at most four processors. Access to G03 is enabled by a
module file and being a member of the appropriate reserved application
group. Please email <rc-support@ucl.ac.uk> to get your userid added to
the G03 group.

All G03 jobs apart from small test jobs (4 cores and less than 5 minutes
runtime) must be submitted as batch jobs. Before you can run G03
interactively you need to load the G03 module and run an initialisation
script using: ```

`module load gaussian/g03_e01/pgi`  
`. $g03root/g03/bsd/g03.profile`

``` You can use: ```

`module list`

``` to check that the module is loaded. Output should look similar
to this: ```

`Currently Loaded Modulefiles:`  
` 1) ucl                          6) nedit/5.6`  
` 2) compilers/intel/11.1/072     7) mrxvt/0.5.4`  
` 3) mkl/10.2.5/035               8) rcops/1.0`  
` 4) mpi/qlogic/1.2.7/intel       9) gaussian/g03_e01/pgi`  
` 5) sge/6.2u3`

``` You should now be able to run G03 using: `g03 < myG03input >
myG03output` for example.

To submit batch jobs to the cluster you will need a runscript. Here is a
simple example G03 runscript for shared memory jobs including comments:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a Gaussian 03 job on Legion with the upgraded```<br />
```# software stack under SGE.```<br />
```#```<br />
```# 21st Sept 2010```<br />
```#```<br />
```# Based on openmp.sh by:```<br />
```#```<br />
```# Owain Kenway, Research Computing, 16/Sept/2010```</p>
<p>```#$ -S /bin/bash```</p>
<p>```# 1. Request 12 hours of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=12:0:0```</p>
<p>```# 2. Request 4 gigabyte of RAM.```<br />
```#$ -l mem=4G```</p>
<p>```# 3. Set the name of the job.```<br />
```#$ -N G03_job1```</p>
<p>```# 4. Select  4 OpenMP threads (the most possible on Legion).```<br />
```#$ -l thr=4```</p>
<p>```# 5. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/G03_output```</p>
<p>```#Old PBS setting: -N G03_job1```<br />
```#Old PBS setting: -l nodes=1:ppn=4,naccesspolicy=singlejob,qos=parallel```<br />
```#Old PBS setting: -l pvmem=8g,walltime=12:00:00```<br />
```#Old PBS setting: -A ucl/```<consortium name>```/```<project name></p>
<p>```# Setup G03 runtime environment```</p>
<p>```module load gaussian/g03_e01/pgi```<br />
```mkdir -p $GAUSS_SCRDIR```<br />
```. $g03root/g03/bsd/g03.profile```</p>
<p>```echo &quot;GAUSS_SCRDIR = $GAUSS_SCRDIR&quot;```<br />
```echo &quot;&quot;```<br />
```echo &quot;Running: g03 &lt; $g03infile &gt; $g03outfile&quot;```<br />
```g03 &lt; $g03infile &gt; $g03outfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/Gaussian/G03_E01/run-g03.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/G03\_output* SGE directives and may need to
change the memory, wallclock time, number of threads and job name
directives as well. A suitable qsub command to submit a G03 job using
this runscript would be:
```

``qsub -v g03infile=`pwd`/MyData.com,g03outfile=MyOutput.out run-g03.sh``

``` where *Mydata.com* is the file containing your G03 commands and
*MyOuput.out* is the output file. In this example input, and your
runscript files are in your current working directory. The output file
is saved in the directory specified by the -wd SGE directive.

### Submitting Long Gaussian Jobs

It is possible to obtain permission to submit single node Gaussian jobs
with wallclock times between 2 and 7 days. For details of how to gain
access to the 7-day Gaussian queue see [ Requests for Additional
Resources](Legion_Resource_Allocation#Requests_for_Additional_Resources_or_Resource_Reservations "wikilink").

As the 7-day queue is restricted to shared memory Gaussian jobs you will
need to make some changes to your runscripts:

1.  Include the grid engine directive:  
    `#$ -ac app=g03`  
    for Gaussian 03 jobs. If the directive is not present, normal job
    wallclock limits apply.
2.  The way Gaussian is launched needs to be modified as the new queues
    launch g03 via a new wrapper command. The new wrapper is G03 - note
    the capital G\! It takes arguments for Gaussian command (standard
    input) and output (standard output) files so need to be used like
    so:  
    `G03 commands.in output.out`  
    where commands.in is the file containing your Gaussian commands and
    output.out is the file where standard output will appear. The G09
    wrapper is used in the same way.

Here is a simple Gaussian 03 runscript using the new '7-day' queue:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a Gaussian 03 job on Legion using ```</p>
<p>```# the restricted '7-day' queue under SGE ```</p>
<p>```#```</p>
<p>```# Aug 2012```</p>
<p>```#```</p>
<p>```# Based on openmp.sh by:```</p>
<p>```#```</p>
<p>```# Owain Kenway, Research Computing, 16/Sept/2010```</p>
<p>```#$ -S /bin/bash```</p>
<p>```# 1. Request 12 hours of wallclock time (format hours:minutes:seconds).```</p>
<p>```#$ -l h_rt=3:0:0```</p>
<p>```# 2. Request 4 gigabyte of RAM.```</p>
<p>```#$ -l mem=8G```</p>
<p>```#$ -ac app=g03```</p>
<p>```# 3. Set the name of the job.```</p>
<p>```#$ -N G03_jobR```</p>
<p>```# 4. Select  12 OpenMP threads (the most possible on Legion).```</p>
<p>```#$ -l thr=12```</p>
<p>```# 5. Select the project that this job will run under.```</p>
<p>```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```</p>
<p>```# a necessary step with the upgraded software stack as compute nodes cannot```</p>
<p>```# write to $HOME.```</p>
<p>```#```</p>
<p>```# Note: this directory MUST exist before your job starts!```</p>
<p>```#$ -wd /home/```<your_UCL_id>```/Scratch/G03_output```</p>
<p>```# Run g03 job```</p>
<p>```echo &quot;GAUSS_SCRDIR = $GAUSS_SCRDIR&quot;```</p>
<p>```echo &quot;&quot;```</p>
<p>```echo &quot;Running: G03 $g03infile $g03outfile&quot;```</p>
<p>```time G03 $g03infile $g03outfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/Gaussian/G03_E01/run-g03-res.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/G03\_output* SGE directives and may need to
change the memory, wallclock time, number of threads and job name
directives as well. A suitable qsub command to submit a G03 job using
this runscript would be:
```

``qsub -v g03infile=`pwd`/MyData.com,g03outfile=MyOutput.out run-g03-res.sh``

``` where *Mydata.com* is the file containing your G03 commands and
*MyOuput.out* is the output file. In this example input, and your
runscript files are in your current working directory. The output file
is saved in the directory specified by the -wd SGE directive.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")