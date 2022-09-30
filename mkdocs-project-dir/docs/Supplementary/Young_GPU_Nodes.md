---
title: Young GPU Nodes
layout: docs
---

## Pilot access

A group of nominated pilot users had access to these nodes during the pilot, which lasted
from 15 July to 5 September 2022. They are now available to all.

## GPU specs

The nodes are listed in [Young's node types table](../Clusters/Young.md#node-types) 

There are 6 nodes which each have 64 AMD EPYC CPU cores and 8 Nvidia A100-SXM4-40GB GPUs.
They have 1T RAM and 200G local disk is [available to request](#request-tmpfs) as `tmpfs` 
unlike the rest of Young. 
The AMD equivalent of hyperthreading is not enabled.

## Request GPUs

```
# Submit a job to the GPU nodes by adding a request for a number of GPUs
#$ -l gpu=8

# Only Free jobs are available at present. Use your normal projects
#$ -P Free
#$ -A Inst_Project
```

At the start of the pilot, jobs did not share nodes and users always had access to all 
GPUs on each node. This has since been altered and device 
cgroups are implemented (as of 10 Aug 2022) so jobs can share nodes on the GPU 
nodes and each only have access to the number of GPUs they requested.

For example, 8 separate single-GPU jobs from different users can be running on one node, 
or 2 4-GPU jobs. Multi-node parallel GPU jobs do not share nodes, so a job asking for 
9-15 GPUs will block out the entire 16 GPUs on those two nodes.

### Exclusive use of nodes

If you are using fewer than 8 GPUs but want to make sure nothing else is running on
the same node as you, add this to your jobscript:

```
#$ -ac exclusive
```

This would generally only be done if you are benchmarking or investigating speeds
and want to rule out anything else running on the rest of the node as possibly
affecting your timings.

## CUDA versions

The newer CUDA installs we have are made visible by first loading `beta-modules`
but can then be used alongside any other compiler.

```
module load beta-modules
module avail cuda

# pick one of the 11.x CUDA installs
module load cuda/11.3.1/gnu-10.2.0
# or
module load cuda/11.2.0/gnu-10.2.0
```

### Choosing a CUDA version

The drivers we have installed on the GPU nodes are version 460.27.03 which is CUDA 11.2.
CUDA 11 has minor version compatibility so in most cases you can use the 11.3.1 runtime,
but not all functionality is available.

If your code builds but when running it you get an error like this:

```
CUDA RUNTIME API error: Free failed with error cudaErrorUnsupportedPtxVersion 
```

then use the `cuda/11.2.0/gnu-10.2.0` module to build and run your program instead.

### Building with CUDA

If the code you are trying to build only needs to link to the CUDA runtime libraries,
`libcudart.so` then you can build it on the login nodes which do not have GPUs.

If it needs the full `libcuda.so` to be available, you need to build it on a GPU node.
You can submit it as a job or request an [interactive session with qrsh](../Interactive_Jobs.md). 
Eg:

```
qrsh -l gpu=8,h_rt=2:0:0,tmpfs=10G,mem=1G -pe smp 4 -P Free -A Inst_Project -now no
```

### NVIDIA documentation

NVIDIA has some useful information at these locations:

 * [Building Ampere compatible apps using CUDA 11](https://docs.nvidia.com/cuda/ampere-compatibility-guide/index.html#building-ampere-compatible-apps-using-cuda-11-0)
 * [CUDA Toolkit release notes](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)


## Run on a specific device or limit the number visible

If you want to tell your code to run on a specific device or devices, you can set 
`CUDA_VISIBLE_DEVICES` to the ids between 0 and 7. If the code only uses one GPU 
it will usually default to running on device 0, but if it is running on all GPUs that
belong to your job and you don't want it to, you can limit it.

```
# run on gpu 1
export CUDA_VISIBLE_DEVICES=1

# run on gpus 0 and 4
export CUDA_VISIBLE_DEVICES=0,4
```

### CUDA utility deviceQuery

CUDA has a number of small utilities that come with its examples which can be useful: 
you can take a copy of the samples directory from the corresponding CUDA version - 
for example `/shared/ucl/apps/cuda/11.3.1/gnu-10.2.0/samples/` and build those utilities 
with their corresponding CUDA module loaded.

`samples/1_Utilities/deviceQuery` will give you a small utility that will confirm that 
setting `CUDA_VISIBLE_DEVICES` is working - you can run it before and after setting it. 
The devices will have been renamed as 0 and 1 in its output, but the location IDs will 
be the same as when you could see all of them.

## Setting PPN

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

## Request tmpfs

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

## Software of interest

GPU software we have installed that may be of particular interest to users of Young.

 * [VASP 6 GPU](../Software_Guides/Other_Software.md/#vasp-6-gpu)
 * [GROMACS 2021.5 GPU](../Software_Guides/Other_Software/#gromacs)
 * [NAMD 2.14 GPU](../Software_Guides/Other_Software/#namd)
 * [LAMMPS 29 Sep 21 Update 2 GPU](../Software_Guides/Other_Software/#lammps)
 
You can also use [NVIDIA Grid Cloud Containers](NVIDIA_Containers.md) via Singularity
which provide pre-configured GPU applications. Our page gives an example of using the 
NAMD 3 container.


