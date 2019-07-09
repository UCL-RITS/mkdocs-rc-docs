---
title: FAQ
categories:
 - User Guide
layout: docs
---

# Frequently-Asked Questions

This page attempts to address some of the topics we most frequently
receive questions about, or to which the answers are most complex.

### Why is my job in Eqw status?

If your job goes straight into Eqw state, there was an error in your
jobscript that meant your job couldn't be started. The standard `qstat`
job information command will give you a truncated version of the error:

```
qstat -j <job_ID>
```

To see the full error instead:

```
qexplain <job_ID>
```

The `qexplain` script is part of our `userscripts` set -- if you try to use it and get
an error that it doesn't exist, load the `userscripts` module:

```
module load userscripts
```

The most common reason jobs go into this error state is that 
a file or directory your job is trying to use doesn't exist.
Creating it after the job is in the `Eqw` state won't make the job
run: it'll still have to be deleted and re-submitted.

### "Unable to determine job requirements" error

```
Unable to run job: Rejected by ucl_jsv4h Reason:Unable to determine job requirements.
Exiting.
```

The `#$` directives are missing from your script, or have extra white
space before them. This means SGE isn't picking them up and doesn't know
what resources you are requesting. Add them or remove the spaces and it
will work.

### "/bin/bash: invalid option" error

This is a sign that your jobscript is a DOS-formatted text file and not
a Unix one - the line break characters are different. Type `dos2unix
<yourscriptname>` in your terminal to convert it.

Sometimes the offending characters will be visible in the error. You can
see here it's trying to parse `^M` as an option.

### Your Scratch space goes missing

You may have accidentally deleted or replaced the link to your Scratch
space. Do an `ls -al` in your home - if set up correctly, it should look
like this:

```
lrwxrwxrwx   1 username private       24 Apr 14  2014 Scratch -> /scratch/scratch/username
```

where `username` is your UCL user ID. You can recreate the symlink with
```
ln -s /scratch/scratch/username Scratch
```

### Which MKL library files should I use to build my application?

Depending on which whether you wish to use BLAS/LAPACK/ScaLAPACK/etc...
there is a specific set of libraries that you need to pass to your
compilation command line. Fortunately, Intel have released a tool that
allows you to determine which libraries to link and in which order for a
number of compilers and operating systems:

<http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/>

See also: [MKL\_on\_Legion](MKL_on_Legion).

### SSH known\_hosts

1\. If you get a warning when connecting in via ssh, we may have updated the login nodes, and 
you probably need to delete old host keys from your `~/.ssh/known_hosts`. You can also delete
the whole file, and the `ssh` command will recreate it (asking you to check) next time you try to connect.

2\. If you look in the error file for your job, you may find a number of
errors like the one below. Please ignore these as they are the result of
compute nodes being unable to write to your home directory and do not
indicate a problem.

```
Failed to add the RSA host key for IP address '10.143.9.1' to the list of known hosts (/home/uccaoke/.ssh/known_hosts)
```

### "ssh: Unsupported option - -x" errors

These errors indicate that you are attempting to use the QLogic version
of mpirun in the OpenMPI parallel environment. It is likely you are
doing this by accident and probably intend to use the OpenMPI mpirun but
do not have your modules configured correctly.

Please add the lines below, either after default modules (defmods) are
loaded in your .bashrc, or else in your job script before mpirun: 
**Note**: the above assumes you are using the Intel
compilers.

### You get "Program not started through mpirun. Exiting..." but are using mpirun\!

This is most often caused by launching a program built with QLogic MPI
with the mpirun from another MPI implementation (e.g. OpenMPI). You can
determine which version of MPI your program was built with by running
`ldd` on the application
binary.

### You want to know where the libraries loaded via modules system are on disk

Look at the contents of the default modules to find the path to those
libraries on the current system. Look at the following command listing: 
As you can see, the modules system sets the paths to libraries in
environment variables which the system uses to locate files.

### Unable to run job: JSV stderr: perl: warning: Setting locale failed.

This error is generally because your SSH client is passing LANG through
as part of the SSH command, and is passing something that conflicts with
what Legion has it set to. You may be more likely to come across this
with newer versions of Mac OS X - if your client is different, have a
look for an equivalent option.

In Mac OS X Terminal, click Settings and under International untick the
box that says "Set locale environment variables on startup".

Per session, you can try `LANG=C ssh userid@legion.rc.ucl.ac.uk`

### Why can't I find out when my job will run?

An informative discussion on this matter can be 
found in the [Scheduler](The_Scheduler) section 
of the User Guide.

### What can I do to minimise the time I need to wait for my job(s) to run?

1.  Minimise the amount of wall clock time you request.
2.  Use job arrays instead of submitting large numbers of jobs (see our
    [job script examples](Example_Scripts)).
3.  Plan your work so that you can do other things while your jobs are
    being scheduled - the rule of thumb is that you will have to wait
    about twice the requested wall clock time (on average).

### What is my project code (short string) / project ID?

Prior to July 2014, every user had a project code. Now all users belong
to the default project "AllUsers" and no longer have to specify this. If
you see older job script examples mentioning a project ID, you can
delete that section. Only projects with access to paid or specialised
resources need to give a project code in order to use those resources.
If you do not know yours, [contact rc-support](Contact and Support).

