---
title: Singularity/Apptainer
layout: docs
---

# Using Apptainer (Singularity) on our clusters

Myriad has Apptainer installed, which will be rolled out to our other clusters at a later date. 
The other clusters still have Singularity. You can use containers you have downloaded in your space.

## Apptainer

Run `apptainer --version` to see which version we currently have installed.

### Set up cache locations

Use this command to load the `apptainer` module to set up a suitable environment:

```
module load apptainer
```

Or set the locations manually:

```
# Create a build directory to build your own containers.
mkdir -p $XDG_RUNTIME_DIR/$USER_apptainerbuild

# Set $APPTAINER_TMPDIR to this local build location.
export APPTAINER_TMPDIR=$XDG_RUNTIME_DIR/$USER_apptainerbuild

# Create a .apptainer directory in your Scratch
mkdir $HOME/Scratch/.apptainer

# Set the cache directory to your Scratch.
export APPTAINER_CACHEDIR=$HOME/Scratch/.apptainer

```

You probably want to add those `export` statements to your `.bashrc` under `# User specific aliases and functions` so those environment variables are always set when you log in.

### Bind locations

Your $HOME and Scratch directories are bound automatically so they are available
from inside your containers.

For more information on these options, have a look at the Apptainer documentation:

* [Apptainer user guide](https://apptainer.org/docs/user/main/index.html)
* [Apptainer bind paths and mounts](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html)
* [Apptainer build environment](https://apptainer.org/docs/user/main/build_env.html)

### Backwards compatibility

The `singularity` command still exists as a symbolic link and will run `apptainer`.

Apptainer will use the older `$SINGULARITY_` environment variables if the `$APPTAINER_` versions
are not set.

### `build --remote` is no longer available

If you were building remote containers on Sylabs using

```
singularity build --remote
```

this functionality is no longer available in Apptainer. You can still log in to Sylabs via the web
interface, build containers on it and then pull them down with Apptainer.

### Building your own containers

With Apptainer you can build containers directly on our clusters without additional permissions, 
as long as they use a local filesystem and not home or Scratch. 

Our default setup uses `$XDG_RUNTIME_DIR` on the local disk of the login nodes, or `$TMPDIR` on a 
compute node (local disk on the node, on clusters that are not diskless).

If you try to build a container on a parallel filesystem, it will fail with a number of
permissions errors.


## Singularity

Run `singularity --version` to see which version we currently have installed.


!!! important "Singularity update to Apptainer"
    On Myriad, we are updating to Singularity to Apptainer. This update will occur on 14th 
    November during a [planned outage](../Planned_Outages.md)

    This update may affect any containers that are currently downloaded, so users will have to test
    them to check their workflow still functions correctly after the update. We expect most to work 
    as before, but cannot confirm this.

    A Singularity command that will no longer be available in Apptainer is 
    `singularity build --remote`. If any of you have workflows that depend on this, 
    please email rc-support@ucl.ac.uk. We are currently looking into how we would provide 
    equivalent functionality.

    Updates to the other clusters will follow, dates tbc.


### Set up cache locations and bind directories

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
# make sure we set up apptainer as above
module load apptainer

# get image from location and call it hello-world.sif in our current directory
apptainer pull hello-world.sif shub://vsoch/hello-world
```

Run the container.
```
apptainer run hello-world.sif
```

Run a specific command within our container.
```
apptainer exec hello-world.sif /bin/echo Hello World!
```

You can run containers inside jobscripts in the same way.

Useful links:

* [Carpentries Incubator lesson: Reproducible computational environments using containers: Introduction to Singularity](https://carpentries-incubator.github.io/singularity-introduction/)
* [Using NVIDIA Grid Cloud Containers on our clusters](../Supplementary/NVIDIA_Containers/#using-nvidia-grid-cloud-containers)

## Docker containers

You can use Singularity to run Docker containers. Docker itself is not suitable for use on a multi-user
HPC system, but Singularity can convert and run Docker containers for you.

```
apptainer pull python-3.9.6.sif docker://python:3.9.6-slim-buster
```

In this case, `apptainer pull` is downloading a Docker image, and also converting it into a format
that Apptainer uses. You then use `apptainer run` or `apptainer exec` on the .sif image as above.

## Graphical containers in interactive jobs

If you are trying to run a graphical application from inside a container in an 
interactive job and it is failing with errors about not being able to open a 
display, you will need to: 

 * ssh in to the cluster with [X-forwarding on](../howto.md/#how-do-i-run-a-graphical-program) 
as normal 
 * request an [interactive job](../Interactive_Jobs.md) using `qrsh` 
 * bind mount your `$HOME/.Xauthority` file inside the container

To do the bind mount, you could add it to your `$APPTAINER_BINDPATH`
```
export APPTAINER_BINDPATH=$APPTAINER_BINDPATH,$HOME/.Xauthority
```

or you can pass it in with the `–-bind=$HOME/.Xauthority` option to `singularity shell` or 
`singularity exec`.

## Building containers with Apptainer

!!! important "Requires Apptainer" 
    This requires Apptainer and will not work in clusters which still use Singularity.


One of the nice new features of Apptainer is it is now possible to build containers on the login/compute nodes of our clusters and you no longer need to have a separate Linux machine (or the Singularity build service) to do so.

### Set up your environment

Load the `apptainer` module:

```
module load apptainer
```

### Write a definition file

Unfortunately Apptainer doesn't (yet) support Dockerfiles and [uses its own syntax](https://apptainer.org/docs/user/main/definition_files.html). 

There are example files in [this repository](https://github.com/owainkenwayucl/apptainer_examples) and we will use the "[AlmaLinux Python](https://github.com/owainkenwayucl/apptainer_examples/tree/main/almalinux_python)" example here.

The two files you need for this example are [`alma_python.def`](https://github.com/owainkenwayucl/apptainer_examples/blob/main/almalinux_python/alma_python.def) and [`pi.py`](https://github.com/owainkenwayucl/apptainer_examples/blob/main/almalinux_python/pi.py).

This example builds an image based on the latest [AlmaLinux](https://almalinux.org/) (at time of writing 9.3) container in Dockerhub:

```
Bootstrap: docker
From: almalinux:latest
Stage: build

%files
	./pi.py /pi.py

%post
	chmod 644 /pi.py
	dnf update -y
	dnf install -y 'dnf-command(config-manager)'
	dnf config-manager --set-enabled crb
	dnf install -y epel-release
	dnf install -y python3 python3-pip python3-virtualenv
	virtualenv /runtime
	source /runtime/bin/activate
	pip install --upgrade pip
	pip install numba
%runscript
	source /runtime/bin/activate
	python3 /pi.py
```


It copys the `pi.py` file into the image (the `%files` section), updates the packages in the container, installs the Code Ready Builder and EPEL repositories, and uses them to install `pip` and `virtualenv` (the `%post` section).  Finally it uses those two tools to build a virtual environment with Numba to run the code in. 

Finally it sets the container's run command to activate the virtual environment with the dependencies and execute `pi.py` (the `%runscript` section).

### Build container

To the build the container simply run:

```
apptainer build --fakeroot alma_python.sif alma_python.def
```

The `--fakeroot` option is important because of course as a normal user on our HPC systems you are not `root`.

### Running the container

To run the container:

```
apptainer run alma_python.sif 
```