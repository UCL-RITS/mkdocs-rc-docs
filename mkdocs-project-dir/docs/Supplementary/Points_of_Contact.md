---
title: MMM Points of Contact
layout: docs
---

## User management tools

This page contains tools and information for the nominated Points of
Contact.

Other system-specific information is at 
[Michael](../Clusters/Michael.md) or 
[Young](../Clusters/Young.md).

These commands can all be run as 
`michael-command` or
`young-command`:
they run the same thing and the different names are for convenience.

### Displaying user information

`young-show`, `michael-show` or `young-show` is a tool that enables you to find a lot
of information about users. Access to the database is given to points of
contact individually, contact rc-support@ucl.ac.uk if you try to use
this and get an access denied.

At the top level, `--user` shows all information for one user, in
multiple tables. `--contacts` shows all points of contact - useful for
getting the IDs, and `--institutes` is the same. `--allusers` will show
everyone's basic info. `--getmmm` will show the most recently used mmm
username.

```
young-show -h  
usage: young-show [-h] [--user username] [--contacts] [--institutes]  
                  [--allusers] [--getmmm]  
                  {recentusers,getusers,whois} ...

Show data from the Young database. Use [positional argument -h] for more  
help.

positional arguments:  
 {recentusers,getusers,whois}  
   recentusers         Show the n newest users (5 by default)  
   getusers            Show all users with this project, institute, contact  
   whois               Search for users matching the given requirements

optional arguments:  
 -h, --help            show this help message and exit  
 --user username       Show all current info for this user  
 --contacts            Show all allowed values for contact  
 --institutes          Show all allowed values for institute  
 --allusers            Show all current users  
 --getmmm              Show the highest mmm username used
```

#### Show recent users

`young-show recentusers` shows you the
most recently-added N users, default 5.

```
young-show recentusers -h  
usage: young-show recentusers [-h] [-n N]

optional arguments:  
 -h, --help  show this help message and exit  
 -n N
```

#### Show users with a given project, institute, contact

`young-show getusers` will search for exact
matches to the given project, institute, contact combination.

```
young-show getusers -h  
usage: young-show getusers [-h] [-p PROJECT] [-i INST_ID] [-c POC_ID]

optional arguments:  
 -h, --help            show this help message and exit  
 -p PROJECT, --project PROJECT  
                       Project name  
 -i INST_ID, --institute INST_ID  
                       Institute ID  
 -c POC_ID, --contact POC_ID  
                       Point of Contact ID
```

#### Search for users based on partial information

`young-show whois` can be used to search for
partial matches to username, name, email fragments, including all of
those in combination.

```
young-show whois -h  
usage: young-show whois [-h] [-u USERNAME] [-e EMAIL] [-n GIVEN_NAME]  
                        [-s SURNAME]

optional arguments:  
 -h, --help            show this help message and exit  
 -u USERNAME, --user USERNAME  
                       UCL username of user contains  
 -e EMAIL, --email EMAIL  
                       Email address of user contains  
 -n GIVEN_NAME, --name GIVEN_NAME  
                       Given name of user contains  
 -s SURNAME, --surname SURNAME  
                       Surname of user contains
```

### Adding user information and new projects

`young-add` will add information to the database.
Access to the database is given to points of contact individually,
contact rc-support@ucl.ac.uk if you try to use this and get an access
denied.

Please note that all options have a `--debug` flag that will allow you
to see the query generated without committing the changes to the
database - double-check that the information you are adding is
correct.

```
young-add -h  
usage: young-add [-h] {user,project,projectuser,poc,institute} ...

Add data to the Young database. Use [positional argument -h] for more help.

positional arguments:  
 {user,project,projectuser,poc,institute}  
   csv                 Add all users from the provided CSV file
   user                Adding a new user with their initial project  
   project             Adding a new project  
   projectuser         Adding a new user-project-contact relationship  
   poc                 Adding a new Point of Contact  
   institute           Adding a new institute/consortium

optional arguments:  
 -h, --help            show this help message and exit
```

#### Add a new user

`young-add user` allows you to add a new user,
with their initial project and point of contact. As of 27 June 2022 this now goes 
ahead and creates their account automatically within 10 minutes - first prompting you 
that the information you have entered is correct. You do not need to email us separately 
about creating accounts unless something has gone wrong. The user's initial project
must already exist (create with `young-add project` first).

The user will be allocated the next free `mmmxxxx` username - you should 
only specify username yourself if they are an existing UCL user, or on
Young if they previously had a Michael account you should give
them the same username. If they already have an account on this cluster with
a different institution, just add them as a projectuser instead using their 
existing username.

You can get your `poc_id` by looking at `young-show --contacts`.

