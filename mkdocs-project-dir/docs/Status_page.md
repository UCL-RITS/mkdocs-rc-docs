---
layout: docs
---

# Status of machines

This page outlines that status of each of the machines managed by the Research Computing team at UCL. We endeavour to keep this page as up-to-date as possible but there might be some delay. Also there are spontaneous errors that we have to deal with (i.e. high load on login nodes) but feel free to report them to rc-support@ucl.ac.uk. Finally, details of our planned outages can be found [here](https://www.rc.ucl.ac.uk/docs/Planned_Outages/).  

Myriad:

- We are working to add new hardware to alleviate some of the load issues but this will take time to implement and test.

- 2021-09-27 10:20 - We think that one of the OSTs (Object Storage Target) in Myriad is bad rather than overloaded as everything accessing it is very slow. We are going to move all files on it elsewhere. Since most files are already elsewhere, we're going to do this migration live while jobs are running. Jobs were re-enabled.

- If you see any errors when trying to run centrally-installed software which say `Text file busy` please report these to us as this is a file-locking issue after an earlier data migration. 

Kathleen:

- All systems are working well.

Young:

- 2021-09-24 16:00 - Jobs were re-enabled but we are encountering a ZFS bug that causes a metadata server to reboot or crash and the filesystem hangs until it recovers. This is causing periodic file access slowness and login failures during the recovery periods. Patching of ZFS is being planned.

- 2021-09-28 16:40 - Metadata server failing to recover again. New jobs are being prevented from running to give the filesystem a chance to catch up. Will revisit on morning of Weds 29. ZFS upgrade still planned.

- There are a small number of nodes that switch themselves off and need to be manually re-booted (this causes jobs to be stuck in `dr` state when they end until the reboot happens).

Michael:

- All systems are working well.

Thomas:

- System is generally fine but the hardware is dated with respect to the other systems so there may be some read write errors.


