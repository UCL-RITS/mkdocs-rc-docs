---
title: ANSYS Software
layout: docs
---
# ANSYS Software

UCL has licenses for ANSYS/CFX and ANSYS/Fluent, and we try to keep the copies on our clusters up-to-date.

Before either application can be run, the user needs to go though a
number of set up steps. These are detailed here.

The ANSYS module needs to be loaded by issuing the command:

```
module load ansys/14.5.7
```

The first time this is done, users should run the shell script
`setup_cfx.sh` to configure licensing and HP-MPI options on a login
node: 

```
setup_cfx.sh
```

Running this script is required regardless of whether you are
running ANSYS/CFX or ANSYS/Fluent.

ANSYS/CFX and ANSYS/Fluent are intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer (up to two hours) on the
User Test Nodes. Interactive work can be done using the ANSYS
interactive tools provided you have X-windows functionality enabled
though your ssh connection. See our [User Guide](User_Guide)
for more information about enabling
X-windows functionality and the User Test nodes.

Our current licence allows up to ten ANSYS/CFX and ANSYS/Fluent jobs
running at one time using no more than 64 cores in addition to cores on
each job's head node.

## ANSYS/CFX Job Submission

On Legion, there are a limited number of licenses (10 jobs, additional
64 cores) available for running CFX and Fluent jobs and in order to make
sure that jobs only run if there are licenses available, it is necessary
for users to request ANSYS licenses with their jobs, by adding "-ac
app=cfx" to their job submission.

In addition, because CFX handles its own parallelisation, a number of
complex options need to be passed in job scripts to make it run
correctly.

### Single node run

Here is an example runscript for running cfx5solve multi-threaded on a
given `.def` file including comments.

##### Example Multi-threaded ANSYS/CFX Runscript

```
#!/bin/bash -l

# ANSYS 14.5.7: Batch script to run cfx5solve on the StaticMixer.def example 
# file, single node multi-threaded (4 threads),

# 1. Force bash as the executing shell.

#$ -S /bin/bash

# 2. Request 15 munutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:15:0

# 3. Request 1 gigabyte of RAM.
#$ -l mem=1G

# 4. Set the name of the job.
#$ -N StaticMixer_thread_4

# 5. Select 4 threads.
#$ -l thr=4

# 6. Select the project that this job will run under.
#$ -P <your project name>

# 7. Request ANSYS licences 
#$ -ac app=cfx

# 8. Set the working directory to somewhere in your scratch space. In this
# case the subdirectory cfxtests-14.5.7
#$ -wd /home/<your userid>/Scratch/cfxtests-14.5.7

# 9. Load the ANSYS module to set up your environment

module load ansys/14.5.7

# 10. Copy the .def file into the working (current) directory

cp /home/<your userid>/cfx_examples/StaticMixer.def .

# 11. Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

cfx5solve -max-elapsed-time "15 [min]" -def StaticMixer.def -par-local -partition $OMP_NUM_THREADS
```

This runscript is available on Legion in the file:

```
/shared/ucl/apps/ansys/14.5.7/ucl/share/run-StaticMixer-thr.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_name>` and `-wd /home/<your_UCL_id>/Scratch/cfxtests-14.5.7` SGE directives and may need
to change the memory, wallclock time, number of threads and job name
directives as well. Replace the `.def` file in 10 and 11 by your one and
modify the `-max-elapsed-time` value if needed. The simplest form of
qsub command can be used to submit the job eg: 

```
qsub run-StaticMixer-thr.sh
```

Output files will be saved in the job's working directory.

### Multi node run

Here is an example runscript for running cfx5solve on more than one node
(using MPI) on a given .def file including comments.

##### Example Multi-node/MPI ANSYS/CFX Runscript

```
#!/bin/bash -l

# ANSYS 14.5.7: Batch script to run cfx5solve on the StaticMixer.def example 
# file, distributed parallel (36 cores),

# Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:00:0

# Request 2 gigabyte of RAM.
#$ -l mem=2G

# Set the name of the job.
#$ -N StaticMixer_P_dist_36

# Select the QLogic parallel environment (qlc) and 36 processors.
#$ -pe qlc 36

# Select the project that this job will run under.
#$ -P <your project name>

# Request ANSYS licences 
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory cfxtests-14.5.7
#$ -wd /home/<your userid>/Scratch/cfxtests-14.5.7

# Load the ANSYS module to set up your environment

module load ansys/14.5.7

# Copy the .def file into the working (current) directory

cp /home/<your userid>/cfx_examples/StaticMixer.def .

# SGE puts the machine file in $TMPDIR/machines. Use this to generate the 
# string CFX_NODES needed by cfx5solve

export CFX_NODES=`cfxnodes $TMPDIR/machines`

# Force infinipath

export MPI_IC_ORDER=PSM

# Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

cfx5solve -max-elapsed-time "60 [min]" -def StaticMixer.def -start-method "Platform MPI Distributed Parallel" -par-dist $CFX_NODES
```

