---
title: Running GROMACS on Legion
layout: docs
---
GROMACS on Legion was built with FFTW, the OpenMPI library and the GNU
compilers. It is therefore strongly recommended that you have these
modules loaded when running it:

  - sge/6.2u3
  - compilers/gnu/4.6.3
  - mpi/openmpi/1.4.5/gnu.4.6.3
  - gromacs/4.6.1/openmpi/gnu.4.6.3

Which version you require depends on the problem you wish to solve. For
both single and double precisions version builds, serial binaries and an
MPI binary for mdrun (mdrun\_mpi) are provided. Double precision
binaries have a \_d suffix (so mdrun\_d, mdrun\_mpi\_d etc). The MPI
binaries should be run in the OpenMPI (openmpi) parallel environment
with the OpenMPI implementation.

### Job Script

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an MPI parallel GROMACS job on Legion with the upgraded software```<br />
```# stack under SGE with OpenMPI.```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=0:10:0```</p>
<p>```# 3. Request 1 gigabyte of RAM per process.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Request 15 gigabyte of TMPDIR space per node (default is 10 GB)```<br />
```#$ -l tmpfs=15G```</p>
<p>```# 5. Set the name of the job.```<br />
```#$ -N GROMACS_1_16_OpenMPI```</p>
<p>```# 6. Select the OpenMPI parallel environment and 16 processes.```<br />
```#$ -pe openmpi 16```</p>
<p>```# 7. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_id></p>
<p>```# 8. Set the working directory of the job to the current directory```<br />
```#     containing your input files.```<br />
```#    This *has* to be somewhere in your Scratch space, or else your```<br />
```#     job will go into the Eqw state.```<br />
```#$ -cwd```</p>
<p>```module unload compilers/intel/11.1/072```<br />
```module unload mpi/qlogic/1.2.7/intel```<br />
```module unload mkl/10.2.5/035```<br />
```module load compilers/gnu/4.6.3```<br />
```module load mpi/openmpi/1.4.5/gnu.4.6.3```<br />
```module load gromacs/4.6.1/openmpi/gnu.4.6.3```</p>
<p>```# Run GROMACS - replace with mdrun command line suitable for your job!```</p>
<p>```gerun mdrun_mpi -v -stepout 10000```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")