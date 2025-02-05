---
title: Example Jobscripts
categories:
 - User Guide
layout: docs
---
On this page we describe some basic example scripts to submit jobs to
our clusters.

After creating your script, submit it to the scheduler with:

`qsub my_script.sh`

## Service Differences

These scripts are applicable to all our clusters, but node sizes (core count, memory, and temporary storage sizes) differ between machines, so please check those details on the cluster-specific pages.
Some clusters are diskless and have no temporary space that can be requested.

## Working Directories and Output

The parallel filesystems we use to provide the home and scratch filesystems perform best when reading or writing single large files, and worst when operating on many different small files. To avoid causing problems, many of the scripts below are written to create all their files in the temporary `$TMPDIR` storage, and compress and copy them to the scratch area at the end of the job.

This can be a problem if your job is not finishing and you need to see the output, or if your job is crashing or failing to produce what you expected. Feel free to modify the scripts to read from or write to Scratch directly, however, your performance will generally not be as good as writing to `$TMPDIR`, and you may impact the general performance of the machine if you do this with many jobs simultaneously. This is particularly the case with single-core jobs, because that core is guaranteed to be writing out data.

Please be aware that some clusters are diskless (eg Kathleen) and have no `$TMPDIR` available 
for use - in those you must remove the request for `tmpfs` in your script. Check the 
cluster-specific pages.

