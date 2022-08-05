---
title: Singularity
layout: docs
---

# Using Singularity on Our Clusters

Singularity is installed on all our clusters. You can use containers you have downloaded in your space.

Run `singularity --version` to see which version we currently have installed. 

## Set up cache locations and bind directories

The cache directories should be set to somewhere in your space so they don't fill up `/tmp` on the login nodes.

The bindpath specifies what directories are made available inside the container - only your home is bound by default so you need to add Scratch.

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

