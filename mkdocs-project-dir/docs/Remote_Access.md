---
title: Remote Access to Research Computing Resources
layout: docs
---
# Remote Access to Research Computing Resources

UCL's Research Computing services are accessible from inside the UCL firewall.  If you wish to connect from outside, you need to either connect through a VPN or use SSH to log in to a machine accessible from outside and use that to "jump" through into the UCL network.

Previously the recommended host for doing this was Socrates. Due to the degree to which this service is overloaded due to the prevailing pandemic increasing its use, ISD has built a new set of "jump" boxes which are designed to be fast, scalable and secure for access to Research Computing services.

## Connecting to the new jump boxes

You can connect to the new jump boxes by connecting with your SSH client to:

```
ssh.rc.ucl.ac.uk
```

Once connected you can then log on to the UCL RC service you are using as normal.

You can configure your ssh client to automatically connect via these jump boxes so that you make the connection in one step.

### Single-step logins using tunnelling

#### Linux / Unix / Mac OS X

##### On the command line
```
# Log in to Grace, jumping via Socrates
ssh -o ProxyJump=ssh.rc.ucl.ac.uk grace.rc.ucl.ac.uk
```
or
```
# Copy 'my_file' from the machine you are logged in to into your Scratch on Grace
scp -o ProxyJump=ssh.rc.ucl.ac.uk my_file grace.rc.ucl.ac.uk:~/Scratch/
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
   proxyCommand ssh -W <remote_hostname>:22 <remote_user_id>@ssh.rc.ucl.ac.uk
```
This causes the commands you type in your client to be forwarded on over a secure channel to the specified remote host.

Here are some examples - you can have as many of these as you need in your config file.
```
Host myriad
   User ccxxxxx
   HostName myriad.rc.ucl.ac.uk
   proxyCommand ssh -W myriad.rc.ucl.ac.uk:22 ccxxxxx@ssh.rcucl.ac.uk

Host login05
   User ccxxxxx
   HostName login05.external.legion.ucl.ac.uk
   proxyCommand ssh -W login05.external.legion.ucl.ac.uk:22 ccxxxxx@ssh.rc.ucl.ac.uk

Host aristotle
   User ccxxxxx
   HostName aristotle.rc.ucl.ac.uk
   proxyCommand ssh -W aristotle.rc.ucl.ac.uk:22 ccxxxxx@ssh.rc.ucl.ac.uk
```

You can now just type `ssh myriad` or `scp file1 aristotle:~` and you will go through Socrates. You'll be asked for login details twice since you're logging in to two machines, Socrates and your endpoint.  


## File storage

The jump boxes have extremely limited file storage space, intentionally, and should not be used for storing files - if you need to transfer files you should use the two-step process above.  This storage should only be used for SSH configuration files.

This storage is not mirrored across the jump boxes which means if you write a file to your home directory, you will not be able to read it if you are allocated to another jump box next time you log in.


## Key management

If you use SSH keys you absolutely **MUST NOT STORE UNENCRYPTED PRIVATE KEYS ON THIS OR ANY OTHER MULTI-USER COMPUTER**.  We will be running regular scans of the filesystem to identify and then block unencrypted public keys across our services.

There are currently two servers in the pool, `ejp-gateway01` and `ejp-gateway02`. 

Because the `/home` filesystem is not shared across the jump boxes, you need to sync SSH configuration files like `~/.ssh/authorized_keys` across all the available jump boxes so that the change takes effect whichever jump box you are allocated to.

You can see which machine you are logged into by the bash prompt.

So for example, if on `ejp-gateway02` then do:

```console
[ccaathj@ad.ucl.ac.uk@ejp-gateway02 ~]$ scp -r ~/.ssh ejp-gateway01:

Password:
known_hosts 100% 196 87.1KB/s 00:00
authorized_keys 100% 0 0.0KB/s 00:00
[ccaathj@ad.ucl.ac.uk@ejp-gateway02 ~]$
```

and similarly if on `ejp-gateway01` do `scp -r ~/.ssh ejp-gateway02:`

