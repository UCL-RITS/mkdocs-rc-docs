---
title: Running StarCCM+ on Legion
layout: docs
---
StarCCM+ is a commercial CFD package that handles fluid flows, heat
transfer, stress simulations, and other common applications of such.

You must request access to the group controlling StarCCM+ access
(legstarcd) to use it.

You will also need to load the appropriate OpenMPI module, and the
StarCCM+ module: ```

`module unload mpi`  
`module load mpi/openmpi/1.4.1/intel`  
`module load starccm`

``` Before running StarCCM+ for the first time you will need to set
up two symbolic links in your home directory to directories you have
created in your Scratch area. This is so that users settings etc can be
written by running jobs. In your home directory:
```

`mkdir Scratch/star-7.02.011`  
`mkdir Scratch/star-7.02.011-`<your userid>  
`ln -s ~/Scratch/star-7.02.011 .star-7.02.011`  
`ln -s ~/Scratch/star-7.02.011-`<your userid>` .star-7.02.011-`<your userid>

``` Replace <your userid> with your UCL userid eg ucemxxx. You can
now run StarCCM+ programs.

Here is an example run script for submitting batch jobs to the cluster:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Job Name (shows up in qstat)```<br />
```#$ -N StarCCM```</p>
<p>```# Merge output and error files```<br />
```#$ -j y```</p>
<p>```# Maximum runtime of job```<br />
```#$ -l h_rt=0:20:00```</p>
<p>```# Request OpenMPI environment with 16 processors```<br />
```#$ -pe openmpi 16```</p>
<p>```# Request 1 license per core```<br />
```#$ -l ccmpsuite=1```</p>
<p>```# Your Project Name```<br />
```#$ -P ProjectName```</p>
<p>```# Run from the current working directory```<br />
```#$ -cwd```</p>
<p>```module unload mpi```<br />
```module load mpi/openmpi/1.4.1/intel```<br />
```module load starccm```</p>
<p>```starccm+ -np $NSLOTS -machinefile $TMPDIR/machines -rsh ssh -batch Example.sim```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/starccm+_7.02.011/run-starccm.sh`

``` Please copy if you wish and edit it to suit your jobs. The
script can then be submitted using the simplest form of the qsub command
ie: ```

`qsub run-starccm.sh`

``` Output will be written to the current working directory, so this
should be submitted from a directory in the Scratch area.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")