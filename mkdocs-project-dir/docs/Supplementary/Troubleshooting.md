---
title: Troubleshooting
categories:
 - User Guide
layout: docs
---

# Troubleshooting

This page lists some common problems encountered by users, with methods to investigate or solve them.

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


### "/bin/bash: invalid option" error

This is a sign that your jobscript is a DOS-formatted text file and not
a Unix one - the line break characters are different. Type `dos2unix
<yourscriptname>` in your terminal to convert it.

Sometimes the offending characters will be visible in the error. You can
see here it's trying to parse `^M` as an option.

### I think I deleted my Scratch space, how do I restore it?

You may have accidentally deleted or replaced the link to your Scratch
space. Do an `ls -al` in your home - if set up correctly, it should look
like this:

```
lrwxrwxrwx   1 username group       24 Apr 14  2022 Scratch -> /scratch/scratch/username
```

where `username` is your UCL user ID and `group` is your primary group. 

If this link is not present, you can recreate it with

```
ln -s /scratch/scratch/$(whoami) Scratch
```

If you have actually deleted the files stored in your Scratch space, there is unfortunately no way to restore them.

### Which MKL library files should I use to build my application?

Depending on which whether you wish to use BLAS/LAPACK/ScaLAPACK/etc...
there is a specific set of libraries that you need to pass to your
compilation command line. Fortunately, Intel have released a tool that
allows you to determine which libraries to link and in which order for a
number of compilers and operating systems:

<http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/>


### Unable to run job: JSV stderr: perl: warning: Setting locale failed.

This error is generally because your SSH client is passing LANG through
as part of the SSH command, and is passing something that conflicts with
what Myriad has it set to. You may be more likely to come across this
with newer versions of macOS - if your client is different, have a
look for an equivalent option.

In Mac OS X Terminal, click Settings and under International untick the
box that says "Set locale environment variables on startup".

Per session, you can try `LANG=C ssh userid@myriad.rc.ucl.ac.uk`

### What can I do to minimise the time I need to wait for my job(s) to run?

1.  Minimise the amount of wall clock time you request.
2.  Use job arrays instead of submitting large numbers of jobs (see our
    [job script examples](Example_Scripts)).
3.  Plan your work so that you can do other things while your jobs are
    being scheduled.

### What is my project code (short string) / project ID?

Prior to July 2014, every user had a project code. Now all users belong
to the default project "AllUsers" and no longer have to specify this. If
you see older job script examples mentioning a project ID, you can
delete that section. Only projects with access to paid or specialised
resources need to give a project code in order to use those resources.
If you do not know yours, [contact rc-support](Contact and Support).

