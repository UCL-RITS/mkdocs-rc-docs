---
title: Running CP2K on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
# 2.2.426

The module for this version is contained in the chemistry modules, so
you will need to load the module set that contains it before it is
visible in the modules list: ```

`module load chemistry-modules`

``` CP2K should then be visible as: ```

`module avail`

`[.....]`

`----- /shared/ucl/depts/chemistry/modulefiles -----`  
`cp2k/2.2.426/openmpi/gnu.4.6.3/cp2k`

```

### Submitter

An automatic submitter is available for this version, available by
loading the submission scripts module from the chemistry set: ```

`module load chemistry-modules`  
`module load submission-scripts`

``` The alias "submitters" will then list the submitters available.

The "cp2k.submit" submitter takes up to 5 arguments, and any omitted
will be asked for interactively:
```

`cp2k.submit «input_file» «cores» «maximum_run_time» «memory_per_core» «job_name»`

``` So, for example: ```

`cp2k.submit water.inp 8 2:00:00 4G mywatermolecule`

``` would request a job running CP2K with the input file
"water.inp", on 8 cores, with a maximum runtime of 2 hours, with 4
gigabytes of memory per core, and a job name of "mywatermolecule".

### Job script

As with the previous versions, some extra arguments to the OpenMPI
mpirun command are necessary. An example job script is below:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```<br />
```# setting up the environment for SGE:```<br />
```#$ -S /bin/bash -l```<br />
```#$ -cwd```<br />
```#$ -N CP2K-Job```</p>
<p>```# Set your project name here:```<br />
```#$ -P  Project_Name ```</p>
<p>```# If necessary, alter the maximum quantity of memory here:```<br />
```#$ -l mem=2G```</p>
<p>```# Alter the maximum run time here (hours:minutes:seconds)```<br />
```#$ -l h_rt=10:00:00```</p>
<p>```# Alter the number of processors here:```<br />
```#$ -pe openmpi 1 ```</p>
<p>```# loading the correct modules```<br />
```module add chemistry-modules```<br />
```module add cp2k/2.2.426/openmpi/gnu.4.6.3/cp2k ```</p>
<p>```#Modify this to name your input file```<br />
```InputFile=ACP2KFile.inp```</p>
<p>```OutputFile=${InputFile%\.inp}.log```</p>
<p>```mpirun --mca btl ^tcp -n $NSLOTS cp2k.popt $InputFile &gt; $OutputFile```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

# branch 2\_1 and trunk

To use these versions of CP2K on Legion, you will have to make
considerable changes to your user environment, including using a test
build of OpenMPI specifically designed for this purpose.

You also need to pick which CP2K package you wish to use: trunk, or
branch 2\_1 - the jobscript below selects branch 2\_1 - if you require
trunk, you will need to change the module specification.

### Job script

In order to use this special version of OpenMPI, you need to make a few
changes to the normal OpenMPI job script. An example job script is shown
below:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#$ -l h_rt=0:30:0```</p>
<p>```# 3. Request 1 gigabyte of RAM.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job.```<br />
```#$ -N cp2k-branch-openmpi-gcc440-test-dev```</p>
<p>```# 5. Select the OpenMPI parallel environment and 8 processors.```<br />
```#$ -pe openmpi  8```</p>
<p>```# 6. Select the project that this job will run under.```<br />
```#$ -P ```<your_project_id></p>
<p>```# 7. Set the working directory to somewhere in your scratch space.  This is```<br />
```# a necessary step with the upgraded software stack as compute nodes cannot```<br />
```# write to $HOME.```<br />
```#$ -wd /home/```<your_UCL_id>```/scratch/```</p>
<p>```# 8. Run our MPI job.  ```</p>
<p>```module add compilers/gnu/4.4.0```<br />
```module add mpi/openmpi/1.4.1/gnu.4.4.0```<br />
```module add fftw/2.1.5/double/gnu.4.4.0```<br />
```module add atlas/3.8.3/gnu.4.4.0```<br />
```module add blacs/patch03/gnu.4.4.0```<br />
```module add scalapack/1.8.0/gnu.4.4.0```<br />
```module add cp2k/2_1-branch/openmpi/gnu.4.4.0```</p>
<p>```# Delete OpenMPI PE SSH wrapper```<br />
```rm $TMPDIR/ssh```</p>
<p>```# Need to add in --prefix $MPI_HOME as not using system OpenMPI```<br />
```mpirun --prefix $MPI_HOME -machinefile $TMPDIR/machines -np $NSLOTS `which cp2k.popt` C.inp```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

The main differences between this script and the normal OpenMPI scripts
is that we have to delete an SSH wrapper from $TMPDIR/ssh and insert
--prefix $MPI\_HOME into our mpirun command. Note that we've also forced
the loading of the correct modules in the job script. This assumes you
have an input file called C.inp in your working directory. Amend this
script as necessary.

If you put the modules into your job script as above, you should not
need to have them in your .bashrc, but it's probably worth doing so just
to be on the safe side, unless doing so causes clashes with other
programs you want to use.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink") [Category:Legion
Applications](Category:Legion_Applications "wikilink") [Category:Legion
Software](Category:Legion_Software "wikilink")