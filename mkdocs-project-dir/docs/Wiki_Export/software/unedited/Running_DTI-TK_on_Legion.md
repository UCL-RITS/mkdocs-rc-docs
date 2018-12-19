---
title: Running DTI-TK on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
DTI-TK is a set of tools for spatial normalization and atlas
construction optimized for examining white matter morphometry using DTI
data.It has been developed at the Penn Image Computing and Science
Laboratory (PICSL), University of Pennsylvania. Version 2.3.0 is
available on Legion. DTI-TK is intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer interactive tests on the
User Test Nodes.

Before you can use DTI-TK you need to load its module and setup script:
```

`module load dti-tk/2.3.0`  
`source $DTITK_ROOT/scripts/dtitk_common.sh`

``` You can now run DTI-TK programs for example: ```

`dti_rigid_reg ixi_aging_template.nii.gz tensor.nii.gz EDS 4 4 4 0.01`

``` Here is an example run script for submitting batch jobs to the
cluster:

<table>
<tbody>
<tr class="odd">
<td><p>```</p>
<p>```#!/bin/bash -l```</p>
<p>```# Batch script to run a DTI-TK example on Legion with the upgraded```</p>
<p>```# software stack under SGE.```</p>
<p>```#```</p>
<p>```# September 2012```</p>
<p>```#```</p>
<p>```# Based on serial.sh by:```</p>
<p>```#```</p>
<p>```# Owain Kenway, Research Computing, 16/Sept/2010```</p>
<p>```#$ -S /bin/bash```</p>
<p>```# 1. Request 3 hours of wallclock time (format hours:minutes:seconds).```</p>
<p>```#$ -l h_rt=3:0:0```</p>
<p>```# 2. Request 4 gigabyte of RAM.```</p>
<p>```#$ -l mem=4G```</p>
<p>```# 3. Set the name of the job.```</p>
<p>```#$ -N DTI-TK-Job1```</p>
<p>```# 5. Select the project that this job will run under.```</p>
<p>```#$ -P ```<your_project_id></p>
<p>```# 6. Set the working directory to somewhere in your scratch space.  This is```</p>
<p>```# a necessary step with the upgraded software stack as compute nodes cannot```</p>
<p>```# write to $HOME.```</p>
<p>```#```</p>
<p>```# Note: this directory MUST exist before your job starts!```</p>
<p>```# Replace &quot;```<your_UCL_id>```&quot; with your UCL user ID :)```</p>
<p>```#$ -wd /home/```<your_UCL_id>```/Scratch/DTI-TK```</p>
<p>```# 7. Setup DTI-TK runtime environment```</p>
<p>```module load dti-tk/2.3.0```</p>
<p>```source $DTITK_ROOT/scripts/dtitk_common.sh```</p>
<p>```# 8. Your work *must* be done in $TMPDIR ```</p>
<p>```cd $TMPDIR```</p>
<p>```# 9. Run job - an example from one of DTI-TK tutorials:```</p>
<p>```#```</p>
<p>```# ```<a href="http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.FirstRegistration">```http://dti-tk.sourceforge.net/pmwiki/pmwiki.php?n=Documentation.FirstRegistration```</a></p>
<p>```# First copy input files to $TMPDIR```</p>
<p>```cp /shared/ucl/apps/DTI-TK/ixi_aging_template/template/ixi_aging_template.nii.gz $TMPDIR```</p>
<p>```cp /shared/ucl/apps/DTI-TK/DTITK_Sample_Data/tensor_aff.nii.gz $TMPDIR```</p>
<p>```cp /shared/ucl/apps/DTI-TK/ixi_aging_template/template/ixi_aging_template_brain_mask.nii.gz $TMPDIR```</p>
<p>```# Run DTI-TK commands```</p>
<p>```time dti_diffeomorphic_reg ixi_aging_template.nii.gz tensor_aff.nii.gz ixi_aging_template_brain_mask.nii.gz 1 5 0.002```</p>
<p>```# 10. Preferably, tar-up (archive) all output files onto the shared scratch area```</p>
<p>```tar zcvf $HOME/Scratch/DTI-TK/files_from_job_$JOB_ID $TMPDIR```</p>
<p>```# Make sure you have given enough time for the copy to complete!```</p>
<p>```</p></td>
</tr>
</tbody>
</table>

This is available on Legion in ```

`/shared/ucl/apps/DTI-TK/run-dtitk.sh`

``` Please copy if you wish and edit it to suit your jobs. You will
need to change the *-P <your_project_id>* and *-wd
/home/<your_UCL_id>/Scratch/DTI-TK* SGE directives. You will also need
to change the DTI-TK commands in the example and may need to change the
memory, wallclock time and job name directives as well. The script can
be submitted using the simplest form of the qsub command ie: ```

`qsub run-dtitk.sh`

``` Output will be written to $TMPDIR and so will need to be copied
back to your ~/Scratch directory - step 10 in the runscript.

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")