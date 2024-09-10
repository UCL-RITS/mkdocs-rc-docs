---
title: Parallel Filesystems
categories:
 - User Guide
 - Background
layout: docs
---

# Parallel Filesystems

## What is different about parallel filesystems?

Parallel filesystems are designed to be able to deal with being written to by many users' jobs at once.
To do this they store the files in a distributed fashion across many servers and disks and have
metadata servers to keep track of this. This can cause access to individual files to be slower
than on your local computer, especially if you have an SSD.

## Working effectively with parallel filesystems

Parallel filesystems do not deal well with directories full of very many small files. Running
a `ls` command to list the contents of such a directory can take a notably long time to show results
because it has to look up the metadata for everything in there. This will affect anything that is trying
to use files in that directory, including your jobs and any moving, deleting or copying files you may
be doing to tidy it up.

Parallel filesystems perform better when accessing single large files instead.

Parallel filesystems will also begin to perform less well as they get fuller. On our Lustre filesystems, 
75% full is a danger point where performance will be significantly impacted. To allow everyone's jobs 
to keep working as intended, we need to keep filesystem usage below that point.

## Tips for use

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

## What filesystems are available?

See [Data Storage](Data_Storage.md).