Note that there is also the option of using [the `Local2Scratch` process](#example-array-job-using-local2scratch), 
which takes place *after* the job has finished, in the clean-up step. This gives you the option of always
getting the contents of `$TMPDIR` back, at the cost of possibly getting incomplete
files and not having any control over where the files go.

## Note about Projects

Projects are a system used in the scheduler and the accounting system 
to track budgets and access controls.

Most users of UCL's internal clusters will not need to specify a project and will default to the AllUsers 
project. Users of the Michael and Young services should refer to the specific 
pages for those machines, and the information they were given when they registered.

To specify a project ID in a job script, use the `-P` object as below:

```
#$ -P <your_project_id>
```

## Resources

The lines starting with `#$ -l` are where you are requesting resources like wallclock 
time (how long your job is allowed to run), memory, and possibly tmpfs (local hard 
disk space on the node, if it is not diskless). In the case for array jobs, each job in the array is treated independently by the scheduler and are each allocated the same resources as are requested. For example, in a job array of 40 jobs requesting for 24 hours wallclock time and 3GB ram, each job in the array will be allocated 24 hours wallclock time and 3GB ram. Wallclock time does not include the time spent waiting in the queue. More details on how to request resources can be found [here](https://www.rc.ucl.ac.uk/docs/Experienced_Users/#resources-you-can-request).

If you have no notion of how much you should request for any of these, have a look at [How do I estimate what resources to request in my jobscript?](howto.md#how-do-i-estimate-what-resources-to-request-in-my-jobscript)

Useful resources:

- [Resource requests (Moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846681) (UCL users)
- [Resource requests pt.2 (Moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846689) (UCL users)
- [Resource requests (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98371) (non-UCL users)
- [Resource requests pt.2 (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98393) (non-UCL users)

## Serial Job Script Example

The most basic type of job a user can submit is a serial job. These jobs run on a single processor (core) with a single thread. 

Shown below is a simple job script that runs /bin/date (which prints the current date) on the compute node, and puts the output into a file.

```bash
#!/bin/bash -l

# Batch script to run a serial job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N Serial_Job

# Set the working directory to somewhere in your scratch space.  
#  This is a necessary step as compute nodes cannot write to $HOME.
# Replace "<your_UCL_id>" with your UCL user ID.
#$ -wd /home/<your_UCL_id>/Scratch/workspace

# Your work should be done in $TMPDIR 
cd $TMPDIR

# Run the application and put the output into a file called date.txt
/bin/date > date.txt

# Preferably, tar-up (archive) all output files onto the shared scratch area
tar -zcvf $HOME/Scratch/workspace/files_from_job_$JOB_ID.tar.gz $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

## Multi-threaded Job Example

For programs that can use multiple threads, you can request multiple processor cores using the `-pe smp <number>` option. One common method for using multiple threads in a program is OpenMP, and the `$OMP_NUM_THREADS` environment variable is set automatically in a job of this type to tell OpenMP how many threads it should use. Most methods for running multi-threaded applications should correctly detect how many cores have been allocated, though (*via* a mechanism called `cgroups`).

Note that this job script works directly in scratch instead of in the temporary `$TMPDIR` storage.

```bash
#!/bin/bash -l

# Batch script to run an OpenMP threaded job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N Multi-threaded_Job

# Request 16 cores.
#$ -pe smp 16

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID
#$ -wd /home/<your_UCL_id>/Scratch/output

# 8. Run the application.
$HOME/my_program/example
```

## MPI Job Script Example

The default MPI implementation on our clusters is the Intel MPI stack. MPI programs don’t use a shared memory model so they can be run across multiple nodes.
This script differs considerably from the serial and OpenMP jobs in that MPI programs need to be invoked by a program called gerun. This is our wrapper for mpirun and takes care of passing the number of processors and a file called a machine file.

***Important***: If you wish to pass a file or stream of data to the standard input (stdin) of an MPI program, there are specific command-line options you need to use to control which MPI tasks are able to receive it. (`-s` for Intel MPI, `--stdin` for OpenMPI.) Please consult the help output of the `mpirun` command for further information. The `gerun` launcher does not automatically handle this.

If you use OpenMPI, you need to make sure the Intel MPI modules are removed and the OpenMPI 
modules are loaded, either in your jobscript or in your shell start-up files (e.g. `~/.bashrc`).

```bash
#!/bin/bash -l

# Batch script to run an MPI parallel job under SGE with Intel MPI.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per process (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space per node 
# (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N MadScience_1_16

# Select the MPI parallel environment and 16 processes.
#$ -pe mpi 16

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID :
#$ -wd /home/<your_UCL_id>/Scratch/output

# Run our MPI job.  GERun is a wrapper that launches MPI jobs on our clusters.
gerun $HOME/src/science/simulate
```


## Array Job Script Example

If you want to submit a large number of similar serial jobs then it may be
easier to submit them as an array job. Array jobs are similar to serial jobs
except we use the `-t` option to get Sun Grid Engine to run 10,000 copies of
this job numbered 1 to 10,000. Each job in this array will have the same job ID
but a different task ID. The task ID is stored in the `$SGE_TASK_ID` environment
variable in each task. All the usual SGE output files have the task ID
appended. MPI jobs and parallel shared memory jobs can also be submitted as
arrays.

```bash
#!/bin/bash -l

# Batch script to run a serial array job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set up the job array.  In this instance we have requested 10000 tasks
# numbered 1 to 10000.
#$ -t 1-10000

# Set the name of the job.
#$ -N MyArrayJob

# Set the working directory to somewhere in your scratch space. 
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/output

# Run the application.

echo "$JOB_NAME $SGE_TASK_ID"
```

## Array Job Script Example Using Parameter File

Often a user will want to submit a large number of similar jobs but their input parameters don't match easily on to an index from 1 to n. In these cases it's possible to use a parameter file. To use this script a user needs to construct a file with a line for each element in the job array, with parameters separated by spaces.

For example: 

```
0001 1.5 3 aardvark
0002 1.1 13 guppy
0003 1.23 5 elephant
0004 1.112 23 panda
0005 ...
```

Assuming that this file is stored in `~/Scratch/input/params.txt` (you can call
this file anything you want) then the user can use awk/sed to get the
appropriate variables out of the file. The script below does this and stores
them in `$index`, `$variable1`, `$variable2` and `$variable3`.  So for example in task
4, `$index = 0004`, `$variable1 = 1.112`, `$variable2 = 23` and `$variable3 = panda`.

Since the parameter file can be generated automatically from a user's datasets,
this approach allows the simple automation, submission and management of
thousands or tens of thousands of tasks.

```bash
#!/bin/bash -l

# Batch script to run an array job.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set up the job array.  In this instance we have requested 1000 tasks
# numbered 1 to 1000.
#$ -t 1-1000

# Set the name of the job.
#$ -N array-params

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/output

# Parse parameter file to get variables.
number=$SGE_TASK_ID
paramfile=/home/<your_UCL_id>/Scratch/input/params.txt

index="`sed -n ${number}p $paramfile | awk '{print $1}'`"
variable1="`sed -n ${number}p $paramfile | awk '{print $2}'`"
variable2="`sed -n ${number}p $paramfile | awk '{print $3}'`"
variable3="`sed -n ${number}p $paramfile | awk '{print $4}'`"

# Run the program (replace echo with your binary and options).

echo "$index" "$variable1" "$variable2" "$variable3"
```

## Example Array Job Using Local2Scratch

Users can automate the transfer of data from `$TMPDIR` to their scratch space by
adding the text `#Local2Scratch` to their script on a line alone as a special comment.
During the clean-up phase of the job, a tool checks whether the script contains that
text, and if so, files are transferred from `$TMPDIR` to a directory in scratch
with the structure `<job id>/<job id>.<task id>.<queue>/`.

The example below does this for a job array, but this works for any job type.

```bash
#!/bin/bash -l

# Batch script to run an array job under SGE and 
#  transfer the output to Scratch from local.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set up the job array.  In this instance we have requested 10000 tasks
# numbered 1 to 10000.
#$ -t 1-10000

# Set the name of the job.
#$ -N local2scratcharray

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/output

# Automate transfer of output to Scratch from $TMPDIR.
#Local2Scratch

# Run the application in TMPDIR.
cd $TMPDIR
hostname > hostname.txt
```

## Array Job Script with a Stride

If each task for your array job is very small, you will get better use of the cluster if you can combine a number of these so each has a couple of hours' worth of work to do. There is a startup cost associated with the amount of time it takes to set up a new job. If your job's runtime is very small, this cost is proportionately high, and you incur it with every array task.

Using a stride will allow you to leave your input files numbered as before, and each array task will run N inputs.

For example, a stride of 10 will give you these task IDs: 1, 11, 21...

Your script can then have a loop that runs task IDs from `$SGE_TASK_ID` to `$SGE_TASK_ID + 9`, so each task is doing ten times as many runs as it was before.

```bash
#!/bin/bash -l

# Batch script to run an array job with strided task IDs under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set up the job array.  In this instance we have requested task IDs
# numbered 1 to 10000 with a stride of 10.
#$ -t 1-10000:10

# Set the name of the job.
#$ -N arraystride

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/output

# Automate transfer of output to Scratch from $TMPDIR.
#Local2Scratch

# Do your work in $TMPDIR 
cd $TMPDIR

# 10. Loop through the IDs covered by this stride and run the application if 
# the input file exists. (This is because the last stride may not have that
# many inputs available). Or you can leave out the check and get an error.
for (( i=$SGE_TASK_ID; i<$SGE_TASK_ID+10; i++ ))
do
  if [ -f "input.$i" ]
  then
    echo "$JOB_NAME" "$SGE_TASK_ID" "input.$i"
  fi
done
```

## Hybrid MPI plus OpenMP jobscript example

This is a type of job where you have a small number of MPI processes, and each
one of those launches a number of threads. One common form of this is to have
only one MPI process per node which handles communication between nodes, and 
the work on each node is done in a shared memory style by threads.

When requesting resources for this type of job, what you are asking the scheduler
for is the physical number of cores and amount of memory per core that you need.
Whether you end up running MPI processes or threads on that core is up to your code.
(The `-pe mpi xx` request is telling it you want an MPI parallel environment and 
xx number of cores, not that you want xx MPI processes - this can be confusing).

### Setting number of threads

You can either set `$OMP_NUM_THREADS` for the number of OpenMP threads yourself, 
or allow it to be worked out automatically by setting it to `OMP_NUM_THREADS=$(ppn)`. 
That is a helper script on our clusters which will set `$OMP_NUM_THREADS` to 
`$NSLOTS/$NHOSTS`, so you will use threads within a node and MPI between nodes 
and don't need to know in advance what size of node you are running on. Gerun 
will then run `$NSLOTS/$OMP_NUM_THREADS` processes, round-robin allocated (if 
supported by the MPI).

```bash
#!/bin/bash -l

# Batch script to run a hybrid parallel job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM per core (must be an integer)
#$ -l mem=1G

# Request 15 gigabytes of TMPDIR space per node (default is 10 GB - remove if cluster is diskless)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N MadIntelHybrid

# Select the MPI parallel environment and 80 cores.
#$ -pe mpi 80

# Set the working directory to somewhere in your scratch space. 
# This directory must exist.
#$ -wd /home/<your_UCL_id/scratch/output/

# Automatically set threads using ppn. On a cluster with 40 cores
# per node this will be 80/2 = 40 threads.
export OMP_NUM_THREADS=$(ppn)

# Run our MPI job with the default modules. Gerun is a wrapper script for mpirun. 
gerun $HOME/src/madscience/madhybrid
```

If you want to specify a specific number of OMP threads yourself, you would alter 
the relevant lines above to this:

```
# Request 80 cores and run 4 MPI processes per 40-core node, each spawning 10 threads
#$ -pe mpi 80
export OMP_NUM_THREADS=10
gerun your_binary
```

## GPU Job Script Example

To use NVIDIA GPUs with the CUDA libraries, you need to load the CUDA runtime libraries module or else set up the environment yourself. The script below shows what you'll need to unload and load the appropriate modules.

You also need to use the `-l gpu=<number>` option to request the GPUs from the scheduler.

```bash
#!/bin/bash -l

# Batch script to run a GPU job under SGE.

# Request a number of GPU cards, in this case 2 (the maximum)
#$ -l gpu=2

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM (must be an integer followed by M, G, or T)
#$ -l mem=1G

# Request 15 gigabyte of TMPDIR space (default is 10 GB)
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N GPUJob

# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/<your_UCL_id>/Scratch/output

# Change into temporary directory to run work
cd $TMPDIR

# load the cuda module (in case you are running a CUDA program)
module unload compilers mpi
module load compilers/gnu/4.9.2
module load cuda/7.5.18/gnu-4.9.2

# Run the application - the line below is just a random example.
mygpucode

# 10. Preferably, tar-up (archive) all output files onto the shared scratch area
tar zcvf $HOME/Scratch/files_from_job_$JOB_ID.tar.gz $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

## Job using MPI and GPUs

It is possible to run MPI programs that use GPUs but our clusters currently only support this within a single node. The script below shows how to run a program using 2 gpus and 12 cpus.

```bash
#!/bin/bash -l

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 12 cores, 2 GPUs, 1 gigabyte of RAM per CPU, 15 gigabyte of TMPDIR space
#$ -l mem=1G
#$ -l gpu=2
#$ -pe mpi 12
#$ -l tmpfs=15G

# Set the name of the job.
#$ -N GPUMPIrun

# Set the working directory to somewhere in your scratch space.
#$ -wd /home/<your user id>/Scratch/output/

# Run our MPI job. You can choose OpenMPI or IntelMPI for GCC.
module unload compilers mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/1.10.1/gnu-4.9.2
module load cuda/7.5.18/gnu-4.9.2

gerun myGPUapp
```

