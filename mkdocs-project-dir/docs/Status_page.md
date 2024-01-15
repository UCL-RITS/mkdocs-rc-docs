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

#### Latest on Myriad

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
    .txt files the \n has been replaced by the string `__NEWLINE__`, and an additional .bin file 
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

### Kathleen

  - 2024-01 No current issues. Parallel filesystem soon to be replaced.

### Young

  - 2023-10-26 14:50 - We seem to have a dying OmniPath switch in Young. The 32 nodes with names 
    beginning `node-c12b` lost their connection to the filesystem earlier. Powercycling the switch 
    only helped temporarily before it went down again. Those nodes are all currently out of service 
    so new jobs will not start on them, but if your job was running on one of those when the two 
    failures happened those jobs will have failed.

    (You can see in `jobhist` what the head node of a job was, and the .po file will show all the 
    nodes that an MPI job ran on).

  - 2024-01 Parallel filesystem soon to be replaced.

### Michael

  - All systems are working well.

### Thomas

  - Thomas is now retired.

