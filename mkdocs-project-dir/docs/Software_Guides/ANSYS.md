---
title: ANSYS
layout: docs
---

# ANSYS

!!! important "License checking"
    Current as of Dec 2021, the `-ac app=cfx` license check does not work
    after ANSYS renamed all products and licenses. Remove this line from
    your jobscripts for the time being or jobs will not be able to start.

ANSYS/CFX and ANSYS/Fluent are commercial fluid dynamics packages.

The most recent version of ANSYS we have installed on the clusters is ANSYS 2023.R1 including ANSYS/CFX, ANSYS/Fluent, ANSYS Mechanical and the ANSYS Electromagnetics Suite (AnsysEM). Some other products included in the ANSYS Campus Agreement are also available including Autodyn.

Older versions of some ANSYS products including ANSYS/CFX and
ANSYS/Fluent are also available but only on Kathleen at the moment - 2021.R2, 2019.R3, 19.1 for example. However ANSYS Inc changed the way they license their software at the beginning of 2021, causing some products from versions before 2020 to have issues getting a valid license from the lciense server.

Before these applications can be run, the user needs to go though a
number of set up steps. These are detailed here.

To see the versions available, type
```
module avail ansys
```

The desired ANSYS module needs to be loaded by issuing a command like:

```
module load ansys/2023.r1
```

This will set up various necessary config directories for you.

!!! important "Module for UCL staff and Students only" 
	these ANSYS modules are for
	UCL staff and Students only as they use the UCL ANSYS License
	Manager. Users from external Institutions on Young (the MMM Hub
	cluster) need to use modules specific to their institution instead.

The ANSYS applications are intended to be run primarily within batch
jobs however you may run short (less than 5 minutes execution time)
interactive tests on the Login Nodes and longer (up to two hours) on an
interactive session on a compute node using qrsh. Interactive work can be done using the ANSYS
interactive tools provided you have X-windows functionality enabled
though your ssh connection. See our User Guide
for more information about enabling
X-windows functionality and using the qrsh command to start interactive sessions.

UCL's campus-wide license covers 125 instances with 512 HPC licenses (for 
parallel jobs) available for running CFX, Fluent and AnsysEM jobs and in 
order to make sure that jobs only run if there are licenses available, it 
is necessary for users to request ANSYS licenses with their jobs, by adding 
`-ac app=cfx` to their job submission.

## ANSYS Supplied MPI used as default does not work

ANSYS 2023.R1 is supplied with a MPI which is used as the default but
doesn't work on our clusters. In every parallel job script you need to
specify the supplied Intel 2018 MPI alternative. See the example job
scripts below.


## ANSYS/CFX

CFX handles its own parallelisation, so a number of complex options need to be passed in job scripts to make it run correctly.

### Example single node multi-threaded ANSYS/CFX jobscript

Here is an example runscript for running `cfx5solve` multi-threaded on a
given `.def` file.


```
#!/bin/bash -l

# ANSYS 2023.R1: Batch script to run cfx5solve on the StaticMixer.def example 
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
# Dec 2021: comment out this check as not currently working
###$ -ac app=cfx

# Set the working directory to somewhere in your scratch space. In this
# case the subdirectory cfxtests-2023.R1
#$ -wd /home/<your_UCL_id>/Scratch/cfxtests-2023.R1

# Load the ANSYS module to set up your environment

module load ansys/2023.r1

# Copy the .def file into the working (current) directory

cp /home/<your userid>/cfx_examples/StaticMixer.def .

# Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

cfx5solve -max-elapsed-time "15 [min]" -def StaticMixer.def -par-local -partition $OMP_NUM_THREADS
```
You will need to change the `-wd /home/<your_UCL_id>/Scratch/cfxtests-2023.R1` location and may need to change the memory, wallclock time, number of threads and job name directives as well. Replace the .def file with your one and modify the -max-elapsed-time value if needed. The simplest form of qsub command can be used to submit the job eg:
```
qsub run-StaticMixer-thr.sh
```
Output files will be saved in the job's working directory.

