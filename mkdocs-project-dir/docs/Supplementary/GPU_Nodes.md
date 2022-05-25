---
title: GPU nodes
layout: docs
---

# GPU Nodes

## Node Types

You can view the hardware specifications for [GPU node types in Myriad](../Clusters/Myriad.md).

There are several types of GPU nodes available in Myriad.

## Available modules

You can see all the available CUDA modules by typing

```
module load beta-modules
module avail cuda
```

The ones that become visible once you load `beta-modules` have been built with newer
compilers.

## Sample CUDA code

There are samples in some CUDA install locations, e.g. 

```
/shared/ucl/apps/cuda/7.5.18/gnu-4.9.2/samples
/shared/ucl/apps/cuda/8.0.61/gnu-4.9.2/samples
``` 

which are further documented [by NVIDIA here](http://docs.nvidia.com/cuda/cuda-samples/index.html). In general,
you should look at their CUDA docs: <http://docs.nvidia.com/cuda/>

## Sample jobscripts

You can see [sample jobscripts here](../Example_Jobscripts.md#gpu-job-script-example).

Use this in your script to request up to 2 GPUs. 

```
#$ -l gpu=2
```

Load GCC and the relevant CUDA module. 

```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load cuda/7.5.18/gnu-4.9.2
```

## Running the sample code

To get started, here's how you would compile one of the CUDA
samples and run it in an interactive session on a GPU node.

You can compile CUDA code on the login nodes like this (which do not have GPUs) if
they do not require all the CUDA libraries to be present at compile time. If they do, you'll
get an error saying it cannot link the CUDA libraries, and `ERROR: CUDA could not be found on your system`  and you will need tro do your compiling on the GPU node as well.

1\. Load the cuda module 

```
module unload compilers mpi
module load compilers/gnu/4.9.2 
module load cuda/7.5.18/gnu-4.9.2
```

2\. Copy the samples directory to somewhere in your home (or to Scratch
if you're building on the GPU node or are going to want a job to write
anything in the same directory).

```
cp -r /shared/ucl/apps/cuda/7.5.18/gnu-4.9.2/NVIDIA_CUDA-7.5_Samples/ ~/cuda
```

3\. Choose an example: eigenvalues in this case, and build using the
provided makefile - if you have a look at it you can see it is using
nvcc and g++. 

```
cd NVIDIA_CUDA-7.5_Samples/6_Advanced/eigenvalues/
make
```

4\. Request an interactive job with a GPU and wait to be
given access to the node. You will see your prompt change to indicate
that you are on a different node than the login node once your qrsh
request has been scheduled, and you can then continue. Load the cuda
module on the node and run the program. 

```
qrsh -l mem=1G,h_rt=0:30:0,gpu=1 -now no

# wait for interactive job to start

module unload compilers mpi
module load compilers/gnu/4.9.2
module load cuda/7.5.18
cd ~/cuda/NVIDIA_CUDA-7.5_Samples/6_Advanced/eigenvalues/
./eigenvalues
```

5\. Your output should look something like this: 

```
Starting eigenvalues  
GPU Device 0: "Tesla M2070" with compute capability 2.0

Matrix size: 2048 x 2048   
Precision: 0.000010  
Iterations to be timed: 100  
Result filename: 'eigenvalues.dat'  
Gerschgorin interval: -2.894310 / 2.923303  
Average time step 1: 26.739325 ms  
Average time step 2, one intervals: 9.031162 ms  
Average time step 2, mult intervals: 0.004330 ms  
Average time TOTAL: 35.806992 ms  
Test Succeeded!
```

## Building your own code

As above, if the code you are trying to compile needs to link against
libcuda, it must also be built on a GPU node because only the GPU nodes
have the correct libraries.

The NVIDIA examples don't require this, but things like Tensorflow do.

## Tensorflow

Tensorflow is installed: type `module avail tensorflow` to see the
available versions.

Modules to load for the non-MKL GPU version: 

```
module unload compilers mpi 
module load compilers/gnu/4.9.2  
module load python3/3.7
module load cuda/10.0.130/gnu-4.9.2  
module load cudnn/7.4.2.24/cuda-10.0
module load tensorflow/2.0.0/gpu-py37
```

## PyTorch

PyTorch is installed: type `module avail pytorch` to see the versions
available.

Modules to load the most recent release we have installed (May 2022)
are:

```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python3/3.9-gnu-10.2.0
module load cuda/11.3.1/gnu-10.2.0
module load cudnn/8.2.1.32/cuda-11.3
module load pytorch/1.11.0/gpu
```

If you want the CPU only version there use:

```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python3/3.9-gnu-10.2.0
module load pytorch/1.11.0/cpu
```

## Using MPI and GPUs

It is possible to run MPI programs that use GPUs but only within a
single node, so you can request up to 4 GPUs and 36 cores on Myriad.

## Looking for more GPUs?

  - [GPU clusters available to UCL users](GPU_Clusters.md).

