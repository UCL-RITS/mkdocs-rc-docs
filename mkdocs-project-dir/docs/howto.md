# How do I?

I have an account, now:

## How do I log in?

Logging in is most straightforward if you are inside the UCL firewall. If you are logging in from home or other external networks then you first have to [get on to the UCL network](#logging-in-from-outside-the-ucl-firewall).

### Linux / Unix / Mac OS X

Use the terminal and type the below command to secure shell (ssh) into the machine you wish to access. Replace `<your_UCL_user_id>` with your central UCL username, and `<system_name>` with the name of the machine you want to log in to, eg. `legion`, `grace`, `aristotle`. 

```
ssh <your_UCL_user_id>@<system_name>.rc.ucl.ac.uk
```

### Windows

On Windows you need something that will give you a suitable terminal and ssh - usually PuTTY, although you could also use Cygwin if you wanted a full Linux-like environment.

#### Using PuTTY

PuTTY is a common SSH client on Windows and is available on Desktop@UCL. You can find it under: `Start > All Programs > Applications O-P > PuTTY`

You will need to create an entry for the host you are connecting to with the settings below. If you want to save your settings, give them an easily-identifiable name in the "Saved Sessions" box and press "Save". Then you can select it and "Load" next time you use PuTTY. 

![PuTTY screenshot](img/putty_gui.png)

In newer versions of PuTTY, it looks like this.

*TODO: new putty*

You will then be asked to enter your username and password. Only enter your username, not `@legion.rc.ucl.ac.uk`. The password field will remain entirely blank when you type in to it - it does not show placeholders to indicate you have typed something. 

### Logging in from outside the UCL firewall

You will need to either use the [UCL Virtual Private Network](http://www.ucl.ac.uk/isd/staff/network/vpn) or ssh in to UCL's gateway `socrates.ucl.ac.uk` first. From Socrates you can then ssh in to our systems by typing `ssh <your_UCL_user_id>@<system_name>.rc.ucl.ac.uk`. 

**Advanced:** If you find you need to go via Socrates often, you can set up this jump automatically, see [Single-step logins using tunnelling](#single-step-logins-using-tunnelling)


### Login problems

If you experience difficulties with your login, please make sure that you are typing your UCL user ID and your password correctly. If you have recently updated your password, it takes some hours to propagate to all UCL systems.

If you still cannot get access but can access other UCL services like Socrates, please contact us on rc-support@ucl.ac.uk. Your account may have expired, or you may have gone over quota.

If you cannot access anything, please see UCL MyAccount - you may need to request a password reset from the Service Desk. 

If you get a host key error message, you will need to delete old host keys. *TODO: details*


## How do I transfer data onto the system?

You can transfer data to and from our systems using any program capable of using the Secure Copy (SCP) protocol. This uses the same SSH system as you use to log in to a command line session, but then transfers data over it. This means that if you can use SSH to connect to a system, you can usually use SCP to transfer files to it. 

### Copying files using Linux or Mac OS X

You can use the command-line utilities scp, sftp or rsync to copy your data about. You can also use a graphical client (Transmit, CyberDuck, FileZilla).

#### scp

This will copy a data file from somewhere on your local machine to a specified location on the remote machine (Legion, Grace etc).

```
scp <local_data_file> <remote_user_id>@<remote_hostname>:<remote_path>
```
```
# Example: copy myfile from your local current directory into Scratch on Legion
scp myfile ccxxxxx@legion.rc.ucl.ac.uk:~/Scratch/
```

This will do the reverse, copying from the remote machine to your local machine. (This is still run from your local machine).

```
scp <remote_user_id>@<remote_hostname>:<remote_path><remote_data_file> <local_path>
```
```
# Example: copy myfile from Legion into the Backups directory in your local current directory
scp ccxxxxx@legion.rc.ucl.ac.uk:~/Scratch/myfile Backups/
```

#### sftp

You can use sftp to log in to the remote machine, navigate through directories and use `put` and `get` to copy files from and to your local machine. `lcd` and `lls` are local equivalents of `cd` and `ls` so you can navigate through your local directories as you go. 

```
sftp <remote_user_id>@<remote_hostname>
cd <remote_path>
get <remote_file>
lcd <local_path>
put <local_file>
```
```
# Example: download a copy of file1 into your local current directory,
# change local directory and upload a copy of file2
sftp ccxxxxx@legion.rc.ucl.ac.uk
cd Scratch/files
get file1
lcd ../files_to_upload
put file2
```

#### rsync

Rsync is used to remotely synchronise directories, so can be used to only copy files which have changed. Have a look at `man rsync` as there are many options. 

### Copying files using Windows and WinSCP

WinSCP is a graphical client that you can use for scp or sftp.

 1. The login/create new session screen will open if this is the first time you are using WinSCP.
 2. You can choose SFTP or SCP as the file protocol. If you have an unstable connection with one, you may wish to try the other. SCP is probably generally better.
 3. Fill in the hostname of the machine you wish to connect to, your username and password.
 4. Click Save and give your settings a useful name.
 5. You'll then be shown your list of Stored sessions, which will have the one you just created.
 6. Select the session and click Login.

### Transferring files from outside the UCL firewall

As when logging in, when you are outside the UCL firewall you will need a method to connect inside it before you copy files. (You do not want to be copying files on to Socrates and then on to our systems - this is slow, unnecessary, and it means you need space available on Socrates too).

You can use the [UCL Virtual Private Network](http://www.ucl.ac.uk/isd/staff/network/vpn) and scp direct to our systems or you can do some form of ssh tunnelling.


### Single-step logins using tunnelling

#### Linux / Unix / Mac OS X

##### On the command line
```
# Log in to Grace, jumping via Socrates
ssh -o ProxyJump=socrates.ucl.ac.uk grace.rc.ucl.ac.uk

# copy 'my_file' from the machine you are logged in to into your Scratch on Grace
scp -o ProxyJump=socrates.ucl.ac.uk my_file grace.rc.ucl.ac.uk:~/Scratch/
```

This tunnels through Socrates in order to get you to your destination - you'll be asked for your password twice, once for each machine. You can use this to log in or to copy files.

You may also need to do this if you are trying to reach one cluster from another and there is a firewall in the way.

##### Using a config file

You can create a config which does this without you needing to type it every time.

Inside your `~/.ssh` directory on your local machine, add the below to your `config` file (or create a file called `config` if you don't already have one).

Generically, it should be of this form where `<name>` can be anything you want to call this entry.

```
Host <name>
   User <remote_user_id>
   HostName <remote_hostname>
   proxyCommand ssh -W <remote_hostname>:22 <remote_user_id>@socrates.ucl.ac.uk
```
This causes the commands you type in your client to be forwarded on over a secure channel to the specified remote host.

Here are some examples - you can have as many of these as you need in your config file.
```
Host myriad
   User ccxxxxx
   HostName myriad.rc.ucl.ac.uk
   proxyCommand ssh -W myriad.rc.ucl.ac.uk:22 ccxxxxx@socrates.ucl.ac.uk

Host login05
   User ccxxxxx
   HostName login05.external.legion.ucl.ac.uk
   proxyCommand ssh -W login05.external.legion.ucl.ac.uk:22 ccxxxxx@socrates.ucl.ac.uk

Host aristotle
   User ccxxxxx
   HostName aristotle.rc.ucl.ac.uk
   proxyCommand ssh -W aristotle.rc.ucl.ac.uk:22 ccxxxxx@socrates.ucl.ac.uk
```

You can now just type `ssh myriad` or `scp file1 aristotle:~` and you will go through Socrates. You'll be asked for login details twice since you're logging in to two machines, Socrates and your endpoint.  

#### Windows - WinSCP

WinSCP can also set up SSH tunnels.

 1. Create a new session as before, and tick the Advanced options box in the bottom left corner.
 2. Select Connection > Tunnel from the left pane.
 3. Tick the Connect through SSH tunnel box and enter the hostname of the gateway you are tunnelling through, for example socrates.ucl.ac.uk
 4. Fill in your username and password for that host. (Central UCL ones for Socrates).
 5. Select Session from the left pane and fill in the hostname you want to end up on after the tunnel.
 6. Fill in your username and password for that host and set the file protocol to SCP.
 7. Save your settings with a useful name.

#### Windows - PuTTY

You can use PuTTY for tunnelling when you just want a single-step login and not a file transfer.


### Managing your quota

After using `lquota` to see your total usage, you may wish to find what is using all your space.

`du` is a command that gives you information about your disk usage. Useful options are:

```
du -ch <dir>
du -h --max-depth=1
```

The first will give you a summary of the sizes of directory tree and subtrees inside the directory you specify, using human-readable sizes with a total at the bottom. The second will show you the totals for all top-level directories relative to where you are, plus the grand total. These can help you track down the locations of large amounts of data if you need to reduce your disk usage.


## How do I submit a job to the scheduler?

To submit a job to the scheduler you need to write a jobscript that contains the resources the job is asking for and the actual commands you want to run. This jobscript is then submitted using the `qsub` command.

```
qsub myjobscript
```

It will be put in to the queue and will begin running on the compute nodes at some point later when it has been allocated resources.

### Passing in qsub options on the command line

The `#$` lines in your jobscript are options to qsub. It will take each line which has `#$` as the first two characters and use the contents beyond that as an option. 

You can also pass options directly to the qsub command and this will override the settings in your script. This can be useful if you are scripting your job submissions in more complicated ways.

For example, if you want to change the name of the job for this one instance of the job you can submit your script with:
```
qsub -N NewName myscript.sh
```

Or if you want to increase the wall-clock time to 24 hours:
```
qsub -l h_rt=24:0:0 myscript.sh
```

You can submit jobs with dependencies by using the `-hold_jid` option. For example, the command below submits a job that won't run until job 12345 has finished:
```
qsub -hold_jid 12345 myscript.sh
```

You may specify node type with the `-ac allow=` flags as below: 
```
qsub -ac allow=XYZ myscript.sh
```
That would restrict the job to running on nodes of type X, Y or Z (the older Legion nodes).

Note that for debugging purposes, it helps us if you have these options inside your jobscript rather than passed in on the command line whenever possible. We (and you) can see the exact jobscript that was submitted for every job that ran but not what command line options you submitted it with.

### Checking your previous jobscripts

If you want to check what you submitted for a specific job ID, you can do it with the `scriptfor` utility.
```
scriptfor 12345
```
As mentioned above, this will not show any command line options you passed in.

## How do I monitor a job?

### qstat

The `qstat` command shows the status of your jobs. By default, if you run it with no options, it shows only your jobs (and no-one else’s). This makes it easier to keep track of your jobs. 

The output will look something like this:
```
job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID 
-----------------------------------------------------------------------------------------------------------------
123454 2.00685 DI_m3      ccxxxxx      Eqw   10/13/2017 15:29:11                                    12 
123456 2.00685 DI_m3      ccxxxxx      r     10/13/2017 15:29:11 Yorick@node-x02e-006               24 
123457 2.00398 DI_m2      ucappka      qw    10/12/2017 14:42:12                                    1 
```

This shows you the job ID, the numeric priority the scheduler has assigned to the job, the name you have given the job, your username, the state the job is in, the date and time it was submitted at (or started at, if it has begun), the head node of the job, the number of 'slots' it is taking up, and if it is an array job the last column shows the task ID.

The queue name (`Yorick` here) is generally not useful. The head node name (`node-x02e-006`) is useful - the `node-x` part tells you this is an X-type node. 

If you want to get more information on a particular job, note its job ID and then use the -f and -j flags to get full output about that job. Most of this information is not very useful.
```
qstat -f -j 12345
```

#### Job states

 `qw`: queueing, waiting
 `r`: running
 `Rq`: a pre-job check on a node failed and this job was put back in the queue
 `Rr`: this job was rescheduled but is now running on a new node
 `Eqw`: there was an error in this jobscript. This will not run.
 `t`: this job is being transferred
 `dr`: this job is being deleted

Many jobs cycling between `Rq` and `Rr` generally means there is a dodgy compute node which is failing pre-job checks, but is free so everything tries to run there. In this case, let us know and we will investigate. 

If a job stays in `t` or `dr` state for a long time, the node it was on is likely to be unresponsive - again let us know and we'll investigate.

A job in `Eqw` will remain in that state until you delete it - you should first have a look at what the error was with `qexplain`.

### qexplain

This is a utility to show you the non-truncated error reported by your job. `qstat -j` will show you a truncated version near the bottom of the output.

```
qexplain 123454
```

### qdel

You use `qdel` to delete a job from the queue.

```
qdel 123454
```

You can delete all your jobs at once:
```
qdel '*'
```

### More scheduler commands

Have a look at `man qstat` and note the commands shown in the `SEE ALSO` section of the manual page. Exit the manual page and then look at the `man` pages for those. (You will not be able to run all commands).

### nodesforjob

This is a utility that shows you the current 

## How do I run a graphical program?
