---
title: Cluster Computing
categories:
 - User Guide
 - Background
layout: docs
---

# Cluster Computing

## What is a cluster?

In this context, a cluster is a collection of computers (often referred to as "nodes"). 
They're networked together with some shared storage and a scheduling system that lets people 
run programs on them without having to enter commands "live".

## Why would I want to use one?

Some researchers have programs that require a lot of compute power, like simulating weather patterns or the quantum behaviour of molecules.

Others have a lot of data to process, or need to simulate a lot of things at once, like simulating the spread of disease or assembling parts of DNA into a genome.

Often these kinds of work are either impossible or would take far too long to do on a desktop or laptop computer, as well as making the computer unavailable to do everyday tasks like writing documents or reading papers.

## How do I use it?

Most people use something like the following workflow:

 - connect to the cluster's "login nodes"
 - create a script of commands to run programs
 - submit the script to the scheduler
 - wait for the scheduler to find available "compute nodes" and run the script
 - look at the results in the files the script created

Most people connect using a program called a Secure Shell Client ("ssh client" for short), but some
programs, like Matlab and Comsol, run on your own computer and can be set up to send work to the cluster automatically. 
That can be a little tricky to get working, though.

The ssh client gives you a command prompt when you can enter text commands, but you can also tell it to 
pass graphical windows through the network connection, using a system called X-Forwarding.
This can be useful for visualising your data without transferring all the files back, but the network
 connection makes it a bit slower to use than running it on your own computer.
You'll need an X server on your own computer to use this: check [our page on X-Forwarding](Wiki_Export/X-Forwarding.md) for details.


