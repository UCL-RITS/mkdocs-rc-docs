---
title: Cluster Computing
categories:
 - User Guide
 - Background Info
 - Legion
 - Myriad
 - Grace
layout: docs
---
# Cluster Computing at UCL

UCL has a number of centrally-funded compute cluster facilities
available, aimed at supporting all types of research at UCL.

  - [Legion](Legion), a mixed-use cluster hosted in UCL's
    Bloomsbury datacentres.
  - [Myriad](Myriad), another mixed-use cluster hosted in UCL's
    portion of the Virtus datacentre in Slough.
  - [Grace](Grace), a cluster designed for medium-scale
    parallel workloads, hosted in UCL's portion of the Virtus
    datacentre in Slough.

## What is a cluster?

A cluster is a large array of PCs or servers, referred to as *nodes*,
networked together and often with a shared filesystem.

Commonly in a shared cluster facility, a *scheduler* is used to take
work from users and assign it to servers or groups of servers to be run
as discrete *jobs*.

Jobs can use more than one core or even more than one node
simultaneously, communicating over special, faster types of network
where available, to allow many cores to divide up the work.

## So is this the same thing as a supercomputer?

Sort of. The term "supercomputer" nowadays usually refers to a large
cluster designed to be able to run a single job in parallel over the
whole machine, with an extremely fast network. In the past it was
used as a catch-all term for a lot of computing installations more
architecturally complex and power-hungry than an ordinary desktop
computer or server.

## Why would a user choose to use a cluster?

Clusters allow the use of many nodes simultaneously, without the user
having to be present or to have a laptop or desktop computer in their
office running all the time.

This means that users can both run large parallel jobs and large numbers
of serial jobs providing them with the ability to run jobs they cannot
run locally, or get through work-loads that would be impractical on
local resources.

The clusters also have some nodes with more specialist hardware and some
with extremely large quantities of RAM, allowing jobs that would be
completely impossible on ordinary office machines.

## When should you not use a cluster?

The vast majority of clusters run the Linux operating system rather than
Windows. The central UCL clusters only run Linux, so if your
applications only run on Windows, this service is not suitable for you.

The available clusters are currently only x86\_64-based (a.k.a. amd64,
em64t), so if you need an alternative processor architecture (such as
ARM or POWER), these are not suitable.

Also, as these clusters are largely designed for work structured around
using scripts, if your applications require you to enter commands while
they're running, you will not be able to make full use of the service.
(Some applications often look like they do but don't in practice,
contact us if you're not sure.)

## What if I need more compute time/longer jobs/more storage?

We recognise that researchers may sometimes require resources than the
basic all-purpose allocation. Options for acquiring additional resources
on a short or long term basis are described on the 
[Additional Resource Requests](Additional_Resource_Requests) page.

## Do I have to pay for any of this?

The central UCL clusters are free at point of use for UCL researchers --
you don't pay for the compute time or storage you use.

Other compute resources you may have to pay for.

## How do I get help?

Any questions about the central UCL clusters should go to the Research
Computing Support Team at <rc-support@ucl.ac.uk>.

The team will respond to your question as quickly as possible, giving
priority to requests that are deemed urgent on the basis of the
information provided. Available 9:30am to 4:30pm, Monday to Friday,
except on Bank Holidays and College Closures. We aim to provide you with
a useful response within 24 hours.

Please do not email individuals unless you are explicitly asked to do
so; always use the rc-support email address provided.

## What if I need something totally different?

Let us know your requirements and we may be able to suggest alternative
computing facilities that you may be eligible to use. It will also allow
us to take your needs into consideration for future acquisitions.

