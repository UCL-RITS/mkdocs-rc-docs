---
title: ATLAS
layout: docs
---
# ATLAS

ATLAS (Automatically Tuned Linear Algebra Software) provides self-tuning
implementations of BLAS and LAPACK. We have versions of ATLAS available
that were built with various different compilers.

## Linking ATLAS 3.10.2

There are ATLAS modules for GCC 4.9.2 and the Intel 2015 compilers.

The modules add the relevant lib directory to your LD\_LIBRARY\_PATH and
LIBRARY\_PATH. You can see what those are with `module show` followed by
the module name.

  - [ATLAS website](http://math-atlas.sourceforge.net/errata.html#LINK)

### Dynamic linking

There is one combined library each for serial and threaded ATLAS (in
most circumstances you probably want the serial version).

Serial:

```
-L${ATLASROOT}/lib -lsatlas
```

Threaded:

```
-L${ATLASROOT}/lib -ltatlas
```

### Static linking

There are multiple libraries.

Serial:

```
-L${ATLASROOT}/lib -llapack -lf77blas -lcblas -latlas
```

Threaded:

```
-L${ATLASROOT}/lib -llapack -lptf77blas -lptcblas -latlas
```

### Runtime errors

If you get a runtime error saying that `libgfortran.so` cannot be found,
you need to add `-lgfortran` to your link line.

The Intel equivalent is `-lifcore`.

You can run `module show <compiler module>` with the compiler you are using to see where the libraries are located.
