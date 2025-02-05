---
title: R
layout: docs
---

Type `module avail r` to see the currently available versions of R.

The current version will always also exist as `r/recommended` - this is a module bundle and loading it will also load its many dependencies.

`module show r/recommended` shows you exactly which versions loading this module will give you.

R can be run on a single core or multithreaded using many cores (some commands can run threaded automatically, otherwise you may wish to look at R's `parallel` package). 

`doMPI`, `Rmpi` and `snow` allow multi-node parallel jobs using MPI to be run.

[List of additional R packages](../Installed_Software_Lists/r-packages.md) shows you what packages are installed and available for the current R version.

## Setup

Before you can use R interactively, you need to load the R module using: 

```
module -f unload compilers mpi gcc-libs
module load r/recommended
```

## Example serial jobscript

This script runs R using only one core.

```
#!/bin/bash -l

# Example jobscript to run a single core R job

# Request ten minutes of wallclock time (format hours:minutes:seconds).
# Change this to suit your requirements.
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM. Change this to suit your requirements.
#$ -l mem=1G

# Set the name of the job. You can change this if you wish.
#$ -N R_job_1

# Set the working directory to somewhere in your scratch space.  This is
# necessary because the compute nodes cannot write to your $HOME
# NOTE: this directory must exist.
# Replace "<your_UCL_id>" with your UCL user ID
#$ -wd /home/<your_UCL_id>/Scratch/R_output

# Your work must be done in $TMPDIR (serial jobs particularly) 
cd $TMPDIR

# Load the R module and run your R program
module -f unload compilers mpi gcc-libs
module load r/recommended

R --no-save < /home/username/Scratch/myR_job.R > myR_job.out

# Preferably, tar-up (archive) all output files to transfer them back 
# to your space. This will include the R_output file above.
tar zcvf $HOME/Scratch/R_output/files_from_job_$JOB_ID.tgz $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

You will need to change the `-wd /home/<your_UCL_id>/Scratch/R_output` location and the location of your R input file, called `myR_job.R` here.  `myR_job.out` is the file we are redirecting the output into. The output file is saved in the tar archive produced by the last command in the runscript and will be in `$HOME/Scratch/R_output`. 

If your jobscript is called `run-R.sh` then your job submission command would be:
```
qsub run-R.sh
``` 

## Example shared memory threaded parallel job

This script uses multiple cores on the same node. It cannot run across multiple nodes.

```
#!/bin/bash -l

# Example jobscript to run an OpenMP threaded R job across multiple cores on one node.
# This may be using the foreach packages foreach(...) %dopar% for example.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
# Change this to suit your requirements.
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per core. Change this to suit your requirements.
#$ -l mem=1G

# Set the name of the job. You can change this if you wish.
#$ -N R_jobMC_2

# Select 12 threads. The number of threads here must equal the number of worker 
# processes in the registerDoMC call in your R program.
#$ -pe smp 12

# Set the working directory to somewhere in your scratch space.  This is
# necessary because the compute nodes cannot write to your $HOME
# NOTE: this directory must exist.
# Replace "<your_UCL_id>" with your UCL user ID
#$ -wd /home/<your_UCL_id>/Scratch/R_output

# Your work must be done in $TMPDIR
cd $TMPDIR

# Load the R module and run your R program
module -f unload compilers mpi gcc-libs
module load r/recommended

R --no-save < /home/username/Scratch/myR_job.R > myR_job.out

# Preferably, tar-up (archive) all output files to transfer them back 
# to your space. This will include the R_output file above.
tar zcvf $HOME/Scratch/R_output/files_from_job_$JOB_ID.tgz $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

You will need to change the `-wd /home/<your_UCL_id>/Scratch/R_output` location and the location of your R input file, called `myR_job.R` here.  `myR_job.out` is the file we are redirecting the output into. The output file is saved in the tar archive produced by the last command in the runscript and will be in `$HOME/Scratch/R_output`.

If your jobscript is called `run-R.sh` then your job submission command would be:
```
qsub run-R.sh
``` 

## Example multi-node parallel job using Rmpi and snow

This script uses Rmpi and snow to allow it to run across multiple nodes using MPI.

```
#!/bin/bash -l

# Example jobscript to run an R MPI parallel job

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per process.
#$ -l mem=1G

# Request 15 gigabytes of TMPDIR space per node (default is 10 GB)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N snow_monte_carlo

# Select the MPI parallel environment with 32 processes
#$ -pe mpi 32

# Set the working directory to somewhere in your scratch space.  This is
# necessary because the compute nodes cannot write to your $HOME
# NOTE: this directory must exist.
# Replace "<your_UCL_id>" with your UCL user ID
#$ -wd /home/<your_UCL_id>/Scratch/R_output

# Load the R module
module -f unload compilers mpi gcc-libs
module load r/recommended

# Copy example files in to the working directory (not necessary if already there)
cp ~/R/Examples/snow_example.R .
cp ~/R/Examples/monte_carlo.R .

# Run our MPI job. GERun is our wrapper for mpirun, which launches MPI jobs  
gerun RMPISNOW < snow_example.R > snow.out.${JOB_ID}
```
The output file is saved in `$HOME/Scratch/R_examples/snow/snow.out.${JOB_ID}`.

If your jobscript is called `run-R-snow.sh` then your job submission command would be:
```
qsub run-R-snow.sh
```

### Example R script using Rmpi and snow

This R script has been written to use Rmpi and snow and can be used with the above jobscript. It is `snow_example.R` above.

```
#Load the snow and random number package.
library(snow)
library(Rmpi)

# This example uses the already installed LEcuyers RNG library(rlecuyer)
library(rlecuyer)

# Set up our input/output
source('./monte_carlo.R')
sink('./monte_carlo_output.txt')

# Get a reference to our snow cluster that has been set up by the RMPISNOW
# script.
cl <- getMPIcluster ()

# Display info about each process in the cluster
print(clusterCall(cl, function() Sys.info()))

# Load the random number package on each R process
clusterEvalQ (cl, library (rlecuyer))

# Generate a seed for the pseudorandom number generator, unique to each
# processor in the cluster.

#Uncomment below line for default (unchanging) random number seed.
#clusterSetupRNG(cl, type = 'RNGstream')

#The lines below set up a time-based random number seed.  Note that 
#this only demonstrates the virtues of changing the seed; no guarantee
#is made that this seed is at all useful.  Comment out if you uncomment
#the above line.
s <- sum(strtoi(charToRaw(date()), base = 32))
clusterSetupRNGstream(cl, seed=rep(s,6))

#Choose which of the following blocks best fit your own needs.

# BLOCK 1
# Set up the input to our Monte Carlo function.
# Input is identical across the batch, only RNG seed has changed. 
# For this example, both clusters will roll one die. 

nrolls <- 2
print("Roll the dice once...")
output <- clusterCall(cl, monte_carlo, nrolls)
output
print("Roll the dice again...")
output <- clusterCall(cl, monte_carlo, nrolls)
output

# Output should show the results of two rolls of a six-sided die.

#BLOCK 2
# Input is different for each processor
print("Second example: coin flip plus 3 dice")
input <- array(1:2)  # Set up array of inputs, with each entry
input[1] <- 1        #   corresponding to one processor.
input[2] <- 3
parameters <- array(1:2)  # Set up inputs that will be used by each cluster.
parameters[1] <- 2        #   These will be passed to monte_carlo as its
parameters[2] <- 6        #   second argument.
output <- clusterApply(cl, input, monte_carlo, parameters)

# Output should show the results of a coin flip and the roll of three 
# six-sided die.

# Output the output.
output

inputStrings <- array(1:2)
inputStrings[1] <- 'abc'
inputStrings[2] <- 'def'
output <- clusterApply(cl, inputStrings, paste, 'foo')
output

#clusterEvalQ(cl, sinkWorkerOutput("snow_monte_carlo.out"))

# Clean up the cluster and release the relevant resources.
stopCluster(cl)
sink()

mpi.quit()
```

This is `monte_carlo.R` which is called by `snow_example.R`:
```
monte_carlo <- function(x, numsides=6){
  streamname <- .lec.GetStreams ()
  dice <- .lec.uniform.int(streamname[1], n = 1, a=1, b=numsides)
  outp <- sum(dice)
  return(outp)
}
```

This example was based on [SHARCNET's Using R and MPI](https://web.archive.org/web/20190107091729/https://www.sharcnet.ca/help/index.php/Using_R_and_MPI).

## Using your own R packages

If we do not have R packages installed centrally that you wish to use, you can 
install them in your space on the cluster and tell R where to find them.

First you need to tell R where to install your package to and where to look for user-installed packages, using the R library path.

### Set your R library path

There are several ways to modify your R library path so you can pick up packages that you have installed in your own space.

The easiest way is to add them to the `R_LIBS` environment variable (insert the correct path):
```
export R_LIBS=/your/local/R/library/path:$R_LIBS
```

This is a colon-separated list of directories that R will search through. 

Setting that in your terminal will let you install to that path from inside R and 
should also be put in your jobscript (or your `.bashrc`) when you submit a job 
using those libraries. This appends your directory to the existing value of 
`$R_LIBS` rather than overwriting it so the centrally-installed libraries can still be found.

You can also change the library path for a session from within R:
```
.libPaths(c('~/MyRlibs',.libPaths()))
```

This puts your directory at the beginning of R's search path, and means that `install.packages()` will automatically put packages there and the `library()` function will find libraries in your local directory.

### Install an R package

To install, after setting your library path:

From inside R, you can do
```
install.packages('package_name', repos="http://cran.r-project.org")
```

Or if you have downloaded the tar file, you can do
```
R CMD INSTALL -l /home/username/your_R_libs_directory package.tar.gz
```

If you want to keep some libraries separate, you can have multiple colon-separated paths in your `$R_LIBS` and specify which one you want to install into with `R CMD INSTALL`.

## BioConductor

If you are installing extra packages for BioConductor, check that you are using the same version that the R module you have loaded is using.

Eg. you can find the [BioConductor 3.15 package downloads here](http://www.bioconductor.org/packages/3.15/BiocViews.html#___Software).

