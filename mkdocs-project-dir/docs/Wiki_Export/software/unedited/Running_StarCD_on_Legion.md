---
title: Running StarCD on Legion
layout: docs
---
StarCD is a commercial CFD package that handles combustion and engine
simulation.

You must request access to the group controlling StarCD access
(legstarcd) to use it.

Here is an example run script for submitting batch jobs to the cluster:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Job Name (shows up in qstat)```<br />
```#$ -N StarCD```</p>
<p>```# Merge output and error files```<br />
```#$ -j y```</p>
<p>```# Maximum runtime of job```<br />
```#$ -l h_rt=0:20:00```</p>
<p>```# Request OpenMPI environment with 16 processors```<br />
```#$ -pe qlc 16```</p>
<p>```# Request one license per core```<br />
```#$ -l starsuite=1```</p>
<p>```# Your Project Name```<br />
```#$ -P ProjectName```</p>
<p>```# Run from the current working directory```<br />
```#$ -cwd```</p>
<p>```module load starcd```<br />
```star```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in: ```

`/shared/ucl/apps/starcd_4.18.019/run-starcd.sh`

``` Please copy if you wish and edit it to suit your jobs. The
script can then be submitted using the simplest form of the qsub command
ie: ```

`qsub run-starcd.sh`

``` Input files will be used from the current working directory, and
output written to the same, so this should be submitted from a directory
containing your input files in the Scratch area.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")