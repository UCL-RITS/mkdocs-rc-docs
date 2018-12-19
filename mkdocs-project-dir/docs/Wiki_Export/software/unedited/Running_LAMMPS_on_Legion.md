---
title: Running LAMMPS on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
The build of LAMMPS on Legion was build with double precision FFTW, the
OpenMPI library and the Intel 13.0 compilers. It is therefore strongly
recommended that you have these modules loaded when running it:

  - sge/6.2u3
  - compilers/intel/13.0/028\_cxx11
  - mpi/openmpi/1.4.5/intel.13.0
  - fftw/2.1.5/double/intel.13.0
  - lammps/7Jun13/openmpi/intel.13.0

The last four of those modules are not loaded by default and (will
conflict with default loaded modules), but may be loaded in your job
script. If you are using the default modules remember to unload them in
your script before loading the modules above.

An example job script for LAMMPS is shown below:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an MPI parallel job on Legion with the upgraded software```<br />
```# stack under SGE with OpenMPI.```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request one hour of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=1:00:00```</p>
<p>```# 3. Request 1 gigabyte of RAM per process.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job.```<br />
```#$ -N ExampleLAMMPS```</p>
<p>```# 5. Select the QLogic parallel environment and 24 processes.```<br />
```#$ -pe openmpi 24```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```# Find ```<your_project_id>``` by running the command &quot;groups&quot;```<br />
```#$ -P ```<your_project_id></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID.```<br />
```#$ -wd /home/```<your_UCL_id>```/Scratch/lammps```</p>
<p>```# 8. Load required modules ```</p>
<p>```# If you have default modules loaded, uncomment lines below:```<br />
```# module remove default-modules```<br />
```# module load sge```</p>
<p>```module load compilers/intel/13.0/028_cxx11```<br />
```module load mpi/openmpi/1.4.5/intel.13.0```<br />
```module load fftw/2.1.5/double/intel.13.0```<br />
```module load lammps/7Jun13/openmpi/intel.13.0```</p>
<p>```# 9. Run our MPI job.  Replace &quot;inputfile&quot; with the name of your LAMMPS input file.```<br />
```gerun `which lmp_legion` -in inputfile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")