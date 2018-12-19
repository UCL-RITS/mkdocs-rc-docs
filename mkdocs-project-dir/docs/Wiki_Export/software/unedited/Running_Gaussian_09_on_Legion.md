---
title: Running Gaussian 09 on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
Gaussian 09 (G09) revisions C.01 and the older A.02 are available on
legion and currently can be used in either:

  - Serial mode and shared memory parallel mode within single nodes
    using at most four processors when running on type W nodes or twelve
    processors when running on type X, Y or Z nodes. Module:
    *gaussian/g09\_a02/pgi*
  - Linda parallel execution mode across multiple nodes. Note: not all
    calculations are Linda parallel. From the Gaussian documentation
    "HF, CIS=Direct, and DFT calculations on molecules are Linda
    parallel, including energies, optimizations and frequencies. TDDFT
    energies and MP2 energies and gradients are also Linda parallel. PBC
    calculations are not Linda parallel. The default for molecules
    larger than 65 atoms is to use the linear scaling algorithms (FMM).
    The linear scaling (FMM-based) algorithms are now Linda-parallel, so
    Linda parallel jobs on large molecules do not need to specify NoFMM,
    and will run faster with the default algorithms chosen by the
    program." Module: *gaussian/g09\_a02\_linda/pgi*

Access to G09 is enabled by a module file and being a member of the
appropriate reserved application group. Please email
<rc-support@ucl.ac.uk> to get your userid added to the G09 group.

All G09 jobs apart from small test jobs (4 cores and less than 5 minutes
runtime) must be submitted as batch jobs. Before you can run G09
interactively you need to load the G09 module and run an initialisation
script using: ```

`module load gaussian/g09_c01_linda/pgi`  
`. $g09root/g09/bsd/g09.profile`

``` for revision C.01. To use the older version use the
*gaussian/g09\_a02\_linda/pgi* module instead. You can use: ```

`module list`

``` to check that the module is loaded. Output should look similar
to this: ```

`Currently Loaded Modulefiles:`  
`  1) ucl                          6) nedit/5.6`  
`  2) compilers/intel/11.1/072     7) mrxvt/0.5.4`  
`  3) mkl/10.2.5/035               8) rcops/1.0`  
`  4) mpi/qlogic/1.2.7/intel       9) gaussian/g09_c01_linda/pgi`  
`  5) sge/6.2u3`

``` You should now be able to run G09 using: ```

`g09 < myG09input > myG09output`

``` for example.

To submit batch jobs to the cluster you will need a runscript.

### Shared memory Gaussian jobs

Here is a simple example G09 runscript for shared memory jobs including
comments:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a shared memory Gaussian 09 job on Legion with the```</p>
<p>```# upgraded software stack under SGE.```</p>
<p>```#```</p>
<p>```# Aug 2012```</p>
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
<p>```#$ -N G09_job1```</p>
<p>```# 4. Select  4 OpenMP threads (the most possible on Legion is 12).```</p>
<p>```#$ -l thr=4```</p>
<p>```# 5. Select the project that this job will run under.```</p>
<p>```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```</p>
<p>```# a necessary step with the upgraded software stack as compute nodes cannot```</p>
<p>```# write to $HOME.```</p>
<p>```#```</p>
<p>```# Note: this directory MUST exist before your job starts!```</p>
<p>```#$ -wd /home/```<your_UCL_id>```/Scratch/G09_output```</p>
<p>```# Setup G09 runtime environment```</p>
<p>```module load gaussian/g09_c01_linda/pgi```</p>
<p>```source $g09root/g09/bsd/g09.profile```</p>
<p>```mkdir -p $GAUSS_SCRDIR```</p>
<p>```# Run g09 job```</p>
<p>```echo &quot;GAUSS_SCRDIR = $GAUSS_SCRDIR&quot;```</p>
<p>```echo &quot;&quot;```</p>
<p>```echo &quot;Running: g09 &lt; $g09infile &gt; $g09outfile&quot;```</p>
<p>```g09 &lt; $g09infile &gt; $g09outfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/Gaussian/G09_C01_L/run-g09.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/G09\_output* SGE directives and may need to
change the memory, wallclock time, number of threads and job name
directives as well. A suitable qsub command to submit a G09 job using
this runscript would be:
```

``qsub -v g09infile=`pwd`/MyData.com,g09outfile=MyOutput.out run-g09.sh``

