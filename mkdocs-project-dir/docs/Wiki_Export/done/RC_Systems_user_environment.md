---
title: RC Systems user environment
categories:
 - User Guide
layout: docs
---
RC Systems User Environment

## Operating System

### Legion, Myriad, and Grace

Legion, Myriad, and Grace run a software stack based upon Red Hat
Enterprise Linux 7 and Son of Grid Engine. The environment provided
should be familiar to users of UNIX-like operating systems.

Here is a [A Quick Introduction to Unix](http://en.wikibooks.org/wiki/A_Quick_Introduction_to_Unix) for
those not familiar with this essential operating system.

### Aristotle

Aristotle runs Red Hat Enterprise Linux 6.5.

## Software

As well as the system software, there are a number of applications,
libraries and development tools available on our machines, the details
of which may be found on the [software pages](Software).

## Modules

Our systems use the [environment modules system](http://modules.sourceforge.net/) to manage packages. A
module configures your current login session or job to use a particular
piece of software. For example, this may involve altering your `PATH` and
`LD_LIBRARY_PATH` environment variables to make the associated commands
and/or libraries available at compile-time and/or run-time, without
explicitly having to know the relevant paths.

A module can for instance be associated with a particular version of the
Intel compiler, or particular MPI libraries, or applications software,
etc.

The default environment has the most commonly required modules already
loaded for your convenience.

You can see what modules are currently loaded by using the command
`module list`. The default module set is shown in the example below:

```
$ module list  
Currently Loaded Modulefiles:  
 1) gcc-libs/4.9.2                 8) screen/4.2.1                  15) tmux/2.2  
 2) cmake/3.2.1                    9) gerun                         16) mrxvt/0.5.4  
 3) flex/2.5.39                   10) nano/2.4.2                    17) userscripts/1.3.0  
 4) git/2.10.2                    11) nedit/5.6-aug15               18) rcps-core/1.0.0  
 5) apr/1.5.2                     12) dos2unix/7.3                  19) compilers/intel/2017/update1  
 6) apr-util/1.5.4                13) giflib/5.1.1                  20) mpi/intel/2017/update1/intel  
 7) subversion/1.8.13             14) emacs/24.5                    21) default-modules/2017  
``` 

This output indicates that the Intel compilers are loaded, the
Intel MPI environment, editor nedit and some other utilities.

In addition to those made available in your default environment, we
provide a rich set of additional modules for your use. These can be
listed by typing: 

```
module whatis
``` 

Or in a shorter form by typing: 

```
module avail
```

You can load additional modules into your current session by using the
command:

```
module load
``` 

For example, to add the module for FFTW 2.1.5 for the Intel
compilers, type: 

```
module load fftw/2.1.5/intel-2015-update2
``` 

Typing `module list` will now show the above with the addition
of the fftw module.

You can unload modules from your current session by using the command:
```
module unload
``` 

For example, to remove the FFTW module, type: 

```
module unload fftw/2.1.5/intel-2015-update2
```

One commonly required change is to switch from using the Intel
compiler and associated libraries (which are provided in the default
environment), to using the GCC compiler. This would be achieved by
typing the following commands: 

```
module unload compilers   
module unload mpi  
module load compilers/gnu/4.9.2  
module load mpi/intel/2015/update3/gnu-4.9.2
``` 

Note that the order in which you execute these commands is
vital\! You must always unload modules before loading their
replacements. Typing `module list` again will show the changes.

You can permanently change what modules are loaded by default in your
environment by editing your `~/.bashrc` file to add the appropriate module
load and unload commands at the end.

When you first start using a new application, typing 

```
module help <module>
``` 

(where `<module>` is the name of the application module) will
provide you with additional Legion-specific instructions on how to use
the application if any are
necessary.

### Module Commands

|                          |                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------- |
| `module load `<module>   | loads a module                                                                                 |
| `module unload `<module> | unloads a module                                                                               |
| `module purge`           | unloads all modules                                                                            |
| `module list`            | shows currently loaded modules                                                                 |
| `module avail`           | shows available modules                                                                        |
| `module whatis`          | shows available modules with brief explanations                                                |
| `module show `<module>   | List the contents of the module fire. Shows environment variables set-up by the module         |
| `module help `<module>   | Shows helpful information about a module, including instructions on how to use the application |


## Aristotle-Specific Modules

Aristotle mounts the Research Computing software stack, so you will see
all the same modules. They won't necessarily all work - everything built
specifically for Aristotle will have Aristotle in the module name or
else be in the extra module section that will show up at the bottom when
using `module avail`:

```
-------------------- /shared/ucl/apps/eb_ivybridge_noib/modules/all --------------------  
Bison/2.7-goolf-1.4.10                              OpenMPI/1.6.4-GCC-4.7.2  
CMake/2.8.11-goolf-1.4.10                           PCRE/8.12-goolf-1.4.10  
Docutils/0.9.1-goolf-1.4.10-Python-2.7.3            Python/2.7.3-goolf-1.4.10  
Doxygen/1.8.3.1-goolf-1.4.10                        ScaLAPACK/2.0.2-gompi-1.4.10-OpenBLAS-0.2.6-LAPACK-3.4.2  
EasyBuild/1.15.1                                    Sphinx/1.1.3-goolf-1.4.10-Python-2.7.3  
FFTW/3.3.3-gompi-1.4.10                             Szip/2.1-goolf-1.4.10  
GCC/4.7.2                                           bzip2/1.0.6-goolf-1.4.10  
GDAL/1.9.2-goolf-1.4.10                             flex/2.5.37-goolf-1.4.10  
GEOS/3.3.5-goolf-1.4.10                             gompi/1.4.10  
GMT/5.1.1-goolf-1.4.10                              goolf/1.4.10  
Ghostscript/9.10-goolf-1.4.10                       hwloc/1.6.2-GCC-4.7.2  
HDF5/1.8.10-patch1-goolf-1.4.10                     libreadline/6.2-goolf-1.4.10  
Jinja2/2.6-goolf-1.4.10-Python-2.7.3                ncurses/5.9-goolf-1.4.10  
LibTIFF/4.0.3-goolf-1.4.10                          netCDF/4.2.1.1-goolf-1.4.10  
M4/1.4.16-goolf-1.4.10                              setuptools/0.6c11-goolf-1.4.10-Python-2.7.3  
OpenBLAS/0.2.6-gompi-1.4.10-LAPACK-3.4.2            zlib/1.2.7-goolf-1.4.10
```

The others are mixed in with the general modules: here are a few:

```
matlab/full/r2015a/8.5-aristotle  
recommended/r-aristotle  
python/2.7.9/gnu.4.7.2-Aristotle  
gnuplot/5.0.1-Aristotle
```

Aristotle has different default modules:

```
$ module show default-modules-aristotle
-------------------------------------------------------------------
/shared/ucl/apps/modulefiles2/bundles/default-modules-aristotle:
  
module-whatis   Adds default Aristotle modules to your environment.
module      load compilers/gnu/4.6.3
module      load nedit/5.6
module      load mrxvt/0.5.4 
-------------------------------------------------------------------

```

