---
layout: docs
---

# Status of machines

!!! important
    There is currently an issue with central groups for new UCL users which means
    we cannot add you to reserved application or shared data groups at present.
    This applies to UCL accounts with a start date of 16 August 2024 or later, as far
    as we are currently aware. 

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
      48TiB of home directories consisting of 219M items, currently copied ~~15TiB~~ 7.5TiB and 27M 
      items).

    Date of next update: Monday 4 Dec by midday.

    Myriad will definitely not be back up this week, and likely to not be back up next week - but 
    we'll update you on that. The data copying all takes a lot of time, and once it is there, we 
    need to run filesystem checks on it which also take time.

  - 2023-12-04 12:30 - The data copying is continuing.

    * The copy of the failed section of filesystem to a new area is at 33% done, expected to take 
      4.5 days more.

    * The copy of home directories from our backup location to easier access location is at 
      ~~44TiB~~ 22TiB (GPFS was reporting twice the real disk usage) 
      and 86M items out of 48TiB and 219M. It is hard to predict how long that may take, as the 
      number of items is the bottleneck. It has been going through usernames in alphabetical order 
      and has reached those starting "ucbe".

    If the first of these copies completes successfully, we will then need to go through a 
    filesystem check. This will also take possibly a week or more - it is difficult to predict 
    right now. If this recovery continues as it has been and completes successfully, it looks like 
    we may have lost a relatively small proportion of data - but we cannot guarantee that at this 
    stage, and the copy has not completed.

    So at present we expect to be down at least all of this week, and all of next week - and 
    possibly into the week of the 18th before UCL's Christmas closing on the 22nd.

    I'm sorry about this - with these amounts of data and numbers of files, it gets difficult to 
    predict how long any of these operations will take.

    We've had a couple of questions about whether there is any way people can get their data from 
    Myriad - until the filesystem is reconstructed and brought back up, we cannot see separate 
    files or directories on Myriad.

  - 2023-12-12 15:00 - First data copy complete.

    * The copy of the failed section of filesystem has completed and is showing at 99.92% rescued, 
      leaving around 75GB of data as not recoverable. (At present we don't know what this data is -
      it could be from all of home, Scratch, shared spaces and our application install area).

    * The copy of home directories from our backup location to easier access location is still 
      going, currently at 42.5TiB and 166M items out of 48TiB and 219M. My earlier reports had 
      doubled the amount we had successfully copied, so when I said 44TiB previously, that was only
      22TiB. (Corrected in this page). This is progressing slowly and has stalled a couple of times.

    We next need to bring the filesystem up so we can start running checks and see what files are 
    damaged and missing. We will be discussing our next steps to do this with our vendor. 

    I intend to send another update this week, before the end of Friday. 

  - 2023-12-15 17:20 - No news, Christmas closing.
    
    No news, I'm afraid. It is looking like Myriad's filesystem will definitely remain down over 
    Christmas.

    * Our vendors are investigating filesystem logs.

    * The copy of home directories from our backup location to easier access location appears to 
      have finished the copying stage but was still doing some cleanup earlier today.

    UCL is closed for Christmas from the afternoon of Friday 22 December until 9am on Tuesday 2 
    January. Any tickets received during this time will be looked at on our return.

    We will send an update next week before UCL closes.

  - 2023-12-18 15:30 - Home directories from backup available

    We have restored Myriad HOME directories only (no Scratch, Projects or
    Apps) from the most recent back up which ran from:
 
    Monday Nov 20 23:46 to Wednesday Nov 22 03:48
 
    They are mounted READ ONLY on the Myriad login nodes so you can login
    to check what files are missing or need updating and scp results etc
    back to your local computer. We apologize for the delay in making this
    data available, unfortunately the restore process was only finished during
    the weekend.
 
    Work on restoring more data (i.e. HOME from after the backup, as well
    as Scratch and Projects) is still in progress.
 
    It is currently not possible to run jobs.
 
    We still don't expect Myriad to be restored to service before the
    Christmas and New Year UCL closure.
 
    UCL is closed for Christmas from the afternoon of Friday 22 December until 9am on Tuesday 2 
    January. Any tickets received during this time will be looked at on our return.

  - 2023-12-22 15:00 - A final Myriad update before UCL closes for the Christmas and New Year break.
 
    The copy of rescued data back onto the re-initialised volume completed this morning (Friday 
    22nd). We are now running filesystem checks. Myriad will remain down during the Christmas and 
    New Year closure apart from the read only HOME directories as detailed previously.

  - 2024-01-05 16:50 - An update on the status of Myriad before the weekend

    We wanted to give you a quick update on the progress with Myriad before the weekend as we 
    know several of you are asking for one.
 
    We are meeting on Monday morning to consider options for returning the live filestore 
    including Apps, HOME, Scratch and projects to service. We should have some rough timescale we 
    can give you later on Monday.
 
    Currently a scan is running to discover which files existed either wholly or in part on the 
    failed volume. So far this has discovered around 60M files, and the scan is about halfway. This 
    will carry on running over the weekend. Unfortunately, there is likely to be significant data 
    loss from your Scratch directories.
 
    We will send another update later on Monday.

  - 2024-01-08 17:50 - Myriad update (Monday)
 
    We met this morning to discuss options for returning the live filestore including Apps, HOME, 
    Scratch and projects to service. Tentatively we hope to be able to allow you access to your 
    HOME, Scratch and projects by the end of this week.
 
    The scan to discover which files existed either wholly or in part on the failed volume has 
    completed and found about 70M files which is around 9.1% of the files on Myriad. We are 
    planning to put files in your HOME directory:
 
    One listing the missing files from your HOME directory.
 
    One listing the missing files from your Scratch directory.
 
    There are also missing files in projects so if you own a project we will give you a list of 
    these too.

  - 2024-01-11 12:30 - Jobs on Myriad

    We've had questions from you about when jobs will be able to restart. We were able to assess 
    the damage to our software stack yesterday and most of the centrally installed applications 
    are affected by missing files and need to be copied over from other clusters or reinstalled.

    We're going to begin by copying over what we can from other systems. We'll be looking at the 
    results of this first step and seeing how much is still missing after it and how fundamental 
    those packages are. 

    It would be possible for us to enable jobs before the whole stack was reinstalled, but we need 
    enough there for you to be able to carry out useful work. We should have a much better idea of 
    what is still missing by Monday and our plans for reinstating it. I would rather lean towards 
    giving you access sooner with only the most commonly-used software available rather than 
    waiting for longer.

    We're on schedule for giving you access to your files by the end of this week.

    New user accounts will start being created again once jobs are re-enabled.

    I'll also be sending an update in the next few days about our future filesystem plans and 
    mitigations we were working on before this happened.

