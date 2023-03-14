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

- 2021-10-26 21:50 - Heavy load on Lustre began. We are investigating whether or not this was a job. Is currently causing slow filesystem access, and affecting MATLAB loading, git clone and Python import times among others.

- 2021-10-29 11:50 - We are going to do a failover between servers, then make some changes to the OSSes (object store servers). We will prevent new jobs from starting while this is going on and will re-enable them later. While the failover is happening, filesystem operations and logins will hang until recovery completes.

- 2021-10-29 14:40 - Jobs were re-enabled. Things are looking better at the moment - we will continue to monitor the system. The main change we made was to upgrade the amount of RAM in the OSSes to let them cache disk use more effectively. 

We took the opportunity to also replace the disks from the previous disk failures with completely new disks so we will no longer be running on hot spares - this work had already been planned. The disks should finish rebuilding over the weekend so there will be some impact from that, but the memory increase appears to have made a notable difference at present. 

- 2021-11-15 09:16 - Beginning on Saturday night, something triggered a Lustre bug that left both OSSes (object store servers) unresponsive and prevented logins. We are currently working on this.

- 2021-11-15 12:00 - Logins are working. Jobs are not yet re-enabled. 

- 2021-11-15 16:05 - Jobs are being re-enabled so new ones can start. (Existing jobs were still 
 running if they had not failed). We will be monitoring performance.

### Kathleen

- 2022-09-27 - Kathleen's metadata servers have started encountering the ZFS+Lustre bug that Young 
 had in the past, which causes very high load and hangs. We also discovered we were running out of
 inodes on the metadata server - an inode exists for every file and directory, so we need a 
 reduction in the number of files on the system. We prevented new jobs from starting for the time 
 being.

- 2022-10-03 - We are upgrading Kathleen's ZFS and Lustre on the metadata servers to mitigate the
 bug. Jobs will not start running again until this is done. Quotas have been enabled. We have 
 contacted users who are currently over quota and also have jobs in the queue - their jobs are held 
 so they do not fail straight away unable to write files once jobs are restarted. These users will 
 be able to release the hold themselves once under quota again with the `qrls all` command.

- 2023-03-14 09:30 - A datacentre cooling issue has caused servers in Kathleen to overheat and power off.
 As of the afternoon, work continues to bring Kathleen back up. 16:20 - We expect to be able to put
 Kathleen back in service tomorrow.

### Young

- 2022-01-04 - The file system on Young is down and has been since the 23rd December. We are working to resolve the issue but there is no official timeline for sorting this out.

- 2022-01-11 - Young cluster is back in service. Please check for completed successfully / failed jobs. We believe there has been no data loss, but jobs would have been broken after the long interval since 23rd of Dec 2021 up to today, due to timeouts and I/O issues with the filesystem.

- 2022-01-13 - The Young filesystem is up but not in a very stable state. We want to do a backup and run checks over the weekend and then put the cluster back into service on Monday the 17th. The login nodes are powered off until the backup completes to prevent any risk of data corruption and to make sure nothing else is accessing the data in order to make the backup as fast as possible.

- 2022-01-17 - We are still waiting for the backup to finish, and at current progress do not expect it to finish until Wednesday at the earliest - sorry about the extended timescale here. The login nodes are still powered off.

- 2022-01-20 - The current status of the Young backup is that we don't expect it to finish until Monday at the earliest now. Apologies for the delay.

- 2022-04-04 17:19 - Scheduled cluster update from 1st to 4th of April is still in progress. Users are expected to be able to login tomorrow April 5th.

- 2023-03-14 09:30 - A datacentre cooling issue has caused servers in Young to overheat and power off. 
 Some disks that hold the operating system on the Object Store Servers have failed. We cannot currently 
 bring the filesystem back up as a result. As of the afternoon, work is continuing. 16:20 - Work on 
 this will need to continue tomorrow.


### Michael

- All systems are working well.

### Thomas

- System is generally fine but the hardware is dated with respect to the other systems so there may be some read write errors.