This runscript is available on Legion in the file:

```
/shared/ucl/apps/ansys/14.5.7/ucl/share/run-StaticMixer-par.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_name>` and `-wd /home/<your_UCL_id>/Scratch/cfxtests-14.5.7` SGE directives and may need
to change the memory, wallclock time, number of MPI Processors (item 5)
and job name directives as well. Replace the `.def` file in 10 and 13 by
your one and modify the *-max-elapsed-time* value if needed. The
simplest form of qsub command can be used to submit the job eg:

```
qsub run-StaticMixer-par.sh
```

Output files will be saved in the job's working directory.

## ANSYS/Fluent Job Submission

On Legion, there are a limited number of licenses (10 jobs, additional
64 cores) available for running CFX and Fluent jobs and in order to make
sure that jobs only run if there are licenses available, it is necessary
for users to request ANSYS licenses with their jobs, by adding 
`-ac app=cfx` to their job submission.

In addition, because Fluent handles its own parallelisation, a number of
complex options need to be passed in job scripts to make it run
correctly.

### Serial Run

Here is an example runscript for running Fluent in serial mode (1 core)
with comments.

##### Example Serial ANSYS/Fluent Runscript

```
#!/bin/bash -l

# ANSYS 14.5.7: Batch script to run ANSYS/fluent in serial mode 
# (1 core). 

# Request 2 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=2:0:0

# Request 2 gigabyte of RAM.
#$ -l mem=2G

# Set the name of the job.
#$ -N Fluent_ser1

# Select the project that this job will run under.
#$ -P <your project ID>

# Request ANSYS licences
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory fluent-tests-14.5.7
#$ -wd /home/<your userid>/Scratch/fluent-tests-14.5.7

# Load the ANSYS module to set up your environment

module load ansys/14.5.7

# Copy Fluent input files into the working (current) directory

cp <path to your input files>/test-1.cas .
cp <path to your input files>/test-1.in .

# Run fluent  in 2D single precision (-g no GUI). For double precision use
# 2ddp. For 3D use 3d or 3ddp. 

fluent 2d -g < test-1.in
```

This runscript is available on Legion in the file:

```
/shared/ucl/apps/ansys/14.5.7/ucl/share/run-ANSYS-fluent-ser.sh
```

Please copy if you wish and edit it to suit your jobs. You will need to
change the `-P <your_project_name>` and `-wd /home/<your_UCL_id>/Scratch/fluent-tests-14.5.7` SGE directives and may
need to change the memory, wallclock time, and job name directives as
well. Replace the `.cas` and `.in` files in 9 and 10 by your ones. The
simplest form of qsub command can be used to submit the job eg:

```
qsub run-ANSYS-fluent-ser.sh
```

Output files will be saved in the job's working directory.

### Parallel Run

Here is an example runscript for running Fluent in parallel potentially
across more than one node.

##### Example Parallel (MPI) ANSYS/Fluent Runscript

```
#!/bin/bash -l

# ANSYS 14.5.7: Batch script to run ANSYS/fluent distributed parallel 
# (8 cores). 

# Request 2 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=2:0:0

# Request 2 gigabyte of RAM.
#$ -l mem=2G

# Set the name of the job.
#$ -N Fluent_par8

# Select the QLogic parallel environment (qlc) and 8 processors.
#$ -pe qlc 8

# Select the project that this job will run under.
#$ -P <your project ID>

# Request ANSYS licences
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory fluent-tests-14.5.7
#$ -wd /home/<your userid>/Scratch/fluent-tests-14.5.7

# Load the ANSYS module to set up your environment

module load ansys/14.5.7

# Copy Fluent input files into the working (current) directory

cp <path to your input files>/test-1.cas .
cp <path to your input files>/test-1.in .

# Run fluent  in 3D single precision (-g no GUI). For double precision use
# 3ddp. For 2D use 2d or 2ddp. 
# Do not change -t, -mpi, -pinfiniband and -cnf options.

fluent 3d -t$NSLOTS -mpi=pcmpi -pinfiniband -cnf=$TMPDIR/machines -g < test-1.in
```

This runscript is available on Legion in the file:

```
/shared/ucl/apps/ansys/14.5.7/ucl/share/run-ANSYS-fluent-par.sh
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-P <your_project_name>` and `-wd /home/<your_UCL_id>/Scratch/fluent-tests-14.5.7` SGE directives and may
need to change the memory, wallclock time, number of MPI Processors
(item 5) and job name directives as well. Replace the *.cas* and *.in*
files in 10 and 11 by your ones. The simplest form of qsub command can
be used to submit the job eg: 

```
qsub run-ANSYS-fluent-ser.sh
```

Output files will be saved in the job's working directory.

