---
title: "Other Software"
layout: docs
---

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
module load beta-modules
module avail packagename
```

By loading `beta-modules` you will also be able to see newer versions of GCC and the software that
has been built using them.

Then `module avail` gives you a list of all the modules we have that match the name you searched 
for. You can then type 
```
module show packagename
```
and it will show you the other software dependencies this module has: these have to be loaded first. It also shows where the software is installed and what environment variables it sets up.

Once you have found the modules you want to load, it is good practice to refer to them using their full name, including the version. If you use the short form (`package` rather than `package/5.1.2/gnu-4.9.2`) then a matching module will be loaded, but if we install a different version, your jobs may begin using the new one and you would not know which version created your results. Different software versions may not be compatible or may have different default settings, so this is undesirable.

You may need to unload current modules in order to load some requirements (eg different compiler, different MPI).

This example switches from Intel compiler and MPI modules to GNU ones.
```
module unload -f compilers mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/3.1.4/gnu-4.9.2
```
You can use the short name when unloading things because there is usually only one match in your current modules.

The last part of a module name usually tells you what compiler it was built with and which version 
of that compiler. There may be GNU compiler versions and Intel compiler versions of the same 
software available.

Once the module is loaded, you should have all the usual executables in your path, and can use its commands. You load modules in exactly the same way inside a jobscript.

Useful resources:

* [Modules pt 1 (moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846737) (UCL users)
* [Modules pt 2 (moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846739) (UCL users)
* [Modules pt 1 (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98405) (non-UCL users)
* [Modules pt 2 (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98414) (non-UCL users)


## Notes on how to run specific packages

The packages below have slightly complex commands needed to run them, or different settings needed on our clusters. These are examples of what should be added to your jobscripts. Change the module load command to the version you want to load and check that the dependencies are the same.

The top of a jobscript should contain your [resource requests](../Experienced_Users.md#script-sections). See also [examples of full jobscripts](../Example_Jobscripts.md) .

### ABAQUS

ABAQUS is a commercial software suite for finite element analysis and computer-aided engineering.

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

BEAST is an application for Bayesian MCMC analysis of molecular sequences orientated towards rooted, time-measured phylogenies inferred using strict or relaxed molecular clock models.

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

Bowtie 1 and 2 are tools for aligning sequencing reads to their reference sequences.

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

CASTEP is a full-featured materials modelling code based on a first-principles quantum mechanical description of electrons and nuclei.

```
module load castep/17.21/intel-2017
# Gerun is our mpirun wrapper which sets the machinefile and number of 
# processes to the amount you requested with -pe mpi.
gerun castep.mpi input
```

CASTEP 19 has different pre-reqs:
```
module unload -f compilers mpi
module load compilers/intel/2019/update4
module load mpi/intel/2019/update4/intel
module load castep/19.1.1/intel-2019
# Gerun is our mpirun wrapper which sets the machinefile and number of 
# processes to the amount you requested with -pe mpi.
gerun castep.mpi input
```

If you have access to the source code and wish to build your own copy, it has been suggested that compiling with these options (on Grace) gave a build that ran about 10% faster than the default compilation options:
```
make COMMS_ARCH=mpi SUBARCH=mpi FFT=mkl MATHLIBS=mkl10 BUILD=fast
```
Do check for numerical accuracy with any optimisations you carry out.


### Cctools

Provides the Parrot connector to CVMFS, the CernVM File System. 

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

CFD-ACE+ is a commercial computational fluid dynamics solver developed by ESI Group. It solves the conservation equations of mass, momentum, energy, chemical species and other scalar transport equations using the finite volume method. These equations enable coupled simulations of fluid, thermal, chemical, biological, electrical and mechanical phenomena.

The license is owned by the Department of Mechanical Engineering who must give permission for users to be added to the group `lgcfdace`.

```
module load cfd-ace/2018.0

CFD-SOLVER -model 3Dstepchannel_060414.DTF -num $NSLOTS -wd `pwd` \ 
   -hosts $TMPDIR/machines -rsh=ssh -decomp -metis -sim 1 -platformmpi -job
```


### COMSOL

COMSOL Multiphysics is a cross-platform finite element analysis, solver and multiphysics simulation software.

Electrical Engineering have a group license for version 52 and must give permission for users to be added to the group `legcomsl`. Chemical Engineering have a Departmental License for version 53 and members of that department may be added to the group `lgcomsol`. 

```
# Run a parallel COMSOL job

# Versions 52 and 52a have this additional module prerequisite
module load xulrunner/3.6.28/gnu-4.9.2

# pick the version to load
module load comsol/53a

# Parallel multinode options:
# $NHOSTS gets the number of nodes the job is running on and
# $TMPDIR/machines is the machinefile that tells it which nodes.
# These are automatically set up in a "-pe mpi" job environment.
comsol -nn $NHOSTS -clustersimple batch -f $TMPDIR/machines -inputfile micromixer_batch.mph \ 
       -outputfile micromixer_batch_output_${JOB_ID}.mph

# On Myriad you need to specify the fabric:
comsol batch -f $TMPDIR/machines -np $NSLOTS -mpifabrics shm:tcp \ 
    -inputfile micromixer_batch.mph -outputfile micromixer_batch_output_${JOB_ID}.mph
```


### CP2K

CP2K performs atomistic and molecular simulations.

To see all available versions type

```
module load beta-modules
module avail cp2k
```

To load CP2K 8.2:

```
module unload -f compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0

# These three modules only needed on Myriad
module load numactl/2.0.12
module load binutils/2.36.1/gnu-10.2.0
module load ucx/1.9.0/gnu-10.2.0

module load mpi/openmpi/4.0.5/gnu-10.2.0
module load openblas/0.3.13-openmp/gnu-10.2.0
module load cp2k/8.2/ompi/gnu-10.2.0

