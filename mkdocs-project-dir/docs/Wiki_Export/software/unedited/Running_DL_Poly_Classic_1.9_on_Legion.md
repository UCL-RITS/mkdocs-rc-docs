---
title: Running DL Poly Classic 1.9 on Legion
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
/shared/ucl/apps/dl\_poly/classic/dl\_class\_1.9/LICENCE.pdf on Legion.

More advanced users may wish to create their own scripts and work-flows
around the DL\_Poly binary. This binary may be found in
/shared/ucl/apps/dl\_poly/classic/dl\_class\_1.9/execute/DLPOLY.X on
Legion. The version of this binary patched to include PLUMED 1.3 may be
found in
/shared/ucl/apps/dl\_poly/classic/dl\_class\_1.9\_plumed\_1.3/execute/DLPOLY\_PLUMED.X
on Legion. Otherwise, the processes required to run the two versions are
identical.

### Example Job Script

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an MPI DL_POLY job on Legion with the upgraded ```<br />
```# software stack under SGE with QLogic MPI.```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request thirty minutes of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=0:30:00```</p>
<p>```# 3. Request 1 gigabyte of RAM per core.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job.```<br />
```#$ -N DL_POLY_JOB```</p>
<p>```# 5. Select the QLogic parallel environment (qlc) and 16 processors.```<br />
```#$ -pe qlc 16```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```#$ -P ```<your project></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This ```<br />
```# is a necessary step as compute nodes cannot write to $HOME.  This should ```<br />
```# be set to the directory where your DL_Poly input files are, and your output files```<br />
```# will be written to the same directory.```<br />
```#$ -wd /home/```<your username>```/Scratch/DLP_Job```</p>
<p>```gerun /shared/ucl/apps/dl_poly/classic/dl_class_1.9/execute/DLPOLY.X```</p>
<p>```# If you want to use PLUMED, replace the line above with:```<br />
```# gerun /shared/ucl/apps/dl_poly/classic/dl_class_1.9_plumed_1.3/execute/DLPOLY_PLUMED.X```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")