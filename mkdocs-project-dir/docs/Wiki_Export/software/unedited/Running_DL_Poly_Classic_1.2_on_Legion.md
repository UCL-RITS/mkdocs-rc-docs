---
title: Running DL Poly Classic 1.2 on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
A build of DL\_Poly classic (the open source version of DL\_Poly 2) is
available to users on Legion. It has been built with the default modules
environment (Intel compilers and QLogic MPI). If you wish to use the
Java GUI, you will have to make sure that you have set up X11 forwarding
and added a Java module to your environment. This has not been tested\!

Please read and understand the DL\_Poly Classic license. A copy of it
may be found in
/shared/ucl/apps/dl\_poly/classic/dl\_class\_1.2/LICENCE.pdf on Legion.

DL\_Poly looks for its input files in the directory which its executable
has been placed. Since this is not practical in a multi-user
environment, it is necessary for a user to copy the DL\_Poly executable
to their working directory before running it. The script below does this
as part of the job, as well as creating a job-specific working
directory. In addition, many of the scripts provided with the DL\_Poly
distribution that live in the execute subdirectory have had the execute
bit removed so that they cannot run (they would not work anyway as users
do not have permission to write to this directory).

### Example submission script

You will need to modify the contents of section 7 so that it points to
the directory with your input files in it, as well as correctly setting
the project in section 6. This script will create a sub-directory of
that directory called <jobname>\_<job id> with your data and output in
it.

More advanced users may wish to create their own scripts and work-flows
around the DL\_Poly binary. This binary may be found in
/shared/ucl/apps/dl\_poly/classic/dl\_class\_1.2/execute/DLPOLY.X on
Legion.

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -i```</p>
<p>```# Batch script to run an MPI DL_POLY job on Legion with the upgraded ```<br />
```# software stack under SGE with QLogic MPI.```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request thirty minutes of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=0:30:0```</p>
<p>```# 3. Request 1 gigabyte of RAM.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job.```<br />
```#$ -N DL_POLY```</p>
<p>```# 5. Select the QLogic parallel environment (qlc) and 16 processors.```<br />
```#$ -pe qlc 16```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```#$ -P ```<your project></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This ```<br />
```# is a necessary step with the upgraded software stack as compute nodes ```<br />
```# cannot write to $HOME.  This should be set to the directory where ```<br />
```# your DL_Poly input files are.```<br />
```#$ -wd /home/```<your username>```/scratch/output/```</p>
<p>```# 8. Now we need to set up and run our DL_Poly job.  DL_Poly is a bit ```<br />
```# odd, so we need to move files about to make things run.```</p>
<p>```dl_poly_work_dir=$SGE_O_WORKDIR/${JOB_NAME}_${JOB_ID}```<br />
```dl_poly_executable=/shared/ucl/apps/dl_poly/classic/dl_class_1.2/execute/DLPOLY.X```</p>
<p>```# Make a working directory.```<br />
```mkdir $dl_poly_work_dir```</p>
<p>```# Copy DL_Poly input files to temporary directory.```<br />
```for a in CONTROL FIELD CONFIG TABLE TABEAM```<br />
```do```<br />
```  if [ -f $SGE_O_WORKDIR/$a ]; then```<br />
```    echo Copying $SGE_O_WORKDIR/$a to $dl_poly_work_dir/$a```<br />
```    cp $SGE_O_WORKDIR/$a $dl_poly_work_dir/$a```<br />
```  else```<br />
```    echo No $SGE_O_WORKDIR/$a found.```<br />
```  fi```<br />
```done```</p>
<p>```# Copy DL_Poly executable to temporary working directory.```<br />
```echo Copying DL_Poly executable to $dl_poly_work_dir```<br />
```cp $dl_poly_executable $dl_poly_work_dir```</p>
<p>```# Run it.```<br />
```cd $dl_poly_work_dir```<br />
```echo Running $dl_poly_work_dir/DLPOLY.X.```<br />
```mpirun -m $TMPDIR/machines -np $NSLOTS $dl_poly_work_dir/DLPOLY.X```</p>
<p>```# Delete executable.```<br />
```rm $dl_poly_work_dir/DLPOLY.X```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")