``` where *Mydata.com* is the file containing your G09 commands and
*MyOuput.out* is the output file. In this example input, and your
runscript files are in your current working directory. The output file
is saved in the directory specified by the -wd SGE directive.

### Linda parallel Gaussian jobs

Here is a simple example G09 runscript for Linda parallel jobs including
comments:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a Gaussian 09 job on Legion using Linda with the upgraded```<br />
```# software stack under SGE.```<br />
```#```<br />
```# Aug 2012```<br />
```#```<br />
```# Based on the Qlogic MPI and Hybrid example scripts at```<br />
```#```<br />
```# ```<a href="http://www.ucl.ac.uk/isd/staff/research_services/research-computing/services/legion-upgrade/userguide/submissionscripts">```http://www.ucl.ac.uk/isd/staff/research_services/research-computing/services/legion-upgrade/userguide/submissionscripts```</a></p>
<p>```#$ -S /bin/bash```</p>
<p>```# 2. Request 12 hours of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=12:0:0```</p>
<p>```# 3. Request 4 gigabyte of RAM.```<br />
```#$ -l mem=4G```</p>
<p>```# 4. Set the name of the job.```<br />
```#$ -N G09l_job1```</p>
<p>```# 5a. Select the QLogic parallel environment (qlc) and 2 processes (Linda ```<br />
```#     workers).```<br />
```#$ -pe qlc 2```</p>
<p>```# 5b. Select number of threads per Linda worker (value of NProcShared in your```<br />
```#     Gaussian input file.```<br />
```#$ -l thr=4```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```#$ -P ```<your_project_name></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```#```<br />
```# Note: this directory MUST exist before your job starts!```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/G09_output```</p>
<p>```# 8. Run our G09 Linda job.```</p>
<p>```# Setup G09 runtime environment```</p>
<p>```module load gaussian/g09_c01_linda/pgi```<br />
```source $g09root/g09/bsd/g09.profile```<br />
```mkdir -p $GAUSS_SCRDIR```</p>
<p>```# Pre-process G09 input file to include nodes alocated to job```</p>
<p>```echo &quot;Running: lindaConv $g09infile $JOB_ID $TMPDIR/machines&quot;```<br />
```echo ''```<br />
```$lindaConv $g09infile $JOB_ID $TMPDIR/machines```</p>
<p>```# Run g09 job```</p>
<p>```echo &quot;GAUSS_SCRDIR = $GAUSS_SCRDIR&quot;```<br />
```echo &quot;&quot;```<br />
```echo &quot;Running: g09 &lt; job$JOB_ID.com &gt; $g09outfile&quot;```</p>
<p>```# communication needs to be via ssh not the Linda default```<br />
```export GAUSS_LFLAGS='-v -opt &quot;Tsnet.Node.lindarsharg: ssh&quot;'```</p>
<p>```time g09 &lt; job$JOB_ID.com &gt; $g09outfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This script is more complicated that the shared memory example as your
Gaussian input file needs to be preprocessed to insert information about
the nodes SGE has allocated to the job.

This is available on Legion in: ```

`/shared/ucl/apps/Gaussian/G09_C01_L/run-g09-linda.sh`

```

Please copy if you wish and edit it to suit your jobs. You will need to
change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/G09\_output* SGE directives and may need to
change the memory, wallclock time, number of Linda workers (the -pe
directive), number of threads and job name directives as well. A
suitable qsub command to submit a G09 job using this runscript would be:
```

``qsub -v g09infile=`pwd`/MyData.com,g09outfile=MyOutput.out run-g09-linda.sh``

```

where *Mydata.com* is the file containing your G09 commands and
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
    `#$ -ac app=g09`  
    for Gaussian 09 jobs. If the directive is not present, normal job
    wallclock limits apply.
2.  The way Gaussian is launched needs to be modified as the new queues
    launch g09 via a new wrapper command. The new wrapper is G09 - note
    the capital G\! It takes arguments for Gaussian command (standard
    input) and output (standard output) files so need to be used like
    so:  
    `G09 commands.in output.out`  
    where *commands.in* is the file containing your Gaussian commands
    and *output.out* is the file where standard output will appear. The
    G03 wrapper is used in the same way.

Here is a simple Gaussian 09 runscript using the new '7-day' queue:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a long Gaussian 09 shared memory job on Legion using ```</p>
<p>```# the restricted '7-day' queue under SGE.```</p>
<p>```#```</p>
<p>```# Aug 2012```</p>
<p>```#```</p>
<p>```# Based on openmp.sh by:```</p>
<p>```#```</p>
<p>```# Owain Kenway, Research Computing, 16/Sept/2010```</p>
<p>```#$ -S /bin/bash```</p>
<p>```# 1. Request 168 hours of wallclock time (format hours:minutes:seconds).```</p>
<p>```#$ -l h_rt=168:0:0```</p>
<p>```# 2. Request 4 gigabyte of RAM.```</p>
<p>```#$ -l mem=8G```</p>
<p>```#$ -ac app=g09```</p>
<p>```# 3. Set the name of the job.```</p>
<p>```#$ -N G09_jobR```</p>
<p>```# 4. Select  12 OpenMP threads (the most possible on Legion).```</p>
<p>```#$ -l thr=12```</p>
<p>```# 5. Select the project that this job will run under.```</p>
<p>```#$ -P ```<your_project_name></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```</p>
<p>```# a necessary step with the upgraded software stack as compute nodes cannot```</p>
<p>```# write to $HOME.```</p>
<p>```#```</p>
<p>```# Note: this directory MUST exist before your job starts!```</p>
<p>```#$ -wd /home/```<your_UCL_id>```/Scratch/G09_output```</p>
<p>```# Run g09 job```</p>
<p>```echo &quot;GAUSS_SCRDIR = $GAUSS_SCRDIR&quot;```</p>
<p>```echo &quot;&quot;```</p>
<p>```echo &quot;Running: G09 $g09infile $g09outfile&quot;```</p>
<p>```time G09 $g09infile $g09outfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/Gaussian/G09_C01_L/run-g09-res.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_name>* and *-wd
/home/<your_UCL_id>/Scratch/G09\_output* SGE directives and may need to
change the memory, wallclock time, number of threads and job name
directives as well. A suitable qsub command to submit a G09 job using
this runscript would be:
```

``qsub -v g09infile=`pwd`/MyData.com,g09outfile=MyOutput.out run-g09-res.sh``

``` where *Mydata.com* is the file containing your G09 commands and
*MyOuput.out* is the output file. In this example input, and your
runscript files are in your current working directory. The output file
is saved in the directory specified by the -wd SGE directive.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")