---
layout: docs
---

# Quick Start Guide for Experienced HPC Users

## What Services are available?

### UCL
 * Grace/Kathleen - HPC, large parallel MPI jobs.
 * Myriad - High Throughput, GPU or large memory jobs.

### External
 * Thomas - MMM Hub Tier 2
 * Michael - Faraday Institution Tier 2


## How do I get access?

UCL services: Fill in the [Sign-up Form](Account_Services)

Tier 2 services: Contact your point of contact.

## How do I connect?

All connections are via SSH, and you use your UCL credentials to log in (external users will should use the `mmmXXXX` account with the SSH key they have provided to their point of contact),  UCL services can only be connected to by users inside the UCL network which may mean using the institutional VPN or "bouncing" off another UCL machine when [accessing them from outside the UCL network](howto#Logging-in-from-outside-the-UCL-firewall).  

### Login hosts

|Service | General alias          | Direct login node addresses                                   |
|--------|------------------------|---------------------------------------------------------------|
|Grace   | `grace.rc.ucl.ac.uk`   | `login01.ext.grace.ucl.ac.uk login02.ext.grace.ucl.ac.uk`     |
|Kathleen| `kathleen.rc.ucl.ac.uk`| `login01.kathleen.rc.ucl.ac.uk login02.kathleen.rc.ucl.ac.uk` |
|Myriad  | `myriad.rc.ucl.ac.uk`  | `login12.myriad.rc.ucl.ac.uk login13.myriad.rc.ucl.ac.uk`     |
|Thomas  | `thomas.rc.ucl.ac.uk`  | `login03.thomas.rc.ucl.ac.uk login04.thomas.rc.ucl.ac.uk`     |
|Michael | `michael.rc.ucl.ac.uk` | `login10.michael.rc.ucl.ac.uk login11.michael.rc.ucl.ac.uk `  |

Generally you should connect to the general alias as this is load-balanced across the available login nodes, however if you use `screen` or `tmux` you will want to use the direct hostname so that you can reconnect to your session.

## Software stack

All UCL services use the same software stack based upon RHEL 7.x with a standardised set of packages, exposed to the user through environment modules (the `module` command).  By default this has a set of useful tools loaded, as well as the Intel compilers and MPI but users are free to change their own environment.

## Batch System

UCL services use Grid Engine to manage jobs.  This install is somewhat customised and so scripts for non-UCL services *may not work*.

We recommend that when launching MPI jobs you use our `gerun` parallel launcher which inherits settings from the job and launches the appropriate number of processes with the MPI implementation you have chosen.