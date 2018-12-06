---
title: MKL
layout: docs
---

# Intel's Math Kernel Library

Intel MKL implements CDFT, BLACS and ScaLAPACK and provides Fortran 95
interfaces for BLAS and LAPACK.

MKL is now part of the default Intel compiler module. (Type `module avail compilers/intel` to see the current versions of Intel modules).

```
module load compilers/intel/2015/update2
```

`module show` on the Intel compiler module will display that `$MKLROOT`
is set.

## Easy linking of MKL

If you can, try to use `-mkl` as a compiler flag - if that works, it
should get all the correct libraries linked in the right order. Some
build systems do not work with this however.

## Intel MKL link line advisor

It can be complicated to get the correct link line for MKL, so Intel has
provided a tool which will give you the link line with the libraries in
the right
    order.

  - <https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor>

Pick the version of MKL you are using (for the Intel 2015 compiler it
should be Intel(R) Parallel Studio XE 2015 Composer Edition), and these
options:

  - OS: Linux
  - Xeon Phi: None (unless you're explicitly using one)
  - Pick your compiler. BLAS and LAPACK are Fortran95 interfaces, to
    select them pick a Fortran compiler.
  - Architecture: Intel 64
  - You can choose what type of linking you prefer. Dynamic linking
    means the libraries are linked at runtime and use the .so library,
    while static means they are linked at compile time and use the .a
    library. The Single Dynamic Library for later MKL versions will mean
    MKL will do clever things to work out which parts of it you are
    using.
  - Interface layer: ILP64 (64-bit integer)
  - You probably want sequential threading in most cases.
  - Select Intel MPI if required.

You'll get something like
this:

```
# Link Flags

${MKLROOT}/lib/intel64/libmkl_blas95_ilp64 ${MKLROOT}/lib/intel64/libmkl_lapack95_ilp64 \
-L${MKLROOT}/lib/intel64 -lmkl_scalapack_ilp64 -lmkl_cdft_core -lmkl_intel_ilp64 \
-lmkl_core -lmkl_sequential -lmkl_blacs_intelmpi_ilp64 -lpthread -lm

# Compiler options

 -i8 -I${MKLROOT}/include/intel64/ilp64 -I${MKLROOT}/include
```

### Corrections

It is a good idea to double check the library locations given by the
tool are correct: do an `ls` and make sure the directory exists and
contains the libraries. In the past there have been slight path
differences between tool and install for some versions.
