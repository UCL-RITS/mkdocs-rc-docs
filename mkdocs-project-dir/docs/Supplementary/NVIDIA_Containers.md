# Using NVIDIA Grid Cloud Containers

NVIDIA's [NGC Container Registry](https://catalog.ngc.nvidia.com/) stores a lot of containers[^what_is_container] with various applications pre-configured to be run with GPUs.
Each container can be set up completely differently, so you'll need to read the instructions in the registry to work out how to use it.

Many of the instructions for using these containers assume you are using the Docker toolset to run the container, but this is not installed on our services[^why_no_docker]. The [Singularity container runtime](https://sylabs.io/singularity) can be used instead for most workloads, but there are some limitations, that mostly affect containers that try to run web services.

In general, if a container's instructions do not have specific instructions for using Singularity, and would tell you to run, for example:

```
docker run --gpus all nvcr.io/some/container
```

You should instead use:

```
singularity run --nv https://nvcr.io/some/container
```

For jobs using MPI, this is more complicated, because the MPI traffic has to be passed between the container and the operating system underneath. Containers built to use MPI will usually contain instructions for using Singularity, however.


## Worked Example: NAMD 3

The NAMD authors publish a NAMD container on the NGC Container Registry, and we should be able to download this and run it on our cluster inside a batch job. 

The page about how to use the container is here: <https://catalog.ngc.nvidia.com/orgs/hpc/containers/namd>

Following it through, you can download the benchmark example to check later whether your container works:

```
mkdir ngc_namd_experiment
cd ngc_namd_experiment
wget -O - https://gitlab.com/NVHPC/ngc-examples/raw/master/namd/3.0/get_apoa1.sh | bash
```

There are a couple of typos in the instructions: you'll need to use the tag `3.0-alpha3-singlenode` instead of `3.0_alpha3-singlenode`:

```
export NAMD_TAG="3.0-alpha3-singlenode"
```

### Creating the Container Image

Before you use Singularity to create the container image, you should load the Singularity module to set up some directories where things are stored. Not doing this can cause you problems, because the default places often do not have space to store the large files needed.

```
module load singularity-env
```

Once you've done that, you can download the container's files and build them into the usable container:

```
singularity build ${NAMD_TAG}.sif docker://nvcr.io/hpc/namd:${NAMD_TAG}
```

This can take a while: Singularity has to download quite a few file collections and assemble them into a single usable set. You may see some of the following warnings:

```
WARNING: 'nodev' mount option set on /lustre, it could be a source of failure during build process
2022/02/03 14:06:28  warn xattr{var/log/apt/term.log} ignoring ENOTSUP on setxattr "user.rootlesscontainers"
2022/02/03 14:06:28  warn xattr{/home/uccaiki/Scratch/.singularity/tmp/rootfs-5ac43e37-84fa-11ec-8784-0894ef553d4e/var/log/apt/term.log} destination filesystem does not support xattrs, further warnings will be suppressed
```

These indicate that various capabilities are not available because of how we're building the container. For HPC use, they don't present a problem, but they could be problematic if you were building a web server into a container.

When Singularity has finished, you should see the following message:

```
INFO:    Creating SIF file...
INFO:    Build complete: 3.0-alpha3-singlenode.sif
```

This file is the *container image*, which contains the files needed to run NAMD. You can see what NAMD gets when running "inside" the container, by running `ls` with it:

```
singularity exec 3.0-alpha3-singlenode.sif ls /
```

gives:

```
WARNING: Bind mount '/home/uccaiki => /home/uccaiki' overlaps container CWD /home/uccaiki/ngc_namd_experiment, may not be available
bin  boot  dev	environment  etc  home	host_pwd  lib  lib64  lustre  media  mnt  opt  proc  root  run	sbin  scratch  singularity  srv  sys  tmp  tmpdir  usr	var
```

The warning you get is telling you that your current working directory overlaps with a directory being "bound" into the container. Binding brings a directory into the container's view of the filesystem, so that, for example, programs can still access your home directory as usual. In this case it's not a problem, because it's warning you that your home directory is being bound into the container in the same place it would usually be, and that means the same files are visible.

By default, the clusters have Singularity configured to bind your home and Scratch directories into the container, as well as the per-job temporary storage allocated to jobs under `$TMPDIR`. 

The NAMD instructions make an alternative suggestion when setting up this environment variable to use to run Singularity, binding your data directory into a fixed place in the container:

```
SINGULARITY="$(which singularity) exec --nv -B $(pwd):/host_pwd ${NAMD_TAG}.sif"
```

The option `-B $(pwd):/host_pwd` handles this, binding wherever you run the command from to the fixed location `/host_pwd` inside the container.

So, for example, if you run:

```
ls
$SINGULARITY ls /host_pwd
```

In both cases, you should see the same files, because you're looking at the same underlying directory.


### Running on a Single Node

At this point you're ready to run NAMD inside the container, but you need a job script to submit to the scheduler which can set up the number of cores and GPUs correctly.

```bash
#!/bin/bash -l

# Start with our resource requirements:
#  1 hour's maximum runtime
#$ -l h_rt=1:00:00

# 2 GPUs
#$ -l gpu=2

# 36 processor cores
#$ -pe smp 36

# Start with current working directory the same as where we submitted the job from
#$ -cwd

# Make sure Singularity looks for our stored container data in the right places
module load singularity-env

# Set the variables we need for this example to run
NAMD_TAG="3.0-alpha3-singlenode"
SINGULARITY="$(which singularity) exec --nv -B $(pwd):/host_pwd ${NAMD_TAG}.sif"

# This is where the benchmark's data ends up inside the container
INPUT="/host_pwd/apoa1/apoa1_nve_cuda.namd"

# Show us some info we can refer to later
printf "Running NAMD using:\n Cores: %d\n GPUs: %d\n Container image: %s\nWorking directory: %s\n Input: %s\n" \
  "$NSLOTS" \
  "$GPU" \
  "${NAMD_TAG}.sif" \
  "$(pwd)" \
  "$INPUT"

# Run NAMD
"$SINGULARITY" namd3  +ppn "$NSLOTS" +setcpuaffinity +idlepoll "$INPUT"
```

Copy this into a file, and submit it to the queue, e.g.:

```
qsub ngc_namd_experiment.sh
```

This should take about 5 minutes to run on a 36-core, 2-GPU node. 


[^what_is_container]: A container is a way of bundling up a collection of files and instructions to run as a kind of "altered view" of the computer's files and systems.

[^why_no_docker]: This is for a variety of reasons, but primarily that Docker presents a much larger range of security and misuse risks when used by inexperienced or hostile users. Singularity represents a much better fit for common HPC workloads and use-cases.

