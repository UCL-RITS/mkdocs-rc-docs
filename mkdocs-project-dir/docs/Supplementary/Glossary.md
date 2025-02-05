---
title: Research Computing Glossary
layout: definitions
---


Bash { #bash }
: A [shell](#shell) and [scripting](#script) language, which is the default
  command processor on most Linux operating systems.

Cluster { #cluster }
: A cluster consists of a set of computer [nodes](#node)
connected together over a fast local area network. A message passing
protocol such as [MPI](#mpi) allows individual nodes to
work together as a single system.

Core { #core }
: A core refers to a processing unit within a [node](#node). A node may have multiple cores which can
work in parallel on a single task, operating on the same data in
memory. This kind of parallelism is coordinated using the [OpenMP](#openmp) library. Alternatively, cores may work
independently on different tasks. Cores may or may not also share
cache.

Interconnect { #interconnect }
: The interconnect is the network which is used to transfer data
between [nodes](#node) in a [cluster](#cluster). Different types of interconnect
operate at different bandwidths and with different amounts of latency, which affects the
suitability of a collection of nodes for jobs which use message
passing ([MPI](#mpi)).

Batch Processing { #batch-processing }
: A workflow in which tasks are collected as produced, and then processed as capacity becomes
available. This usually involves ensuring that the task can be completed without user
intervention, so that the user does not have to remain present or available.

Job { #job }
: In the context of [Batch Processing](#batch-processing), a job refers to a
computational task to be performed such as a single simulation or
analysis.

Job Script { #job-script }
: A job script is essentially a special kind of [script](#script) used to specify the parameters of a job.
Users can specify the data to input, program to use, and the
computing resources required. The job script is specified when a job
is submitted to SGE, which reads lines starting with `#$`.

MPI { #mpi }
: The Message Passing Interface (MPI) system is a set of portable
libraries which can be incorporated into programs in order to
control parallel computation. Specifically it coordinates effort
between [nodes](#node) which do not share the same
memory address space cf. [OpenMP](#openmp).

Node { #node }
: In cluster computing, a node refers to a computational unit which is
capable of operating independently of other parts of the cluster. As
a minimum it consists of one (or more) processing [cores](#core), has its own memory, and runs its own
operating system.

OpenMP { #openmp }
: Open Multi-Processing. OpenMP supports multithreading, a process
whereby a master [thread](#thread) generates a number of
slave threads to run a task which is divided among them. OpenMP
applies to processes running on shared memory platforms, i.e. 
[jobs](#job) running on a single [node](#node). Hybrid applications may make use of both
OpenMP and [MPI](#mpi).

Process { #process }
: A process is a single instance of a program that is running on a
computer. A single process may consist of many [threads](#thread) acting concurrently, and there may
multiple instances of a program running as separate processes.

Script { #script }
: A [shell](#shell) script enables users to list commands
to be run consecutively by typing them into a text file instead of typing them out live. The first
line of the script uses the [shebang](#shebang) notation `#!` to designate the
scripting language interpreter program to be used to interpret the commands, e.g. [bash](#bash).

Shebang { #shebang }
: "Shebang" is a common abbreviation for "hash-bang" — the character sequence `#!` — which is placed at
the start of a [script](#script) to specify the
interpreter that should be used. When the shebang is found in the
first line of a script, the program loader reads the rest of the
line as the path to the required interpreter (e.g. `/bin/bash` is the
usual path to the [bash](#bash) shell). The specified
interpreter is then run with the path to the script passed as an
argument to it.

Shell { #shell }
: A command line interpreter which provides an interface for users to
type instructions to be interpreted by the operating system and
display output via the monitor. Users type specific shell commands
in order to run [processes](#process), e.g. `ls` to list
directory contents.

Son of Grid Engine (SGE or SoGE) { #soge }
: The queuing system used by many cluster computing systems (including, currently, all the ones we run)
to organise and schedule [jobs](#job). Once jobs are submitted to SGE, it takes
care of executing them when the required resources become available.
Job priority is subject to the local fair use policy.

Sun Grid Engine (SGE) { #sge }
: The original software written by Sun Microsystems that was later modified to
make Son of Grid Engine (among other products, like Univa Grid Engine).
Documentation may refer to Sun Grid Engine instead of Son of Grid Engine, and
for most user purposes, the terms are interchangeable.

Thread { #thread }
: A thread refers to a serial computational process which can run on a
single [core](#core). The number of threads generated by
a parallel job may exceed the number of cores available though, in
which case cores may alternate between running different threads.
Threads are a software concept whereas cores are physical hardware.

