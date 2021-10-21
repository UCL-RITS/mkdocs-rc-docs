---
layout: docs
---

# Status of machines

This page outlines that status of each of the machines managed by the Research Computing team at UCL. We endeavour to keep this page as up-to-date as possible but there might be some delay. Also there are spontaneous errors that we have to deal with (i.e. high load on login nodes) but feel free to report them to rc-support@ucl.ac.uk. Finally, details of our planned outages can be found [here](https://www.rc.ucl.ac.uk/docs/Planned_Outages/).  

### Myriad

- 2021-10-12 17:25 - As part of our scheduled outage, we did some load testing on Myriad and believe that we have identified the root cause of all the recent issues with the filesystem to be related to the Mellanox Infiniband interconnect throwing connection errors, specifically failures of network links causing credit loops. These network failures were in turn causing Lustre to crash. 

- 2021-10-14 16:00 - Remedial work on the Infiniband network was completed, jobs re-enabled and logins allowed again. Status of the cluster is good.

We found an undiagnosed issue with one of the quota features in Lustre which we have disabled while we investigate further - this means that filesystem quotas are not currently being enforced, and the `lquota` command does not work.

- 2021-10-19 12:00 - the new Myriad expansion nodes were enabled and are running jobs.

### Kathleen

- All systems are working well.

### Young

- 2021-09-24 16:00 - Jobs were re-enabled but we are encountering a ZFS bug that causes a metadata server to reboot or crash and the filesystem hangs until it recovers. This is causing periodic file access slowness and login failures during the recovery periods. Patching of ZFS is being planned.

- 2021-09-29 15:20 - Queues being drained of jobs so that ZFS upgrade can take place on Thurs 30 Sept. This should fix the above bug.

- 2021-10-04 15:00 - The ZFS upgrade was more complicated than originally thought. We currently expect Young to be back in service midday on Tues 5 Oct.

- 2021-10-05 12:00 - Upgrade completed. Jobs were re-enabled on Young.

- There are a number of nodes that intermittently lose power from their chassis, switch themselves off and need to be manually powered back on (this causes jobs to be stuck in `dr` state when they end until the reboot happens). This leads to a higher than usual number of nodes being seen by the scheduler as unavailable. We are awaiting hardware components for those chassis.

### Michael

- All systems are working well.

### Thomas

- System is generally fine but the hardware is dated with respect to the other systems so there may be some read write errors.


