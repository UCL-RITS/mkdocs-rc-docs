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


## Notes on how to run specific packages

The packages below have slightly complex commands needed to run them, or different settings needed on our clusters. These are examples of what should be added to your jobscripts. Change the module load command to the version you want to load and check that the dependencies are the same.

### ABAQUS

You must be authorised by the Mech Eng Department before you can be added to the group controlling access to ABAQUS (legabq).

A serial interactive analysis can be run on the compute nodes (via a `qrsh` session) like this:
```
abaqus interactive job=myJobSerial input=myInputFile.inp
```

A parallel job can be run like this (fill in your own username):
```
module load abaqus/2017

INPUT_FILE=/home/<username>/ABAQUS/heattransfermanifold_cavity_parallel.inp
ABAQUS_ARGS=
ABAQUS_PARALLELSCRATCH=/home/<username>/Scratch/Abaqus/parallelscratch
# creates a parallel scratch dir and a new working dir for this job
mkdir -p $ABAQUS_PARALLELSCRATCH
mkdir -p $JOB_NAME.$JOB_ID
cd $JOB_NAME.$JOB_ID
cp $INPUT_FILE .

INPUT=$(basename $INPUT_FILE)
abaqus interactive cpus=$NSLOTS mp_mode=mpi job=$INPUT.$JOB_ID input=$INPUT \
       scratch=$ABAQUS_PARALLELSCRATCH $ABAQUS_ARGS
```

### BEAST

Note that FigTree and Tracer are available as standalone modules. The addons DISSECT, MODEL_SELECTION, and SNAPP are installed for BEAST. 

```
cd $TMPDIR

module load java/1.8.0_45
module load beast/2.3.0

beast -threads $OMP_NUM_THREADS ~/Scratch/BEAST/gopher.xml

# tar up all contents of $TMPDIR back into your space
tar zcvf $HOME/Scratch/BEAST/files_from_job_$JOB_ID.tar.gz $TMPDIR
```

### Bowtie

Bowtie 1 and 2 are available. For reads longer than about 50 bp Bowtie 2 is generally faster, more sensitive, and uses less memory than Bowtie 1. For relatively short reads (e.g. less than 50 bp) Bowtie 1 is sometimes faster and/or more sensitive. For further differences, see [How is Bowtie 2 different from Bowtie 1?](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#how-is-bowtie-2-different-from-bowtie-1).

Bowtie sets `$BT1_HOME` and Bowtie2 sets `$BT2_HOME`. You can have both modules loaded at once. 

```
cd $TMPDIR
module load bowtie2/2.2.5

# Run Bowtie2 example from getting started guide:
# http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#getting-started-with-bowtie-2-lambda-phage-example
bowtie2-build $BT2_HOME/example/reference/lambda_virus.fa lambda_virus
bowtie2 -x lambda_virus -U $BT2_HOME/example/reads/reads_1.fq -S eg1.sam

# tar up all contents of $TMPDIR back into your space
tar zcvf $HOME/Scratch/Bowtie2_output/files_from_job_$JOB_ID.tgz $TMPDIR
```

### CASTEP

```
module load castep/17.21/intel-2017
# Gerun is our mpirun wrapper which sets the machinefile and number of 
# processes to the amount you requested with -pe mpi.
gerun castep.mpi input
```

If you have access to the source code and wish to build your own copy, it has been suggested that compiling with these options (on Grace) gave a build that ran about 10% faster than the default compilation options:
`make COMMS_ARCH=mpi SUBARCH=mpi FFT=mkl MATHLIBS=mkl10 BUILD=fast`
Do check for numerical accuracy with any optimisations you carry out.

### Cctools

By default, the cctools module sets the following:
```
export PARROT_CVMFS_REPO=<default-repositories> 
export PARROT_ALLOW_SWITCHING_CVMFS_REPOSITORIES=yes 
export HTTP_PROXY=DIRECT;
export PARROT_HTTP_PROXY=DIRECT;
```

Example usage - will list the contents of the repository then exit:
```
module load cctools/7.0.11/gnu-4.9.2
parrot_run bash
ls /cvmfs/alice.cern.ch
exit
```

That will create the cache in `/tmp/parrot.xxxxx` on the login nodes when run interactively. To use in a job, you will want to put the cache somewhere in your space that the compute nodes can access. You can set the cache to be in your Scratch, or to `$TMPDIR` on the nodes if it just needs to exist for the duration of that job.
```
export PARROT_CVMFS_ALIEN_CACHE=</path/to/cache>
```

### CFD-ACE

```
module load cfd-ace/2018.0

CFD-SOLVER -model 3Dstepchannel_060414.DTF -num $NSLOTS -wd `pwd` -hosts $TMPDIR/machines -rsh=ssh -decomp -metis -sim 1 -platformmpi -job
```

### COMSOL

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


### CP2K

```
module unload compilers mpi
module load mpi/openmpi/3.0.0/gnu-4.9.2
module load cp2k/5.1/ompi/gnu-4.9.2

# Gerun is our mpirun wrapper which sets the machinefile and number of 
# processes to the amount you requested with -pe mpi.
gerun cp2k.popt < input.in > output.out
```

For CP2K 4.1 there is also a Chemistry department version with submission script generator. To access it:
```
module load chemistry-modules
module load submission-scripts
```
The command `submitters` will then list the submitters available.
You can then run `cp2k.submit` which will ask you questions in order to create a suitable jobscript.

The `cp2k.submit` submitter takes up to 6 arguments, and any omitted will be asked for interactively:
`cp2k.submit «input_file» «cores» «version» «maximum_run_time» «memory_per_core» «job_name»`

So, for example:
`cp2k.submit water.inp 8 4.1 2:00:00 4G mywatermolecule`
would request a job running CP2K 4.1 with the input file `water.inp`, on 8 cores, with a maximum runtime of 2 hours, with 4 gigabytes of memory per core, and a job name of `mywatermolecule`. 

### CRYSTAL



### FreeSurfer

### GAMESS

### GATK

### Hammock

### HOPSPACK

### IDL

### JAGS

### LAMMPS

### MEME Suite

### miRDeep2

### MISO/misopy

### MOLPRO

### MRtrix

### MuTect

### NONMEM

### NWChem

### Picard

### Quantum Espresso

### Repast HPC 

### ROOT

### SAS

### StarCCM+

### StarCD

### Stata/MP

### Torch

### Turbomole

### VarScan

### VASP

### XMDS


