---
title: Aristotle
categories:
 - Aristotle
layout: docs
---

## Overview

Aristotle is a stop-gap interactive service for teaching running on a
pair of nodes of the same specification as [Legion's U-type nodes](Legion#Hardware), each with 64 gigabytes of RAM and 16
cores. The machines run [RHEL 7](https://en.wikipedia.org/wiki/Red_Hat_Enterprise_Linux)
and have a subset of the RCPS software
stack available. The main aim of this service is to allow specific
teaching courses to run that need to run Unix applications and have
outgrown the Socrates service.

## Access

Anyone with a UCL userid and within the UCL institutional firewall can
access Aristotle by connecting via ssh to:

```
aristotle.rc.ucl.ac.uk
```

This address can point to more than one actual server (via DNS
round-robin); usually there are two available. To connect to a specific
server from the set, you will need to know its number: for example, the
second server has the address `aristotle02.rc.ucl.ac.uk`. When you
connect, you should be shown which one you are connected to on your
command line.

The userid and password you need to connect with are those provided to
you by [Information Services Division](http://ucl.ac.uk/isd).

If you experience difficulties with your login, please make sure that
you are typing your UCL user ID and your password correctly. If you
still cannot get access, please contact us at <rc-support@ucl.ac.uk>.

If you are outside the UCL firewall, you will need to connect to
Socrates first, [as with our main UCL clusters](Accessing Clusters from Outside UCL).

## User Environment

Aristotle runs Red Hat Enterprise Linux 7 and NFS mounts the [RCPS
Software Stack](RCPS_Software). As this machine is intended
for teaching, work has focused on getting specific applications required
for specific courses to work and these are:

  - SAC
  - Phon
  - GMT
  - Fortran compilers (of which there are a large variety)

Packages are available through modules and users should consult the
relevant [modules documentation](Modules).
