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

  - 2023-07-31 12:30 - Myriad's filesystem is currently being very slow because we have two failed 
    drives in the Object Store Target storage. One drive has fully failed and the volume is under 
    reconstruction. The other has been detected as failing soon and is being copied to a spare, but
    this is happening slowly, likely because the disk is failing.

    They are in separate volumes so there isn't a risk there, but it can take some time for 
    reconstruction to complete and this will make the filesystem sluggish. This will affect you 
    accessing files on the login nodes, and also your jobs reading or writing to files on Scratch 
    or home, and accessing our centrally-installed software. (It won't affect writing to `$TMPDIR`,
    the local hard disk on the compute node).

    Once the reconstruction is complete, performance should return to normal. This could take most 
    of the day and potentially continue into tomorrow.

  - 2023-08-01 11:00 - We have had a report of another impending disk failure in the same volume as
    the first failed disk, which puts data at risk. The volume reconstruction is still in progress 
    and expected to take another 30-odd hours. (The second copy to spare has completed).

    We have stopped Myriad from running jobs to reduce load on the filesystem while the 
    reconstruction completes, so no new jobs will start for the time being. We'll keep you updated 
    if anything changes.

  - 2023-08-03 10:30 - We have another estimated 18 hours of volume reconstruction to go, so we are
    leaving jobs off today. On Friday morning we will check on the status of everything and 
    hopefully be able to re-enable jobs then if all is well.

  - 2023-08-04 10:00 - The reconstruction is complete and we have re-enabled jobs on Myriad.

  - 2023-11-23 14:00 - We need to stop new jobs running on Myriad while its filesystem recovers.

    This means that jobs that are already running will keep running, but new jobs will not start 
    until we enable them again. The filesystem is likely to be slower than usual. You can still log 
    in and access your files.

    This is because we've just had two disks fail in the same area of Myriad's filesystem and the 
    draining of jobs is to reduce usage of the filesystem while it rebuilds onto spare disks.

    The current estimated time for the disk rebuild is 35 hours (but these estimates can be 
    inaccurate).

    We will update you when new jobs can start running again.

  - 2023-11-24 09:45 - **Myriad filesystem is down.** 

    I'm afraid Myriad's filesystem is currently down. You will not be able to log in and jobs are 
    stopped.

    A third disk failed in the same area as the last two and we started getting errors that some 
    areas were unreadable and reconstruction failed. We need to get this area reconstructed so are 
    in contact with our vendors.

    **Detail**

    Our parallel filesystem is Lustre. It has Object Storage Targets that run on the Object 
    Storage Servers. Data gets striped across these so one file will have pieces in multiple 
    different locations, and there is a metadata server that keeps track of what is where. One of 
    the Object Storage Targets has lost three disks, is unreadable and is what needs to be 
    reconstructed. While it is unavailable, the filesystem does not work. We will also have some 
    amount of damaged files which have pieces that are unreadable.

    If the reconstruction succeeds, we will then need to clear out the unreadable sectors. Then we 
    will be able to start checking how much damage there is to the filesystem.

    This is all going to take some time. We will update you again on Monday by midday, but there 
    may be no new information by then.

    I'm sorry about this, we don't know right now how long an interruption this will cause to 
    service, or how much data we may have lost.

    Please send any queries to rc-support@ucl.ac.uk 

  - 2023-11-27 12:10 - There is not much of an update on Myriad's filesystem yet - we've been in 
    contact with our vendors, have done some things they asked us to (reseating hardware) and are 
    waiting for their next update.

    In the meantime, we are starting to copy the backup of home that we have from the backup system
    where it is very slow to access to somewhere faster to access, should we need to recover files 
    from it on to Myriad.

    We received a question about backups - the last successful backup for Myriad home directories 
    ran from Nov 20 23:46 until Nov 22 03:48. Data before that interval should be backed up. Data 
    after that is not. Data created or changed during it may be backed up, it depends on which 
    users it was doing when.

    (Ideally we would be backing up every night, but as you can see the backup takes longer than a 
    day to complete, and then the next one begins. The next backup had started on Nov 22 at 08:00 
    but did not complete before the disk failures).

  - 2023-11-29 11:30 Today's Myriad filesystem update:

    * We are continuing to meet with our vendor and have sent them more data to analyse.

    * We are going to copy over the failed section of filesystem to a new area, with some data 
      loss, so we end up with a working volume that we can use to bring the whole filesystem back 
      up.

    * The copy of data from our backup location to easier access location is ongoing (we have 
      48TiB of home directories consisting of 219M items, currently copied 15TiB and 27M items).

    Date of next update: Monday 4 Dec by midday.

    Myriad will definitely not be back up this week, and likely to not be back up next week - but 
    we'll update you on that. The data copying all takes a lot of time, and once it is there, we 
    need to run filesystem checks on it which also take time.


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
    
  - 2023-03-14 09:30 - A datacentre cooling issue has caused servers in Kathleen to overheat and power 
    off. As of the afternoon, work continues to bring Kathleen back up. 16:20 - We expect to be able 
    to put Kathleen back in service tomorrow.

  - 2023-03-16 08:20 - Kathleen is back up and running jobs and you should be able to log in again. 
    This took a bit longer than expected as we had some configuration issues with the login nodes that 
    were fixed last thing yesterday, after which we ran some test jobs.
    Any jobs that were running when the nodes powered down will have failed.

  - 2023-07-31 10:00 - Kathleen's Object Store Servers went down on Sunday at around 6am. We're
    currently working on bringing everything back up. You won't be able to log in right now, and 
    jobs that were running at the time will have failed. 

  - 2023-07-31 17:30 - Kathleen is running jobs again and you should be able to log in. It took a 
    bit longer to bring back up because one of the OSSs temporarily misplaced its network card - 
    after encouraging it to find it again we verified that it was working under load before 
    re-enabling jobs.

