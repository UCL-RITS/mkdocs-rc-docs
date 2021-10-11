---
layout: docs
---

# Status of machines

This page outlines that status of each of the machines managed by the Research Computing team at UCL. We endeavour to keep this page as up-to-date as possible but there might be some delay. Also there are spontaneous errors that we have to deal with (i.e. high load on login nodes) but feel free to report them to rc-support@ucl.ac.uk. Finally, details of our planned outages can be found [here](https://www.rc.ucl.ac.uk/docs/Planned_Outages/).  

### Myriad

- We are working to add new hardware to alleviate some of the load issues but this will take time to implement and test.

- 2021-10-11 11:32 - One of the OSTs stopped working over the weekend which lead to login issues and the queue being suspended. The queue has been renabled and users should be able to login and run jobs though thesystem should still be considered at risk. There is a planned outage tomorrow (2021-10-12) so that we can diagnose the problem, we are sorry for the disruption thishas caused.
- 2021-09-27 10:20 - We think that one of the OSTs (Object Storage Target) in Myriad is bad rather than overloaded as everything accessing it is very slow. We are going to move all files on it elsewhere. Since most files are already elsewhere, we're going to do this migration live while jobs are running. Jobs were re-enabled.

- 2021-09-29 7:00 - Filesystem issue occurred late last night. New jobs currently prevented from running. Outage likely to be required for full recovery process.

- 2021-09-30 10:00 - We need to run a full filesystem check on Myriad's storage, to rule out filesystem corruption as the root cause of the performance problem or a contributing factor. As this is likely to take a few days we have decided to start immediately. New jobs have already been stopped from running, and unfortunately some long running jobs have had to be killed.
 
- 2021-10-04 13:00 - Jobs were re-enabled on Myriad. 

Unfortunately, it will be necessary to take Myriad out of service again next Tuesday, the 12th October. This is our next scheduled monthly maintenance day, when all research computing services are at risk. We will carry out load tests on Myriad's filesystem, to avoid performance problems when the planned expansion of the cluster goes ahead. Access to the login nodes will be blocked during the load testing work, which is expected to be finished by the end of the day.
 
We apologise for any inconvenience this work may cause, and we hope you understand the cautious approach we are taking with Myriad's filesystem after all the recent problems.

### Kathleen

- All systems are working well.

### Young

- 2021-09-24 16:00 - Jobs were re-enabled but we are encountering a ZFS bug that causes a metadata server to reboot or crash and the filesystem hangs until it recovers. This is causing periodic file access slowness and login failures during the recovery periods. Patching of ZFS is being planned.

- 2021-09-29 15:20 - Queues being drained of jobs so that ZFS upgrade can take place on Thurs 30 Sept. This should fix the above bug.

- 2021-10-04 15:00 - The ZFS upgrade was more complicated than originally thought. We currently expect Young to be back in service midday on Tues 5 Oct.

- 2021-10-05 12:00 - Upgrade completed. Jobs were re-enabled on Young.

- There are a small number of nodes that switch themselves off and need to be manually re-booted (this causes jobs to be stuck in `dr` state when they end until the reboot happens).

### Michael

- All systems are working well.

### Thomas

- System is generally fine but the hardware is dated with respect to the other systems so there may be some read write errors.


