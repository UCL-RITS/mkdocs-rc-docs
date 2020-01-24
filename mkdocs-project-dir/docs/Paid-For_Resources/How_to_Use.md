---
title: How to Use
layout: docs
---

# Using Paid-For Resources

Users with access to paid resources have some extra flags and a tool for
monitoring their nodes.

## Job Script Additions

For a job to be eligible to run on your nodes, you will need to specify
your project in your jobscript:

```
# Specify project
#$ -P <project>
```

This will allow a job to run on your nodes, but it can also be scheduled
on general-use nodes if some are available first. This should be the
main way you run jobs.

If you need to, you can force jobs to run on your nodes only. This is
suitable when you have arranged policies on your nodes that are
different from the normal policies, as it allows you to override
them.

```
# Specify paid flag to force running on your nodes only, with your policies
#$ -l paid=1
```

## Check what is running on your nodes

We have a script named `whatsonmynode`, that runs `qhost -j` for all the
nodes belonging to your project, so you can see which nodes you have,
what is running on them and from which user.

```
module load userscripts
whatsonmynode <project>
```

## Backfill

In our usual arrangement, paid-for nodes become available for short jobs from
other users when you have not been using them. The policy is set by the
CRAG: this is the current policy as of November 2015.

  - When you have not run a job on an individual node for 48hrs, then it
    becomes available for general use jobs of up to 12hrs.
  - When you submit a new job, the queues will not allow any other
    general use jobs on to your nodes, but the ones currently running
    will complete.

The maximum wait time for your job is hence 12hrs.

Other options may be discussed at time of purchase if this is not
suitable.