### Example multi-node MPI ANSYS/CFX jobscript

Here is an example runscript for running cfx5solve on more than one node
(using MPI) on a given .def file. **Note**: the need to use the supplied
Intel 2018 MPI instead of the default.

```
#!/bin/bash -l

# ANSYS 2023.R1: Batch script to run cfx5solve on the StaticMixer.def example 
# file, distributed parallel (80 cores).

# Using ANSYS 2021 licence manager running on UCL central licence server.

# 1. Force bash as the executing shell.
#$ -S /bin/bash

# 2. Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:60:0

# 3. Request 2 gigabyte of RAM per core.
#$ -l mem=2G

# 4. Set the name of the job.
#$ -N StaticMixer_P_dist_80_NLC

# 5. Select the MPI parallel environment and 80 processors.
#$ -pe mpi 80

# 6. Request ANSYS licences $ not inserted so currently inactive. Job will queue until
# suficient licenses are available when active.
# -ac app=cfx

# 7. Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory cfxtests-2023.R1
#$ -wd /home/<your_UCL_id>/Scratch/cfxtests-2023.R1

# 8. Load the ANSYS module to set up your environment

module load ansys/2023.r1

# 9. Copy the .def file into the working (current) directory

cp /home/<your_UCL_id>/Software/ANSYS/cfx_examples/StaticMixer.def .

# 10. SGE puts the machine file in $TMPDIR/machines. Use this to generate the 
# string CFX_NODES needed by cfx5solve

export CFX_NODES=`cfxnodes $TMPDIR/machines`

# 11. Run cfx5solve - Note: -max-elapsed-time needs to be set to the same
# time as defined by 2 above.

# Run with default MPI.
cfx5solve -max-elapsed-time "60 [min]" -def StaticMixer.def -start-method "Intel MPI 2018 Distributed Parallel" -par-dist $CFX_NODES

```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-wd /home/<your_UCL_userid>/Scratch/cfxtests-2023.R1` location and may need
to change the memory, wallclock time, number of MPI processors
and job name directives as well. Replace the `.def` file with
your one and modify the `-max-elapsed-time` value if needed. The
simplest form of qsub command can be used to submit the job eg:

```
qsub run-StaticMixer-par.sh
```

Output files will be saved in the job's working directory.

#### Running CFX with MPI on Myriad

On Myriad the maximum number of MPI processors you can request is 36.

### Troubleshooting CFX

If you are getting licensing errors when trying to run a parallel job and you have an older version's `~/.ansys/v161/licensing/license.preferences.xml` file, delete it. It does not work with the newer license server. (This applies to all older versions, not just `v161`).


## ANSYS/Fluent

Fluent handles its own parallelisation, so a number of
complex options need to be passed in job scripts to make it run
correctly.

The .in file mentioned in the scripts below is a [Fluent journal file](https://www.cfd-online.com/Wiki/Fluent_FAQ#Journal_File_and_Text_User_Interface_.28TUI.29_Related), giving it the list of commands to carry out in batch mode.

### Example serial ANSYS Fluent jobscript

!!! important "Serial ANSYS Fluent not currently working on Myriad"
	Currently we have not been able to get serial ANSYS Fluent jobs
	working on Myriad with ANSYS 2023.R1.

Here is an example jobscript for running Fluent in serial mode (1
core). **Note**: this is for an older version of ANSYS which is not
currently available on Myriad and Kathleen cannot run serial jobs.

```
#!/bin/bash -l

# ANSYS 2021.R2: Batch script to run ANSYS/fluent in serial mode 
# (1 core). 

# Request 2 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=2:0:0

# Request 2 gigabytes of RAM.
#$ -l mem=2G

# Set the name of the job.
#$ -N Fluent_ser1

# Request ANSYS licences
# Dec 2021: comment out this check as not currently working
###$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory fluent-tests-19.1
#$ -wd /home/<your_UCL_userid>/Scratch/fluent-tests-2021.R2