#### Check lists of damaged files on Myriad

  - 2024-01-12 14:00 Myriad: filesystem access restored, jobs tentatively expected for Monday

    We've restored read-write access to Myriad's filesystem, and you will be able to log in and 
    see all your directories again. Here's some detail about how you can identify which of your 
    files were damaged.

    **Your data on Myriad**

    During the incident all files that resided at least partially on OST00 have been lost. 
    In total these are 70M files (out of a filesystem total of 991M).

    We restored files in `/lustre/home` from the latest backup where available. Data that was 
    created while the backup was running or afterwards had no backup and could not be restored. 
    For the time being, we will keep the latest backup available read-only in the directory 
    `/lustre-backup`.

    Files in `/lustre/scratch` and `/lustre/projects` were not backed up, as a matter of policy. 
    All OST00 files from these directories have been lost.

    Where files were lost but still showing up in directory listings, we have removed ("unlinked") 
    them so it doesn't appear that they are still there when they are not.

    For a tiny fraction of the lost files (0.03%), there is still some file data accessible, but 
    most of these files are damaged (e.g. truncated or partially filled with zeroes). For some 
    users these damaged files might still contain useful information, so we have left these files 
    untouched.

    The following files have been placed into your home directory:

     - OST00-FILES-HOME-restored.txt
         - A list of your home directory files that resided on OST00 and that were successfully 
         restored from backup.

     - OST00-FILES-HOME-failed.txt
         - A list of your home directory files that resided on OST00 and that could not be restored 
           from backup, including one of the following messages:
         - "no backup, stale directory entry, unlinked" - There was no backup for this file, and we 
           removed the stale directory entry.
         - "target file exists, potentially corrupt, leaving untouched" - Original file data is still 
           accessible, but likely damaged or corrupt. Feel free to delete these files if there's no 
           useful data in there.

     - OST00-FILES-SCRATCH.txt
         - A list of your Scratch directory files that resided on OST00, including one of the 
           following messages (similar to the above):
         - "stale directory entry, unlinked"
         - "file exists, potentially corrupt, leaving untouched"

    For projects, the following file has been placed in the project root directory:

     - OST00-FILES-PROJECTS.txt
         - A list of project files that resided on OST00, including one of the following messages:
         - "stale directory entry, unlinked"
         - "file exists, potentially corrupt, leaving untouched"

    A very few users had newline characters (`\n`) in their filenames: in this case in the above 
    .txt files the `\n` has been replaced by the string `__NEWLINE__`, and an additional .bin file 
    has been placed alongside the .txt file, containing the list of original filenames terminated 
    by null bytes (and not including the messages).

    These OST00-FILES-* files are owned by root, so that they don't use up any of your quota. 
    You can still rename, move, or delete these files.

    **Jobs**

    We're currently running a Lustre filesystem check in the background. Provided it does not throw 
    up any serious problems, we expect to be able to re-enable jobs during Monday. We'll be putting
    user holds on all the jobs so you can check that the files and applications they are trying to 
    use exist before allowing them to be scheduled. They will show in status `hqw` in qstat.

    Once you have made sure they are ok, you will be able to use `qrls` followed by a job ID to 
    release that job, or `qrls all` to release all your jobs. They will then be in status `qw` and 
    queue as normal. (Array jobs will have the first task in status `qw` and the rest in `hqw` - 
    this is normal). If you want to delete the jobs instead, use `qdel` followed by the job ID.

    **Software**

    We have successfully restored the vast majority of Myriad's software stack. I'll send a final 
    update when we re-enable jobs, but at present I expect the missing applications to be:
 
     - ABAQUS 2017
     - ANSYS (all versions)
     - STAR-CCM+ (all versions)
     - STAR-CD (all versions)

    These are all licensed applications that are best reinstalled from their original media, so 
    we'll be working through those, starting with the most recent version we had.

    Please send any queries to rc-support@ucl.ac.uk. If you've asked us for account deletions, we 
    will be starting those next week, along with new user account creations.

  - 2024-01-15 16:00 - Myriad jobs enabled

    We have now allowed jobs to start on Myriad. 

    We have reinstalled ABAQUS 2017, ANSYS 2023.R1, STAR-CCM+ 14.06.013 and STAR-CD 4.28.050. The 
    older versions of these applications are still missing at the moment.

    Your jobs that were still in the queue from before have user holds on them and show in status 
    `hqw` in qstat.

    Once you have made sure the files and applications the jobs are using are present and correct, 
    you will be able to use `qrls` followed by a job ID to release that job, or `qrls all` to 
    release all your jobs. They will then be in status `qw` and queue as normal. (Array jobs will 
    have the first task in status `qw` and the rest in `hqw` - this is normal). If you want to 
    delete the jobs instead, use `qdel` followed by the job ID.

    User deletions and new user creations are underway. We'll need to check that the 
    synchronisation to the mailing list is working correctly and people are being added and removed
    as appropriate.

