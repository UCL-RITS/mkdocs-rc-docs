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

## Managing shared spaces

If you have applied for a shared space/hosted dataset on the cluster, there are several ways to 
manage access to that data.

The best way to manage it will depend on the numbers of people you expect to be giving access to, how 
much those are likely to change, and what permissions they will need on the data.

### Location

* `/lustre/projects`
* `/shared/ucl/depts` - this is a symbolic link to the above

The top-level directory of the space is given the short name you requested. I will refer to the
nonexistent `/lustre/projects/SharedExample` below.

### Permissions 

If you run `ls -al /lustre/projects` then the directories in there may look like this:

```
drwxr-sr-x   3 ccspapp ccsp       4096 Aug 30 14:00 SharedExample
```

Those letters at the front show the permissions. The `d` shows it is a directory, and then there are 
three groups of three characters, for `user`, `group` and `other` (everyone on the cluster). Then it 
has the username who owns that directory `ccspapp` and the group that owns that directory `ccsp`. By 
default, this would be the departmental group of the owning user, which contains a subset of the 
usernames beginning with the same letters, and is not generally a useful group to use for access 
management.

The first three characters after the `d` are `rwx`, so the user `ccspapp` has read, write and execute 
permissions. (Execute permissions on a directory are necessary to be able to list what is inside it).

The next three are the permissions for the group that owns it, which is currently `ccspapp`'s 
departmental group `ccsp`. It has `r-s` which means read, no write, and that new files created in it 
will have the same group ownership as the directory does, and that the group has execute permissions. 
If it did not, it would show as `S`. The `s` and `S` permissions are referred to as `setgid`. So the 
`ccsp` group can read the data and look inside directories.

Finally, the last three are `r-x` for other, which means that the rest of the people on the cluster have 
read and execute permissions and can look inside this space. If your dataset has no restrictions, this is 
fine, otherwise you will want to restrict these permissions.

#### Summary of permissions

* `d` - this is a directory
* `[user][group][other]` - this is the order of the `rwx` trios.
* `r` - this entity has read access
* `w` - this entity has write access
* `x` - this entity has execute access, or search access for directories
* `s` - only in the `group` trio, in the execute position. This indicates that the same group identity will be set for newly created files, plus the group has execute permissions
*  `S` - only in the `group` trio, in the execute position. Indicates the same as `s` but the group does not have execute permissions
* `-` - this entity does not have this access
* `+` - this may show after the trios and indicates that Unix ACLs have been set

#### Modifying permissions

This is done with the `chmod` command.

```
chmod -R o+rX /lustre/projects/SharedExample/data
```

This would recursively give read and execute permissions to `other` (`o`) on a `data` directory inside 
`SharedExample` and everything it contained. (They would only be able to access it if they had 
permissions on `/lustre/projects/SharedExample` as well).

* `u` - change permissions for `user`
* `g` - change permissions for `group`
* `o` - change permissions for `other` (everyone)
* `-R` is for recursive, so all files and directories inside there are changed too
* `+` - add these permissions to this entity
* `-` - remove these permissions from this entity
* `X` - only give execute permission if another entity already has it - this prevents everything being made executable

See `man chmod` for details. 

Permissions can also be given as numbers (octal digits from 0-7) so you may have seen `chmod 700` for 
example which gives `user` read (4), write (2), and execute (1) and no permissions to anyone else.

### Managing access using Unix ACLs:

If you have a small number of people you want to give access to (less than 24) then you can use 
Unix ACLs to manage who has access. This lets you add and remove people yourself and takes effect
instantly. You can also adjust these on a per-directory or per-file basis, if some people need to 
be able to write to the space as well as just reading what is in it.

Downsides: it can be more complicated to maintain the correct permissions across the whole space,
particularly if multiple people are creating data in the space. It is also harder to see at a glance
who has which permissions on what. There is a maximum number of users who can be added.

There is a tutorial on Unix ACLs at [TACC Unix ACL tutorial](https://docs.tacc.utexas.edu/tutorials/acls/). 
You have the `getfacl` and `setfacl` commands to view and change the ACLs that are set on a directory 
or file.

#### Giving read and execute permissions with ACLs

Giving read and execute permissions to `ccspap2` on the top-level directory with Unix ACLs would look 
like this and that user could then see inside the directory:

```
setfacl -m u:ccspap2:rx /lustre/projects/SharedExample
```

`ls -al` will then have a `+` at the end, indicating the existence of an ACL:

```
drwxr-sr-x+  3 ccspapp ccsp       4096 Aug 30 14:00 SharedExample
```

The ACL can be viewed using `getfacl`.

```
getfacl /lustre/projects/SharedExample
getfacl: Removing leading '/' from absolute path names
# file: lustre/projects/SharedExample
# owner: ccspapp
# group: ccsp
# flags: -s-
user::rwx
user:ccspap2:r-x
group::r-x
other::r-x
```

`user:ccspap2:r-x` is the added item. This user already had those permissions, but we could have
given write access instead.

It is simplest to only restrict the permissions at the top level directory if possible - no one else 
can see inside to get to anything else, so for data that you put inside there, it is fine to have it 
readable for `other` further in because everyone else on the cluster cannot get inside that directory 
in the first place, and this means you don't need to keep changing permissions on individual items inside 
there.

A combination of `setfacl` and `chmod` is needed to set the permissions as you require them.

#### Removing ACLs

`setfacl --remove-all` will remove all the additional accesses you have added on a file or directory, 
and you can also do that recursively.

### Managing access using groups:

If there are going to be more people involved, you will need a central group to manage access to the 
space. At present this would be named something like `lgsh050` and rc-support would need to add people 
to it or remove them from it, which would at present only update overnight. So the owner of the space 
will need to tell us who should be added or removed.

Groups can make permissions management easier since you can use `chmod`'s `setgid` mentioned above to
preserve the group permissions. There may still be some issues managing data if other users have been 
allowed to create directories and have not given the owner write access to alter them later.

Recursively change the group owning this space and everything inside it.
```
chgrp -R lgsh050 /lustre/projects/SharedExample
```

Set the group permissions to what you want, this recursively gives it read and execute on everything
in the space, and non-recursively removes just the top-level permissions for `other` so they can no 
longer see inside:
```
chmod -R g+rX /lustre/projects/SharedExample
chmod o-rwx /lustre/projects/SharedExample
```

The space's permissions would now look like this.

```
drwxr-s---   3 ccspapp lgsh050       4096 Aug 30 14:00 SharedExample
```

Again, it is simplest to only restrict the permissions at the top level directory if possible. 