### Young

  - 2023-03-14 09:30 - A datacentre cooling issue has caused servers in Young to overheat and power off. 
    Some disks that hold the operating system on the Object Store Servers have failed. We cannot 
    currently bring the filesystem back up as a result. As of the afternoon, work is continuing. 
    16:20 - Work on this will need to continue tomorrow.

  - 2023-03-15 11:45 - Young is back up - you should be able to log in now and jobs have started running.
    Any jobs that were running when the nodes powered down will have failed.
    We're currently running at risk and with reduced I/O performance because we only have one OSS (Object 
    Store Server) running and it has one failed disk in its boot volume, so we are lacking in resilience 
    until that is replaced (hopefully later today - done) and the second OSS is fixed and brought back 
    up. 

  - 2023-03-16 09:30 - Young's admin nodes have now gone offline, which will be preventing anyone from 
    logging in. We are investigating.

  - 2023-03-16 13:15 - Young is back up. There was a cooling issue that affected only the admin rack this 
    time which consists of admin, util and login nodes plus the Lustre storage. The compute nodes stayed 
    up and jobs kept running, but they might have failed due to Lustre being unavailable. UCL Estates 
    know the cause of the problem and so hopefully this should not happen again for the time being.

  - 2023-03-23 03:20 - Young's single running OSS went down due to high load and was brought back up
    shortly before 9am. The second OSS had lost both internal drives and is likely to take several more
    days before it can be brought back into service, so we are still running at risk.

  - 2023-03-24 09:00 - Young's single running OSS went down again overnight. Last night we appeared to 
    be running into a new ZFS issue, where we had a kernel panic, a reboot and a failure to start ZFS 
    resources. Our Infrastructure team brought the resources back up this morning and Lustre recovery 
    began, but now the OSS has become unresponsive again. This means that you will not be able to log in 
    at the moment and jobs will have failed because they haven't been able to access the filesystem. 

  - 2023-03-24 13:00 - We do not currently expect to be able to bring everything up again until after 
    the weekend. Right now there is very high memory usage on the existing OSS even when only the util 
    and login nodes are running Lustre clients and all the compute nodes are off. We aren't sure why. 
    
    Next week we may need to delay bringing the compute back up until after the other OSS is fully fixed,
    but we will update you on this then.
    
    Sorry about this, we were running ok on one OSS until Thursday and now something is preventing us 
    from continuing like that, so we may have another underlying problem.

  - 2023-03-27 11:00 - The disks in the Young OSSes will be replaced tomorrow (we had another 
    failure in the OSS that is currently up, so it is down a disk again). This means that it will be 
    during Wednesday at the earliest that we're able to start jobs again, and it does depend somewhat 
    on how well everything is behaving after all the disks are replaced and we have a properly 
    resilient system again - we'll need to do some testing before allowing jobs to start even if 
    everything looks good.

  - 2023-03-28 17:15 - Young's filesystem is running on two OSSes again. Roughly half the compute nodes 
    are enabled and jobs are running on them. If all goes well, we'll switch on the rest of the compute 
    nodes tomorrow.

  - 2023-03-29 15:10 - Jobs were started on the rest of the nodes at around 10:30am and everything is 
    running ok with the exception of the GPU nodes. On the GPU nodes we are seeing Lustre client 
    evictions which cause I/O errors for jobs running on the nodes - they weren't able to complete 
    the read or write they were requesting. For now we aren't running jobs on the GPU nodes until we have 
    this sorted out. You may have a job that started running there earlier today or yesterday and failed 
    or did not create all the output expected because of this - please do check your output carefully in 
    that case.
    
    This is a new issue. We have some suspicions that it is configuration-related, since the GPU nodes 
    have two OmniPath cards each and Lustre is set up to use both. This setup was working previously; we 
    are going to investigate further.

  - 2023-03-30 10:40 - Last night we had two ZFS panics, one on each OSS. These occurred at just 
    before 10pm and again at 1:30am. These will have caused some jobs to fail with I/O errors. We have 
    adjusted some configuration so that if we have more panics then the filesystem should hopefully be 
    able to recover more quickly and cause fewer I/O errors.
    
    We had a problem with ZFS panics before where it was a known issue with the versions we were running 
    and fixed it by upgrading the versions of Lustre and ZFS that we had on Young. The current issue we 
    are experiencing does not appear to be a known one, investigation continues.

  - 2023-04-03 10:30 - Young stayed up over the weekend and was running CPU jobs successfully. We have 
    now re-enabled the GPU nodes as well.
    
    We are still getting some ZFS panics, but the change to how they work mean the filesystem is 
    failing over and recovering in time to only affect a few client connections. We are scanning for
    corrupted metadata and files since this may be the cause.
    
    We will be leaving Young up and running jobs over Easter. UCL's Easter closing is from Thurs 6 April 
    to Weds 12 April inclusive and we will be back on Thurs 13 April. If anything goes wrong during this 
    time, we won't be able to fix it until we are back.

  - 2023-04-04 14:20 - The `zfs scrub` we were running to look for corrupted metadata and files
    has exposed a drive failure. We have spares and the affected ZFS pool is now recovering, which will 
    take a day or so. I/O performance may be degraded during the recovery. 

  - 2023-06-21 16:30 - We had a filesystem issue caused by a failed disk in the metadata server 
    at about 4:30pm. We brought it back up and it was recovering at around 8:20pm and will have 
    been slower for a while overnight until recovery completed. Jobs will have failed in the 
    period when it was down, so please do check on things that were running during this time to 
    see whether they completed or not - our apologies for this.

  - 2023-06-27 20:15 - We’ve had an unexpectedly high number of drive failures in Young’s 
    filesystem, and this has created a significant risk of filesystem failure until we can replace 
    the drives and restore resiliency. 
    
    To try to keep the filesystem running, we’ve had to shut down the login and compute nodes, 
    terminating all running jobs and removing access to the cluster. This should massively 
    reduce the load on the filesystem, and allow us to more rapidly bring the system back to a 
    safe level of redundancy.

    In future, we will also attempt to keep more spare drives on-site, which should help us avoid 
    this kind of situation.

    Apologies for the inconvenience: we’re going to be replacing drives and we will hopefully have 
    an update with better news tomorrow.

  - 2023-06-28 11:00 The situation with the disks in Young's filesystem is worse than we thought 
    and we're currently doing some data recovery procedures so we can then evaluate what we 
    should do next.

    Data in home directories is backed up. We have likely lost some data from Scratch but are 
    working to find out the implications of that, and what and how much could be affected.

    How long Young will be down depends on what we discover in the next few days. We will need 
    to do a full filesystem check once we have a recovered filesystem to check, and this can take 
    some time.

    The detail, for those who wish to know:

    A Lustre filesystem consists of object store servers and metadata servers, and the metadata 
    servers store information such as filenames, directories, access permissions, and file layout.

    We had a failed drive in a metadata mirror on Wednesday last week. We have eight mirrors in 
    that metadata target and each consists of two drives. We had a replacement drive arrive, but 
    before we could fit it, the second drive in the same mirror indicated that it was beginning to 
    fail. 

    We fitted the replacement drive yesterday, but the rebuild of the mirror overnight did not 
    succeed and the failing disk's status degraded further. What we are going to do next is to 
    retrieve as much off the failing disk as we can, move it onto a healthy disk, and then see 
    what status the filesystem is in and what is in an inconsistent state. 

    As was mentioned, we had also ordered more spare drives to keep on site but this happened 
    before those arrived.

    We're sorry for this situation and are working to address it. We'll keep you updated as we 
    know more.

  - 2023-06-29 11:30 - We've recovered what was on the failing disk and are missing approximately 
    250kB of metadata. (Since it is metadata, this doesn't directly translate to the effect on your
    files, but we can probably be cautiously optimistic about the expected size of impact, should 
    nothing else go horribly wrong).

    Replacement disks are being sent to us and should arrive today or tomorrow.

    Once the disks arrive, we will proceed with the next step of moving the recovered data onto a 
    new disk and getting the filesystem to use that in replacement of the failed disk, and then we 
    can attempt to bring the filesystem up and see what status it thinks it is in. At that point we
    will have several levels of filesystem health checking to run.

    We are also progressing with some contingency plans relating to the backup data we have, to 
    make it easier to use should we need to. 

    I've had a couple of questions about when Young will be back up - we don't know yet, but not 
    during next week. I would expect us to still be doing the filesystem recovery and checks on 
    the first couple of days of the week even if the disks do arrive today, so we probably won't 
    have any additional updates for you until midweek.

    It does take a long and unpredictable time to rebuild disks, check all the data, and recover 
    files: as an example, our metadata recovery was giving us estimates of 19 hours to 5 days while
    it was dealing with the most damaged portions of the disk. 

  - 2023-07-04 10:25 - I just wanted to give you an update on our progress. The short version is 
    "we are still working on it but now believe we have lost little to no user data".
 
    We do not have an ETA for return to service but may be able to give you read-only access to 
    your files in the near future.

    More detail for those who are interested:
 
    We have fitted the replacement disks and migrated the data to the new drives. The underlying 
    ZFS filesystem now believes that everything is OK and we are running the Lustre filesystem 
    checks. 
 
    We are also restoring a backup to a different file-system so that in the event that any data 
    in /home was damaged we can restore it quickly.
 
    Medium term, we plan to replace the storage appliance, which we are funding from UCL's budget 
    in our FY 23/24 (starts 1st August). This work should be completed by Christmas and will also 
    affect the local Kathleen system.

  - 2023-07-04 16:25 - I'm pleased to announce that while we are not in a position to return to 
    service yet (the Lustre filesystem check is still running), we have managed to get to a state 
    where we can safely give you read-only access to your files. You should be able to log into 
    the login nodes as usual to retrieve your files.
 
    (Obviously, this means you cannot change any files or run jobs!)

  - 2023-07-07 12:30 - I didn't want to head into the weekend without giving an update – we are 
    still running the Lustre File-system Check and hope to have completed it by mid next week, 
    but unfortunately the tool that does this doesn't report its progress in a very helpful way – 
    as of this morning it had completed checking 13.7M directories on the file-system but we don't 
    have an exact number for how many there are total, only an estimate.
 
    Again, apologies for this unplanned outage – we are working at full speed to get a replacement 
    for this hardware later this year so we should not see a recurrence of these problems once 
    that is done.

  - 2023-07-12 16:30 - Full access to Young is restored, and jobs are running again!

    The Lustre filesystem check finished successfully earlier today and we ran some I/O-heavy test 
    jobs without issues. 

    We have replaced disks in the metadata server where both in a pair were still original disks, 
    to prevent this situation happening again.

    We remounted the filesystem read-write and at 15:45 and 16:00 rebooted the login nodes one 
    after the other. We're now back in full service.

    Please do check your space and if anything appears to be inconsistent or missing, email 
    rc-support@ucl.ac.uk 

    Thank you for your patience during this time.

  - 2023-10-26 14:50 - We seem to have a dying OmniPath switch in Young. The 32 nodes with names 
    beginning `node-c12b` lost their connection to the filesystem earlier. Powercycling the switch 
    only helped temporarily before it went down again. Those nodes are all currently out of service 
    so new jobs will not start on them, but if your job was running on one of those when the two 
    failures happened those jobs will have failed.

    (You can see in `jobhist` what the head node of a job was, and the .po file will show all the 
    nodes that an MPI job ran on).

### Michael

  - All systems are working well.

### Thomas

  - Thomas is now retired.

