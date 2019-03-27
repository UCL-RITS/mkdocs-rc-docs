---
title: Myriad
layout: cluster
---
# Myriad

Myriad is designed for high I/O, high throughput jobs that will run
within a single node rather than multi-node parallel jobs.

## Accounts

Everyone who [signs up for a Research Computing account](Account_Services.md) gets access to Myriad.

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
instructions for [accessing services from outside UCL](Accessing_RC_Systems.md).

### Logging in to a specific node

You can access a specific Myriad login node with: 

```
ssh uccaxxx@login12.myriad.rc.ucl.ac.uk
ssh uccaxxx@login13.myriad.rc.ucl.ac.uk
```

The main address will redirect you on to either one of them.

## Copying data onto Myriad

You will need to use an SCP or SFTP client to copy data onto Myriad.
Please refer to the page on [Managing Data on RC Systems](Managing_Data.md).

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
LUSTRE SCRATCH USAGE/QUOTA
 userid        quota        usage      percent       Filesystem
uccaxxx        150GB          0GB        0.00% /home/uccaxxx
uccaxxx       1024GB          0GB        0.00% /scratch/scratch/uccaxxx
```

You can apply for quota increases using the form at [Additional Resource Requests](Additional_Resource_Requests.md).

Here are some tips for [managing your quota](Managing_Data_on_RC_Systems#Managing_your_quota) and
finding where space is being used.

## Job sizes

| Cores   | Max wallclock |
| ------- | ------------- |
| 1       | 72hrs         |
| 2 to 36 | 48hrs         |

[Interactive jobs](Interactive_Jobs.md) run with `qrsh` have a
maximum wallclock time of 2 hours.

## Node types

Myriad contains three node types: standard compute nodes, high memory
nodes and GPU nodes.

| Type | Cores per node | RAM per node | Nodes |
| ---- | -------------- | ------------ | ----- |
| H    | 36             | 192GB        | 48    |
| I    | 36             | 1.5TB        | 2     |
| J    | 36 + 2 GPUs    | 192GB        | 2     |

You can tell the type of a node by its name: type H nodes are named
`node-h00a-001` etc.

## GPUs

Myriad has two GPU nodes, each with two nVidia Tesla P100s.

You can request one or two GPUs by adding them as a resource request to your jobscript: 

```
# For 1 GPU
#$ -l gpu=1

# For 2 GPUs
#$ -l gpu=2
```

The [GPU nodes](GPU_Nodes.md) page has some sample code for running GPU jobs if you need a test example.

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

