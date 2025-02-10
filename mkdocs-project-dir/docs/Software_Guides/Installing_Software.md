---
title: Installing Software
layout: docs
---

## Installing software

If you want to request that software be installed centrally, you can email us at 
rc-support@ucl.ac.uk. When you send in a request please address the following questions so 
that the install can be properly prioitised and planned,

* Can you provide some details as to why and give an idea of the timeline you would like us 
to build it in?
* Do you have an idea of the user base for this software within your community? If you are asking 
for some software on the MMM machines this can be the wider community and for UCL machines users 
in your ecosystem.
* If the software is only required by you would you be open to trying to install the software in 
your home space? We can provide some assistance here if you tell us what problems you are
encountering.

The requests will be added to the issues in our [buildscripts repository](https://github.com/UCL-ARC/rcps-buildscripts). The buildscripts themselves are there too, so you can see how we 
built and installed our central software stack.

You can install software yourself in your space on the cluster. Below are some tips for 
installing packages for languages such as Python or Perl as well as compiling software.

### No sudo!

You cannot install anything using `sudo` (and neither can we!). If the instructions tell you to do that, read further to see if they also have instructions for installing in user space, or for doing an install from source if they are RPMs.

Alternatively, just leave off the `sudo` from the command they tell you to run and look for an alternative way to give it an install location if it tries to install somewhere that isn't in your space (examples for some common build systems are below).

### Download source code

Use wget or curl to download the source code for the software you want to install 
to your account on the cluster. You can use `tar` to extract source archives named 
like `tar.gz` or `.tgz` or `.tar.bz2` among others and `unzip` for `.zip` files. 
`xz --decompress` will expand `.xz` files.

```
wget https://www.example.com/program.tar.gz
tar -xvf program.tar.gz
```
You will not be able to use a package manager like `yum`, and will need to follow 
the manual installation instructions for a user-space install (not using `sudo`).

### Set up modules

Before you start compiling, you need to make sure you have the right compilers, 
libraries and other tools available for your software. If you haven't changed 
anything, you will have the default modules loaded.

Check what the instructions for your software tell you about compiling it. If the 
website doesn't say much, the source code will hopefully have a README or INSTALL file.

You may want to use a different compiler - the default is the Intel compiler.

`module avail compilers` will show you all the compiler modules available. Most 
Open Source software tends to assume you're using GCC and OpenMPI (if it uses MPI) 
and is most tested with that combination, so if it doesn't tell you otherwise  you 
may want to begin there (do check what the newest modules available are - the below 
is correct at time of writing):

```
# unload your current compiler and mpi modules
module unload -f compilers mpi
# load the GNU compiler
module load compilers/gnu/4.9.2

# these three modules are only needed on Myriad
module load numactl/2.0.12
module load binutils/2.29.1/gnu-4.9.2
module load ucx/1.8.0/gnu-4.9.2

# load OpenMPI
module load mpi/openmpi/4.0.3/gnu-4.9.2
```

Useful resources:

* [Modules pt 1 (moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846737) (UCL users)
* [Modules pt 2 (moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4846739) (UCL users)
* [Modules pt 1 (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98405) (non-UCL users)
* [Modules pt 2 (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98414) (non-UCL users)

### Newer versions of GCC and GLIBCXX

The software you want to run may require newer compilers or a precompiled binary may say 
that it needs a newer GLIBCXX to be able to run. You can access these as follows:

```
# make all the newer versions visible
module load beta-modules
# unload current compiler, mpi and gcc-libs modules
module unload -f compilers mpi gcc-libs
# load GCC 10.2.0
module load gcc-libs/10.2.0
module load compilers/gnu/10.2.0
```

The `gcc-libs` module contains the actual compiler and libraries, while the `compilers/gnu` 
module sets environment variables that are likely to be picked up by build systems, telling them
what the C, C++ and Fortran compilers are called.

### GLIBC version error

If you get an error saying that a precompiled binary that you are installing needs a newer
GLIBC (not GLIBCXX) then this has been compiled on a newer operating system and will not
work on our clusters. Look for a binary that was created for CentOS 7 (we have RHEL 7) or
build the program from source if possible.

## Build systems

Most software will use some kind of build system to manage how files are
compiled and linked and in what order. Here are a few common ones.

### Automake configure

[Automake](http://www.gnu.org/software/automake/manual/automake.html)
will generate the Makefile for you and hopefully pick up sensible
options through configuration. You can give it an install prefix to tell
it where to install (or you can build it in place and not use make
install at all).

```
./configure --prefix=/home/username/place/you/want/to/install
make
# if it has a test suite, good idea to use it
make test 
make install
```

If it has more configuration flags, you can use `./configure --help` to
view them.

Usually configure will create a config.log: you can look in there to
find if any tests have failed or things you think should have been
picked up haven't.

### CMake

[CMake](http://www.cmake.org/) is another build system. It will have a
CMakeFile or the instructions will ask you to use cmake or ccmake rather
than make. It also generates Makefiles for you. `ccmake` is a
terminal-based interactive interface where you can see what variables
are set to and change them, then repeatedly configure until everything
is correct, generate the Makefile and quit. `cmake` is the commandline
version. The interactive process tends to go like this:

```
ccmake CMakeLists.txt
# press c to configure - will pick up some options
# press t to toggle advanced options
# keep making changes and configuring until no more errors or changes
# press g to generate and exit
make
# if it has a test suite, good idea to use it
make test 
make install
```

The options that you set using ccmake can also be passed on the commandline to
cmake with `-D`. This allows you to script an install and run it again later.
`CMAKE_INSTALL_PREFIX` is how you tell it where to install.

```
# making a build directory allows you to clean it up more easily
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/home/username/place/you/want/to/install
```

If you need to rerun cmake/ccmake and reconfigure, remember to delete the
`CMakeCache.txt` file first or it will still use your old options.
Turning on verbose Makefiles in cmake is also useful if your code
didn't compile first time - you'll be able to see what flags the
compiler or linker is actually being given when it fails.

### Make

Your code may come with a Makefile and have no configure, in which
case the generic way to compile it is as follows:

```
make targetname
```

There's usually a default target, which `make` on its own will use. `make all`
is also frequently used. 
If you need to change any configuration options, you'll need to edit those
sections of the Makefile (usually near the top, where the variables/flags are
defined).

Here are some typical variables you may want to change in a Makefile.

These are what compilers/mpi wrappers to use - these are also defined by
the compiler modules, so you can see what they should be. Intel would be
`icc`, `icpc`, `ifort`, while the GNU compiler would be `gcc`, `g++`, `gfortran`. 
If this is a program that can be compiled using MPI and only has a variable for CC, 
then set that to mpicc.

```
CC=gcc
CXX=g++
FC=gfortran
MPICC=mpicc
MPICXX=mpicxx
MPIF90=mpif90
```

CFLAGS and LDFLAGS are flags for the compiler and linker respectively,
and there might be LIBS or INCLUDE in the Makefile as well. When linking a library 
with the name libfoo, use `-lfoo`.

```
CFLAGS="-I/path/to/include"
LDFLAGS="-L/path/to/foo/lib -L/path/to/bar/lib"
LDLIBS="-lfoo -lbar"
```

Remember to `make clean` first if you are recompiling with new options. This will delete
object files from previous attempts. 


## BLAS and LAPACK

BLAS and LAPACK are linear algebra libraries that are provided as part of MKL, 
OpenBLAS or ATLAS. There are several different OpenBLAS and ATLAS modules for 
different compilers. MKL is available as part of each Intel compiler module.

Your code may try to link `-lblas -llapack`: this isn't the right way to use BLAS 
and LAPACK with MKL or ATLAS (though our OpenBLAS now has symlinks that mean this 
will work).

### MKL

When you have an Intel compiler module loaded, typing 
```
echo $MKLROOT
```
will show you that MKL is available.

#### Easy linking of MKL

If you can, try to use `-mkl` as a compiler flag - if that works, it should get 
all the correct libraries linked in the right order. Some build systems do not 
work with this however and need explicit linking.

#### Intel MKL link line advisor

It can be complicated to get the correct link line for MKL, so Intel has provided 
a tool which will give you the link line with the libraries in the right order.

* https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

Pick the version of MKL you are using (for the Intel 2018 compiler it should be 
Intel(R) MKL 2018.0), and these options:

* OS: Linux
* Pick your compiler. BLAS and LAPACK are Fortran95 interfaces, to select them pick a Fortran compiler.
* Architecture: Intel(R) 64
* You can choose what type of linking you prefer. Dynamic linking means the libraries are linked at runtime and use the .so library, while static means they are linked at compile time and use the .a library. The Single Dynamic Library for later MKL versions will mean MKL will do clever things to work out which parts of it you are using.
* Interface layer: 64-bit integer
* Threading layer: You probably want sequential threading in most cases.
* Select additional libraries (ScaLAPACK) if required.
* Select Intel MPI if required.
* Select 'Link with Intel MKL libraries explicitly' 

You'll get something like this:
```
${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a ${MKLROOT}/lib/intel64/libmkl_lapack95_ilp64.a -L${MKLROOT}/lib/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl
```
and compiler options:
```
-i8 -I${MKLROOT}/include/intel64/ilp64 -I${MKLROOT}/include
```

It is a good idea to double check the library locations given by the tool are 
correct: do an `ls ${MKLROOT}/lib/intel64` and make sure the directory exists 
and contains the libraries. In the past there have been slight path differences 
between tool and install for some versions.

### OpenBLAS

We have native threads, OpenMP and serial versions of OpenBLAS. 
Type `module avail openblas` to see the available versions.

#### Linking OpenBLAS

Our OpenBLAS modules now contain symlinks for `libblas` and `liblapack` that both 
point to `libopenblas`. This means that the default `-lblas -llapack` will in fact work.

This is how you would normally link OpenBLAS:
```
-L${OPENBLASROOT}/lib -lopenblas
```
If code you are compiling requires separate entries for BLAS and LAPACK, set them 
both to `-lopenblas`.

#### Troubleshooting: OpenMP loop warning

If you are running a threaded program and get this warning:
```
OpenBLAS Warning : Detect OpenMP Loop and this application may hang. Please rebuild the library with USE_OPENMP=1 option.
```
Then tell OpenBLAS to use only one thread by adding the below to your jobscript 
(this overrides `$OMP_NUM_THREADS` for OpenBLAS only):
```
export OPENBLAS_NUM_THREADS=1
```
If it is your own code, you can also set it in the code with the function
```
void openblas_set_num_threads(int num_threads);
```

You can avoid this error by compiling with one of the `native-threads` or `serial` 
OpenBLAS modules instead of the `openmp` one.

### ATLAS

We would generally recommend using OpenBLAS instead at present, but we do have 
ATLAS modules.

#### Dynamic linking ATLAS

There is one combined library each for serial and threaded ATLAS (in most 
circumstances you probably want the serial version).

Serial:
```
-L${ATLASROOT}/lib -lsatlas
```

Threaded:
```
-L${ATLASROOT}/lib -ltatlas
```

#### Static linking ATLAS

There are multiple libraries to link.

Serial:
```
-L${ATLASROOT}/lib -llapack -lf77blas -lcblas -latlas
```

Threaded:
```
-L${ATLASROOT}/lib -llapack -lptf77blas -lptcblas -latlas
```

#### Troubleshooting: libgfortran or lifcore cannot be found

If you get a runtime error saying that `libgfortran.so` cannot be found, 
you need to add `-lgfortran` to your link line.

The Intel equivalent is `-lifcore`.

You can do a module show on the compiler module you are using to see where 
the Fortran libraries are located if you need to give a full path to them.


## Installing additional packages for an existing scripting language

### Python

There are `python2/recommended` and `python3/recommended` module bundles you will see if you type 
`module avail python`. These use a virtualenv, have a lot of Python packages installed already, 
like numpy and scipy (see [the Python package list](../Installed_Software_Lists/python-packages.md)) 
and have `pip` set up for you.

#### Load the GNU compiler

Our Python installs were built with GCC. You can run them without problems with the default Intel
compilers loaded because it also depends on the `gcc-libs/4.9.2` module. However, when you are 
*installing* your own Python packages you should make sure you have the GNU compiler module loaded.
This is to avoid the situation where you build your package with the Intel compiler and then try to
run it with our GNU-based Python. If it compiled any C code, it will be unable to find Intel-specific
instructions and give you errors.

Change your compiler module:
```
module unload compilers
module load compilers/gnu/4.9.2
```

If you get an error like this when trying to run something, you built a package with the Intel compiler.
```
undefined symbol: __intel_sse2_strrchr
```

#### Install your own packages in the same virtualenv

This will use our central virtualenv and the packages we have already installed.

```
# for Python 2
pip install --user <python2pkg>
# for Python 3
pip3 install --user <python3pkg>
```
These will install into `.python2local` or `.python3local` in your home directory. 

If your own installed Python packages get into a mess, you can delete (or rename) the whole 
`.python3local` and start again.

#### Using your own virtualenv

If you need different packages that are not compatible with the centrally installed versions (eg. 
what you are trying to install depends on a different version of something we have already installed)
then you can create a new virtualenv and only packages you are installing yourself will be in it.

In this case, you do not want our virtualenv with our packages to also be active.
We have two types of Python modules. If you type `module avail python` there are 
"bundles" which are named like `python3/3.7` - these include our virtualenv and
packages. Then there are the base modules for just python itself, like `python/3.7.4`. 

When using your own virtualenv, you want to load one of the base python modules.

```
# load a base python module (you will always need to do this)
module load python/3.7.4
# create the new virtualenv, with any name you want
virtualenv <DIR>
# activate it
source <DIR>/bin/activate
```
Your bash prompt will change to show you that a different virtualenv is active.
(This one is called `venv`).
```
(venv) [uccacxx@login03 ~]$ 
```

`deactivate` will deactivate your virtualenv and your prompt will return to normal.

You only need to create the virtualenv the first time. 

##### Error while loading shared libraries

You will always need to load the base python module before activating your
virtualenv or you will get an error like this:
```
python3: error while loading shared libraries: libpython3.7m.so.1.0: cannot open shared object file: No such file or directory
```

#### Installing via setup.py

If you need to install by downloading a package and using `setup.py`, you can use the `--user` 
flag and as long as one of our python module bundles are loaded, it will install into the same 
`.python2local` or `.python3local` as `pip` does and your packages will be found automatically.
```
python setup.py install --user
```

If you want to install to a different directory in your space to keep this package separate,
you can use `--prefix` instead. You'll need to add that location to your `$PYTHONPATH` and `$PATH`
as well so it can be found. Some install methods won't create the prefix directory you requested
for you automatically, so you would need to create it yourself first.

This type of install makes it easier for you to only have this package in your paths when you
want to use it, which is helpful if it conflicts with something else.
```
# add location to PYTHONPATH so Python can find it
export PYTHONPATH=/home/username/your/path/lib/python3.7/site-packages:$PYTHONPATH
# if necessary, create lib/pythonx.x/site-packages in your desired install location
mkdir -p /home/username/your/path/lib/python3.7/site-packages
# do the install
python setup.py install --prefix=/home/username/your/path
```
It will tend to tell you at install time if you need to change or create the `$PYTHONPATH` directory.

To use this package, you'll need to add it to your paths in your jobscript or `.bashrc`.
Check that the `PATH` is where your Python executables were installed.
```
export PYTHONPATH=/home/username/your/path/lib/python3.7/site-packages:$PYTHONPATH
export PATH=/home/username/your/path/bin:$PATH
```
It is very important that you keep the `:$PYTHONPATH` or `:$PATH` at the end of these - you
are putting your location at the front of the existing contents of the path. If you leave 
them out, then only your package location will be found and nothing else.


#### Troubleshooting: remove your pip cache

If you built something and it went wrong, and are trying to reinstall it with `pip` and keep 
getting errors that you think you should have fixed, you may still be using a previous cached version. 
The cache is in `.cache/pip` in your home directory, and you can delete it.

You can prevent caching entirely by installing using `pip3 install --user --no-cache-dir <python3pkg>`

#### Troubleshooting: Python script executable paths

If you have an executable Python script (eg. something you run using `pyutility` and not 
`python pyutility.py`) that begins like this: 
```
#!/usr/bin/python2.6
```
and fails because that Python doesn't exist in that location or isn't the one that has the 
additional packages installed, then you should change it so it uses the first Python found 
in your environment instead, which will be the one from the Python module you've loaded.
```
#!/usr/bin/env python
```


