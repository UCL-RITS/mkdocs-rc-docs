---
title: GPU nodes
layout: docs
---

# GPU Nodes

## Node Types

You can view the hardware specifications for GPU node types on the [RC Systems Platforms Overview](RC_Systems.md) page.

There are GPU nodes available in Legion and Myriad.

### Legion Type P GPU node

There is one NVIDIA K40c GPU node in Legion. To use this, you need to
specify this in your jobscript or [interactive qrsh request](Interactive_Jobs.md) (remove the `#$` for qrsh): 

```
#$ -l gpu=1
```

### Myriad Type J GPU nodes

Myriad has two GPU nodes each with two NVIDIA Tesla P100s. To use them,
you need to request one or two GPUs in your jobscript or [interactive
qrsh request](Interactive Jobs) (remove the `#$` for qrsh):

```
#$ -l gpu=2
```

## Available modules

You can see the available CUDA modules by typing

```
`module avail cuda`
```

## Sample CUDA code

There are samples in the CUDA install locations, e.g. 

```
/shared/ucl/apps/cuda/7.5.18/gnu-4.9.2/samples
/shared/ucl/apps/cuda/8.0.61/gnu-4.9.2/samples
``` 

which are further documented [by NVIDIA here](http://docs.nvidia.com/cuda/cuda-samples/index.html). In general,
you should look at their CUDA docs: <http://docs.nvidia.com/cuda/>

## Sample jobscripts

You can see [sample jobscripts here](Example Scripts).

Use this in your script to request up to 2 GPUs. 

```
`#$ -l gpu=2`
```

Load GCC and the relevant CUDA module. 

```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load cuda/7.5.18/gnu-4.9.2
```

## Running the sample code

To get started, here's how you would compile and run one of the cuda
samples interactively on a user test node using a GPU.

1\. Load the cuda module 

```
`module unload compilers mpi`  
`module load compilers/gnu/4.9.2`  
`module load cuda/7.5.18/gnu-4.9.2`
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

Please note: if the code you are trying to compile needs to link
libcuda, it must also be built on a GPU node because only the GPU node
has the correct libraries.

The NVIDIA examples don't require this, but things like Tensorflow do.

## Tensorflow

Tensorflow is installed: type `module avail tensorflow` to see the
available versions.

Modules to load for the non-MKL GPU version: 

```
module unload compilers mpi  
module load compilers/gnu/4.9.2  
module load python3/recommended  
module load cuda/8.0.61-patch2/gnu-4.9.2  
module load cudnn/6.0/cuda-8.0  
module load tensorflow/1.4.1/gpu
```

## Using MPI and GPUs

It is possible to run MPI programs that use GPUs but only within a
single node, so you can request 1 GPU and 12 processor cores on Legion, or up to 2
GPUs and 36 cores on Myriad.

# Looking for more GPUs?

  - [GPU clusters available to UCL users](GPU_clusters).

