---
title: Connecting to the Research Data Storage Service
categories:
 - Myriad
layout: docs
---
The [Research Data Storage Service](https://www.ucl.ac.uk/advanced-research-computing/platforms-and-services/research-data-storage-service)
(RDSS) is a system run by the Research Data group in the Advanced Research
Computing department, and is designed to help with data storage
during and after a project. Several solutions for copying data between
RDSS and the central UCL research computing platforms are presented below.
Sections of the example code surrounded by angle brackets (\<\>) should 
be replaced by the information indicated (do not keep the angle brackets in).

## Between Myriad and RDSS

If you already have an account with the Research Data Storage Service, you can
transfer data directly between Legion and Research Data Storage using
the Secure Copy (`scp`) command.

### From RDS to Myriad

If you are on an RDSS login node, you can transfer data to
Myriad’s Scratch area at the highest rate currently possible by running
the command: 

```
scp data_file.tgz myriad.rc.ucl.ac.uk:~/Scratch/
```

Or from somewhere within Myriad (including compute nodes in
running jobs) running the command: 

```
scp ssh.rd.ucl.ac.uk:~/data_file.tgz ~/Scratch/
```

### From Myriad to RDSS

From Myriad, send data to your project space on RDSS by running the
command:

```
scp data_file.tgz ccaaxyz@ssh.rd.ucl.ac.uk:<path_to_project_space>
``` 

The RDSS support pages provide more
information:

<https://www.ucl.ac.uk/advanced-research-computing/rdss-myriad-data-storage-transfer-service>