#### Latest on Myriad

  - 2024-10-18 13:55 - **Action required: compression or removal of data on Myriad**

    Myriad's filesystem is too full, so we need everyone to check what data they are keeping on the 
    cluster and to remove data they are not currently using. To perform effectively, the filesystem 
    needs a significant portion of empty space. As it gets fuller, performance begins to get worse 
    and then stability also decreases. 

    The filesystem is at 70% full, and we will need to stop jobs running when it reaches 75%. (1% of 
    the filesystem is 19.4 TiB).

    Keeping data unnecessarily on the system affects everyone's ability to run jobs.

    We will also be contacting those of you with large amounts of data separately.

    **How to check usage and compress data**

    You can check your quota and see how much space you are using on Myriad with the lquota command, 
    and you can see which directories are taking the most space using `du -h` which can also be run 
    in specific directories. You can tell du to only output details of the first level of directory 
    sizes with the `--max-depth=1` option.

    If you cannot remove your data from the cluster, please consider whether you can archive and 
    compress any of it for the time being.

    Example to tar up and gzip compress a directory:

    - `tar -czvf /home/username/Scratch/myarchive.tar.gz /home/username/Scratch/work_data` 
      will (c)reate a g(z)ipped archive (v)erbosely in the specified (f)ilename location. The 
      contents will be everything in this user's `work_data` directory.

    You can request bzip2 compression instead with `-j` or `--bzip2` and `xz` compression with `-J` 
    or `--xz`. These will give you better compression than gzip, with xz generally being the most 
    compressed.

    If you are compressing an individual file rather than a directory, you can use the `gzip`, 
    `bzip2` and `xz` commands on their own without tar.

    (Have a look at `man tar` or gzip, bzip2 and xz for the manual page details - they also contain 
    the names of the uncompress commands).

    If you are transferring data to Windows and want to uncompress the data there, 7-zip can open 
    all of these formats. Or you can create your archives using the `zip` command.

    **Quota policies**

    We are going to be adjusting the policies for granting Scratch quota increases - the CRAG will 
    be granting them for shorter periods of time and will not be as easily re-granting increases at 
    the end of that time period. We will have a process for what happens when a quota increase 
    expires, including notifications to you. You will be asked to consider your plans for what to 
    do with the data when the quota increase expires at the time of requesting one.

    We are also going to be setting up annual account reapplications again, so we can identify 
    users who are no longer using the system and activate our account deletion policies.

    This is to prevent the current situation where new users to the system cannot get relatively 
    small and short term quota increases necessary for their work because increases granted in the 
    past are still using the space.

    **ARC Cluster File System (ACFS)**

    Timelines for access to the ARC Cluster Filesystem (ACFS) from Myriad are currently being 
    considered. There is some info about the ACFS at 
    [ARC Cluster File System](https://www.rc.ucl.ac.uk/docs/Background/Data_Storage/#arc-cluster-file-system-acfs) 

    The ACFS once available from Myriad will give you 1T in total of backed-up data (and your home 
    directories will no longer be backed up). For those of you with larger Scratch quota increases, 
    you will still need to consider what you will do with the bulk of your data. 

    **Info**

    We recently added some pages to our documentation which may be relevant:

    - [Parallel Filesystems](https://www.rc.ucl.ac.uk/docs/Background/Parallel_Filesystems/) includes 
      sections on working effectively with parallel filesystems and tips for use.
    - [Data Storage](https://www.rc.ucl.ac.uk/docs/Background/Data_Storage/) - what storage locations exist.
    - [Data Management](https://www.rc.ucl.ac.uk/docs/Data_Management/) - checking quotas, transferring 
      data to other users, requesting data from those who have left.

    Please email rc-support@ucl.ac.uk with any queries or raise a request about Myriad via 
    [UCL MyServices](https://myservices.ucl.ac.uk/). If you are no longer using the cluster and 
    wish to be removed from this mailing list, please also contact us and say we can delete your account.


### Kathleen

  - 2024-09-05 - Kathleen outage for new filesystems on Tues 10 September - action required 

    The previously-announced Kathleen outage for new filesystems will now take place on maintenance 
    day next week, **Tuesday 10 September**. 

    The Kathleen cluster will go into maintenance on Tuesday 10 Sept 2024 from 9:00. Logins to 
    Kathleen will not be possible until the maintenance is finished. Any jobs that won’t finish by 
    the start of the maintenance window will stay queued. We aim to finish the maintenance within 
    one day, so that you can access Kathleen again on Weds 11 Sept.
 
    **We are implementing a number of changes to how data is stored on Kathleen:**

    * The current Lustre filesystem will be replaced with a new Lustre filesystem. The old Lustre is 
      running on aging and error-prone hardware, and suffers from performance issues, especially for 
      interactive work on the login nodes. The new Lustre should provide a vastly better experience.
    * The Kathleen nodes will mount the ACFS (ARC Cluster File System) which is ARC’s new centralised 
      storage system that will (eventually) be available on other ARC systems (e.g. Myriad) too. 
      ACFS will be available read-write on the login nodes but read-only on the compute nodes.
    * Going forward, only the data on ACFS will be backed up. **Please note that the data on the new 
      Lustre will not be backed up, not even data under `/home`**.
 
    **After the maintenance, you have the following storage locations:**

    * `/home/username`: your new home directory on the new Lustre; not backed up (this is a change 
      to the current situation)
    * `/scratch/username`: your new scratch directory on the new Lustre; not backed up
    * `/acfs/users/username`: your ACFS directory; backed up daily; read-only on the compute nodes
    * `/old_lustre/home/username`: your old home directory on the old Lustre; read-only
    * `/old_lustre/scratch/username`: your old scratch directory on the old Lustre; read-only

    You will also have a `~/ACFS` shortcut/symbolic link in your home that points to `/acfs/users/username`.
 
    If you are looking in your `/old_lustre/home/username/Scratch` symbolic link, that will direct you 
    back to your **new** Scratch not your old Scratch because it uses an absolute path. Please make sure 
    to access old Scratch using `/old_lustre/scratch/username`.

    **What you will need to do (after the maintenance):**

    * After login, you will notice that your new home and scratch directories are mostly empty. 
      Please copy any data you need from your old home and scratch directories under `/old_lustre` to 
      the appropriate new locations.
        - E.g. `cp -rp /old_lustre/home/username/data /home/username` will recursively copy your old 
          `data` directory and everything in it into your new home, while preserving the permissions.
    * Any data that you consider important enough to be backed up should be copied into your ACFS 
      directory instead.
    * You have **three months** to copy your data. After this, the `/old_lustre` will become unavailable.
    * Your queued jobs will be held (showing status `hqw` in `qstat`) and won’t start running 
      automatically, as their job scripts will likely refer to locations on `/lustre` which won’t exist 
      until you have copied over the data. After you have copied the data that your jobs need to the new 
      Lustre, you can release the hold on your queued jobs.
        - E.g. `qrls $JOB_ID` will release a specific job ID, and `qrls all` will release all your jobs.
        - Released array jobs will have the first task in status `qw` and the rest in `hqw` - this is normal.
    * Depending on the amount of data, the copying may take some time, especially if you have many small 
      files. If you are copying data to ACFS and you don’t need immediate access to each file individually, 
      consider creating tar archives instead of copying data recursively.
        - E.g. `tar -czvf /acfs/users/username/myarchive.tar.gz /old_lustre/home/username/data` will 
          (c)reate a g(z)ipped archive (v)erbosely in the specified (f)ilename location. The contents will be 
          everything in this user's old `data` directory. 

    Further reminders will be sent before `/old_lustre` is removed on 11 December.

    **Kathleen quotas**

    You will continue to have one quota on Kathleen, with a default value of 250G that includes your 
    home and Scratch. If you have an active quota increase request that has not reached its requested 
    expiry date on your old space, we will be recreating these on the new space. As stated above, 
    `/home` will no longer be backed up.

    **ACFS quotas**

    You will have 1T of quota on the ACFS. You will be able to check this with the `aquota` command.

    The ACFS has dual locations for resilience, and as a result standard commands like `du` or `ls -al` 
    will report filesizes on it as being twice what they really are. The `aquota` command will show you 
    real usage and quota. One of the reasons for the previous delay is that we tried to get filesizes to 
    report correctly in all circumstances, but that was not possible so we decided it was less confusing 
    if everything other than `aquota` always showed double. 

    For those interested, the ACFS is a GPFS filesystem.

    This outage will show shortly on [Planned Outages](https://www.rc.ucl.ac.uk/docs/Planned_Outages/) 
    and the ACFS information will be added to our documentation.

    We apologise for the inconvenience, but we believe these changes will help to provide a more performant 
    and robust service in the future.
 
    Please email rc-support@ucl.ac.uk with any queries or raise a request about Kathleen via 
    [UCL MyServices](https://myservices.ucl.ac.uk/).

  - 2024-09-11 09:35 Kathleen filesystem outage complete

    The outage is complete and you can log in and access your new home, Scratch and ACFS directories 
    on Kathleen.

    In addition to the information given previously:

    - You will have a `~/ACFS` shortcut/symbolic link in your home that points to `/acfs/users/username`
    - If you want to copy data and preserve the permissions, use `cp -rp` rather than `cp -r`
    - If you are looking in your `/old_lustre/home/username/Scratch` symbolic link, that will direct you 
      back to your new Scratch not your old Scratch because it uses an absolute path. Please make sure to 
      access old Scratch using `/old_lustre/scratch/username`

    This will be added to https://www.rc.ucl.ac.uk/docs/Status_page/#kathleen and has been updated in the 
    original message there.

    The message you see when first logging in to Kathleen has been updated with the change to backed-up 
    locations and ACFS information.

    We have these additional pages in our documentation:

    - https://www.rc.ucl.ac.uk/docs/Background/Parallel_Filesystems/ (parallel filesystem concepts)
    - https://www.rc.ucl.ac.uk/docs/Background/Data_Storage/ (data storage locations we provide)
    - https://www.rc.ucl.ac.uk/docs/Data_Management/ (how to check quotas, transfer ownership of files)

    **Terms & Conditions update**

    We have updated our Terms and Conditions (https://www.rc.ucl.ac.uk/docs/Terms_and_Conditions/) - 
    please take a look. It now defines our data retention policies and when we can access your data, 
    among other things. 

### Young

  - 2023-10-26 14:50 - We seem to have a dying OmniPath switch in Young. The 32 nodes with names 
    beginning `node-c12b` lost their connection to the filesystem earlier. Powercycling the switch 
    only helped temporarily before it went down again. Those nodes are all currently out of service 
    so new jobs will not start on them, but if your job was running on one of those when the two 
    failures happened those jobs will have failed.

    (You can see in `jobhist` what the head node of a job was, and the .po file will show all the 
    nodes that an MPI job ran on).

  - 2024-01 Parallel filesystem soon to be replaced.

  - 2024-01-03 12:30 Filesystem issues on Young: temporary hangs, running but degraded 

    We've just had two periods today where Young's filesystem would have hung - hopefully briefly 
    enough that operations in progress will have continued after it recovered.

    We failed over from one server to the other and back again. 

    Young's filesystem is more at risk than usual right now since we have some failed disks and 
    one area (one Object Store Target) is degraded. We have stopped new data from being written 
    there and are migrating the existing data to the rest of the filesystem. 

    The filesystem is still working and Young is still running jobs. We do not need you to take 
    any action at present, but things may be running more slowly while this completes.

  - 2024-09 Young's new filesystem is being readied for service.

#### Young new filesystem

  - 2024-09-27 - Young and Michael outage for new filesystem on Mon 7 Oct - action required

    We will be replacing the two filesystems on Young and Michael with one new filesystem on 
    **Monday 7 October 2024**. 
 
    Both clusters will go into maintenance on Monday 7 Oct 2024 from 09:00am. Logins will not be 
    possible until the maintenance is finished. Any jobs that won’t finish by the start of the 
    maintenance window will stay queued. We aim to finish the maintenance within one day, so that 
    you can access the clusters again on Tues 8 Oct.

    **Single login node outages between 2-4 Oct**

    From 2-4 October, Young `login02` and Michael `login11` will each be out of service for a day 
    during this period for testing updates before the filesystem migration. There will be no 
    interruption to jobs or logins to the general addresses `young.rc.ucl.ac.uk` and 
    `michael.rc.ucl.ac.uk`. If you are on `login02` or `login11` at the time, you may see a message 
    that it is about to go down for reboot, and if you have a tmux or screen session on that login 
    node then it will be terminated. You will be able to log back in and be assigned to the other 
    login node, Young `login01` or Michael `login10`.
 
    **Why the change:**
 
    * Young's filesystem is running on aging and error-prone hardware, and suffers from performance 
      issues, especially for interactive work on the login nodes. The new Lustre should provide a 
      vastly better experience.
    * Michael's filesystem is old and replacement parts are no longer available.
    * The new filesystem is a HPE ClusterStor Lustre filesystem and will enable both machines to keep 
      running in a supported and maintainable manner.
 
    **After the maintenance, you have the following storage locations:**
 
    * `/home/username`: your new home directory on the new Lustre; backed up
    * `/scratch/username`: your new scratch directory on the new Lustre; not backed up
    * `/old_lustre/home/username`: your old home directory on the old Lustre; read-only
    * `/old_lustre/scratch/username`: your old scratch directory on the old Lustre; read-only

    If you currently have accounts on both Young and Michael, you will need to log into Young to 
    see Young's `old_lustre` and into Michael to see Michael's `old_lustre`, but your home and 
    Scratch will be the same on both, and the data you copy into it will be visible on both.

    **Quotas**

    On the new filesystem we are able to set separate home and Scratch quotas. 

     * Home: 100G, backed up
     * Scratch: 250G by default

    Previously the default quota was 250G total.

    If you have an existing non-expired quota increase, we will increase your Scratch quota on 
    the new filesystem to this amount. If you find you need an increased Scratch quota, you can 
    run the `request_quota` command on either cluster and it will ask you for some information and 
    send us a support ticket.
 
    **What you will need to do (after the maintenance):**
 
    * After login, you will notice that your new home and scratch directories are mostly empty. 
      Please copy any data you need from your old home and scratch directories under `/old_lustre` to 
      the appropriate new locations. Your existing SSH keys will all have been copied in so that you 
      can log in. You can do this copy on the login nodes.
        - E.g. `cp -rp /old_lustre/home/username/data /home/username` will recursively copy with 
          preserved permissions your old `data` directory and everything in it into your new home.
    * You have **three months and one week** to copy your data. After this, the `/old_lustre` will 
      become unavailable.
    * Your queued jobs will be held (showing status `hqw` in qstat) and won’t start running 
      automatically, as their job scripts will likely refer to locations on `/lustre` which won’t 
      exist until you have copied over the data. After you have copied the data that your jobs 
      need to the new Lustre, you can release the hold on your queued jobs.
        - E.g. `qrls $JOB_ID` will release a specific job ID, and `qrls all` will release all your jobs.
        - Released array jobs will have the first task in status `qw` and the rest in `hqw` - this is normal.
    * Depending on the amount of data, the copying may take some time, especially if you have many 
      small files. If you wish to archive some of your data, consider creating tar archives straight 
      away instead of copying data recursively.
        - E.g. `tar -czvf /home/username/Scratch/myarchive.tar.gz /old_lustre/home/username/data` will 
          (c)reate a g(z)ipped archive (v)erbosely in the specified (f)ilename location. The contents 
          will be everything in this user's old `data` directory. 
 
    Further reminders will be sent before the `/old_lustre` locations are removed on **14 January 2025**.

    **Terms & Conditions update**

    We have updated our [Terms and Conditions for all services](https://www.rc.ucl.ac.uk/docs/Terms_and_Conditions/) 
    - please take a look. It now defines our data retention policies and when we can access your data, 
    among other things.
  
 
    These outages are listed on [Planned Outages](https://www.rc.ucl.ac.uk/docs/Planned_Outages/). 
    The information above will also be copied into the https://www.rc.ucl.ac.uk/docs/Status_page/ 
    sections for Young and Michael.
 
    Please email rc-support@ucl.ac.uk with any queries. 

    If you are no longer using Young or Michael and wish to be removed from these mailing lists, 
    email us confirming that we can delete your accounts and we will do so and remove you from the lists.

  - 2024-10-07 11:00 - **Delay in returning Young GPU nodes to service**

    In addition to the above, there may be a delay in allowing the GPU nodes in Young to run jobs again - 
    we need to rebuild the existing GPU software for those, to have it on an architecture-specific section 
    of our software stack. This will result in GPU jobs remaining in the queue while we complete this. I 
    would expect this to be complete by Wednesday or Thursday but will keep you updated.

  - 2024-10-08 13:30 - **Logins are enabled.**

    Logins are enabled again.

    We're continuing to rebuild the GPU applications on Young.

  - 2024-10-09 17:00 - **GPU nodes are enabled, plus FAQ**

  The GPU applications are rebuilt so we have re-enabled jobs on the GPU nodes. Please let us know if you 
  encounter any issues or if we have missed something.

  We found that we hadn't synced keys across for users created after 26 September so they could not log in 
  - this was sorted out at 10:20am today. It affected mmm1457 to mmm1463 on Young.

  **Some frequently-asked questions about the filesystem update:**

  1. Where is my old `.bashrc`? & Why are my jobs failing with module errors now?

     This is in `/old_lustre/home/username/.bashrc` 

     It begins with a dot and is a hidden file so will only show up with `ls -a` rather than `ls`. You can 
     copy this across into your current home again. You may have put module load and unload commands in it, 
     so are now getting module conflicts when your jobs run since the modules are the default ones.

     Note that this also applies to other hidden files or directories you may have, like `.condarc` and `.python3local`.

  2. Do I need to copy my data in a job?

     No, you can do the copy on the login nodes. It can cause a lot of I/O usage on the login nodes so you 
     could also do it in a job if you wanted or if you noticed that it was going slowly, but using the login 
     nodes for this is allowed.

  3. I need more than the 100G home quota and 250G Scratch quota for my data, what do I do?

     Home is your backed-up area and is limited in size. Scratch is not backed up and also not deleted and we 
     can give you more space there. Run the `request_quota` command and it will ask you a few questions and send 
     us the request. We migrated all quota increases that were made within the last 12 months to Scratch 
     increases and did not migrate older ones. This allows us to make sure that the quota increases are current 
     and still needed. We are processing the new requests.

  4. Where should I write large temporary data during my jobs?

     Into Scratch. As above, you can request a larger quota if you need one. (If you are using the GPU nodes, 
     you can use `$TMPDIR` and request it with `#$ -l tmpfs=20G` for example, but the GPU nodes are the only 
     ones with local disks so everything else needs to be in Scratch).


### Michael

  - 2024-01-24 16:40 - Problem on Michael's admin nodes causing DNS failures - now solved

    We have been having DNS problems on Michael today since around 14:40, meaning that scheduler 
    commands were not working and running jobs may have errors, including failed username lookups. 
    New jobs trying to start during this time are likely to have failed on start up. Running jobs 
    may have been affected, so please check the outputs for any jobs that were running during 14:40 
    to 16:30 today.

    This was caused by a problem on the admin nodes that has now been sorted out.

  - 2024-09 Michael's new filesystem (shared with Young) is being readied for service.

#### Michael new filesystem

  - 2024-09-27 - Young and Michael outage for new filesystem on Mon 7 Oct - action required

    We will be replacing the two filesystems on Young and Michael with one new filesystem on
    **Monday 7 October 2024**.

    Both clusters will go into maintenance on Monday 7 Oct 2024 from 09:00am. Logins will not be
    possible until the maintenance is finished. Any jobs that won’t finish by the start of the
    maintenance window will stay queued. We aim to finish the maintenance within one day, so that
    you can access the clusters again on Tues 8 Oct.

    **Single login node outages between 2-4 Oct**

    From 2-4 October, Young `login02` and Michael `login11` will each be out of service for a day
    during this period for testing updates before the filesystem migration. There will be no
    interruption to jobs or logins to the general addresses `young.rc.ucl.ac.uk` and
    `michael.rc.ucl.ac.uk`. If you are on `login02` or `login11` at the time, you may see a message
    that it is about to go down for reboot, and if you have a tmux or screen session on that login
    node then it will be terminated. You will be able to log back in and be assigned to the other
    login node, Young `login01` or Michael `login10`.

    **Why the change:**

    * Young's filesystem is running on aging and error-prone hardware, and suffers from performance
      issues, especially for interactive work on the login nodes. The new Lustre should provide a
      vastly better experience.
    * Michael's filesystem is old and replacement parts are no longer available.
    * The new filesystem is a HPE ClusterStor Lustre filesystem and will enable both machines to keep
      running in a supported and maintainable manner.

    **After the maintenance, you have the following storage locations:**

    * `/home/username`: your new home directory on the new Lustre; backed up
    * `/scratch/username`: your new scratch directory on the new Lustre; not backed up
    * `/old_lustre/home/username`: your old home directory on the old Lustre; read-only
    * `/old_lustre/scratch/username`: your old scratch directory on the old Lustre; read-only

    If you currently have accounts on both Young and Michael, you will need to log into Young to
    see Young's `old_lustre` and into Michael to see Michael's `old_lustre`, but your home and
    Scratch will be the same on both, and the data you copy into it will be visible on both.

    **Quotas**

    On the new filesystem we are able to set separate home and Scratch quotas.

     * Home: 100G, backed up
     * Scratch: 250G by default

    Previously the default quota was 250G total.

    If you have an existing non-expired quota increase, we will increase your Scratch quota on
    the new filesystem to this amount. If you find you need an increased Scratch quota, you can
    run the `request_quota` command on either cluster and it will ask you for some information and
    send us a support ticket.

    **What you will need to do (after the maintenance):**

    * After login, you will notice that your new home and scratch directories are mostly empty.
      Please copy any data you need from your old home and scratch directories under `/old_lustre` to
      the appropriate new locations. Your existing SSH keys will all have been copied in so that you
      can log in. You can do this copy on the login nodes.
        - E.g. `cp -rp /old_lustre/home/username/data /home/username` will recursively copy with
          preserved permissions your old `data` directory and everything in it into your new home.
    * You have **three months and one week** to copy your data. After this, the `/old_lustre` will
      become unavailable.
    * Your queued jobs will be held (showing status `hqw` in qstat) and won’t start running
      automatically, as their job scripts will likely refer to locations on `/lustre` which won’t
      exist until you have copied over the data. After you have copied the data that your jobs
      need to the new Lustre, you can release the hold on your queued jobs.
        - E.g. `qrls $JOB_ID` will release a specific job ID, and `qrls all` will release all your jobs.
        - Released array jobs will have the first task in status `qw` and the rest in `hqw` - this is normal.
    * Depending on the amount of data, the copying may take some time, especially if you have many
      small files. If you wish to archive some of your data, consider creating tar archives straight
      away instead of copying data recursively.
        - E.g. `tar -czvf /home/username/Scratch/myarchive.tar.gz /old_lustre/home/username/data` will
          (c)reate a g(z)ipped archive (v)erbosely in the specified (f)ilename location. The contents
          will be everything in this user's old `data` directory.

    Further reminders will be sent before the `/old_lustre` locations are removed on **14 January 2025**.

    **Terms & Conditions update**

    We have updated our [Terms and Conditions for all services](https://www.rc.ucl.ac.uk/docs/Terms_and_Conditions/)
    - please take a look. It now defines our data retention policies and when we can access your data,
    among other things.


    These outages are listed on [Planned Outages](https://www.rc.ucl.ac.uk/docs/Planned_Outages/). 
    The information above will also be copied into the https://www.rc.ucl.ac.uk/docs/Status_page/ 
    sections for Young and Michael.

    Please email rc-support@ucl.ac.uk with any queries.

    If you are no longer using Young or Michael and wish to be removed from these mailing lists,
    email us confirming that we can delete your accounts and we will do so and remove you from the lists.

  - 2024-10-08 13:30 Logins are enabled.

    Logins are enabled again.


### Thomas

  - Thomas is now retired.

