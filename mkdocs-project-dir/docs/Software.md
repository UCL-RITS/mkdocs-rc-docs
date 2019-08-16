---
title: Software
layout: docs
---

# Software

We maintain a large software stack that is available across all our clusters (licenses permitting).

We use environment modules to let you manage which specific versions of software packages you are using. 

## General use of environment modules

We have a default set of modules that everyone has loaded when they log in: these include the current default compiler and MPI, some utili
ties to make your life easier and some text editors.

### Summary of module commands
```
module avail            # shows available modules
module whatis           # shows available modules with brief explanations
module list             # shows your currently loaded modules

module load <module>    # load this module
module unload <module>  # unload this module
module purge            # unload all modules

module show <module>    # Shows what the module requires and what it sets up
module help <module>    # Shows a longer text description for the software
```

### Find out if a software package is installed and load it

Generically, the way you find out if a piece of software is installed is to run
```
module avail packagename
```

This gives you a list of all the modules we have that match the name you searched for. You can then type 
```
module show packagename
```
and it will show you the other software dependencies this module has: these have to be loaded first. It also shows where the software is installed and what environment variables it sets up.

Once you have found the modules you want to load, it is good practice to refer to them using their full name, including the version. If you use the short form (`package` rather than `package/5.1.2/gnu-4.9.2`) then a matching module will be loaded, but if we install a different version, your jobs may begin using the new one and you would not know which version created your results. Different software versions may not be compatible or may have different default settings, so this is undesirable.

You may need to unload current modules in order to load some requirements (eg different compiler, different MPI).

This example switches from Intel compiler and MPI modules to GNU ones.
```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/3.1.4/gnu-4.9.2
```
You can use the short name when unloading things because there is usually only one match in your current modules.

The last part of a module name usually tells you what compiler it was built with. There may be a GNU compiler version and an Intel compiler version of the same software available.

Once the module is loaded, you should have all the usual executables in your path, and can use its commands. You load modules in exactly the same way inside a jobscript.

# Notes on how to run specific packages

The packages below have slightly complex commands needed to run them, or different settings needed on our clusters. These are examples of what should be added to your jobscripts. Change the module load command to the version you want to load and check that the dependencies are the same.

## ABAQUS

## BEAST

## Bowtie

## CASTEP

## Cctools

## CFD-ACE

```
module load cfd-ace/2018.0

CFD-SOLVER -model 3Dstepchannel_060414.DTF -num $NSLOTS -wd `pwd` -hosts $TMPDIR/machines -rsh=ssh -decomp -metis -sim 1 -platformmpi -job
```

## COMSOL

```
# Run a parallel COMSOL job

# Versions 52 and 52a have this module prerequisite
module load xulrunner/3.6.28/gnu-4.9.2

# pick the version to load
module load comsol/53a

# Parallel multinode options:
# $NHOSTS gets the number of nodes the job is running on and
# $TMPDIR/machines is the machinefile that tells it which nodes.
# These are automatically set up in a "-pe mpi" job environment.
comsol -nn $NHOSTS -clustersimple batch -f $TMPDIR/machines -inputfile micromixer_batch.mph -outputfile micromixer_batch_output_${JOB_ID}.mph

# On Myriad you need to specify the fabric:
comsol batch -f $TMPDIR/machines -np $NSLOTS -mpifabrics shm:tcp -inputfile micromixer_batch.mph -outputfile micromixer_batch_output_${JOB_ID}.mph
```


## CP2K

## CRYSTAL

## FreeSurfer

## GAMESS

## GATK

## Hammock

## HOPSPACK

## IDL

## JAGS

## LAMMPS

## MEME Suite

## miRDeep2

## MISO/misopy

## MOLPRO

## MRtrix

## MuTect

## NONMEM

## NWChem

## Picard

## Quantum Espresso

## Repast HPC 

## ROOT

## SAS

## StarCCM+

## StarCD

## Stata/MP

## Torch

## Turbomole

## VarScan

## VASP

## XMDS



