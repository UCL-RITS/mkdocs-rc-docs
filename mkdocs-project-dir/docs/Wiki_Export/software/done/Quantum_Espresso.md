---
title: Quantum Espresso
categories:
 - Bash script pages
layout: docs
---

# Quantum Espresso

If you're already acquainted with Quantum Espresso, running it on Legion
should be relatively straightforward. The script below demonstrates how
to run `pw.x`, but should be adaptable to any of the other binaries.

We have attempted to compile all the relevant components of Quantum
Espresso, but if there's a particular component missing in our build
that you need, let us know and we'll try to add it. (There are a lot of
bits.)

This script assumes that you are somewhere in the Scratch area already
-- it doesn't change directory, so if you attempt to run it from
somewhere in the normal home directories, the job will go into the Eqw
state with an error saying that the space isn't writable. Simply submit
the script from the same directory as your Quantum Espresso input files,
and change the input and output file names if necessary. You'll also
need to change the project name to your project (and take out the \<\>
brackets).

```
#!/bin/bash -l

# 1. Force bash as the executing shell.
#$ -S /bin/bash

# 2. Request thirty minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=0:30:0

# 3. Request 1 gigabyte of RAM per core.
#$ -l mem=1G

# 4. Set the name of the job.
#$ -N QE

# 5. Select the QLogic parallel environment (qlc) and 16 cores.
#$ -pe qlc 16

# 6. Select the project that this job will run under.
#$ -P <your project>

# 7. Set the working directory to the current working directory when the job is submitted. 
#$ -cwd 

# The autoload module unloads and loads all the required modules.
# Careful when using this with any other modules.
# Take a look at what it's doing with 'module show quantumespresso/5.0.2/autoload' if you're not sure.
module load quantumespresso/5.0.2/autoload

# Set the path here to where ever you keep your pseudopotentials.
export ESPRESSO_PSEUDO=$HOME/qe-psp


# Note - the -in argument here for input files avoids any problems with 
#   redirection to MPI applications that can arise.

gerun pw.x -in input.in >output.out
```
