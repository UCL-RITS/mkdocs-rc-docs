---
title: OpenBLAS
layout: docs
---
# OpenBLAS

OpenBLAS provides CBLAS, BLAS and LAPACK.

There are versions compiled for the Intel and GNU compilers.

With the default modules loaded:

```
module load openblas/0.2.14/intel-2015-update2
```

`module show` on the OpenBLAS module will display that `$OPENBLASROOT`
is set, so you can use this in your link line if the library is not
picked up automatically.

## Linking OpenBLAS

  - Our OpenBLAS modules now contain symlinks for libblas and liblapack
    that both point to libopenblas. This means that the default
    `-lblas -llapack` link options, that some programs try to use when 
    building, will work.

This is how you would normally link OpenBLAS:

```
-L${OPENBLASROOT}/lib -lopenblas
```

If code you are compiling requires separate entries for BLAS and LAPACK,
set them both to `-lopenblas`.

## OpenBLAS and OpenMP warning

If you are running a threaded program and get this
warning:

```
OpenBLAS Warning : Detect OpenMP Loop and this application may hang. Please rebuild the library with USE_OPENMP=1 option.
```

Then tell OpenBLAS to use only one thread by adding this to your
jobscript (this overrides `$OMP_NUM_THREADS` for OpenBLAS):

```bash
export OPENBLAS_NUM_THREADS=1
```

If it is your code, you can also set it with the function 

```C
void openblas_set_num_threads(int num_threads);
```
