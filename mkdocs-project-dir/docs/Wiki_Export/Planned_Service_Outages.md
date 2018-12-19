---
title: Planned Service Outages
layout: docs
---
Below is the list of planned outages, partial or otherwise, which
Research Computing Platforms will have to undergo for service
improvements or due to external dependencies, such as data centre
infrastructural works.

  - Date: specifies the period of time during which the outage is
    expected to take place.

  - Service Impact: details the Service and specific hardware affected by the
    outage.

  - Comments: provides additional information such as details about how
    the service will be affected and advice.

| Date | Service Impact | Comments |
|:----:|:--------------:|:---------|
| Thurs 24 May 2018 | Legion partial outage | Node types LMNOQSUY will be drained for 8am for work to take place on the power to the racks in TP3 datacentre. Node types XPTVZ will be running jobs. This work is not expected to take all day. |
| Tues 10 - Thurs 12 Apr 2018 | Thomas full outage | Update of Lustre firmware. Jobs will be drained for 8am on 10th and the cluster will be out of service for that day, login nodes included. Possibility of overrun and 13th should be considered at risk. Outage extended by one day as a member of staff was required on site in the datacentre. |
| Tues 27 - Weds 28 Feb 2018 | Thomas full outage | Update of Lustre firmware. Jobs will be drained for 8am on 27th and the cluster will be out of service for that day, login nodes included. Possibility of overrun and 28th should be considered at risk. ''(This was rescheduled to April due to strike action.)'' |
| Fri 17 Nov - Mon 20 Nov 2017 | Legion partial outage | All the L, M, N, O, P, S, U and Y nodes are draining for 3pm on Friday 17th November so nodes and infrastructure currently in Wolfson House datacentre can be moved back out. Login08 is also being moved. We will attempt to have everything back online during Monday. |
| Weds 27 Sept - Mon 2 Oct 2017 | Grace outage | Our vendors need to replace some hardware components and run further tests. Grace will be unavailable for submissions or data access from 08:00 on Wed 27th Sep 2017. The service will be restored at or before 10:00 on Mon 02 Oct 2017. Following this, Intel expect to issue a permanent firmware fix within two months, likely requiring a further downtime period.  |
| 31 July 2017 | Grace queue lengths and outage | Another outage is required for OCF to replace the broken cable. Mon 31st July will be an all-day outage. Full-length jobs will be running over the weekend. |
| Thurs 20 July 2017 | Grace outage | Grace is being drained on the 19th so OCF can swap a cable that has problems. This work is expected to be finished at some point in the afternoon. There is likely to be another day's outage at a later date to replace it - we do not have details at present. |
| Thurs 22 June 2017 | Legion outage | We will be updating the firmware of Legion's Lustre metadata controller. Jobs are being drained and Legion will be down entirely for the morning and at risk in the afternoon. |
| Thurs 15 June 2017 | Thomas outage | Thomas will have a brief outage in the morning for us to reconfigure it to have no link to Grace's Infiniband. Home directories are being moved (data is being rsynced to Thomas' Lustre). The queues are being drained in preparation. |
| Weds 14 - Thurs 15 June 2017 | Grace outage | Grace is down today in preparation to reconfigure the Infiniband network so there is no link to Thomas, which we believe is causing the problems. We will bring Grace back up later on Thursday and hopefully the issues will be resolved. |
| Weds 17 May 2017 | Grace and Thomas outage | A faulty module is being replaced in a Grace switch. The queues have been drained so jobs are not running. This should allow the subset of Grace nodes that are still down to be brought back into use. |
| Mon 8 May 2017 | Grace and Thomas outage | Cables needed to be switched in order for the work intended for the previous outage to be carried out, and the switch has been done. The queues are being drained for 10am and will be re-enabled as soon as we know no further work needs to be carried out. Jobs will run over the weekend but will not start if they do not have time to finish. |
| Thurs 4 - Fri 5 May 2017 | Grace and Thomas outage | Our vendors are doing some work on the network equipment in Grace (we narrowed down the Infiniband problems to specific switches). Jobs on Grace and Thomas are drained. Thomas login nodes will not be available. |
| Thurs 27 April 2017 | Grace and Thomas outage | We are investigating intermittent Infiniband problems on Grace and jobs have been drained for today. We cannot guarantee that the login nodes will remain available. (Thomas is still in pilot, but this may also make home directories inaccessible for parts of the day and affect running jobs).  |
| Sun 26th - Tues 28th Feb 2017 | Legion outage | We are replacing the NFS file servers on Legion with upgraded ones and as a result there is a planned outage from 5PM Sunday 26th Feb until morning Tuesday 28th Feb. You will be unable to log into the service, existing logins will be logged out and jobs will not be running during the outage. The service should be considered "at risk" for the rest of the 28th. |
| Weds 7th - Fri 9th Dec 2016 | Grace outage | Due to some remedial work dating back to the last Grace upgrade and preparation for the coming deployment of the Tier 2 materials centre it is necessary to have a three day outage of the Grace service to adjust the configuration of the storage. There will be no access during this time. |
| Fri 18 Nov - Tues 22 Nov 2016 | Legion reduced service | The TXYZ nodes will be up and running, but all other nodes will be down during this time as they need to be moved. They may be back as early as Monday lunchtime, but we cannot guarantee this and they could be unavailable until end of day on Tuesday 22nd November. |
| Mon 26 Sept - Weds 28 Sept 2016 | Legion outage | This is to update Lustre firmware. The system should be considered at risk on the 29th and 30th after this. Legion login nodes will be unavailable from the morning of Monday 26th. If you are going to need any of your data during this time, please remember to copy it elsewhere before the outage, as there will be no access during this time. This will also mean a service interruption for the Research Software Development "Jenkins" service, which depends on Legion. |
| Mon 11 July - Tues 30 August 2016 | Grace expansion outage | Grace will taken out of service for this period in order to be undertake an expansion and upgrade of the compute, storage and interconnect fabric of the machine. These works will provide an additional 324 nodes (5,184 cores), a doubling in storage (scratch and home) and an InfiniBand network capable of scaling to circa 1000 nodes. This will effectively double the capacity of Grace in the short term and provide a much easier pathway for future expansions of the system. We have discussed the length of the outage, and potential options for mitigating this, with the Computational Resource Allocation Group. However, both the CRAG and Research IT Services members agree that the need to take a single long outage is the right decision in this instance given the breadth and complexity of the work that needs to be undertaken. We will be providing additional information, progress updates and any actions required from users prior to and during the system outage via the grace-users mailing list. |
| Thurs 12 May 2016 | Grace outage | There will be an all-day network outage at Slough so Grace will be down all day and not running jobs. |
| Mon 9 May 2016 | Legion outage | We are draining jobs for Monday so we can install updates to fix a kernel bug. |
| Mon 18 - Thurs 21 April 2016 | Legion outage | Legion will be unavailable while we do some updates, test Lustre and enable Scratch quotas. It should be considered at risk for the rest of the week.  Update: Work still ongoing on Thurs 21. |
| Fri 1 April 2016 | Login05 outage | The dedicated transfer node login05 will be re-imaged with the new Legion OS so will not be available for data transfer for part of the day. |
| Thurs 11 Feb 2016, 8-9am | Grace connectivity at risk | Network routing tests to Slough are being done between 8-9am. There may be some issues connecting to Grace during that window. |
| Mon 29 - Tues 30 June 2015 | Legion outage | Legion will be unavailable while we replace an NFS controller and re-enable Lustre quotas. Weds 1 July should be considered at risk. |
| Tues 5 - Thurs 7 May 2015 | Legion outage | Legion will be unavailable while we carry out a necessary software update to the parallel file system. The service should also be considered at risk on Fri 8 May. |
| Mon 9 - Tues 10 Mar 2015 | login05 outage | Legion's dedicated transfer node, login05, will be unavailable from 10am on March 10th so we can move it to a new datacentre. It won't allow new logins after 10am on March 9th.  |
| Mon 19th Jan to Weds 21st Jan 2015 | Legion outage | Legion will be down while we update the Lustre firmware. The 22nd and 23rd should also be considered at risk. |
| Fri 29th Nov to Mon 1st Dec 2014 | Legion outage | Wolfson House Data Centre shutdown for remedial work to be carried out by Estates. |
| Midday Fri 31st Oct to Mon 10th Nov 2014 | Complete outage of Legion while electrical testing is done at Torrington Place data centre.  | During this time we also intend to move the remaining core infrastructure for Legion to the Torrington Place datacentre so that we avoid being affected by planned outages at the other datacentre later this year.  |