# Load the ANSYS module to set up your environment

module load ansys/2021.r2

# Copy Fluent input files into the working (current) directory

cp <path to your input files>/test-1.cas .
cp <path to your input files>/test-1.in .

# Run fluent in 2D single precision (-g no GUI). For double precision use
# 2ddp. For 3D use 3d or 3ddp. 

fluent 2d -g < test-1.in
```

Please copy if you wish and edit it to suit your jobs. You will need to
change the `-wd /home/<your_UCL_id>/Scratch/fluent-tests-2021.R2` 
location and may
need to change the memory, wallclock time, and job name as
well. Replace the `.cas` and `.in` files with your ones. The
simplest form of qsub command can be used to submit the job eg:

```
qsub run-ANSYS-fluent-ser.sh
```

Output files will be saved in the job's working directory.

### Example parallel (MPI) ANSYS/Fluent jobscript

Here is an example runscript for running Fluent in parallel potentially
across more than one node. **Note**: the need to use the supplied
Intel 2018 MPI instead of the default.

```
#!/bin/bash -l

# ANSYS 2023.R1: Batch script to run ANSYS/fluent distributed parallel 
# (80 cores). 

# Request 2 hours of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=2:0:0

# Request 2 gigabytes of RAM per core.
#$ -l mem=2G

# Set the name of the job.
#$ -N Fluent_par80

# Select the MPI parallel environment and 80 processors.
#$ -pe mpi 80

# Request 25 Gb TMPDIR space (if on a cluster that supports this)
#$ -l tmpfs=25G

# Request ANSYS licences
# Dec 2021: comment out this check as not currently working
###$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory fluent-tests-2023.R1
#$ -wd /home/<your_UCL_userid>/Scratch/fluent-tests-2023.R1

# Load the ANSYS module to set up your environment

module load ansys/2023.r1

# Copy Fluent input files into the working (current) directory

cp <path to your input files>/test-1.cas .
cp <path to your input files>/test-1.in .

# Run fluent  in 3D single precision (-g no GUI). For double precision use
# 3ddp. For 2D use 2d or 2ddp. 
# Do not change -t, -mpi, and -cnf options.

fluent 3ddp -t$NSLOTS -mpi=intel2018 -cnf=$TMPDIR/machines -g < test-1.in
```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-wd /home/<your_UCL_id>/Scratch/fluent-tests-2023.R1` location and may
need to change the memory, wallclock time, number of MPI processors
and job name as well. Replace the *.cas* and *.in*
files with your ones. The simplest form of qsub command can
be used to submit the job eg: 

```
qsub run-ANSYS-fluent-par-80.sh
```

Output files will be saved in the job's working directory.

#### Running ANSYS Fluent with MPI on Myriad

On Myriad the maximum number of MPI processors you can request is 36.

#### Changes to jobscripts for ANSYS Fluent 2021.R2

The following changes are needed to the example jobscript for the
older ANSYS 2021.R2 version. Load this module file instead:

```
module load ansys/2021.r2
```
and run fluent with this MPI option:

```
fluent 3ddp -t$NSLOTS -mpi=intel -cnf=$TMPDIR/machines -g < test-1.in
```

### Troubleshooting Fluent

If you are getting licensing errors when trying to run a parallel job and you have an older version's `~/.ansys/v161/licensing/license.preferences.xml` file, delete it. It does not work with the newer license server. (This applies to all older versions, not just `v161`).

Fluent 14 required `-mpi=pcmpi -pinfiniband` in the parallel options: if you have older scripts remember to remove this.


## ANSYS Mechanical 

ANSYS Mechanical handles its own parallelisation, and needs an
additional setting to work on our clusters. It also only appears to
work with Intel MPI. Here is an example jobscript for running in
parallel potentially across more than one node, for example on the
Kathleen cluster. **Note**: the need to use the supplied
Intel 2018 MPI instead of the default.

