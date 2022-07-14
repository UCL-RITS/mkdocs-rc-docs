---
title: Young GPU Nodes
layout: docs
---

## Pilot access

A group of nominated pilot users have access to these nodes during the pilot, which is 
intended to last for four weeks, until mid-August 2022.

### GPU specs

The nodes are listed in [Young's node types table](../Clusters/Young.md#node-types) 

There are 6 nodes which each have 64 AMD EPYC CPU cores and 8 Nvidia A100-SXM4-40GB GPUs.
They have 1T RAM and 200G local disk is available for `tmpfs` unlike the rest of Young. 
The AMD equivalent of hyperthreading is not enabled.

### Request GPUs

```
# Submit a job to the GPU nodes by adding a request for a number of GPUs
#$ -l gpu=8

# Only Free jobs are available at present. Use your normal projects
#$ -P Free
#$ -A Inst_Project
```

Jobs won't share nodes at the start of the pilot, and you will always get all 8 GPUs 
on each node even if you only ask for 1 until the device cgroups are implemented.

### CUDA versions

The newer CUDA installs we have are made visible by first loading `beta-modules`
but can then be used alongside any other compiler.

```
module load beta-modules
module avail cuda

module load cuda/11.3.1/gnu-10.2.0
```

### Run on a specific device or limit the number visible

If you want to tell your code to run on a specific device or devices, you can set 
`CUDA_VISIBLE_DEVICES` to the ids between 0 and 7. If the code only uses one GPU 
it will usually default to running on device 0, but if it is running on all 8 and 
you don't want it to, you can limit it.

```
# run on gpu 1
export CUDA_VISIBLE_DEVICES=1

# run on gpus 0 and 4
export CUDA_VISIBLE_DEVICES=0,4
```

#### CUDA utility deviceQuery

CUDA has a number of small utilities that come with its examples which can be useful: 
you can take a copy of the samples directory from the corresponding CUDA version - 
for example `/shared/ucl/apps/cuda/11.3.1/gnu-10.2.0/samples/` and build those utilities 
with their corresponding CUDA module loaded.

`samples/1_Utilities/deviceQuery` will give you a small utility that will confirm that 
setting `CUDA_VISIBLE_DEVICES` is working - you can run it before and after setting it. 
The devices will have been renamed as 0 and 1 in its output, but the location IDs will 
be the same as when you could see all of them.

### Setting PPN

You will also be able to set the number of cpu slots per node that you want. 
Instead of `-pe smp` or `-pe mpi`, you would request:

```
-pe ppn=<slots per node> <total slots>
```

```
# this would give you 4 slots per node and 8 slots total (so is using 2 nodes)
#$ -pe ppn=4 8
```

Like `-pe mpi` this will also create a suitable machinefile for you so MPI will know 
how many cores on which nodes it can use. `gerun` (our mpirun wrapper) will use it 
automatically for Intel MPI as usual and our OpenMPI modules shouldn't need it since they 
have scheduler integration, but you can find it in `$TMPDIR/machines` if you are using 
mpirun and need it.

### Request tmpfs

The GPU nodes do have local disks and you can request an amount of tmpfs up to the maximum 
200G like this:

```
# Request a $TMPDIR of 20G
#$ -l tmpfs=20G
```

In the job, you refer to this using `$TMPDIR`. Many programs will use this environment
variable for temporary files automatically, or you may need to tell them to do it
explicitly with a command line argument.

`$TMPDIR` is deleted at the end of the job, so if you need any data that is being written
to there, copy it back to your Scratch at the end of the job.


