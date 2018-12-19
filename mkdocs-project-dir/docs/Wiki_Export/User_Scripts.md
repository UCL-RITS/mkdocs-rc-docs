---
title: User Scripts
categories:
 - Software
 - User Guide
layout: docs
---
These are tools developed by either the Research Computing group or
users of the services, which may be useful to others. If you have a tool
which you think might be useful to others, please feel free to send it
to <rc-support@ucl.ac.uk>. If we think it's appropriate, we'll give it a
look over and possibly some polish, and add it to the list.

These tools tend to be created for Legion in the first instance, so they
may not all be appropriate on other systems.

These are located in: 

```
/shared/ucl/apps/userscripts
```

or can be used by loading the userscripts module:

```
module load userscripts
```

You should be able to obtain more information about 
these scripts by typing the name of the script followed by `--help`, for
example: `qexplain --help`

| Script   | Description |
|:--------:|:----|
| qexplain | Prints the full error associated with a job in an error state. |
| jobhist  | Shows recently finished jobs, along with when they finished and, optionally, other information about them. Displays the last 24 hours by default. |
| nodesforjob | Shows all the nodes that a currently-running job is running on, along with information on load, memory and swap being used. |
| nodetypes | Show a list of currently-available node types, including the number of cores and amount of RAM they have. (Nodes that are down will not be counted, so the numbers will fluctuate). |
| to-grace, to-legion | Copy files from Legion to Grace or vice versa. Uses login05 as the destination if copying to Legion. It will tar up the file/directory you give it, copy it to your home on the other machine and untar it again. |