```
#!/bin/bash -l

# ANSYS 2023.R1: Batch script to run ANSYS Mechanical solver
# file, distributed parallel (80 cores).

# Using ANSYS 2021.R2 licence manager running on UCL central licence server.

# Force bash as the executing shell.
#$ -S /bin/bash

# Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:00:0

# Request 2 gigabyte of RAM per core. (Must be an integer)
#$ -l mem=2G

# Set the name of the job.
#$ -N Mech_P_dist_80

# Select the MPI parallel environment and 80 processors.
#$ -pe mpi 80

# Request ANSYS licences $ inserted so currently active.Job will queue until
# suficient licences are available.
# Dec 2021: comment out this check as not currently working
###$ -ac app=cfx

# Set the working directory to somewhere in your scratch space.  In this
# case the subdirectory ANSYS_Mech
#$ -wd /home/<your_UCL_username>/Scratch/ANSYS_Mech

# Load the ANSYS module to set up your environment
module load ansys/2023.r1

# Copy the .in file into the working (current) directory
cp ~/ANSYS/steady_state_input_file.dat .

# 10. SGE puts the machine file in $TMPDIR/machines. Use this to generate the 
# string CFX_NODES needed by ansys195 which requires : as the separator.

export CFX_NODES=`cfxnodes_cs $TMPDIR/machines`
echo $CFX_NODES

# Need to set KMP_AFFINTY to get round error: OMP: System error #22: Invalid argument

export KMP_AFFINITY=disabled

# Run ansys mechanical

mapdl -mpi intelmpi2018 -dis -b -machines $CFX_NODES -i steady_state_input_file.dat


```

Please copy if you wish and edit it to suit your jobs. You will
need to change the `-wd /home/<your_UCL_id>/Scratch/ANSYS_Mech` location and may
need to change the memory, wallclock time, number of MPI processors
and job name as well. Replace the *.dat* 
file with your one. The simplest form of qsub command can
be used to submit the job eg: 

```
qsub ansys-mech-2023.R1-ex.sh
```

Output files will be saved in the job's working directory.

If you have access to Kathleen, this test input and jobscript are available at `/home/ccaabaa/Software/ANSYS/steady_state_input_file.dat` and `/home/ccaabaa/Software/ANSYS/ansys-mech-2023.R1-ex.sh`

## ANSYS Electromagnetic Suite (AnsysEM)


The AnsysEM products handle their own parallelisation so a number of complex options need to be passed in job scripts to make it run correctly. Also additional module commands are required.

Here is an example jobscript for running in parallel potentially across more than one node, for example on the Kathleen cluster.

```
#!/bin/bash -l

# AnsysEM 2023 R1: Batch script to run one of the Ansys Electromagnetics Products
# example simulations on Kathleen - distributed parallel (80 cores)

# 1. Force bash as the executing shell.
#$ -S /bin/bash

# 2. Request one hour of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=1:00:0

# 3. Request 2 gigabyte of RAM per core.
#$ -l mem=2G

# 4. Set the name of the job.
#$ -N DiffSL_P_dist_80

# 5. Select the MPI parallel environment and 80 processors - two nodes.
#$ -pe mpi 80

# 7. Request ANSYS licences $ inserted so currently active. Job will queue until
# suficient licenses are available. Not currently active.
###$ -ac app=cfx

# 8. Set the working directory to somewhere in your scratch space.  In this
# case the directory the job was submitted from,
#$ -cwd

# 9. Load the ANSYS module to set up your environment

module load ansys/2023.r1
module load xorg-utils/X11R7.7
module load giflib/5.1.1

# 10. Run ansysedt

ansysedt -ng -Distributed -machinelist num=$NSLOTS -batchoptions 'HFSS/MPIVendor'='Intel' -batchoptions 'TempDirectory'="${TMPDIR}" -batchoptions 'HFSS/HPCLicenseType'='pool'  -batchoptions 'HFSS-IE/HPCLicenseType'='pool' -BatchSolve differential_stripline.aedt

```