# Gerun is our mpirun wrapper which sets the machinefile and number of 
# processes to the amount you requested with -pe mpi.
gerun cp2k.popt < input.in > output.out
```

### CRYSTAL

CRYSTAL is a general-purpose program for the study of crystalline solids. The CRYSTAL program computes the electronic structure of periodic systems within Hartree Fock, density functional or various hybrid approximations. 

CRYSTAL is commercial software which is available free of charge to UK academics. You must obtain a license from Crystal Solutions: [How to get CRYSTAL - Academic UK license](http://www.crystalsolutions.eu/cat/crystal-cryscor/academic-uk). You need to create an account and then request to be upgraded to Academic UK. Access to CRYSTAL is enabled by being a member of the reserved application group `legcryst`. For proof of access we accept emails from CRYSTAL saying your account has been upgraded to "Academic UK", or a screenshot of your account page showing you have the full download available rather than just the demo version. 

```
module unload -f mpi
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
```
```
# Similarly, for Pproperties the command would be
gerun $CRY17_EXEDIR/$VERSION/Pproperties
```

For CRYSTAL 17 v1.0.2, the modules and path are slightly different and you would do this instead:
```
module unload -f compilers mpi
module load compilers/intel/2017/update4
module load mpi/intel/2017/update3/intel
module load crystal17/v1.0.2/intel-2017

# Create a directory for this job and copy the input file into it.
mkdir test00
cd test00
cp ~/Scratch/Crystal17/test_cases/inputs/test00.d12 INPUT

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
# The CRYSTAL module sets $CRYxx_EXEDIR and $VERSION environment variables.
gerun $CRY17_EXEDIR/Pcrystal
```

### FreeSurfer

FreeSurfer is a set of tools for analysis and visualization of structural and functional brain imaging data.

Freesurfer can use threads to run on multiple cores in one node: request the number with `-pe smp` in the resource-request part of your jobscript.
```
#$ -pe smp 4

module load xorg-utils/X11R7.7
module load freesurfer/6.0.0
export SUBJECTS_DIR=~/Scratch/FreeSurfer_examples/subjects

# -openmp $NSLOTS runs with the number of threads you requested
recon-all -openmp $NSLOTS -i sample-001.nii.gz -s bert -all
```


### GAMESS

The General Atomic and Molecular Electronic Structure System (GAMESS) is a general ab initio quantum chemistry package. 

The GAMESS module should be loaded once from a login node before submitting a job - this creates the `~/Scratch/gamess` directory for you which is used as `USERSCR` to write some scratch files during the job. If you don't want to keep these files and would prefer them to be written to `$TMPDIR` instead, you can put `export GAMESS_USERSCR=$TMPDIR` in your jobscript after the module load command.

```
module unload compilers mpi
module load compilers/intel/2015/update2
module load mpi/intel/2015/update3/intel
module load gamess/5Dec2014_R1/intel-2015-update2

# Optional: set where the USERSCR files go. 
# By default, the module sets it to ~/Scratch/gamess
export GAMESS_USERSCR=$TMPDIR

rungms exam01.inp 00 $NSLOTS $(ppn)
```

#### Troubleshooting GAMESS

If there's something wrong with the way you are running your model or a mismatch between the number of
processes you tell it to use and what it expects, you may get a log that only shows this:

```
Copying input file exam01.inp to your run's scratch directory...
cp tests/standard/exam01.inp /tmpdir/job/12345.undefined/exam01.F05
unset echo
@: Expression Syntax.
```

To see what was happening to cause the error, you should take a local copy of `rungms`. Use 
`module show` to look at the gamess module you are using, and look at the line that sets the PATH. 
This shows you where the install is, and where the `rungms` script is located:

```
module show gamess/5Dec2014_R1/intel-2015-update2
-------------------------------------------------------------------
/shared/ucl/apps/modulefiles/applications/gamess/5Dec2014_R1/intel-2015-update2:

module-whatis   {Adds GAMESS 5Dec2014_R1 to your environment, built for Intel MPI. Uses ~/Scratch/gamess for USERSCR. You can override by exporting GAMESS_USERSCR as another path.}
prereq          gcc-libs
prereq          compilers/intel/2015/update2
prereq          mpi/intel/2015/update3/intel
conflict        gamess
prepend-path    PATH /shared/ucl/apps/gamess/5Dec2014_R1/intel-2015-update2
prepend-path    CMAKE_PREFIX_PATH /shared/ucl/apps/gamess/5Dec2014_R1/intel-2015-update2
setenv          GAMESS_USERSCR ~/Scratch/gamess
-------------------------------------------------------------------
```

Copy `rungms` from the version you are using to somewhere in your space.
```
cp /shared/ucl/apps/gamess/5Dec2014_R1/intel-2015-update2/rungms` ~/Scratch/gamess_test
```

Edit it to add `-evx` to the very first line so it reads:

```
#!/bin/csh -evx
```

Now in your jobscript, use your `rungms` instead of the central one.

```
# using rungms in current directory
./rungms exam01.inp 00 $NSLOTS $(ppn)
```

You should get error output showing you what the script is doing. At the end it might look like this:

```
@ PPN2 = $PPN + $PPN
@: Expression Syntax.
```

This can happen if you were running `./rungms exam01.inp 00 $NSLOTS` so that `$PPN` was not being 
passed to `rungms` and is undefined.

### GATK

The Genome Analysis Toolkit or GATK is a software package developed at the Broad Institute to analyze high-throughput sequencing data. 

Version 4 of GATK is BSD-licensed so does not require a group to control access to the software. 

