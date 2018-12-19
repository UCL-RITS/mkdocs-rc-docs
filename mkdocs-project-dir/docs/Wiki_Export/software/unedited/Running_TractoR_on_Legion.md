---
title: Running TractoR on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
TractoR (Tractography with R) is an R application for reading, writing,
analysing and visualising magnetic resonance images stored in Analyze,
NIfTI and DICOM file formats. It also contains functions specifically
designed for working with diffusion MRI and tractography, including a
standard implementation of the neighbourhood tractography approach to
white matter tract segmentation. TractoR is developed at UCL by Jonathan
Clayden and colleagues.

Two versions of TractoR are available on Legion - 2.4.2 and 2.2.1.

TractoR packages can be used from within an R session. In addition a
control script is provided that allows using TractoR without interacting
with R. On Legion TractoR is intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer interactive tests on the
User Test Nodes.

To use TractoR version 2.4.2 in either mode (within R or using the
control script) you need to load the following modules: ```

`module unload compilers/intel/11.1/072`  
`module unload mpi/qlogic/1.2.7/intel`  
`module unload mkl/10.2.5/035`  
`module load recommended/r`  
`module load fsl/5.0.2.2/gnu.4.6.3`  
`module load tractor/2.4.2`  
`source $FSLDIR/etc/fslconf/fsl.sh`

``` To use the older version 2.2.1 replace the FSL and TractoR
modules in the above with: ```

`module load fsl/5.0.1/gnu.4.6.3`  
`module load tractor/2.2.1`

``` TractoR also uses the FMRIB Software Library (FSL) hence the
need to source its setup script. You should now be able to run a TractoR
command, for example: ```

`tractor list`

``` which should display the list of available commands:
```

`Starting TractoR environment...`  
`Experiment scripts found in /shared/ucl/apps/R/TractoR/tractor-2.2.1/share/experiments:`  
` [1] age             bedpost         binarise        camino2fsl`  
` [5] caminofiles     chfiletype      clone           contact`  
` [9] dicomread       dicomsort       dicomtags       dirviz`  
`[13] dpreproc        extract         fsl2camino      gmap`  
`[17] gmean           gradcheck       gradread        gradrotate`  
`[21] hnt-eval        hnt-interpret   hnt-ref         hnt-viz`  
`[25] identify        imageinfo       imagestats      list`  
`[29] mean            mkroi           morph           mtrack`  
`[33] peek            platform        plotcorrections pnt-collate`  
`[37] pnt-data        pnt-data-sge    pnt-em          pnt-eval`  
`[41] pnt-interpret   pnt-prune       pnt-ref         pnt-train`  
`[45] pnt-viz         proj            ptrack          rtrack`  
`[49] slice           smooth          status          streamlines2trk`  
`[53] tensorfit       track           update          upgrade`  
`[57] values          view`

Experiment completed with 0 warning(s) and 0 error(s) ```

Here is an example run script using the command script mode for
submitting batch jobs to the cluster:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run an OpenMP threaded TractoR job on Legion with the upgraded```<br />
```# software stack under SGE. ```</p>
<p>```# This version works with the modules environment upgraded in Feb 2012.```</p>
<p>```# TractoR Version 2.4.2```</p>
<p>```# 1. Force bash as the executing shell.```<br />
```#$ -S /bin/bash```</p>
<p>```# 2. Request ten minutes of wallclock time (format hours:minutes:seconds).```<br />
```#    Change this to suit your requirements.```<br />
```#$ -l h_rt=0:10:0```</p>
<p>```# 3. Request 1 gigabyte of RAM. Change this to suit your requirements.```<br />
```#$ -l mem=1G```</p>
<p>```# 4. Set the name of the job. You can change this if you wish.```<br />
```#$ -N TractoR_job_1```</p>
<p>```# 5. Select 12 threads (the most possible on Legion). ```<br />
```#$ -l thr=12```</p>
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
```#$ -wd /home/```<your_UCL_id>```/Scratch/TractoR_output```</p>
<p>```# 8. Load correct modules for TractoR and R```<br />
```module unload compilers/intel/11.1/072```<br />
```module unload mpi/qlogic/1.2.7/intel```<br />
```module unload mkl/10.2.5/035```<br />
```module load recommended/r```<br />
```module load fsl/5.0.2.2/gnu.4.6.3```<br />
```module load tractor/2.4.2```<br />
```source $FSLDIR/etc/fslconf/fsl.sh```</p>
<p>```# 9. Run TractoR commands - example from ```<br />
```#    ```<a href="http://www.tractor-mri.org.uk/HNT-tutorial">```http://www.tractor-mri.org.uk/HNT-tutorial```</a><br />
```cd $TMPDIR```<br />
```cp -r $TRACTOR_HOME/tests/data/session-12dir/ .```<br />
```mkdir tmp```<br />
```tractor  hnt-eval SessionList:session-12dir TractName:genu SearchWidth:7```<br />
```echo ''```<br />
```echo '--------------------------------------------'```<br />
```echo ''```<br />
```tractor hnt-viz SessionList:session-12dir TractName:genu ResultsName:results CreateVolumes:true```<br />
```echo ''```<br />
```echo '--------------------------------------------'```<br />
```echo ''```<br />
```tractor mean genu_session1 session-12dir Metric:FA AveragingMode:binary```<br />
```echo ''```<br />
```echo '--------------------------------------------'```<br />
```echo ''```</p>
<p>```# 10. Preferably, tar-up (archive) all output files onto the shared scratch area```<br />
```#    this will include the R_output file above.```<br />
```tar zcvf $HOME/Scratch/TractoR_output/files_from_job_$JOB_ID.tgz $TMPDIR```</p>
<p>```# Make sure you have given enough time for the copy to complete! ```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

A copy of this runscript is available on Legion in: ```

`/shared/ucl/apps/R/TractoR/run-TractoR.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_id>* and *-wd
/home/<your_UCL_id>/Scratch/TractoR\_output* grid engine directives and
the TractoR commands. You may also need to change the *-l thr=12*, *-l
mem=1G* and *-l h\_rt=0:10:0* directives. The script can be submitted
using the simplest form of the qsub command ie: ```

`qsub run-TractoR.sh`

```

Output will be written to *$TMPDIR* and so will need to be copied back
to your ~/Scratch directory - step 10 in the runscript.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")