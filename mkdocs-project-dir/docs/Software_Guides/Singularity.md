---
title: Singularity
layout: docs
---

Singularity is installed on all our clusters. You can use containers you have downloaded in your space.

Run `singularity --version` to see which version we currently have installed. 

## Set up cache locations and bind directories

The cache directories should be set to somewhere in your space so they don't fill up `/tmp` on the login nodes.

The bindpath specifies what directories are made available inside the container - only your home is bound by default so you need to add Scratch.

Replace `uccaxxx` with your own username.

```
# Create a .singularity directory in your Scratch
mkdir /home/uccaxxx/Scratch/.singularity

# Set all the Singularity cache dirs to Scratch
export SINGULARITY_CACHEDIR=/home/uccaxxx/Scratch/.singularity/
export SINGULARITY_TMPDIR=/home/uccaxxx/Scratch/.singularity/tmp
export SINGULARITY_LOCALCACHEDIR=/home/uccaxxx/Scratch/.singularity/localcache
export SINGULARITY_PULLFOLDER=/home/uccaxxx/Scratch/.singularity/pull

# Bind your Scratch directory so it is accessible from inside the container
export SINGULARITY_BINDPATH=/scratch/scratch/uccaxxx
```

Different subdirectories are being set for each cache so you can tell which files came from where.

You probably want to add those `export` statements to your `.bashrc` under `# User specific aliases and functions` so those environment variables are always set when you log in.

For more information on these options, have a look at the Singularity documentation:

* [Singularity user guide](https://sylabs.io/guides/2.6/user-guide/index.html)
* [Singularity Bind Paths and Mounts](https://sylabs.io/guides/2.6/user-guide/bind_paths_and_mounts.html)
* [Singularity Build Environment](https://sylabs.io/guides/2.6/user-guide/build_environment.html)

