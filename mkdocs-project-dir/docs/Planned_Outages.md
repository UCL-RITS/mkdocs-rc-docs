---
layout: docs
---

# Planned Outages

The second Tuesday of every month is a maintenance day, when the following clusters should be considered at risk from 8:00AM: Myriad, Kathleen, Thomas, Young, Michael, Aristotle and the Data Science Platform. We won’t necessarily perform maintenance every month, and notice by email will not always be given about maintenance day work that only puts services at risk.

Full details of outages are emailed to the cluster-specific user lists. 

Generally speaking, an outage will last from the morning of the first date listed until mid-morning of the end date listed. The nodes may need to be emptied of jobs in advance ('drained'), so jobs may remain in the queue for longer before an outage begins.

If there is a notable delay in bringing the system back we will contact you after approximately midday - please don't email us at 9am on the listed end days!

After an outage, the first day or two back should be considered 'at risk'; that is, things are more likely to go wrong without warning and we might need to make adjustments.

Date                | Service | Status | Reason 
--------------------|---------|--------|--------
14 Sept 2021        | Myriad  | Planned | Queues drained for 8am so that the central software installs can be redistributed over more servers. This is to help mitigate the effects of current filesystem issues.

## Previous Outages

Date                | Service | Status | Reason 
--------------------|---------|--------|--------
03 Aug 2021     | Young, Michael | Completed | Shortly after 8am: ~10 mins Gold outage for security updates. New job submission and Gold commands will not work during this.
12 July 2021        | Myriad  | Completed | Drain of d97a (Economics) nodes for 8am to update network config. May require less than the full day. Jobs will remain in queue until drain is over or run on other nodes if they can.
15 Jun 2021 -> 18 Jun 2021 | Myriad | Completed | Datacentre network outage. No jobs will run on the 15th, and Myriad will be at risk for the rest of the week.
14 Jun 2021 | Kathleen, Young and Data Science Platform | Completed | Datacentre network outage 8.30-9am. No login access and no jobs will run.
08 Jun 2021 | Thomas | Completed | Storage will be at risk during an essential controller reboot.
22 May 2021 -> 24 May 2021 | Michael | Completed | Datacentre network outage. Queues to be drained. Full outage, no access.
22 May 2021 -> 24 May 2021 | Young | Completed | Gold and job submission expected to be unavailable while database uncontactable due to datacentre network outage.
22 May 2021 -> 24 May 2021 | Myriad and Kathleen | Completed | Gold (i.e. high priority) job submission expected to be unavailable while database uncontactable due to datacentre network outage.
29 Mar 2021 -> 30 Mar 2021 | Myriad | Completed | A number of GPU nodes will be reserved for the [NVidia AI Bootcamp](https://t.co/Moqa1evelh) on the 29th and 30th March. Some users may experience longer than usual waiting times for GPUs, from Monday the 22nd until after the event, especially for long jobs.  We apologise for any inconvenience this may cause.
30 Mar 2021 | Kathleen | Completed | Essential Lustre filesystem maintenance. Queue draining starts 26th March, SSH access to login nodes disabled on the 30th. Full outage, no access.
23 Feb 2021 8-9:30am | Young | Completed | Gold and job submission expected to be unavailable for two 10-min periods while network switches upgraded.
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


