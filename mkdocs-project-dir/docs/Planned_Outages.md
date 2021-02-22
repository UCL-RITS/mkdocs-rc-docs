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
23 Feb 2021 8-9:30am | Young | Planned | Gold and job submission expected to be unavailable for two 10-min periods while network switches upgraded.

## Previous Outages

Date                | Service | Status | Reason 
--------------------|---------|--------|--------
09 Feb 2021 8-1pm   | Young   | Completed | Gold and job submission outage while we migrate our database server.
08 Jan 2021 -> 12 Jan 2021 | Kathleen | Completed | Electrical work in datacentre. Logins delayed until Tues morning while tests completed.
08 Jan 2021 -> 12 Jan 2021 | MMM Michael | Completed | Electrical work in datacentre. Logins delayed until Tues morning while tests completed.
08 Jan 2021 -> 12 Jan 2021 | MMM Young | Completed | Electrical work in datacentre. Logins delayed until Tues morning while tests completed.
02 Jul 2020 -> 09 Jul 2020 | Michael | Rollback | Lustre software upgrade to fix bug. Full outage, no access. Upgrade was unusable, downgrading to previous.
01 May 2020 -> 11 May 2020 | Myriad | Completed | Storage upgrade.
20 Mar 2020 -> 30 Mar 2020 | Myriad | Stopped, Postponed | Issues found with new storage during outage. Myriad returned to service 24th. Sync data; switch to new storage. (Important: new metadata servers). Begins midday. Full outage, no access.
16 Mar 2020 -> (was 23) 26 Mar 2020 | Michael | Completed | Firmware upgrades to bridge old and new networks. Extended to get jobs working on new nodes.
2 Mar 2020 -> 9 Mar 2020 | Michael | Completed | Installation of phase 2 hardware, network bridging
10 Feb 2020 -> 17 Feb 2020 | Myriad | Cancelled | Storage upgrade to 3PB

## Retirements

These clusters are being retired. Notable dates are below.

Grace:

- 1st February 2021: Job submission will be switched off. Jobs still in the queue will run. Access to the login nodes will remain for three months so you can recover your data.
- 3rd May 2021: Access to the login nodes will be removed and all data will be deleted.

Thomas:

- Monday 1 March 2021: Job submission will be switched off this morning. Jobs already in the queue may still run. Access to the login nodes will remain for one month so you can retrieve data.
- Friday 5 March 2021: Queues will be drained. Any jobs left will never run.
- Thursday 1 April 2021: Access to the login nodes will be removed and all data will be deleted.

