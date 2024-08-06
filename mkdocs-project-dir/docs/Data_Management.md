---
title: Data Management
categories:
- User Guide
layout: docs
---

# Data Management

## On-cluster storage

Our clusters have local parallel filesystems consisting of your home and Scratch directories where you 
can write data. These are "close to" the compute, connected to it with a fast network.

### Home

Every user has a home directory. This is the directory you are in when you first log in.

- Location: `/home/<username>`
- May also be referred to as: `~`, `$HOME`.

Many programs will write hidden config files in here, with names beginning with `.` (eg `.config`, 
`.cache`). You can see these with `ls -al`.

### Scratch

Every user also has a Scratch directory. It is intended that this is a larger space to keep your working 
files as you do your research, but should not be relied on for secure long-term permanent storage. 

Important data should be regularly backed up to another location.

- Location: `/scratch/scratch/<username>`
- Also at: `/home/<username>/Scratch` (a shortcut or symbolic link to the first location).


## Parallel filesystems

Parallel filesystems are designed to be able to deal with being written to by many users' jobs at once. 
To do this they store the files in a distributed fashion across many servers and disks and have 
metadata servers to keep track of this. This can cause access to individual files to be slower 
than on your local computer, especially if you have an SSD.

### Working effectively with parallel filesystems

Parallel filesystems do not deal well with directories full of very many small files. Running 
a `ls` command to list the contents of such a directory can take a notably long time to show results 
because it has to look up the metadata for everything in there. This will affect anything that is trying
to use files in that directory, including your jobs and any moving, deleting or copying files you may 
be doing to tidy it up.

Parallel filesystems perform better when accessing single large files instead. 

Parallel filesystems will also begin to perform less well as they get fuller. On ours, 75% full is a 
danger point where performance will be significantly impacted. To allow everyone's jobs to keep working 
as intended, we need to keep filesystem usage below that point.

Tips for use:

- Use different directories for different jobs. Do not write everything to the same place.
- If you are on a cluster with disks for local temporary storage on the nodes (`$TMPDIR`) then your
  jobs can write temporary data there, faster, and you can decide what you need to keep and copy back
  to Scratch at the end.
- Clear up Scratch after your jobs. Keep the files you need, archive or delete the ones you do not.
- Archive and compress directory trees you aren't currently using. (`tar` command for example). This
  stores all their contents as one file, and compressing it saves space.
- Back up your important data to somewhere off the cluster regularly. 
- If you haven't used particular files for some months and do not expect to in the near future, keep
  them off-cluster and delete the copies on the cluster.
- If you are no longer using a cluster, remove your data to maintain filesystem performance and allow
  the space to be used by current active users.
- Before you leave UCL, please consider what should happen to your data, and take steps to put it in
  a Research Data archive and/or ensure that your colleagues are given access to it.
  

## Filesystem retirement

When filesystems or clusters are retired, they will eventually be decommissioned and we will not retain 
the data left on them. Barring unforeseen circumstances, you will receive plenty of notice before this 
happens.


## Giving files to another user

If both users are active and on the same cluster, you can give files to them. 
[Walkthrough: Giving Files to Another User](Walkthroughs/Giving_Files.md)

## Transferring data ownership

### Requesting transfer of your data to another user

If you want to transfer ownership of all your data on a service to another user, with their consent, 
you can contact us at rc-support@ucl.ac.uk and ask us to do this. Please arrange this while you still 
have access to the institutional credentials associated with the account. Without this, we cannot 
identify you as the owner of the account. 

You will need to tell us what data to transfer, on what cluster, and the username of the recipient.

### Requesting data belonging to a user who has left

If a researcher you were working with has left and has not transferred their data to you before 
leaving there is a general UCL Data Protection process to gain access to that data.

At [UCL Information Security Policy](https://www.ucl.ac.uk/information-security/information-security-policy) 
go to Monitoring Forms and take a copy of Form MO2 "Form MO2 - Request for Access to Stored Documents 
and Email - long-term absence or staff have left". (Note, it is also applicable to students). 

Follow the guidance on that page for how to encrypt the form when sending it to them. The form needs 
to be signed by the head of department/division and the UCL data protection officer 
(data-protection@ucl.ac.uk).
