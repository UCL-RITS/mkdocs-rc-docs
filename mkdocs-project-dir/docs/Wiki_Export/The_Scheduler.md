---
title: How the scheduler works
categories:
 - User Guide
layout: docs
---
One of the biggest concerns users experience when running jobs in a
scheduled environment is uncertainty over when jobs they have submitted
will run. Scheduler policies are always complex, there are many other
users on the machine and it can be extremely frustrating to see other
users' jobs running while yours remain in the queue.

Some users end up driven to spend most of their time scrutinising the
output of qstat, desperately trying to come up with a formula for job
submission that will skip them further up the queue, before sending a
somewhat grumpy ticket to the service desk to ask what is going on. Here
we will attempt to explain some of this scheduler behaviour to alleviate
some common concerns about how the system works.

## The scheduler is not a queue

The first (and most basic), thing to understand is that the system does
not operate a first in, first out queue like users might expect. In many
ways, the scheduler does not behave like a queue at all. For a start,
the scheduler is not dealing with jobs that are all the same size. Some
jobs are large parallel jobs, while other jobs are smaller or even
serial. This means that if you operate on a first come, first serve
basis, then large parallel jobs will block the execution of smaller jobs
while they wait for nodes to become free, wasting a great deal of
resource. If instead the system were to operate in such a way as to run
the next job that will fit into the available resource, then large
parallel jobs would never run at all, because the resources needed to
run on them would always be allocated to smaller jobs first. As a
result, the scheduler needs to be implemented in such a way as to
provide a balance between these behaviours. Scheduler behaviour on
Legion is further complicated by our policy of fair-share (where the
priority of heavy users is automatically lower than the priority of
light users) which is necessitated by Legion being a "free" at the point
of use resource.

What this means is that the scheduler schedules jobs based on:

1.  The matching of available resources to the job
2.  The priority of the job

Job priority is almost entirely based on three factors: fair-share
weighting, wall clock time requested and how long the job has been in
the queue (longer = higher priority).

This all seems relatively simple so far, and you might be wondering "why
can't I have a tool which will tell me when my job will run?". The
answer is simple: The time your job will run is not only affected by the
state of the queue when you submit the job, but also by any higher
priority jobs (as a result of fair-share) which are submitted after your
job is submitted.

*We have a big random number generator attached to the scheduler called
"users" who submit jobs in an unpredictable fashion with inaccurate wall
clock time estimates.*

*With fair share, you have a priority parameter that modifies constantly
the queue arrangement, depending on jobs being submitted at any given
time.*

*Any snapshot you take of the queue cannot be representative of its
overall behaviour. You have to gather statistics over time, and that is
what the
[CRAG](http://www.ucl.ac.uk/isd/about/governance/research-it/crag) does
every month.*

# User X is using most of the machine

Another common complaint (from some user we shall call "Y") comes in the
form "I'm trying to get some very important results, my jobs are in the
queue, but user X is running hundreds of cores worth of jobs on the
machine and more of their jobs are starting all of the time\!". This can
usually be explained by one of, or a combination of, these two
possibilities:

1.  User Y's jobs are hard to schedule (this usually means large
    parallel jobs), whereas user X's jobs fit into the gaps between
    other jobs.
2.  User X's jobs have been in the queue for a very long time and
    therefore have an unusually high priority due to wait time. This
    behaviour is camouflaged somewhat by the qstat command because it
    uses one field for job submission/job start time and so when the job
    starts, it displays the start time rather than the submission time.

This can give other users the impression that user X is getting unfair
access to the resource (often made worse if user X is submitting large
arrays of single processor jobs) but should be clear that if the cause
is a) the scheduler is merely being efficient, and if it is b) it is
being fair.

## Cores \!= Slots

Another confusion that can arise is in utilisation of the machine. It
may seem obvious to the user that the number of cores in use is the sum
of the number of slots requested by jobs in the "running" state, but
this is NOT the case. This confusion can lead to tickets of the form
"half the cluster is not in use but my jobs still aren’t running\!".

The reason this is the case is as follows:

1.  If a user requests more RAM per process than is available per core
    on the node type their job runs on, then they will be consuming
    additional cores which are not reflected in the number of slots they
    have requested. This problem is made considerably worse by users
    over-estimating the amount of RAM that their job needs.

Doing a naïve count of the number of slots in use will give a user the
impression that the machine is under-used.

