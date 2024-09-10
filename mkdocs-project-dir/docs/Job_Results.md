---
title: Where do my results go?
layout: docs
---

# Where do my results go?

After submitting your job, you can use the command `qstat` to view the status of all the jobs you have submitted. Once you can no longer see your job on the list, this means your job has completed. To view details on jobs that have completed, you can run `jobhist`, part of the [`userscripts`](Installed_Software_Lists/module-packages.md) module. There are various ways of monitoring the output of your job.

## Output and error files

When writing your job script you can either tell it to start in the directory you submit it from (`-cwd`), or from a particular directory (`-wd <dir>`), or from your home directory (the default). When your job runs, it will create files in this directory for the job's output and errors:

| File Name | Contents |
|:----------|:---------|
| `myscript.sh` | Your job script. |
| `myscript.sh.o12345` | Output from the job. (`stdout`) |
| `myscript.sh.e12345`  | Errors, warnings, and other messages from the job that aren't mixed into the output. (`stderr`) |
| `myscript.sh.po12345` | Output from the setup script run before a job. ("prolog") |
| `myscript.sh.pe12345` | Output from the clean-up script run after a job. ("epilog") |

Normally there should be nothing in the `.po` and `.pe` files, and that's fine. If you change the name of the job in the queue, using the `-N` option, your output and error files will use that as the filename stem instead.

Most programs will also produce *separate* output files, in a way that is particular to that program. Often these will be in the same directory, but that depends on the program and how you ran it.

## Grid Engine commands

The following commands can be used to submit and monitor a job.

### Qsub

This command submits your job to the batch queue. You can also use options on the command-line to override options you have put in your job script.

| Command | Action |
|:--------|--------|
| `qsub myscript.sh`                 | Submit the script as-is  |
| `qsub -N NewName myscript.sh`      | Submit the script but change the job's name |
| `qsub -l h_rt=24:0:0 myscript.sh`  | Submit the script but change the maximum run-time |
| `qsub -hold_jid 12345 myscript.sh` | Submit the script but make it wait for job 12345 to finish |
| `qsub -ac allow=XYZ myscript.sh`   | Submit the script but only let it run on node classes X, Y, and Z |


### Qstat 

This command shows the status of your jobs. When you run `qstat` with no options, all of your jobs currently running will be displayed. By adding in the option `-f -j <job-ID>` you will get more detail on the specified job.

### Qdel

This command deletes your job from the queue. When deleting a job will need to run `qdel <job-ID>`, however `qdel '*'` can be used to delete all jobs. To delete a batch of jobs, creating a file with the list of job IDs that you would like to delete and placing it in the following commands will delete the following jobs: `cat <filename> | xargs qdel`

## Qsub emailing
We also have a mailing system that can be implemented to send emails with reminders of the status of your job through `qsub`. In your jobscript, or when you use `qsub` to submit your job, you can use the option `-m`. You can specify when you want an email sent to you by using the below options after `qsub -m`:

|   |   |
|---|---|
| `b` | Mail is sent at the beginning of the job. |
| `e` | Mail is sent at the end of the job. |
| `a` | Mail is sent when the job is aborted or rescheduled. |
| `s` | Mail is sent when the job is suspended. |
| `n` | No mail is sent. (The default.) |

You specify where the email should be sent with `-M`.

You can use more than one of these options by putting them together after the `-m` option; for example, adding the following to your job script would mean you get an email when the job begins and when it ends:

```
#$ -m be
#$ -M me@example.com
```

Further resources can be found here:

* [Scheduler fundamentals (moodle)](https://moodle.ucl.ac.uk/mod/page/view.php?id=4845666) (UCL users)
* [Scheduler fundamentals (mediacentral)](https://mediacentral.ucl.ac.uk/Play/98368) (non-UCL users)