```
young-add user -h  
usage: young-add user [-h] -u USERNAME -n GIVEN_NAME [-s SURNAME] -e  
                      EMAIL_ADDRESS -k "SSH_KEY" -p PROJECT_ID -c POC_ID  
                      [--debug]

optional arguments:  
 -h, --help            show this help message and exit  
 -u USERNAME, --user USERNAME  
                       UCL username of user  
 -n GIVEN_NAME, --name GIVEN_NAME  
                       Given name of user  
 -s SURNAME, --surname SURNAME  
                       Surname of user (optional)  
 -e EMAIL_ADDRESS, --email EMAIL_ADDRESS  
                       Institutional email address of user  
 -k "SSH_KEY", --key "SSH_KEY"  
                       User's public ssh key (quotes necessary)  
 -p PROJECT_ID, --project PROJECT_ID  
                       Initial project the user belongs to  
 -c POC_ID, --contact POC_ID  
                       Short ID of the user's Point of Contact  
 --noconfirm           Don't ask for confirmation on user account creation
 --verbose             Show SQL queries that are being submitted  
 --debug               Show SQL query submitted without committing the change
```

##### SSH key formats

It will verify the provided ssh key by default. Note that it has to be
in the form `ssh-xxx keystartshere`. If someone has sent in a key which
has line breaks and header items, make it into this format by adding the
key type to the start and removing the line breaks from the key body.

This key:

```
---- BEGIN SSH2 PUBLIC KEY ----  
Comment: "comment goes here"  
AAAAB3NzaC1yc2EAAAABJQAAAQEAlLhFLr/4LGC3cM1xgRZVxfQ7JgoSvnVXly0K  
7MNufZbUSUkKtVnBXAOIjtOYe7EPndyT/SAq1s9RGZ63qsaVc/05diLrgL0E0gW+  
9VptTmiUh7OSsXkoKQn1RiACfH7sbKi6H373bmB5/TyXNZ5C5KVmdXxO+laT8IdW  
7JdD/gwrBra9M9vAMfcxNYVCBcPQRhJ7vOeDZ+e30qapH4R/mfEyKorYxrvQerJW  
OeLKjOH4rSnAAOLcEqPmJhkLL8k6nQAAK3P/E1PeOaB2xD7NNPqfIsjhAJLZ+2wV  
3eUZATx9vnmVF0YafOjvzcoK2GqUrhNAvi7k0f+ihh8twkfthj==  
---- END SSH2 PUBLIC KEY ----
```

should be converted into
```
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlLhFLr/4LGC3cM1xgRZVxfQ7JgoSvnVXly0K7MNufZbUSUkKtVnBXAOIjtOYe7EPndyT/SAq1s9RGZ63qsaVc/05diLrgL0E0gW+9VptTmiUh7OSsXkoKQn1RiACfH7sbKi6H373bmB5/TyXNZ5C5KVmdXxO+laT8IdW7JdD/gwrBra9M9vAMfcxNYVCBcPQRhJ7vOeDZ+e30qapH4R/mfEyKorYxrvQerJWOeLKjOH4rSnAAOLcEqPmJhkLL8k6nQAAK3P/E1PeOaB2xD7NNPqfIsjhAJLZ+2wV3eUZATx9vnmVF0YafOjvzcoK2GqUrhNAvi7k0f+ihh8twkfthj==
```

