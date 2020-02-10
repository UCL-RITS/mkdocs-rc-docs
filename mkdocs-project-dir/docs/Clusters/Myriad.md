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

[Interactive jobs](../Advanced_Topics/Interactive_Jobs.md) run with `qrsh` have a
maximum wallclock time of 2 hours.

## Node types

Myriad contains three main node types: standard compute nodes, high memory
nodes and GPU nodes. As new nodes as added over time with slightly newer processor
variants, new letters are added.

| Type  | Cores per node   | RAM per node | Nodes |
| ----- | ---------------- | ------------ | ----- |
| H,D   | 36               | 192GB        | 86    |
| I,B   | 36               | 1.5TB        | 9     |
| J     | 36 + 2 P100 GPUs | 192GB        | 2     |
| E,F   | 36 + 2 V100 GPUs | 192GB        | 9     |

You can tell the type of a node by its name: type H nodes are named
`node-h00a-001` etc.

## GPUs

Myriad has three types of GPU nodes, J, E and F. There are two J-types nodes each with two nVidia Tesla P100s.
There is one F-type and eight E-type nodes, each with two nVidia Tesla V100s. The CPUs are slightly different on these two.

You can request one or two GPUs by adding them as a resource request to your jobscript: 

```
# For 1 GPU
#$ -l gpu=1

# For 2 GPUs
#$ -l gpu=2
```

This will give you either type of GPU. If you need to specify one over the other, add a request for that type of node to your jobscript:

```
# request a V100 node only
#$ -ac allow=EF
```

The [GPU nodes](../Advanced_Topics/GPU_Nodes.md) page has some sample code for running GPU jobs if you need a test example.

### Tensorflow

Tensorflow is installed: type `module avail tensorflow` to see the
available versions.

Modules to load for the non-MKL GPU version: 

```
module unload compilers mpi
module load compilers/gnu/4.9.2
module load python3/recommended
module load cuda/8.0.61-patch2/gnu-4.9.2
module load cudnn/6.0/cuda-8.0
module load tensorflow/1.4.1/gpu
```

