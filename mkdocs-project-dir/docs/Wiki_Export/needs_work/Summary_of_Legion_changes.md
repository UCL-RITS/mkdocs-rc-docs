---
title: Summary of Legion changes
layout: docs
# This might have some useful bits that should be split up and distributed among other parts of the docs.
---

## Host key warning

The host keys for these login nodes and for legion.rc.ucl.ac.uk have
changed, so when you try to log in you may get a warning from ssh saying
that this has happened. You will need to remove the old keys from the
known hosts list.

### Remove old host keys

On Linux you can remove the old keys with:

```

`ssh-keygen -R login09.external.legion.ucl.ac.uk`  
`ssh-keygen -R 193.60.225.59`

`ssh-keygen -R login08.external.legion.ucl.ac.uk`  
`ssh-keygen -R 193.60.225.58`

`ssh-keygen -R login07.external.legion.ucl.ac.uk`  
`ssh-keygen -R 193.60.225.57`

`ssh-keygen -R login06.external.legion.ucl.ac.uk`  
`ssh-keygen -R 193.60.225.56`

`ssh-keygen -R legion.rc.ucl.ac.uk`

```

On Socrates you will probably need to edit your `~/.ssh/known_hosts`
file manually and delete the line for legion. (pico and vi are available
text editors on Socrates).

Using WinSCP the warning will look like this, and you will have the
option to update the key. ```

`'Server's host key does not match the one that WinSCP has in cache.'`

```

# Modules

There are some fairly significant changes to the modules available and
of course newer versions of packages than were available under the old
system. To see all the modules: 

```
`module avail`
```

If you have the Legion default modules loaded in your .bashrc, then you
should have the new default modules loaded
automatically.

```

`module list`  
`Currently Loaded Modulefiles:`  
`  1) gcc-libs/4.9.2             7) subversion/1.8.13         13) rcps-core/1.0.0`  
`  2) cmake/3.2.1                8) screen/4.2.1              14) compilers/intel/2015/update2`  
`  3) flex/2.5.39                9) gerun                     15) mpi/intel/2015/update3/intel`  
`  4) git/2.3.5                 10) nano/2.4.2                16) default-modules`  
`  5) apr/1.5.2                 11) nedit/5.6-aug15`  
`  6) apr-util/1.5.4            12) dos2unix/7.3`

```

If you have “module load” commands in your .bashrc, you'll have to
update them to reflect the changes to the module names/versions,
otherwise you will see error messages.

You can check our progress in installing all applications on the github
repository for the module files here:

<https://github.com/UCL-RITS/rcps-modulefiles>

And the scripts that build the packages here:

<https://github.com/UCL-RITS/rcps-buildscripts>

# Jobscript differences

## Parallel environments for shared memory threads or MPI

The way you request threads has changed: instead of using `#$ -l thr=4`,
you would put this in your jobscript:

```

`# Request 4 threads`  
`#$ -pe smp 4`

```

If you are using MPI, then there is only one parallel environment:

```

`# Request 4 MPI processes`  
`#$ -pe mpi 4`

```

(`-pe mpi` is an alias for `-pe qlc` so you can use either and they are
equivalent).

## RAM requested by shared memory jobs

As a result of the change above, threaded jobs now also request RAM per
core like MPI jobs do, rather than requesting the total amount. For
example, asking for 4 threads and 12G RAM will give you a total of 48G
RAM and not 12G as it was before. Check your memory requirements as you
will greatly reduce the places your jobs can run if you leave them too
high.

## Mixed-mode OpenMP and MPI

This has changed significantly. You will now request the total number of
cores you wish to use, and either set OMP\_NUM\_THREADS yourself, or
allow it to be worked out automatically.

```

`# Run 12 MPI processes, each spawning 2 threads`  
`#$ -pe qlc 24`  
`export OMP_NUM_THREADS=2`  
`gerun your_binary`

```

The below will automatically set OMP\_NUM\_THREADS to $NSLOTS/$NHOSTS,
so you will use threads within a node and MPI between nodes and don't
need to know in advance what size of node you are running on. Gerun will
then run $NSLOTS/$OMP\_NUM\_THREADS processes, round-robin allocated (if
supported by the MPI).

```

`#$ -pe qlc 24`  
`export OMP_NUM_THREADS=$(ppn)`  
`gerun your_binary`

```

For example, if that runs on 2 x 12-core nodes, you'll get 2 MPI
processes, each using 12 threads.

# Python

There are `python2/recommended` and `python3/recommended` bundles. These
use a virtualenv and have pip set up for you. They both have numpy and
scipy available.

See also [Compiling\#Python](Compiling#Python "wikilink") for how to
install your own packages.

To see what is already installed, the [Python-shared
list](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/lists/python-shared.list)
shows what is installed for both Python2 and 3, while the [Python2
list](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/lists/python-2.list)
and [Python3
list](https://github.com/UCL-RITS/rcps-buildscripts/blob/master/lists/python-3.list)
show what is only installed for one or the other. (There may also be
prereqs that aren't listed explicitly - pip will tell you if something
is already installed as long as you have the bundle loaded).
