---
title: Running Hybrid OpenMP/MPI Code
layout: docs
---
If you wish to submit a job that combines MPI and OpenMP parallelisation
then you have a number of challenges you need to think about. 

First of all, you may need to use an MPI library that is thread-safe -- that does not keep MPI state in shared memory between processor threads. 
Support for this in OpenMPI is still in development, and Intel MPI (the default on our systems) is recommended for this instead.

This guide will give you are short walk-through of the process of
writing, building and running a simple hybrid code on Legion.

## Set up modules

The default modules are correct - in case you have others loaded, these
are what you need:

```
module unload compilers mpi  
module load compilers/intel/2015/update2  
module load mpi/intel/2015/update3/intel
```

You can check the MPI you have loaded by running `mpif90 -v` You should
see something similar to the output below:

```
mpif90 for the Intel(R) MPI Library 5.0 Update 3 for Linux*  
Copyright(C) 2003-2015, Intel Corporation.  All rights reserved.  
ifort version 15.0.2
```

## Compile the code

To compile the code, you need to use the mpif90 compiler wrapper (or the
C equivalent for your own C code) and pass it the -openmp option to
enable the processing of OpenMP directives. Run:

```
mpif90 -o hybrid -openmp hybrid.f90
```

This should produce a binary called "hybrid" in your current working
directory.


## Submit the Job

You will need to request the total number of cores you wish to use, and either set
`$OMP_NUM_THREADS` for the number of OpenMP threads yourself, or allow it to be
worked out automatically by setting it to `OMP_NUM_THREADS=$(ppn)`.
That will set `$OMP_NUM_THREADS` to `$NSLOTS/$NHOSTS`, so you can use threads
within a node and MPI between nodes and don't need to know in advance what size
of node you are running on. GERun will then run `$NSLOTS/$OMP_NUM_THREADS`
processes, round-robin allocated (if supported by the MPI). 

Therefore, if you want to use 24 cores on the type X nodes, with one MPI process per node and 12 threads per process you would request the example below.

Note that if you are using multiple nodes and `ppn`, you get exclusive access to those nodes, so if you ask for 2.5 nodes-worth of cores you will end up with more threads on the last node than you thought you had.

```
#!/bin/bash -l

# Batch script to run a hybrid parallel job under SGE with Intel MPI.

#$ -S /bin/bash

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space per node (default is 10 GB)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N MadIntelHybrid

# Select the MPI parallel environment and 24 cores.
#$ -pe mpi 24

# Set the working directory to somewhere in your scratch space.
#$ -wd /home/<your_UCL_id/scratch/output/

# Automatically set threads to processes per node: if on X nodes = 12 OMP threads
export OMP_NUM_THREADS=$(ppn)

# Run our MPI job with the default modules. Gerun is a wrapper script for mpirun. 

gerun $HOME/src/madscience/madhybrid
```


If you want to specify a specific number of OMP threads, you would alter the relevant lines above to this:

```
# Run 12 MPI processes, each spawning 2 threads
#$ -pe mpi 24
export OMP_NUM_THREADS=2
gerun your_binary
```
