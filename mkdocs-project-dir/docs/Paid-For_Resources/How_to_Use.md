---
title: How to Use
layout: docs
---

# Using Paid-For Resources

Paid resources may be in the form of priority access (Gold), dedicated nodes
or both.

Users with access to Gold have tools for monitoring budgets and usage.

Users with access to dedicated nodes have a tool for monitoring current use of 
their nodes.

## Why we recommend priority access

We recommend priority access via Gold rather than dedicated nodes in most
circumstances because:

 * The amount of Gold you get is equivalent to the core hours if you ran your node 
   at 100% utilisation throughout its 3-year lifespan.
 * If you have a dedicated node and aren't currently running anything on it, it is 
   idle and you cannot recover that time (and it still uses power and incurs 
   hosting costs).
 * If you aren't currently using your Gold, you have 3 months (or your chosen 
   allocation period length) to recover that time and use it.

## Priority access via Gold

If you have priority access, this is managed by a resource called Gold.
Gold is divided into allocations, which have start and end dates and a
given amount of Gold associated with them. Any unused Gold expires after
the allocation period ends.

On Myriad, one Gold = one core hour. If you run a job that asks for a
wallclock time of 3hrs and 10 cores, then the job costs 30 Gold.

Gold is reserved when you submit a job, so the entire 30 will be reserved 
and taken away from the available balance when you run `qsub`. After the 
job ends, how long it ran for is checked, and any unused Gold is put back
for anyone to use. 

For example, you asked for 3 hours and 20 cores, but your job finished 
in 2 hours. When you submit the job, it will reserve 30 Gold and your
budget will go down by 30. When it ends, the final charge is only 20 Gold,
so 10 Gold gets put back in your available budget.

### View your Gold budgets

To see the Gold budgets available to you, run:
```
budgets
```

You will see something like this:
```
Project    Machines  Balance
---------  --------  -----------
hpc.999     ANY       124560.00
hpc.998     ANY       0.00
```

The project column shows which budgets you have access to and the balance
shows how much is left unused in the current allocation.

### Jobscript additions for Gold jobs

You choose whether you want a specific job to be a Gold job or a normal
priority job. For a Gold job, add these to your jobscript:
```
#$ -P Gold
#$ -A hpc.xx
```

You can also pass these in on the command line to the `qsub` and `qrsh` commands: 
```
qsub -P Gold -A hpc.xx myscript.sh
```

### Viewing allocation dates

You can look at all the start and end dates for your allocations:
```
glsalloc -p hpc.xx
```

Output will look like this:
```
Id  Account Projects StartTime  EndTime    Amount    Deposited Description    
--- ------- -------- ---------- ---------- --------- --------- -------------- 
001 01      hpc.999  -infinity  infinity        0.00      0.00 Auto-Generated 
002 01      hpc.999  2021-12-01 2022-03-01 105124.00 205124.00                
003 01      hpc.999  2022-03-01 2022-06-01 205124.00 205124.00                
004 01      hpc.999  2022-06-01 2022-09-01 205124.00 205124.00 
```
Allocations begin and end at approximately 00:05 on the date mentioned.

 - 'Deposited' is the total amount this allocation had to begin with.
 - 'Amount' is the amount it has left just now.

### Monitoring Gold usage

You can view some information about when your Gold was used, in which jobs,
 and by whom.

```
# show help
gstatement --man

# show statement between the given dates
gstatement -p hpc.xx -s 2020-12-01 -e 2021-12-01

# give a summary between the given dates
gstatement -p hpc.xx -s 2020-12-01 -e 2021-12-01 --summarize
```

## Dedicated nodes

For dedicated nodes, only members of your project are allowed to run jobs 
on your node. Your project is usually set by default so you do not
need to specify it in your jobscript. You can check this by looking at
`qstat -j $JOB_ID` for an existing job ID, and looking at the `project`
line near the bottom.

### Jobscript additions for dedicated nodes

If the project is not being set by default, for a job to be eligible to run on
your nodes you will need to specify your project in your jobscript:

```
# Specify project
#$ -P <project>
```

This will allow a job to run on your nodes, but it can also be scheduled
on general-use nodes if some are available first. This should be the
main way you run jobs.

If you need to, you can force jobs to run on your nodes only. This is
suitable when you have arranged policies on your nodes that are
different from the normal policies (eg. a longer maximum wallclock time),
as it means your policies will be in effect instead of the general policies.

```
# Specify paid flag to force running on paid nodes only, with your policies
#$ -l paid=1
```

### Check what is running on your nodes

We have a script named `whatsonmynode`, that runs `qhost -j` for all the
nodes belonging to your project, so you can see which nodes you have,
what is running on them and from which user.

```
module load userscripts
whatsonmynode <project>
```

