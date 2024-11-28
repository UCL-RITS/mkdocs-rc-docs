---
title: Additional Resource Requests
categories:
 - Legion
 - Myriad
 - Grace
layout: docs
---
# Additional Resource Requests

We recognise that researchers may sometimes require a higher throughput
of work than it is possible to achieve with free ‘fair share’ usage of
[Myriad](Clusters/Myriad.md) and [Kathleen](Clusters/Kathleen.md).
There a couple of ways of obtaining additional Myriad resources
beyond this fair share:

## Make a special request to the CRAG for free access to additional resources

Users who wish to request additional resources or reserve resources
beyond those provided can complete the additional resource request form
in collaboration with your supervisor or the project's principal
investigator. This includes requests for increased storage quotas.

The completed form should be sent to the Research Computing Platforms
team at <mailto:rc-support@ucl.ac.uk>, for technical review. If successful,
your case will be presented to the
[CRAG](http://www.ucl.ac.uk/isd/about/governance/research-it/crag) for
consideration at the next meeting of the Group. The
[CRAG](http://www.ucl.ac.uk/isd/about/governance/research-it/crag) meets
monthly, usually on the second Tuesday of the month, and users will be
informed of the Group’s decision as soon as possible after their next
meeting.

Note that an application to the
[CRAG](http://www.ucl.ac.uk/isd/about/governance/research-it/crag) for
additional resources is only likely to be approved if the impact on
other users is not deemed to be significant, or of long duration.

  - [Additional resource request form](Additional_Resource_Requests/CRAG_additional_resources_request_form.rtf)
  - *NB:* Myriad's filesystem is still very full (replacement due March 2025) and so
    we need more detail for requests, plus your plan for removal of the data once your 
    quota increase ends. We will be considering requests in batches and comparing to
    space left. All granted requests will expire at the end of March 2025 or Myriad
    refresh date, whichever is earliest, and will require reapplication for the new 
    filesystem.


### Examples of requests

 - Increased Scratch quota - tell us how much, for what purpose and how long you'll need it. Also
   tell us in brief your plan for removal of the data once your quota increase ends.
    - Once implemented, `lquota` will show the new quota.
 - Longer wallclock limit
    - Consider whether you can checkpoint and restart your job: that is, write out everything that
      you need for a second job to begin where the previous one finished. Running multiple shorter
      jobs one after the other is more robust since if anything goes wrong you lose less work. If
      this is not possible for your jobs, explain why. 
    - Please note that we cannot guarantee that longer jobs will not be interrupted by planned
      outages or maintenance periods. We try not to, but sometimes it is unavoidable.
    - Include details on what resources one job is likely to require, how many of those jobs you
      expect to need to run, and over what time period you'll need access to longer jobs. 
    - If granted, you will be given access to the `crag5day` project for example, and by adding
      `#$ -P crag5day` to your jobscript you will be able to request a longer wallclock time than 
      usual for that job.

## Request hosting of shared datasets

We have provision for hosting shared datasets for users on Myriad. These
can be datasets that are freely accessible by all users, or ones limited
to groups.

Hosted datasets:

  - Will not be backed up.
  - Must have a named primary contact.
  - Must be reapplied for every 12 months to make sure they are still
    current and required.
  - Will have an associated quota.
  - Will be removed when renewal lapses (notice will be given).

They are likely to be managed by a role account - access to the role
account will be by ssh key.

To apply for a hosted dataset, please send this form to
<rc-support@ucl.ac.uk>.

  - [Hosted dataset request form](Additional_Resource_Requests/Hosted_dataset_request_form.rtf)

## Purchase dedicated compute nodes or priority cycles on Myriad

Researchers may purchase additional resources to be used as part of the [Myriad](Clusters/Myriad.md) High Performance Computing cluster if the free service does not meet their needs. See Paid-for resources: [Purchasing in Myriad](Paid-For_Resources/Purchasing_in_Myriad.md) for details.

## Further information

For further advice or information on future hardware options, please
contact [rc-support@ucl.ac.uk](mailto:rc-support@ucl.ac.uk).