Version 3 of GATK requires you to agree to the GATK license before we can add you to the `leggatk` group which gives you access: you can do this by downloading GATK 3 from [The Broad Institute GATK download page](https://software.broadinstitute.org/gatk/download/), reading the license, and telling us you agree to it. You may need to create a gatkforums account before you can download.

GATK 3 uses Java 1.7 (the system Java) so you do not need to load a Java module. GATK 4 uses 1.8 so you need to load `java/1.8.0_92` first.

GATK 4.2.5.0 or newer uses the newest version of Java 8, so you need to load `java/temurin-8`.

Load the version you want, then to run GATK you should either prefix the .jar you want to run with `$GATKPATH`:
```
java -Xmx2g -jar $GATKPATH/GenomeAnalysisTK.jar OPTION1=value1 OPTION2=value2...
```

Or we provide wrappers, so you can run it one of these ways instead:
```
GenomeAnalysisTK OPTION1=value1 OPTION2=value2...
```
```
gatk OPTION1=value1 OPTION2=value2...
```

If you want to use some of the newer tools in GATK 4 which rely on Python/Conda, you must use GATK >= 4.2.5.0 and additionally set up your miniconda environment.  With 4.2.5.0 this means:

```
module load java/temurin-8
module load gatk/4.2.5.0
module load python/miniconda3/4.10.3
source $UCL_CONDA_PATH/etc/profile.d/conda.sh 
conda activate $GATK_CONDA
```

(For newer versions of GATK it will tell you which version of miniconda to load)

### Gaussian

Access to Gaussian 09 or Gaussian 16 are controlled by membership of separate groups. 
UCL has a site license so UCL users can be added on request.

Gaussian is too resource-intensive to ever be run on the login nodes.

#### Multithreaded shared memory Gaussian jobs

The main Gaussian executable lets you run jobs that use from 1 core up to a full node.
When using more than one core, make sure your input file contains `%NProcShared=` with
the number of cores your job is requesting.

`$GAUSS_SCRDIR` is where Gaussian puts temporary files which can use a lot of space.
On Myriad in a job this is created inside `$TMPDIR` by default. On diskless clusters, this 
is set this to a directory in your Scratch instead: loading one of the Gaussian 
modules will handle this automatically and show where it has created the directory.

```
# Example for Gaussian 16

# Set up runtime environment
module load gaussian/g16-a03/pgi-2016.5
source $g16root/g16/bsd/g16.profile

# Run g16 job
g16 input.com
```

```
# Example for Gaussian 09

# Setup runtime environment
module load gaussian/g09-d01/pgi-2015.7
source $g09root/g09/bsd/g09.profile

# Run g09 job
g09 input.com
```

#### Linda parallel Gaussian jobs

**Only currently working for Gaussian 09.**

Gaussian Linda jobs can run across multiple nodes.

```
# Select the MPI parallel environment and 80 cores total
#$ -pe mpi 80

# 8. Select number of threads per Linda worker (value of NProcShared in your
#     Gaussian input file. This will give 80/40 = 2 Linda workers.
export OMP_NUM_THREADS=40

# Setup g09 runtime environment
module load gaussian/g09-d01/pgi-2015.7
source $g09root/g09/bsd/g09.profile

# Pre-process g09 input file to include nodes allocated to job
echo "Running: lindaConv testdata.com $JOB_ID $TMPDIR/machines"
echo ''
$lindaConv testdata.com $JOB_ID $TMPDIR/machines

# Run g09 job

echo "Running: g09 \"job$JOB_ID.com\""

# communication needs to be via ssh not the Linda default
export GAUSS_LFLAGS='-v -opt "Tsnet.Node.lindarsharg: ssh"'

g09 "job$JOB_ID.com"
```

#### Troubleshooting: Memory errors

If you encounter errors like:
```
Out-of-memory error in routine ShPair-LoodLd2 (IEnd= 257724 MxCore= 242934)

Use %mem=48MW to provide the minimum amount of memory required to complete this step.
```
Try adding this to your jobscript:
```
export GAUSS_MEMDEF=48000000
```
You may need to increase this value even more to allow it to run.

#### Troubleshooting: No space left on device

If you get this error
```
  g_write: No space left on device
```

The `$GAUSS_SCRDIR` is probably full - if it was on a cluster that has local 
disks and is using `$TMPDIR` you should increase the amount of `tmpfs` you are 
requesting in your jobscript. Otherwise check `lquota` for your data usage and
potentially request a larger Scratch.

### GROMACS

We have many versions of GROMACS installed, some built with Plumed. The module name will indicate this.

Which executable you should run depends on the problem you wish to solve. For both single and double precision version builds, serial binaries and an MPI binary for mdrun (`mdrun_mpi` for newer versions, `gmx_mpi` for Plumed and some older versions) are provided. Double precision binaries have a `_d` suffix (so `gmx_d`, `mdrun_mpi_d`, `gmx_mpi_d` etc). 

You can see what the executable names are by running `module show gromacs/2021.2/gnu-7.3.0` 
for example and then running the `ls` command on the `bin` directory that the module tells you 
that version is installed in.

```
# Example for GPU gromacs/2021.5/cuda-11.3
module load beta-modules
module unload -f compilers mpi gcc-libs
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0
module load python3/3.9-gnu-10.2.0 
module load cuda/11.3.1/gnu-10.2.0
module load mpi/openmpi/4.0.5/gnu-10.2.0
module load gromacs/2021.5/cuda-11.3

# Run GROMACS - the executables are gmx_cuda, gmx_mpi_cuda and mdrun_mpi_cuda

```

```
# Example for gromacs/2021.2/gnu-7.3.0
module load beta-modules
module unload -f compilers mpi gcc-libs
module load gcc-libs/7.3.0
module load compilers/gnu/7.3.0
module load mpi/openmpi/3.1.4/gnu-7.3.0
module load python3
module load gromacs/2021.2/gnu-7.3.0

# Run GROMACS - replace with mdrun command line suitable for your job!

gerun mdrun_mpi -v -stepout 10000
```

```
# Example for gromacs/2019.3/intel-2018
module unload -f compilers mpi
module load compilers/intel/2018/update3
module load mpi/intel/2018/update3/intel
module load gromacs/2019.3/intel-2018

# Run GROMACS - replace with mdrun command line suitable for your job!

gerun mdrun_mpi -v -stepout 10000
```

```
# Plumed example for gromacs/2019.3/plumed/intel-2018
module unload -f compilers mpi
module load compilers/intel/2018/update3 
module load mpi/intel/2018/update3/intel 
module load libmatheval 
module load flex 
module load plumed/2.5.2/intel-2018
module load gromacs/2019.3/plumed/intel-2018

# Run GROMACS - replace with mdrun command line suitable for your job!

gerun gmx_mpi -v -stepout 10000
```

#### Passing in options to GROMACS non-interactively

Some GROMACS executables like `trjconv` normally take interactive input. You can't do this in a jobscript, so you need to pass in the input you would normally type in. There are several ways of doing this, mentioned at [GROMACS Documentation - Using Commands in Scripts](http://www.gromacs.org/Documentation/How-tos/Using_Commands_in_Scripts). The simplest is to echo the input in and keep your gmx options as they would normally be. If the inputs you would normally type were 3 and 3, then you can do this:

```
echo 3 3 | gmx whatevercommand -options
```

#### Checkpoint and restart

GROMACS has built-in checkpoint and restart ability, so you can use this if your runs will not complete in the maximum 48hr wallclock time.

Have a look at the GROMACS manual for full details, as there are more options than mentioned here.

You can tell GROMACS to write a checkpoint file when it is approaching the maximum wallclock time available, and then exit.

In this case, we had asked for 48hrs wallclock. This tells GROMACS to start from the last checkpoint if there is one, and write a new checkpoint just before it reaches 47 hrs runtime.

```
gerun mdrun_mpi -cpi -maxh 47 <options>
```

The next job you submit with the same script will carry on from the checkpoint the last job wrote. You could use job dependencies to submit two identical jobs at the same time and have one dependent on the other, so it won't start until the first finishes - have a look at `man qsub` for the `-hold_jid` option.

You can also write checkpoints at given intervals:

```
# Write checkpoints every 120 mins, start from checkpoint if there is one.
gerun mdrun_mpi -cpi -cpt 120 <options>
```


### Hammock

Hammock is a tool for peptide sequence clustering. It is able to cluster extremely large amounts of short peptide sequences into groups sharing sequence motifs. Typical Hammock applications are NGS-based experiments using large combinatorial peptide libraries, e.g. Phage display. 

Hammock has to be installed in your own space to function, so we provide a hammock module that contains the main dependencies and creates a quick-install alias:

```
# on the login nodes
module unload compilers
module load hammock/1.0.5
do-hammock-install
```

This will install Hammock 1.0.5 in your home, edit settings.prop to use clustal-omega and hmmer from our modules and tell it to write temporary files in your Scratch directory (in the form `Hammock_temp_time`). 

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

HOPSPACK (Hybrid Optimization Parallel Search PACKage) solves derivative-free optimization problems using an open source, C++ software framework.

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

IDL is a complete environment and language for the analysis and visualisation of scientific and other technical data. It can be used for everything from quick interactive data exploration to building complex applications. 

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

JAGS (Just Another Gibbs Sampler) is a program for analysis of Bayesian hierarchical models using Markov Chain Monte Carlo (MCMC) simulation not wholly unlike BUGS. 

Use this to use JAGS in standalone command line mode:
```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load openblas/0.2.14/gnu-4.9.2
module load jags/4.2.0/gnu.4.9.2-openblas
```

We have also added JAGS support to `r/recommended` using the `rjags` and `R2jags` R packages.


### LAMMPS

LAMMPS is an open source parallel molecular dynamics code which exhibits good scaling in a wide range of environments. 

The LAMMPS binaries are called `lmp_$cluster` and all have an `lmp_default` symlink which can be used.

LAMMPS-8Dec15 and later were built with additional packages `kspace`, `replica`, `rigid`, and `class2`.

The versions from `lammps-16Mar18-basic_install` onwards (not `lammps/16Mar18/intel-2017`) have most of the included packages built. There are also `userintel` and `gpu` versions from this point.

We do not install the LAMMPS user packages as part of our central install, but you can build your own version with the ones that you want in your space.

```
module -f unload compilers mpi
module load compilers/intel/2018
module load mpi/intel/2018
module load lammps/16Mar18/basic/intel-2018

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun $(which lmp_default) -in inputfile
```

For the latest version of LAMMPS we have installed which is 29th September 2021 Update 2 where the binaries are called `lmp_mpi` for the MPI version and `lmp_gpu` for the GPU version:

```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0
module load mpi/openmpi/4.0.5/gnu-10.2.0
module load python3/3.9-gnu-10.2.0
module load lammps/29sep21up2/basic/gnu-10.2.0

gerun lmp_mpi -in inputfile
```
for the basic MPI version and:
```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0

# these three modules for Myriad only
module load numactl/2.0.12
module load binutils/2.36.1/gnu-10.2.0
module load ucx/1.9.0/gnu-10.2.0

module load mpi/openmpi/4.0.5/gnu-10.2.0
module load cuda/11.3.1/gnu-10.2.0
module load python3/3.9-gnu-10.2.0
module load lammps/29sep21up2/gpu/gnu-10.2.0

gerun lmp_gpu -sf gpu -pk gpu 1 -in inputfile
```
for the version with GPU support which is only available on clusters with GPUs. 
The MPI version is available on all clusters. On Myriad the `numactl`, `binutils` and 
`ucx` modules are additionally needed by OpenMPI.

LAMMPS 29th September 2021 Update 2 has been built with the GNU compilers, OpenMPI and CUDA for the GPU version. 

We also have Intel installs:

```
# LAMMPS 29 Sep 2021 Update 2 with Intel compilers and INTEL package
module unload -f compilers mpi
module load compilers/intel/2020/release
module load mpi/intel/2019/update6/intel
module load python/3.9.10
module load lammps/29sep21up2/userintel/intel-2020

gerun lmp_mpi -in inputfile
```

```
# LAMMPS 29 Sep 2021 Update 2 for GPU with Intel compilers
module unload -f compilers mpi
module load beta-modules
module load compilers/intel/2020/release
module load mpi/intel/2019/update6/intel
module load python/3.9.10
module load cuda/11.3.1/gnu-10.2.0
module load lammps/29sep21up2/gpu/intel-2020

gerun lmp_gpu -sf gpu -pk gpu 1 -in inputfile
```

### MEME Suite

MEME Suite: Motif-based sequence analysis tools. This install is for the command-line tools and connects to their website for further analysis. 

```
module unload compilers
module unload mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/1.8.4/gnu-4.9.2
module load perl/5.22.0
module load python2/recommended
module load ghostscript/9.16/gnu-4.9.2
module load meme/4.10.1_4
```


### miRDeep2

Discovering known and novel miRNAs from deep sequencing data, miRDeep2 is a completely overhauled tool which discovers microRNA genes by analyzing sequenced RNAs. The tool reports known and hundreds of novel microRNAs with high accuracy in seven species representing the major animal clades. 

```
module load squid/1.9g
module load randfold/2.0
module load perl/5.22.0
module load bowtie/1.1.2
module load python/2.7.9
module load viennarna/2.1.9
module load mirdeep/2.0.0.7
```


### MISO/misopy

MISO (Mixture of Isoforms) is a probabilistic framework that quantitates the expression level of alternatively spliced genes from RNA-Seq data, and identifies differentially regulated isoforms or exons across samples.

misopy is available as part of the `python2/recommended` bundle. 

MISO can run multithreaded on one node, or can submit multiple independent single-core jobs at once using the `--use-cluster` option.

If you want to use MISO's ability to create and submit jobs itself, you need a MISO settings file like the one shown below. You give your job options as arguments to the qsub command in the `cluster_command` line. 

Settings files can be used with the `--settings-filename=SETTINGS_FILENAME` option. You will also need to put your module unload and load commands in your .bashrc if using MISO's own job submission, because you are no longer including them in a jobscript.

Example `miso_settings.txt`. Multithreaded jobs will use `num_processors`. `num_processors` is ignored if `--use-cluster` is specified:
```
[data]
filter_results = True
min_event_reads = 20

[cluster]
cluster_command = "qsub -l h_rt=00:10:00 -l mem=1GB -wd ~/Scratch"

[sampler]
burn_in = 500
lag = 10
num_iters = 5000
num_chains = 6
num_processors = 4
```


### MOLPRO

Molpro is a complete system of ab initio programs for molecular electronic structure calculations. 

Molpro 2015.1.3 was provided as binary only and supports communication over Ethernet and not Infiniband - use this one on single-node jobs primarily.

Molpro 2015.1.5 was built from source with the Intel compilers and Intel MPI, so can be run multi-node.

Molpro 2020.1 is a more recent binary install and supports both.

```
module load molpro/2015.1.5/intel-2015-update2

# Example files available in /shared/ucl/apps/molpro/2015.1.5/intel-2015-update2/molprop_2015_1_linux_x86_64_i8/examples/
# If this is a multi-node job you need to set the wavefunction directory to 
# somewhere in Scratch with -W. For a single-node job -W should be in $TMPDIR.
# You can use $SGE_O_WORKDIR to refer to the directory you set with -wd in your jobscript.
# $NSLOTS will use the number of cores you requested with -pe mpi.

echo "Running molpro -n $NSLOTS -W $TMPDIR h2o_scf.com"

molpro -n $NSLOTS -W $TMPDIR h2o_scf.com
```

On Myriad, if you get this error with the MPI 2015 install, please use the binary 2015.1.3 install.
```
libi40iw-i40iw_ucreate_qp: failed to create QP, unsupported QP type: 0x4
```

Output: MOLPRO can end up writing very many small output files, and this is detrimental to
the performance of a parallel filesystem like Lustre. If you are running jobs on Myriad then
you should set your -I -d and (especially) -W directories to be in $TMPDIR so they can be 
accessed quickly and not slow down other jobs. At the end of the job, copy back the data you
want to keep into your Scratch.

If you are running parallel multi-node jobs and the directories need to be readable by all 
the nodes, then you need to write to Scratch.


### MRtrix

MRtrix provides a set of tools to perform diffusion-weighted MRI white matter tractography in the presence of crossing fibres. 

```
module load python3/recommended
module load qt/4.8.6/gnu-4.9.2
module load eigen/3.2.5/gnu-4.9.2
module load fftw/3.3.6-pl2/gnu-4.9.2
module load mrtrix/3.0rc3/gnu-4.9.2/nogui
```

You must load these modules once from a login node before submitting a job. It copies a `.mrtrix.conf` to your home directory the first time you run this module from a login node, which sets:
```
  Analyse.LeftToRight: false
  NumberOfThreads: 4
```

You need to alter `NumberOfThreads` to what you are using in your job script before you submit a job. 

The MRtrix GUI tools are unavailable: `mrview` and `shview` in MRtrix 3 cannot be run over a remote X11 connection so are not usable on our clusters. To use these tools you will need a local install on your own computer. 


### MuTect

MuTect is a tool developed at the Broad Institute for the reliable and accurate identification of somatic point mutations in next generation sequencing data of cancer genomes. It is built on top of the GenomeAnalysisToolkit (GATK), which is also developed at the Broad Institute, so it uses the same command-line conventions and (almost all) the same input and output file formats. 

MuTect requires you to agree to the GATK license before we can add you to the `lgmutect` group which gives you access: you can do this by downloading MuTect from [The Broad Institute CGA page](https://software.broadinstitute.org/cancer/cga/mutect). You may need to create a gatkforums account before you can download.

MuTect is currently not compatible with Java 1.8, so you need to use the system Java 1.7. Set up your modules as follows: 
```
module load mutect/1.1.7
```

Then to run MuTect, you should either prefix the .jar you want to run with `$MUTECTPATH`:
```
java -Xmx2g -jar $MUTECTPATH/mutect-1.1.7.jar OPTION1=value1 OPTION2=value2...
``` 
Or we provide wrappers, so you can run it this way instead: 
```
mutect OPTION1=value1 OPTION2=value2...
```


### NAMD

NAMD is a parallel molecular dynamics code designed for high-performance simulation of 
large biomolecular systems.

We have several different types of install, some of them suited to particular clusters
only. To see all the versions, type `module avail namd`.

These examples are running the `apoa1` benchmark, available from the [NAMD website](https://www.ks.uiuc.edu/Research/namd/benchmarks/).

#### Multicore GPU

This version of NAMD runs within one GPU node. It can run on multiple GPUs on that node, 
but not across multiple different nodes. NAMD uses the CPUs and GPUs together so it is 
recommended you request all the cores on the node if you are requesting all the GPUs.

For best performance of simulations it is recommended that you use an entire node, 
all the CPUs and all the available GPUs.

```
# request a number of CPU cores and GPUs
#$ -pe smp 10
#$ -l gpu=1

module load namd/2.14/multicore-gpu

# ${NSLOTS} will get the number of cores you asked for with -pe smp.
# +setcpuaffinity is recommended to make sure threads are assigned to specific CPUs.

namd2 +p${NSLOTS} +setcpuaffinity apoa1_nve_cuda.namd
```

#### OFI

This version of NAMD is for clusters with OmniPath interconnects (not Myriad).
It can run across multiple nodes. The OFI versions should use significantly less 
memory than the older MPI-based installs.

```
module unload -f compilers mpi
module load compilers/intel/2019/update5
module load mpi/intel/2019/update5/intel
module load namd/2.14/ofi/intel-2019

# ${NSLOTS} will get the number of cores you asked for with -pe.

charmrun +p${NSLOTS} namd2 apoa1.namd
```

#### OFI-SMP

This version of NAMD runs with threads (smp) and processes and is for clusters 
with OmniPath interconnects (not Myriad). It can run across multiple nodes.
The OFI versions should use significantly less memory than the older MPI-based installs.

```
module unload -f compilers mpi
module load compilers/intel/2019/update5
module load mpi/intel/2019/update5/intel
module load namd/2.14/ofi-smp/intel-2019

# ${NSLOTS} will get the number of cores you asked for with -pe.
# +setcpuaffinity is recommended to make sure threads are assigned to specific CPUs.
# ++ppn is the number of PEs (or worker threads) to create for each process.

charmrun +p${NSLOTS} namd2 apoa1.namd ++ppn2 +setcpuaffinity
```

#### OFI-SMP-GPU

This version of NAMD runs with threads (smp) and processes and is for clusters
with OmniPath interconnects as well as GPUs (not Myriad). It can run across multiple nodes.

```
# request a number of CPU cores and GPUs
#$ -pe smp 24
#$ -l gpu=2

module unload -f compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/7.3.0
module load compilers/intel/2019/update5
module load mpi/intel/2019/update5/intel
module load cuda/11.3.1/gnu-10.2.0
module load namd/2.14/ofi-smp-gpu/intel-2019

# ${NSLOTS} will get the number of cores you asked for with -pe.
# +setcpuaffinity is recommended to make sure threads are assigned to specific CPUs.
# ++ppn is the number of PEs (or worker threads) to create for each process.

# The number of GPU devices must be a multiple of the number of NAMD processes
# since processes cannot share GPUs.
# Here we have ++ppn12 for 12 threads, and charmrun works out we have 2 NAMD processes 
# available for the 2 GPUs.

charmrun +p${NSLOTS} namd2 apoa1_nve_cuda.namd ++ppn12 +setcpuaffinity 
```

#### MPI

These are older versions. It is recommended to run the OFI versions above instead
if possible.

```
module load fftw/2.1.5/intel-2015-update2
module load namd/2.13/intel-2018-update3

# GErun is our mpirun wrapper that gets $NSLOTS and the machinefile for you.

gerun namd2 apoa1.namd 
```

### Nextflow

We do not currently have central installs of Nextflow, but a group of UCL researchers have 
contributed a config file and instructions for Myriad at the [nf-core/configs repository](https://github.com/nf-core/configs/blob/master/docs/ucl_myriad.md)

Nextflow containers can be run using [Singularity](Singularity.md).

### NONMEM

NONMEM® is a nonlinear mixed effects modelling tool used in population pharmacokinetic / pharmacodynamic analysis. 

We have one build that uses the GNU compiler and ATLAS and an Intel build using MKL. Both use Intel MPI. 

This example uses the Intel build.

```
jobDir=example1_parallel_$JOB_ID
mkdir $jobDir

# Copy control and datafiles to jobDir
cp /shared/ucl/apps/NONMEM/examples/foce_parallel.ctl $jobDir
cp /shared/ucl/apps/NONMEM/examples/example1b.csv $jobDir
cd $jobDir

module unload compilers mpi
module load compilers/intel/2015/update2
module load mpi/intel/2015/update3/intel
module load nonmem/7.3.0/intel-2015-update2

# Create parafile for job using $TMPDIR/machines
parafile.sh $TMPDIR/machines > example1.pnm

nmfe73 foce_parallel.ctl example1.res -parafile=example1.pnm -background -maxlim=1 > example1.log
```


### NWChem

NWChem applies theoretical techniques to predict the structure, properties, and reactivity of chemical and biological species ranging in size from tens to millions of atoms.

You should load the NWChem module you wish to use once from a login node, as it will create a symlinked `.nwchemrc` in your home. 

```
module unload compilers mpi
module load compilers/intel/2017/update4
module load mpi/intel/2017/update3/intel
module load python/2.7.12
module load nwchem/6.8-47-gdf6c956/intel-2017

# $NSLOTS will get the number of processes you asked for with -pe mpi.
mpirun -np $NSLOTS -machinefile $TMPDIR/machines nwchem hpcvl_sample.nw
```

#### NWChem troubleshooting

If you get errors like this
```
{    0,    3}:  On entry to PDSTEDC parameter number   10 had an illegal value
```
then you are coming across an error in Intel MKL 2018, and should make sure you change 
to the Intel 2017 compiler module as shown above. (MKL versions are bundled with the 
corresponding Intel compiler modules).

If your run terminates with an error saying
```
ARMCI supports block process mapping only
```
then you are probably trying to use round-robin MPI process placement, which ARMCI does not like. `gerun` uses round-robin for Intel MPI by default as it works better in most cases. Use `mpirun` instead of `gerun`:
```
mpirun -np $NSLOTS -machinefile $TMPDIR/machines nwchem input.nw
```

If you get an error complaining about `$NWCHEM_NWPW_LIBRARY` similar to this:
```
warning:::::::::::::: from_compile
NWCHEM_NWPW_LIBRARY is: <
/dev/shm/tmp.VB3DpmjULc/nwchem-6.6/src/nwpw/libraryps/>
but file does not exist or you do not have access to it !
------------------------------------------------------------------------
nwpwlibfile: no nwpw library found 0
```
then your `~/.nwchemrc` symlink is likely pointing to a different version that you used previously. Deleting the symlink and loading the module you want to use will recreate it correctly. 


### ORCA

ORCA is an ab initio, DFT, and semi-empirical SCF-MO package.

```
module unload compilers 
module unload mpi
module load compilers/gnu/4.9.2
module load mpi/openmpi/3.1.4/gnu-4.9.2
module load orca/4.2.1-bindist/gnu-4.9.2

orca input.inp > output.out
```

If you want to run ORCA in parallel using MPI, the jobscript will be the same but you will
need to add the `!PAL` keyword to your input file to tell it how many processes to use. (You
do not use `mpirun` or `gerun` with ORCA).


### Picard

Picard comprises Java-based command-line utilities that manipulate SAM files, and a Java API (SAM-JDK) for creating new programs that read and write SAM files. Both SAM text format and SAM binary (BAM) format are supported. 

Picard requires a Java 1.8 module to be loaded.

```
module load java/1.8.0_92
module load picard-tools/2.18.9
```

To run Picard you can prefix the .jar you want to run with `$PICARDPATH` and give the full command, or we have wrappers:
```
java -Xmx2g -jar $PICARDPATH/picard.jar PicardCommand TMP_DIR=$TMPDIR OPTION1=value1 OPTION2=value2...
``` 
The wrappers allow you to run commands like this - in this case our wrapper sets `TMP_DIR` for you as well: 
```
PicardCommand OPTION1=value1 OPTION2=value2...
```

Temporary files: by default, Picard writes temporary files into `/tmp` rather than into `$TMPDIR`. These are not cleaned up after your job ends, and means future runs can fail because `/tmp` is full (and requesting more tmpfs in your job doesn't make it larger). If you run Picard with the full `java -jar` command then give Picard the `TMP_DIR=$TMPDIR` option as our example above does to get it to write in the correct place. 


### Quantum Espresso

Quantum Espresso is an integrated suite of Open-Source computer codes for electronic-structure calculations and materials modelling at the nanoscale. It is based on density-functional theory, plane waves, and pseudopotentials. 

The most recent version we have available on the clusters is 7.3.1. For 
this version we have both the normal CPU/MPI variant and a GPU one. The GPU variant is only 
available on the Myriad and Young clusters.

For the CPU/MPI variant:

```
module unload compilers mpi gcc-libs
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0
module load mpi/openmpi/4.0.5/gnu-10.2.0
module load fftw/3.3.9/gnu-10.2.0
module load quantum-espresso/7.3.1-cpu/gnu-10.2.0

# Set the path here to where ever you keep your pseudopotentials.
export ESPRESSO_PSEUDO=$HOME/qe-psp

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun pw.x -in input.in >output.out

```

For the GPU variant:

```
module unload compilers mpi gcc-libs
module load gcc-libs/10.2.0
module load compilers/nvidia/hpc-sdk/22.9
module load quantum-espresso/7.3.1-gpu/nvidia-22.9

# Set the path here to where ever you keep your pseudopotentials.
export ESPRESSO_PSEUDO=$HOME/qe-psp

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun pw.x -in input.in >output.out

```

Older versions are still available, for 6.1:

```
module load xorg-utils
module load quantum-espresso/6.1-impi/intel2017

# Set the path here to where ever you keep your pseudopotentials.
export ESPRESSO_PSEUDO=$HOME/qe-psp

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun pw.x -in input.in >output.out
```


### Repast HPC 

Repast for High Performance Computing (Repast HPC) is a next generation agent-based modelling system intended for large-scale distributed computing platforms. It implements the core Repast Simphony concepts (e.g. contexts and projections), modifying them to work in a parallel distributed environment. 

```
module unload compilers
module unload mpi
module load compilers/gnu/4.9.2
module load hdf/5-1.8.15/gnu-4.9.2
module load netcdf/4.3.3.1/gnu-4.9.2
module load netcdf-fortran/4.4.1/gnu-4.9.2
module load mpi/openmpi/1.8.4/gnu-4.9.2
module load python/2.7.9
module load boost/1_54_0/mpi/gnu-4.9.2
module load netcdf-c++/4.2/gnu-4.9.2
module load repast-hpc/2.1/gnu-4.9.2
```

The module sets the environment variables `$REPAST_HPC_INCLUDE`, `$REPAST_HPC_LIB_DIR` and `$REPAST_HPC_LIB`.


### ROOT

ROOT provides a set of OO frameworks for handling, analysing, and visualising large amounts of data. Included are specialised storage methods, methods for histograming, curve fitting, function evaluation, minimization etc. ROOT includes a built-in CINT C++ interpreter. 

```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load fftw/3.3.4/gnu-4.9.2
module load gsl/1.16/gnu-4.9.2
module load root/6.04.00/gnu-4.9.2

# run root in batch mode
root -b -q myMacro.C > myMacro.out
```


### SAS

SAS is a statistics package providing a wide range of tools for data management, analysis and presentation. 

```
cd $TMPDIR

module load sas/9.4/64

# copy all your input files into $TMPDIR
cp ~/Scratch/sas_input/example1/* $TMPDIR

sas example1.in

# tar up all contents of $TMPDIR back into your space
tar cvzf $HOME/Scratch/SAS_output/files_from_job_$JOB_ID.tgz $TMPDIR
```


### StarCCM+

StarCCM+ is a commercial CFD package that handles fluid flows, heat transfer, 
stress simulations, and other common applications of such. 

Before running any StarCCM+ jobs on the clusters you must load the StarCCM+ 
module on a login node. This is so the module can set up two symbolic links 
in your home directory to directories created in your Scratch area so that user 
settings etc can be written by running jobs.

```
module load star-ccm+/13.06.012
```

Here is the jobscript example.

```
# Request one license per core - makes sure your job doesn't start 
# running until sufficient licenses are free.
#$ -l ccmpsuite=1

module load star-ccm+/13.06.012

starccm+ -np $NSLOTS -machinefile $TMPDIR/machines -rsh ssh -batch my_input.sim
```

#### hfi error

If you get an error like this:

```
hfi_wait_for_device: The /dev/hfi1_0 device failed to appear after 15.0 seconds: Connection timed out
```
then you need to add `-fabric ibv` to your options as shown in the example script.

It is trying to use an OmniPath device on a cluster that has InfiniBand, so the 
fabric needs to be changed. If you have this left over in jobscripts from Grace,
you need to remove it on Kathleen.

### StarCD

StarCD is a commercial package for modelling and simulating combustion and engine dynamics. 

You must request access to the group controlling StarCD access (legstarc) to use it. The license is owned by the Department of Mechanical Engineering who will need to approve your access request. 

```
# Request one license per core - makes sure your job doesn't start 
# running until sufficient licenses are free.
#$ -l starsuite=1

module load star-cd/4.28.050

# run star without its tracker process as this causes multicore jobs to die early
star -notracker
```

StarCD uses IBM Platform MPI by default. You can also run StarCD simulations using Intel MPI by changing the command line to:
```
star -notracker -mpi=intel
```
Simulations run using Intel MPI may run faster than they do when using IBM Platform MPI. 

If being run on a diskless cluster without available `$TMPDIR` like Kathleen, 
then StarCD will create a `$HPC_SCRATCH` location to store its temporary files
when the module is loaded. In a job this is set to `$HOME/Scratch/STAR_ScrDirs/[randomLabel]`
and it will make this directory and notify that it did this in your .e file. 
You can delete the randomly-named directory after the job ends.
To set the location yourself, after you load the module you can set it to any 
other existing directory instead:
```
export HPC_SCRATCH=/path/to/desired/location
```

### Stata/MP

Stata is a statistics, data management, and graphics system. Stata/MP is the version of the package that runs on multiple cores. 

We have a sixteen user license of Stata/MP. Our license supports Stata running on up to four cores per job. 

```
# Select 4 OpenMP threads (the most possible)
#$ -pe smp 4

cd $TMPDIR
module load stata/15

# copy files to $TMPDIR
cp myfile.do $TMPDIR

stata-mp -b do myfile.do

# tar up all contents of $TMPDIR back into your space
tar zcvf $HOME/Scratch/Stata_output/files_from_job_$JOB_ID.tar.gz $TMPDIR
```


### Torch

Torch is a scientific computing framework with wide support for machine learning algorithms that puts GPUs first. 

We provide a `torch-deps` module that contains the main Torch dependencies and creates a quick-install alias, `do-torch-install`. This uses Torch's installation script to git clone the current distribution and install LuaJIT, LuaRocks and Torch in `~/torch`. 

```
module unload compilers mpi
module load torch-deps

do-torch-install
```

You should load these same modules in your jobscript when using the version of torch this installs.


### Turbomole

Turbomole is an ab initio computational chemistry program that implements various quantum chemistry methods. 
Turbomole has a Chemistry-wide license. Reserved application group `legtmole` for Chemistry users only.

There are scripts you can use to generate Turbomole jobs for you:
```
/shared/ucl/apps/turbomole/turbomole-mpi.submit
/shared/ucl/apps/turbomole/turbomole-smp.submit
```
They will ask you which version you want to use, how much memory, how many cores etc and set up and submit the job for you.

Use the first for MPI jobs and the second for single-node shared memory threaded jobs.


### VarScan

VarScan is a platform-independent mutation caller for targeted, exome, and whole-genome resequencing data generated on Illumina, SOLiD, Life/PGM, Roche/454, and similar instruments. 

```
module load java/1.8.0_45
module load varscan/2.3.9
```

Then to run VarScan, you should either prefix the .jar you want to run with $VARSCANPATH:
```
java -Xmx2g -jar $VARSCANPATH/VarScan.v2.3.9.jar OPTION1=value1 OPTION2=value2...
```
Or we provide wrappers, so you can run it this way instead:
```
varscan OPTION1=value1 OPTION2=value2...
```


### VASP

The Vienna Ab initio Simulation Package (VASP) is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.

VASP is licensed software. To gain access, you need to email us letting us know 
what email address you are named on a VASP license using. You can also mention 
the name and email of the main VASP license holder and the license number if you 
have it, though this is not necessary. We will then check in the VASP portal if 
we can give you access. We will add you to the `legvasp5` or `legvasp6` reserved 
application groups depending on which versions you are licensed for, and remove 
you when VASP tell us you no longer have access.

The VASP executables for current versions are named like this:

 * `vasp_gam` - optimised for gamma point calculations only
 * `vasp_std` - standard version
 * `vasp_ncl` - for non-collinear magnetic structure and/or spin-orbit coupling calculations 

#### VASP 5

```
# vasp 5
module unload -f compilers mpi
module load compilers/intel/2017/update1
module load mpi/intel/2017/update1/intel
module load vasp/5.4.4-18apr2017/intel-2017-update1

# Gerun is our mpirun wrapper which sets the machinefile and number of
# processes to the amount you requested with -pe mpi.
gerun vasp_std > vasp_output.$JOB_ID
```

Note: although you can run VASP using the default Intel 2018 compiler this can lead to numerical errors in some types of simulation. In those cases we recommend switching to the specific compiler and MPI version used to build that install (mentioned at the end of the module name). We do this in the example above.

Building your own VASP: You may also install your own copy of VASP in your home if you have access to the source, and we provide a [simple VASP individual install script](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/vasp_individual_install) (tested with VASP 5.4.4, no patches). You need to download the VASP source code into your home directory and then you can run the script following the instructions at the top.

#### VASP 6

```
# vasp 6
module unload -f compilers mpi
module load compilers/intel/2019/update5
module load mpi/intel/2019/update5/intel
module load vasp/6.3.0-24Jan2022/intel-2019-update5

gerun vasp_std > vasp_output.$JOB_ID
```

#### VASP 6 GPU

This is the OpenACC GPU port of VASP. The [VASP documentation](https://www.vasp.at/wiki/index.php/OpenACC_GPU_port_of_VASP) has some information about suitable numbers of MPI processes vs GPUs.

```
# vasp 6 GPU

# request a gpu
#$ -l gpu=1

module unload -f compilers mpi
module load compilers/nvidia/hpc-sdk/22.1
module load fftw/3.3.10/nvidia-22.1
module load vasp/6.3.0-24Jan2022/nvidia-22.1-gpu

gerun vasp_std > vasp_output.$JOB_ID
```


### XMDS

XMDS allows the fast and easy solution of sets of ordinary, partial and stochastic differential equations, using a variety of efficient numerical algorithms. 

We have XMDS 3 and XMDS 2 installed.

For XMDS 3.0.0 you will need to load the modules on a login node and run `xmds3-setup` 
to set up XMDS.

```
module unload compilers
module unload mpi
module load compilers/gnu/4.9.2
module load mpi/intel/2015/update3/gnu-4.9.2
module load python3/3.7
module load fftw/3.3.4-impi/gnu-4.9.2
module load hdf/5-1.8.15/gnu-4.9.2
module load xmds/3.0.0

# run this on a login node to set up XMDS
xmds3-setup
```

You can also build the current developmental version from SVN in your space by running 
`create-svn-xmds3-inst`.

For XMDS 2.2.2 you will need to load the modules on a login node and run `xmds2-setup` 
to set up XMDS. 

```
module unload compilers
module unload mpi
module load compilers/gnu/4.9.2
module load mpi/intel/2015/update3/gnu-4.9.2
module load python2/recommended
module load fftw/3.3.4-impi/gnu-4.9.2
module load hdf/5-1.8.15/gnu-4.9.2
module load xmds/2.2.2

# run this on a login node to set up XMDS
xmds2-setup
```

Note that the `create-svn-xmds-inst` SVN install using the 2.2.2 modules will 
no longer work since the release of XMDS 3.0.0 (see above to use that).