Other types of keys (ed25519 etc) will say what they are in the first line,
and you should change the `ssh-rsa` appropriately. The guide linked at
[Creating an ssh key in
Windows](../Clusters/Young.md#creating-an-ssh-key-in-windows)
also shows where users can get the second format out of PuTTY.

#### Add new users in bulk from a CSV file

`young-add csv` allows you to add users in bulk using a CSV file of specific format 
and headers. As of 27 June 2022 the accounts will be all created and activated 
automatically within 10 minutes.

The CSV is comma-separated with a header line of 
```
email,given_name,surname,username,project_ID,ssh_key
```
You can leave username empty for it to allocate them a new username, but if 
they have an existing mmm username you should fill it in. 
It may be useful to [show users with a given institute](#show-users-with-a-given-project-institute-contact) on Young if you are migrating users from one service to another.

You can [download a CSV template here](MMM_Hub_Files/young.csv). Replace the
example data.

`young-add csv` will try to automatically get your Point of Contact ID based on
your username. If it can't, or if you have more than one, it will give you a 
list to choose from. (All users in one CSV upload will be added using the
same Point of Contact ID). 

It will prompt you for confirmation on each user account creation unless you give
the `--noconfirm` option.

The project you are adding the user to must already exist.

The SSH key must be formatted as shown in [SSH key formats](#ssh-key-formats).

If you check your CSV file on the cluster with `cat -v` and it shows that it is 
beginning with `M-oM-;M-?` and ending with `^M` you probably need to run 
`dos2unix` on it first.

#### Add a new project

`young-add project` will create a new project,
associated with an institution. It will not show in Gold until it also
has a user in it.

A project ID should begin with your institute ID, followed by an
underscore and a project name.

```
young-add project -h  
usage: young-add project [-h] -p PROJECT_ID -i INST_ID [--debug]

optional arguments:  
 -h, --help            show this help message and exit  
 -p PROJECT_ID, --project PROJECT_ID  
                       A new unique project ID  
 -i INST_ID, --institute INST_ID  
                       Institute ID this project belongs to  
 --debug               Show SQL query submitted without committing the change
```

#### Add a new project/user pairing

`young-add projectuser` will add an
existing user to an existing project. Creating a new user for an
existing project also creates this relationship. After a new
project-user relationship is added, a cron job will pick that up within
15 minutes and create that project for that user in Gold, with no
allocation.

```
young-add projectuser -h  
usage: young-add projectuser [-h] -u USERNAME -p PROJECT_ID -c POC_ID  
                             [--debug]

optional arguments:  
 -h, --help            show this help message and exit  
 -u USERNAME, --user USERNAME  
                       An existing UCL username  
 -p PROJECT_ID, --project PROJECT_ID  
                       An existing project ID  
 -c POC_ID, --contact POC_ID  
                       An existing Point of Contact ID  
 --debug               Show SQL query submitted without committing the change
```

### Deactivating information

This tool is only partly functional at present. It allows you to deactivate 
(not delete) some entities that may no longer exist or may have been created
in error.

#### Deactivate a projectuser

Use this when the user should no longer be a member of the given project. It
does not deactivate the user account, just their membership in this project.
You can confirm the change by looking at `young-show --user` - it will say 
'deactivated' rather than 'active' next to their listing for this project.

```
young-deactivate projectuser -h
usage: young_deactivate.py projectuser [-h] -u USERNAME -p PROJECT [--debug]

optional arguments:
  -h, --help            show this help message and exit
  -u USERNAME, --user USERNAME
                        An existing username
  -p PROJECT, --project PROJECT
                        An existing project ID
  --debug               Show SQL query submitted without committing the change
```


## Gold resource allocation

We are currently using Gold to manage allocations.
The Michael and Young clusters use separate databases for this, so projects
on one will not appear on the other.

### Reporting from Gold

There are wrapper scripts for a number of Gold commands (these exist in
the `userscripts` module, loaded by default).

These are all set to report in cpu-hours with the `-h` flag, as that is
our main unit. If you wish to change anything about the wrappers, they
live in `/shared/ucl/apps/cluster-scripts/` so you can take a copy and
add your preferred options.

They all have a `--man` option to see the man pages for that command.

Here are some basic useful options and what they do. They can all be
given more options for more specific
searches.

```
gusage -p project_name [-s start_time]  # Show the Gold usage per user in this project, in the given timeframe if specified.  
gbalance                                # Show the balance for every project, split into total, reserved and available.  
glsuser                                 # Shows all the users in Gold.  
glsproject                              # Shows all the projects and which users are in them.  
glsres                                  # Show all the current reservatioms, inc user and project. The Name column is the SGE job ID.  
gstatement                              # Produce a reporting statement showing beginning and end balances, credits and debits.

# Less useful commands  
glstxn                                  # Show all Gold transactions. Filter or it will take forever to run.  
glsalloc                                # Show all the allocations.
```

These can be run by any user. The date format is YYYY-MM-DD.

Eg. `gstatement -p PROJECT -s 2017-08-01` will show all credits and
debits for the given project since the given date, saying which user and
job ID each charge was associated with.

### Transferring Gold

As the point of contact, you can transfer Gold from your allocation
account into other project accounts. As before, we've put `-h` in the
wrapper so it is always working in cpu-hours.

```
gtransfer --fromProject xxx_allocation --toProject xxx_subproject cpu_hours
```

You can also transfer in the opposite direction, from the subproject
back into your allocation account.

Note that you are able to transfer your allocation into another
institute's projects, but you cannot transfer it back again - only the
other institute's point of contact (or rc-support) can give it back, so
be careful which project you specify.

#### When two allocations are active

There is now an overlap period of a week when two allocations can be
active. By default, `gtransfer` will transfer from active allocations in
the order of earliest expiring first. To transfer from the new
allocation only, you need to specify the allocation id.

```
gtransfer -i allocation_ID --fromProject xxx_allocation --toProject xxx_subproject cpu_hours
```

`glsalloc -p xxx_allocation` shows you all allocations that ever existed for your institute, 
and the first column is the id.

```
Id  Account Projects              StartTime  EndTime    Amount     Deposited  Description      
--- ------- --------------------- ---------- ---------- ---------- ---------- --------------   
87  38      UKCP_allocation       2017-08-07 2017-11-05 212800.00 3712800.00  
97  38      UKCP_allocation       2017-10-30 2018-02-04 3712800.00 3712800.00
```

