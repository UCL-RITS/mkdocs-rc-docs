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

CRYSTAL is commercial software which is available free of charge to UK academics. You must obtain a license from Crystal Solutions: [How to get CRYSTAL - Academic UK license](http://www.crystalsolutions.eu/cat/crystal-cryscor/academic-uk). You need to create an account and then request to be upgraded to Academic UK. Access to CRYSTAL is enabled by being a member of the reserved application group `legcryst`. For proof of access we accept emails from CRYSTAL saying your account has been upgraded to "Academic UK", or a screenshot of your account page showing you have the full download available rather than just the demo version. 

```
module unload mpi
module load mpi/openmpi/2.1.2/intel-2017
module load crystal17/v1.0.1

# 9. Create a directory for this job and copy the input file into it. 
mkdir test00
cd test00
cp ~/Scratch/Crystal17/test_cases/inputs/test00.d12 INPUT

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
# The CRYSTAL module sets $CRYxx_EXEDIR and $VERSION environment variables.
gerun $CRY17_EXEDIR/$VERSION/Pcrystal

# Similarly, for Pproperties the command would be
gerun $CRY17_EXEDIR/$VERSION/Pproperties
```

### FreeSurfer

Freesurfer can use threads to run on multiple cores in one node: request the number with `-pe smp` in the resource-request part of your jobscript.
```
cd $TMPDIR

module load xorg-utils/X11R7.7
module load freesurfer/5.3.0
export SUBJECTS_DIR=~/Scratch/PADDINGTON

time recon-all -subjid 30432 -autorecon1 -cw256
```

### GAMESS

The GAMESS module should be loaded once from a login node before submitting a job - this creates the `~/Scratch/gamess` directory for you which is used as `USERSCR` to write some scratch files during the job. If you don't want to keep these files and would prefer them to be written to `$TMPDIR` instead, you can put `export $GAMESS_USERSCR=$TMPDIR` in your jobscript after the module load command.

```
module unload compilers mpi
module load compilers/intel/2015/update2
module load mpi/intel/2015/update3/intel
module load gamess/5Dec2014_R1/intel-2015-update2

# Optional: set where the USERSCR files go. 
# By default, the module sets it to ~/Scratch/gamess
export $GAMESS_USERSCR=$TMPDIR

rungms exam01.inp 00 $NSLOTS $(ppn)
```

### GATK

Version 4 of GATK is BSD-licensed so does not require a group to control access to the software. 

Version 3 of GATK requires you to agree to the GATK license before we can add you to the `leggatk` group which gives you access: you can do this by downloading GATK 3 from [The Broad Institute GATK download page](https://software.broadinstitute.org/gatk/download/), reading the license, and telling us you agree to it. You may need to create a gatkforums account before you can download.

GATK 3 uses Java 1.7 (the system Java) so you do not need to load a Java module. GATK 4 uses 1.8 so you need to load `java/1.8.0_92` first.

Load the version you want, then to run GATK you should either prefix the .jar you want to run with `$GATKPATH`:
`java -Xmx2g -jar $GATKPATH/GenomeAnalysisTK.jar OPTION1=value1 OPTION2=value2...`

Or we provide wrappers, so you can run it one of these ways instead:
`GenomeAnalysisTK OPTION1=value1 OPTION2=value2...`
`gatk OPTION1=value1 OPTION2=value2...`


### Hammock

Hammock has to be installed in your own space to function, so we provide a hammock module that contains the main dependencies and creates a quick-install alias:

```
# on the login nodes
module unload compilers
module load hammock/1.0.5
do-hammock-install
```

This will install Hammock 1.0.5 in your home, and edit settings.prop to use clustal-omega and hmmer from our modules and tell it to write temporary files in your Scratch directory (in the form `Hammock_temp_time`). 

```
# in your jobscript
module unload compilers
module load hammock/1.0.5

# This copies the MUSI example that comes with Hammock into your working
# directory and runs it. The module sets $HAMMOCKPATH for you. 
# You must set the output directory to somewhere in Scratch with -d. 
# Below makes a different outputdir per job so multiple runs don't overwrite files.
cp $HAMMOCKPATH/../examples/MUSI/musi.fa .
outputdir=~/Scratch/hammock-examples/musi_$JOB_ID
mkdir -p $outputdir
echo "Running java -jar $HAMMOCKPATH/Hammock.jar full -i musi.fa -d $outputdir"

java -jar $HAMMOCKPATH/Hammock.jar full -i musi.fa -d $outputdir
```

### HOPSPACK

We have versions of HOPSPACK built using the GNU compiler and OpenMPI, and the Intel compiler and MPI. This example shows the GNU version. Serial and parallel versions are available, `HOPSPACK_main_mpi` and `HOPSPACK_main_serial`.

```
module unload compilers
module unload mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/1.8.4/gnu-4.9.2
module load atlas/3.10.2/gnu-4.9.2
module load hopspack/2.0.2/gnu-4.9.2

# Add the examples directory we are using to our path. 
# Replace this with the path to your own executables.
export PATH=$PATH:~/Scratch/examples/1-var-bnds-only/

# Run parallel HOPSPACK.
# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun HOPSPACK_main_mpi ~/Scratch/examples/1-var-bnds-only/example1_params.txt > example1_output.txt
```

### IDL

Single-threaded jobscript:
```
cd $TMPDIR

module load idl/8.4.1

# Copy IDL source files to $TMPDIR
cp ~/Scratch/IDL/fib.pro $TMPDIR
cp ~/Scratch/IDL/run1.pro $TMPDIR

idl -queue -e @run1.pro

# tar up all contents of $TMPDIR back into your space
tar zcvf $HOME/Scratch/IDL_output/files_from_job_$JOB_ID.tgz $TMPDIR
```

Parallel jobscript:
```
cd $TMPDIR

module load idl/8.1

# this sets the IDL thread pool: do not change this
export IDL_CPU_TPOOL_NTHREADS=$OMP_NUM_THREADS

# Copy IDL source files to $TMPDIR
cp ~/Scratch/IDL/fib.pro $TMPDIR
cp ~/Scratch/IDL/run2mp.pro $TMPDIR

idl -queue -e @run2mp.pro

# tar up all contents of $TMPDIR back into your space
tar zcvf $HOME/Scratch/IDL_output/files_from_job_$JOB_ID.tgz $TMPDIR
```

### JAGS

Use this to use JAGS in standalone command line mode:
```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load openblas/0.2.14/gnu-4.9.2
module load jags/4.2.0/gnu.4.9.2-openblas
```

We have also added JAGS support to `r/recommended` using the `rjags` and `R2jags` R packages.

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


