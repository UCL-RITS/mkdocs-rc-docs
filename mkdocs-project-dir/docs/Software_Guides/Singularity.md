---
title: Singularity
layout: docs
---

# Using Singularity on Our Clusters

Singularity is installed on all our clusters. You can use containers you have downloaded in your space.

Run `singularity --version` to see which version we currently have installed. 

## Set up cache locations and bind directories

The cache directories should be set to somewhere in your space so they don't fill up `/tmp` on 
the login nodes.

The bindpath mentioned below specifies what directories are made available inside the container - 
only your home is bound by default so you need to add Scratch.

You can either use the `singularity-env` environment module for this, or run the commands manually.

```
module load singularity-env
```

or:

```
# Create a .singularity directory in your Scratch
mkdir $HOME/Scratch/.singularity

# Create cache subdirectories we will use / export
mkdir $HOME/Scratch/.singularity/tmp
mkdir $HOME/Scratch/.singularity/localcache
mkdir $HOME/Scratch/.singularity/pull

# Set all the Singularity cache dirs to Scratch
export SINGULARITY_CACHEDIR=$HOME/Scratch/.singularity
export SINGULARITY_TMPDIR=$SINGULARITY_CACHEDIR/tmp
export SINGULARITY_LOCALCACHEDIR=$SINGULARITY_CACHEDIR/localcache
export SINGULARITY_PULLFOLDER=$SINGULARITY_CACHEDIR/pull

# Bind your Scratch directory so it is accessible from inside the container
#      and the temporary storage jobs are allocated
export SINGULARITY_BINDPATH=/scratch/scratch/$USER,/tmpdir
```

Different subdirectories are being set for each cache so you can tell which files came from where.

You probably want to add those `export` statements to your `.bashrc` under `# User specific aliases and functions` so those environment variables are always set when you log in.

For more information on these options, have a look at the Singularity documentation:

* [Singularity user guide](https://sylabs.io/guides/3.5/user-guide/index.html)
* [Singularity Bind Paths and Mounts](https://sylabs.io/guides/3.5/user-guide/bind_paths_and_mounts.html)
* [Singularity Build Environment](https://sylabs.io/guides/3.5/user-guide/build_environment.html)

## Downloading and running a container

Assuming you want to run an existing container, first you need to pull it from somewhere online that
provides it:

```
# make sure we set up singularity as above
module load singularity-env

# get image from location and call it hello-world.sif in our current directory
singularity pull hello-world.sif shub://vsoch/hello-world
```

Run the container.
```
singularity run hello-world.sif
```

Run a specific command within our container.
```
singularity exec hello-world.sif /bin/echo Hello World!
```

You can run containers inside jobscripts in the same way.

Useful links:

* [Carpentries Incubator lesson: Reproducible computational environments using containers: Introduction to Singularity](https://carpentries-incubator.github.io/singularity-introduction/)
* [Using NVIDIA Grid Cloud Containers on our clusters](../Supplementary/NVIDIA_Containers/#using-nvidia-grid-cloud-containers)

## Docker containers

You can use Singularity to run Docker containers. Docker itself is not suitable for use on a multi-user
HPC system, but Singularity can convert and run Docker containers for you.

```
singularity pull python-3.9.6.sif docker://python:3.9.6-slim-buster
```

In this case, `singularity pull` is downloading a Docker image, and also converting it into a format
that Singularity uses. You then use `singularity run` or `singularity exec` on the .sif image as above.

## Graphical containers in interactive jobs

If you are trying to run a graphical application from inside a container in an 
interactive job and it is failing with errors about not being able to open a 
display, you will need to: 

 * ssh in to the cluster with [X-forwarding on](../howto.md/#how-do-i-run-a-graphical-program) 
as normal 
 * request an [interactive job](../Interactive_Jobs.md) using `qrsh` 
 * bind mount your `$HOME/.Xauthority` file inside the container

To do the bind mount, you could add it to your `$SINGULARITY_BINDPATH`
```
export SINGULARITY_BINDPATH=/scratch/scratch/$USER,/tmpdir,$HOME/.Xauthority
```

or you can pass it in with the `--bind` option to `singularity shell` or 
`singularity exec`.

