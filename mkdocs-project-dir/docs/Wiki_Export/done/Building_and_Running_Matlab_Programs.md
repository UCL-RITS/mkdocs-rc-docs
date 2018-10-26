---
title: Building and Running Matlab Programs
categories:
 - Legion
 - Myriad
 - Matlab
layout: docs
---
### Before you start, here are the caveats:

Although full Matlab is now available on Legion, you can still compile
Matlab programs on an external machine and then run them on Legion using
the Matlab runtime.

Your Matlab program must be compiled using a 64bit Linux version of the
Matlab compiler; the compiled code is not cross-platform compatible so
it cannot be built on OS X and then transferred to Legion.

Piping code into the Matlab compiler will not work, and the main routine
being executed must be converted into a proper Matlab function.

When arguments are passed into compiled Matlab executable, the compiled
code does not automatically convert them to the required type (i.e.
float or integer) as Matlab does from the command line. In this case the
arguments, where necessary, must be converted to numbers using the
`str2num()` function.

Because of the way Matlab threads work, you **must** request exclusive
access to Legion nodes when running compiled Matlab programs.

### Compiling your program:

The Matlab code is must be compiled using the **mcc** tool; this must be
initially run as `mcc -setup` before anything is built. The mcc tool can
actually be invoked from the interpreter command prompt and executing
`help mcc` will give you quite a lot of information about how to use the
tool, along with examples.

All `.m` files must be built into the compiled code with the first .m
referenced in the build line acting as the main entry point for the
built code. It may be useful to include data files in the built code
which are handled in the build line using the `-a <datafile>` option.
Please remember to make the `.m` file an actual function and all other
dependencies sub-functions, otherwise the compiled code will not
execute.

### Some important mcc options:

  - `-m`: this is option which runs the macro to generate a C stand-alone
    application.  
    `-R`: specify runtime options for the Matlab compiler runtime.

### Some important runtime options:

  - `-nojvm`: disables the java virtual machine, which may speed-up
    certain codes. This option cannot be used if you are planning to
    have, for example pdf files or any other plots produced as output of
    your run.  
    `-nodisplay`: prevents anything being displayed on the screen, can be
    useful if this happens with the application as this would not work
    correctly in batch mode.  
    `--singleCompThread`: use only a single computational thread,
    otherwise Matlab will try to use more than one thread when the
    operation being performed supports multi threading. This is an
    alternative to allocating a whole Legion node to your job.

Once the application has been built, there should be an executable named
after the prefix of the `.m` file, generally `<app name>.m`, and a shell
script with the name `run\_<app name>.sh` - both these files need to be
transferred to Legion.

We have installed a runtime environment on Legion here:

```
/shared/ucl/apps/Matlab/R2011a/Runtime7.15/v715/
```

If you have been given pre-compiled code by someone else, the
application may not work as the Matlab runtime version must reasonably
match that of the Matlab compiler that was used to build the
application. The runtime is freely distributable and can be found in the
installation directory of Matlab. The runtime has a GUI install
interface and it can be installed at any location in your home
directory.

For more information, please read your Matlab documentation.

### Job submission scripts:

There are three things that you must take into account:

1.  The location of the Matlab compiler runtime needs to be passed to
    the script used to run the compiled Matlab code as the first
    argument.
2.  The compiler runtime needs a directory (cache) to unpack files to
    when it is running. By default this directory is in the home folder.
    This needs to be changed since the home directory is not writable in
    Legion from the compute nodes. Since the Matlab runs will be single
    node jobs, the cache location should be in the storage on the
    compute nodes which is stored in `TMPDIR`.
3.  Use the `-ac exclusive` SGE option to request exclusive access to a
    Legion node unless you use the `--singleCompThread` Matlab option.

For example, a multi-threaded serial script should look something like:

```bash
#!/bin/bash -l
# Batch script to run a serial job on Legion with the upgraded
# software stack under SGE.

# Force bash as the executing shell.
#$ -S /bin/bash

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:10:0

# Request 1 gigabyte of RAM 
#$ -l mem=1G

# Select 12 threads (the most possible on Legion).
#$ -l thr=12

# The way Matlab threads work requires Matlab to not share nodes with other
# jobs.
#$ -ac exclusive

# Set the name of the job.
#$ -N Matlab_Job_1

# Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to $HOME. For example:
##$ -wd /home//Scratch
# Alternatively, launch your job from anywhere *within ~/Scratch*
#$ -cwd

# store the MATLAB runtime path in a global environment variable (MCR_HOME)
export MCR_HOME=/shared/ucl/apps/Matlab/R2011a/Runtime7.15/v715/

# the path to the Matlab cache is stored in the global variable MCR_CACHE_ROOT 
export MCR_CACHE_ROOT=$TMPDIR/mcr_cache

# make sure the directory in MCR_CACHE_ROOT exists
mkdir -p $MCR_CACHE_ROOT

# Run the executable, passing the path stored in MCR_HOME as the first argument.
# There is no need to pass the content of MCR_CACHE_ROOT as an argument to the
# to the run_appname.sh script since it is a variable that the Matlab runtime is aware of.
./run_appname.sh $MCR_HOME [arguments list]

# Preferably, tar-up (archive) all output files onto the shared scratch area
tar zcvf $HOME/Scratch/files_from_job_${JOB_ID}.tgz $TMPDIR

# Make sure you have given enough time for the copy to complete!
```

For any queries and problem reports, please contact
<rc-support@ucl.ac.uk>.

