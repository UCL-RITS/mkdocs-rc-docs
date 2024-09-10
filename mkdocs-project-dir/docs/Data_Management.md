---
title: Data Management
categories:
- User Guide
layout: docs
---

# Data Management

Our clusters have local [parallel filesystems](Background/Parallel_Filesystems.md) and may also
have the [ARC Cluster File System (ACFS)](Background/Data_Storage.md) available.

## Checking quotas

The amount of storage you can use on the cluster is limited by a quota.

### Local filesystem quota

Check your quota and usage for home and Scratch with the `lquota` command.

### ACFS quotas

Check your ACFS quota and usage with the `aquota` command.

The ACFS has dual locations for resilience, and as a result commands like `du -h` or `ls -alsh` 
will report filesizes on it as being twice what they really are. The `aquota` command will show you 
real usage and quota.  


## Giving files to another user

If both users are active and on the same cluster, you can give files to them. 
[Walkthrough: Giving Files to Another User](Walkthroughs/Giving_Files.md)

## Transferring data ownership

### Requesting transfer of your data to another user

If you want to transfer ownership of all your data on a service to another user, with their consent, 
you can contact us at rc-support@ucl.ac.uk and ask us to do this. Please arrange this while you still 
have access to the institutional credentials associated with the account. Without this, we cannot 
identify you as the owner of the account. 

You will need to tell us what data to transfer, on what cluster, and the username of the recipient.

### Requesting data belonging to a user who has left

If a researcher you were working with has left and has not transferred their data to you before 
leaving there is a general UCL Data Protection process to gain access to that data.

At [UCL Information Security Policy](https://www.ucl.ac.uk/information-security/information-security-policy) 
go to Monitoring Forms and take a copy of Form MO2 "Form MO2 - Request for Access to Stored Documents 
and Email - long-term absence or staff have left". (Note, it is also applicable to students). 

Follow the guidance on that page for how to encrypt the form when sending it to them. The form needs 
to be signed by the head of department/division and the UCL data protection officer 
(data-protection@ucl.ac.uk).
