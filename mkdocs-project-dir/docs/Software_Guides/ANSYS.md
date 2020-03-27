---
title: ANSYS
layout: docs
---

# ANSYS

ANSYS/CFX and ANSYS/Fluent are commercial fluid dynamics packages. 

ANSYS/CFX and ANSYS/Fluent version 17.2, 18.0, 19.1 and later are available. The ANSYS Electromagnetics Suite (AnsysEM) is available from version 19.1 onwards. ANSYS Mechanical is available from 2019.r3 onwards.

Before these applications can be run, the user needs to go though a
number of set up steps. These are detailed here.

To see the versions available, type
```
module avail ansys
```

The desired ANSYS module needs to be loaded by issuing a command like:

```
module load ansys/19.1
```

The first time this is done, users should run the shell script
`setup_cfx.sh` to configure licensing and HP-MPI options on a login
node: 

```
setup_cfx.sh
```

Running this script is required regardless of which ANSYS application you are running..

The ANSYS applications are intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer (up to two hours) on the
User Test Nodes. Interactive work can be done using the ANSYS
interactive tools provided you have X-windows functionality enabled
though your ssh connection. See our User Guide
for more information about enabling
X-windows functionality and the User Test nodes.

UCL's campus-wide license covers 125 instances with 512 HPC licenses (for parallel jobs) available for running CFX, Fluent and AnsysEM jobs and in order to make sure that jobs only run if there are licenses available, it is necessary for users to request ANSYS licenses with their jobs, by adding `-ac app=cfx` to their job submission.

## ANSYS/CFX

CFX handles its own parallelisation, so a number of complex options need to be passed in job scripts to make it run correctly.

### Example single node multi-threaded ANSYS/CFX jobscript

Here is an example runscript for running `cfx5solve` multi-threaded on a
given `.def` file.


```
#!/bin/bash -l

# ANSYS 19.1: Batch script to run cfx5solve on the StaticMixer.def example 
# file, single node multi-threaded (12 threads),

# Force bash as the executing shell.

#$ -S /bin/bash

# Request 15 munutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:15:0

# Request 1 gigabyte of RAM per core.
#$ -l mem=1G

# Set the name of the job.
#$ -N StaticMixer_thread_12

# Select 12 threads.
#$ -pe smp 12

# Request ANSYS licences 
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space. In this
# case the subdirectory cfxtests-19.1
#$ -wd /home/<your_UCL_id>/Scratch/cfxtests-19.1

# Load the ANSYS module to set up your environment

module load ansys/19.1

# Copy the .def file into the working (current) directory

cp /home/<your userid>/cfx_examples/StaticMixer.def .

# Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

cfx5solve -max-elapsed-time "15 [min]" -def StaticMixer.def -par-local -partition $OMP_NUM_THREADS
```
You will need to change the `-wd /home/<your_UCL_id>/Scratch/cfxtests-19.1` location and may need to change the memory, wallclock time, number of threads and job name directives as well. Replace the .def file with your one and modify the -max-elapsed-time value if needed. The simplest form of qsub command can be used to submit the job eg:
```
qsub run-StaticMixer-thr.sh
```
Output files will be saved in the job's working directory.

### Example multi-node MPI ANSYS/CFX jobscript

Here is an example runscript for running cfx5solve on more than one node
(using MPI) on a given .def file.

```
#!/bin/bash -l

# ANSYS 19.1: Batch script to run cfx5solve on the StaticMixer.def example 
# file, distributed parallel (36 cores).

# Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:00:0

# Request 2 gigabyte of RAM per core.
#$ -l mem=2G

# Set the name of the job.
#$ -N StaticMixer_P_dist_36

# Select the MPI parallel environment and 36 processors.
#$ -pe mpi 36

# Request ANSYS licences 
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory cfxtests-19.1
#$ -wd /home/<your_UCL_userid>/Scratch/cfxtests-19.1

# Load the ANSYS module to set up your environment

module load ansys/19.1

# Copy the .def file into the working (current) directory

cp /home/<your_UCL_userid>/cfx_examples/StaticMixer.def .

# SGE puts the machine file in $TMPDIR/machines. Use this to generate the 
# string CFX_NODES needed by cfx5solve

export CFX_NODES=$(cfxnodes $TMPDIR/machines)

# Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

cfx5solve -max-elapsed-time "60 [min]" -def StaticMixer.def -par-dist $CFX_NODES
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-wd /home/<your_UCL_userid>/Scratch/cfxtests-19.1` location and may need
to change the memory, wallclock time, number of MPI processors
and job name directives as well. Replace the `.def` file with
your one and modify the `-max-elapsed-time` value if needed. The
simplest form of qsub command can be used to submit the job eg:

```
qsub run-StaticMixer-par.sh
```

Output files will be saved in the job's working directory.


## ANSYS/Fluent

Fluent handles its own parallelisation, so a number of
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


## ANSYS Mechanical 

```
#!/bin/bash -l

# ANSYS 2019.R3: Batch script to run ANSYS Mechanical solver
# file, distributed parallel (32 cores).

# Using ANSYS 2019 licence manager running on UCL central licence server.

# Force bash as the executing shell.
#$ -S /bin/bash

# Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:00:0

# Request 2 gigabyte of RAM per core. (Must be an integer)
#$ -l mem=2G

# Set the name of the job.
#$ -N Mech_P_dist_32

# Select the MPI parallel environment and 32 processors.
#$ -pe mpi 32

# Request ANSYS licences $ inserted so currently active.Job will queue until
# suficient licences are available.
#$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory ANSYS_Mech
#$ -wd /home/<your_UCL_username>/Scratch/ANSYS_Mech

# Load the ANSYS module to set up your environment
module load ansys/2019.r3

# Copy the .in file into the working (current) directory
cp ~/ANSYS/steady_state_input_file.dat .

# SGE puts the machine file in $TMPDIR/machines. Use this to generate the 
# string CFX_NODES needed by ansys195 which requires : as the separator.

export CFX_NODES=$(cfxnodes $TMPDIR/machines | sed -e 's/\*/:/g' -e 's/,/:/g')
echo $CFX_NODES

# Run ansys mechanical - Note: use ansys195 instead of ansys and -p argument
# needed to switch to a valid UCL license.

ansys195 -dis -b -p aa_r -machines $CFX_NODES < steady_state_input_file.dat
```

If you have access to Grace, this test input and jobscript are available at `/home/ccaabaa/Software/ANSYS/steady_state_input_file.dat` and `/home/ccaabaa/Software/ANSYS/ansys-mech-ex.sh`
`
