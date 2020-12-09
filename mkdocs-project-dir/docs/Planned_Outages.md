---
layout: docs
---

# Planned Outages

Full details of outages are emailed to the cluster-specific user lists. 

Generally speaking, an outage will last from the morning of the first date listed until mid-morning of the end date listed. The nodes may need to be emptied of jobs in advance ('drained'), so jobs may remain in the queue for longer before an outage begins.

If there is a notable delay in bringing the system back we will contact you after approximately midday - please don't email us at 9am on the listed end days!

After an outage, the first day or two back should be considered 'at risk'; that is, things are more likely to go wrong without warning and we might need to make adjustments.

Date                | Service | Status | Reason 
--------------------|---------|--------|--------
08 Jan 2020 -> 11 Jan 2020 | Kathleen | Planned | Electrical work in datacentre.
08 Jan 2020 -> 11 Jan 2020 | MMM Michael | Planned | Electrical work in datacentre.
08 Jan 2020 -> 11 Jan 2020 | MMM Young | Planned | Electrical work in datacentre.


## Previous Outages

Date                | Service | Status | Reason 
--------------------|---------|--------|--------
02 Jul 2020 -> 09 Jul 2020 | Michael | Rollback | Lustre software upgrade to fix bug. Full outage, no access. Upgrade was unusable, downgrading to previous.
01 May 2020 -> 11 May 2020 | Myriad | Completed | Storage upgrade.
20 Mar 2020 -> 30 Mar 2020 | Myriad | Stopped, Postponed | Issues found with new storage during outage. Myriad returned to service 24th. Sync data; switch to new storage. (Important: new metadata servers). Begins midday. Full outage, no access.
16 Mar 2020 -> (was 23) 26 Mar 2020 | Michael | Completed | Firmware upgrades to bridge old and new networks. Extended to get jobs working on new nodes.
2 Mar 2020 -> 9 Mar 2020 | Michael | Completed | Installation of phase 2 hardware, network bridging
10 Feb 2020 -> 17 Feb 2020 | Myriad | Cancelled | Storage upgrade to 3PB

## Grace status

Returned to service 19 Nov 2020!

Here is the explanation for the long downtime. As of 2 Sept:

"As you will be aware, we have not yet been able to return Grace to service after the hack. 
Most recently, we've run into some challenging issues with the aging infiniband network 
that we are still working our way through, hampered somewhat by issues getting to Slough 
under the current regime.

We would advise all users migrate to using Kathleen (as Grace was due to be retired in 
January 2021 anyway). To aid in this we've set up the login nodes such that it read-only 
mounts the home and scratch file-systems so that you can retrieve your files.

As usual please send any queries to rc-support@ucl.ac.uk"

Since Grace has read-only access, you cannot edit or delete data. You also cannot submit jobs.
If you had a Grace account, you already have a Kathleen account. Grace might not run any more
jobs before it is retired.

