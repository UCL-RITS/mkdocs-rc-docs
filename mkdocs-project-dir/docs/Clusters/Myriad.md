---
title: Myriad
layout: cluster
---
# Myriad

Myriad is designed for high I/O, high throughput jobs that will run
within a single node rather than multi-node parallel jobs.

## Accounts

Myriad accounts can be applied for via the [Research Computing sign up process](../Account_Services.md).

As Myriad is our most general-purpose system, everyone who signs up for a Research Computing account is given access to Myriad.

## Logging in

You will use your UCL username and password to ssh in to Myriad.

```
ssh uccaxxx@myriad.rc.ucl.ac.uk
```

If using PuTTY, put `myriad.rc.ucl.ac.uk` as the hostname and your
seven-character username (with no @ after) as the username when logging
in, eg. `uccaxxx`. When entering your password in PuTTY no characters or
bulletpoints will show on screen - this is normal.

If you are outside the UCL firewall you will need to follow the
instructions for [Logging in from outside the UCL firewall](../howto.md#logging-in-from-outside-the-ucl-firewall).

### Logging in to a specific node

You can access a specific Myriad login node with: 

```
ssh uccaxxx@login12.myriad.rc.ucl.ac.uk
ssh uccaxxx@login13.myriad.rc.ucl.ac.uk
```

The main address will redirect you on to either one of them.

## Copying data onto Myriad

You will need to use an SCP or SFTP client to copy data onto Myriad.
Please refer to the page on [How do I transfer data onto the system?](../howto.md#how-do-i-transfer-data-onto-the-system)

## Quotas

The default quotas on Myriad are 150GB for home and 1TB for Scratch.

These are hard quotas: once you reach them, you will no longer be able
to write more data. Keep an eye on them, as this will cause jobs to fail
if they cannot create their .o or .e files at the start, or their output
files partway through.

You can check both quotas on Myriad by running: 

```
lquota
``` 

which will give you output similar to this:

```
     Storage        Used        Quota   % Used   Path
        home  721.68 MiB   150.00 GiB       0%   /home/uccaxxx
     scratch   52.09 MiB     1.00 TiB       0%   /scratch/scratch/uccaxxx
```

You can apply for quota increases using the form at [Additional Resource Requests](../Additional_Resource_Requests.md).

Here are some tips for [managing your quota](../howto.md#managing-your-quota) and
finding where space is being used.

## Job sizes

| Cores   | Max wallclock |
| ------- | ------------- |
| 1       | 72hrs         |
| 2 to 36 | 48hrs         |

[Interactive jobs](../Interactive_Jobs.md) run with `qrsh` have a
maximum wallclock time of 2 hours.

## Node types

Myriad contains three main node types: standard compute nodes, high memory
nodes and GPU nodes. As new nodes as added over time with slightly newer processor
variants, new letters are added.

| Type  | Cores per node   | RAM per node | tmpfs | Nodes |
| ----- | ---------------- | ------------ | ----- | ----- |
| H,D   | 36               | 192GB        | 1500G | 342   |
| I,B   | 36               | 1.5TB        | 1500G | 17    |
| J     | 36 + 2 P100 GPUs | 192GB        | 1500G | 2     |
| E,F   | 36 + 2 V100 GPUs | 192GB        | 1500G | 19    |
| L     | 36 + 4 A100 GPUs | 192GB        | 1500G | 6     |

You can tell the type of a node by its name: type H nodes are named
`node-h00a-001` etc.

Here are the processors each node type has:

  - F, H, I, J: Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
  - B, D, E, L: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz

(If you ever need to check this, you can include `cat /proc/cpuinfo` in your jobscript so
you get it in your job's .o file for the exact node your job ran on. You will get an entry
for every core).

## GPUs

Myriad has four types of GPU nodes: E, F, J and L. 

  - L-type nodes each have four NVIDIA A100s. (Compute Capability 80)
  - F-type and E-type nodes each have two NVIDIA Tesla V100s. The CPUs are slightly different on the different letters, see above. (Compute Capability 70)
  - J-type nodes each have two NVIDIA Tesla P100s. (Compute Capability 60)

You can include `nvidia-smi` in your jobscript to get information about the GPU your job ran on.

### Compute Capability

[Compute Capability](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#gpu-generations) is how NVIDIA categorises its generations of GPU architectures. 
When code is compiled, it targets one or multiple of these and so it may only be able 
to run on GPUs of a specific Compute Capability.

If you get an error like this:

```
CUDA runtime implicit initialization on GPU:0 failed. Status: device kernel image is invalid
```
then the software you are running does not support the Compute Capability of the GPU
you tried to run it on, and you probably need a newer version.

### Requesting multiple and specific types of GPU

You can request a number of GPUs by adding them as a resource request to your jobscript: 

```
# For 1 GPU
#$ -l gpu=1

# For 2 GPUs
#$ -l gpu=2

# For 4 GPUs
#$ -l gpu=4
```

If you ask for one or two GPUs your job can run on any type of GPU since it can fit on
any of the nodetypes. If you ask for four, it can only be a node that has four. 
If you need to specify one node type over the others because you need a particular 
Compute Capability, add a request for that type of node to your jobscript:

```
# request a V100 node only
#$ -ac allow=EF

# request an A100 node only
#$ -ac allow=L
```

The [GPU nodes](../Supplementary/GPU_Nodes.md) page has some sample code for running GPU jobs if you need a test example.

### Tensorflow

Tensorflow is installed: type `module avail tensorflow` to see the
available versions.

Modules to load for the non-MKL GPU version: 

```
module load python3/3.7
module load cuda/10.0.130/gnu-4.9.2
module load cudnn/7.4.2.24/cuda-10.0
module load tensorflow/2.0.0/gpu-py37
```

### PyTorch

PyTorch is installed: type `module avail pytorch` to see the versions
available.

Modules to load the most recent release we have installed (May 2022)
are:

```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python3/3.9-gnu-10.2.0
module load cuda/11.3.1/gnu-10.2.0
module load cudnn/8.2.1.32/cuda-11.3
module load pytorch/1.11.0/gpu
```

If you want the CPU only version then use:

```
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python3/3.9-gnu-10.2.0
module load pytorch/1.11.0/cpu
```
