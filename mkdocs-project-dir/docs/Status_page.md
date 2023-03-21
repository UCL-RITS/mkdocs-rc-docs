---
layout: docs
---

# Status of machines

This page outlines that status of each of the machines managed by the Research Computing team at UCL. We endeavour to keep this page as up-to-date as possible but there might be some delay. Also there are spontaneous errors that we have to deal with (i.e. high load on login nodes) but feel free to report them to rc-support@ucl.ac.uk. Finally, details of our planned outages can be found [here](https://www.rc.ucl.ac.uk/docs/Planned_Outages/).  

### Myriad

- 2023-03-06 - Myriad's filesystem is getting full again, which will impact performance. If you are 
 able, please consider backing up and deleting any files that you aren't actively using for your 
 research for the time being.

 You can check your quota and see how much space you are using on Myriad with the `lquota` command, 
 and you can see which directories are taking the most space using the `du` command, which can also 
 be run in specific directories. You can tell `du` to only output details of the first level of 
 directory sizes with the `--max-depth=1` option.

 Jobs are still running for the moment, but if the filesystem keeps getting fuller we may need to 
 stop new jobs running until usage is brought down again.

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

- 2023-03-16 08:20 - Kathleen is back up and running jobs and you should be able to log in again. 
 This took a bit longer than expected as we had some configuration issues with the login nodes that 
 were fixed last thing yesterday, after which we ran some test jobs.
 Any jobs that were running when the nodes powered down will have failed.

### Young

- 2023-03-14 09:30 - A datacentre cooling issue has caused servers in Young to overheat and power off. 
 Some disks that hold the operating system on the Object Store Servers have failed. We cannot currently 
 bring the filesystem back up as a result. As of the afternoon, work is continuing. 16:20 - Work on 
 this will need to continue tomorrow.

- 2023-03-15 11:45 - Young is back up - you should be able to log in now and jobs have started running.
 Any jobs that were running when the nodes powered down will have failed.
 We're currently running at risk and with reduced I/O performance because we only have one OSS (Object 
 Store Server) running and it has one failed disk in its boot volume, so we are lacking in resilience 
 until that is replaced (hopefully later today - done) and the second OSS is fixed and brought back up. 

- 2023-03-16 09:30 - Young's admin nodes have now gone offline, which will be preventing anyone from 
 logging in. We are investigating.

- 2023-03-16 13:15 - Young is back up. There was a cooling issue that affected only the admin rack this 
 time which consists of admin, util and login nodes plus the Lustre storage. The compute nodes stayed 
 up and jobs kept running, but they might have failed due to Lustre being unavailable. UCL Estates know 
 the cause of the problem and so hopefully this should not happen again for the time being.

### Michael

- All systems are working well.

### Thomas

 - 2023-03-15 15:00 - Thomas had some Lustre filesystem issues. Jobs may have failed and logins been
 timing out. This was fixed at 17:00 and all should be working as normal again.

 - 2023-03-21 10:00 - The Lustre outage we had last week was a symptom of Thomas' filesystem finally 
 getting too old and beginning to fail, so it is now time that we retire Thomas.

 We're draining the cluster of jobs at the moment - existing jobs will complete, and new jobs will 
 not start.

 We will keep the filesystem up and running as best we can until **Monday 22 May**, shortly after 
 which we will shut down the machine for the last time and no data that was on Scratch will be 
 recoverable. (We currently believe that we can keep it running this long, barring unexpected events).

 We're two years after Thomas stopped being the MMM Hub machine and originally was intended to stop 
 running - we appreciate the hardware for being able to continue this long!

 If you are trying to copy data to other UCL clusters and get errors about too many authentication 
 failures, make sure you don't have old out of date entries in your `.ssh/known_hosts` file.  

