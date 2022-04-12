---
layout: docs
---

Here are walkthroughs showing all the steps to get logged in to one of our clusters
from computers with different operating systems.

These instructions assume you have already [applied for an account](../Account_Services.md) 
and received the email saying it has been created and that you can log in.

We use Myriad as the cluster we are logging in to. The same steps also apply to Kathleen.

To log in, you need an SSH client to be installed on the computer you are logging in
from. 

## Logging in from Windows

There are several choices of SSH client for Windows, with one now included in the
Windows Command Prompt on Windows 10 or later. You can also log in via 
Desktop@UCL Anywhere, which provides a Windows environment inside the UCL network.

### PuTTY

PuTTY will provide you with a graphical interface to configure your SSH connection and then
open a terminal window you can type into and press return to submit.

### Windows Command Prompt

Launch the Command Prompt from the Windows Start menu. It will give you a prompt that
you can type commands into. 

Replace "uccacxx" with your own central UCL username.

```
ssh uccacxx@socrates.ucl.ac.uk
```

![SSH to Socrates](../img/socrates/win_01.png)

If your computer has never connected to Socrates before, it has no existing record of the 
host fingerprint for Socrates which identifies it, so it will ask if you want to accept it 
and continue.

Type "yes" to accept the fingerprint. It will save it and check it next time. If the 
fingerprint is different, it can be an indication that something else is pretending to
be Socrates (or that it has changed after a major update). If concerned, contact 
rc-support@ucl.ac.uk or the main Service Desk.

![Accept host fingerprint](../img/socrates/win_02.png)

It now informs you that it has added Socrates to your list of known hosts.

You have now contacted Socrates and it displays a small splash screen and asks for your
UCL password. Nothing will show up when typing in this box - no placeholders or bullet
point characters. Press return at the end to submit.

![Type password](../img/socrates/win_03.png)

If you have a typo in your password or have changed it within the last couple of hours
and the new one hasn't propagated yet, it will ask again.

Once the correct password has been entered, it will show you a longer message about
the system.

The prompt on Socrates looks like a number followed by a `%` - this does not mean that you 
are 15% logged in and need to wait, it is just some characters to start off the line.

From Socrates, we want to ssh in to Myriad:

```
ssh uccacxx@myriad.rc.ucl.ac.uk
```

![On Socrates, SSH into Myriad](../img/socrates/win_04.png)

Your user on Socrates will also not have connected to Myriad before, so you will get a 
similar prompt about Myriad's host fingerprint. You can check this against 
[our current key fingerprints](../Supplementary/Hostkeys.md).

After saying "yes" you will be prompted for your password again, and after typing it in
you will be logged in to Myriad and see Myriad's message containing information about
the system and where to get help.

![Welcome from Myriad](../img/socrates/win_05.png)

At the bottom you can see that the prompt on Myriad looks like

```
[uccacxx@login13 ~]$
```

It shows you your username, which Myriad login node you are on, and where you are 
(`~` is a short way to reference your home directory). You can now look at what software
is available and write jobscripts.

### Desktop@UCL Anywhere

You can log in to this from a web browser or download a Citrix client. Once logged in,
Desktop@UCL is inside the UCL network so we can log straight into a cluster with no need
for a gateway machine or VPN.

You can use PuTTY or the Windows Command Prompt on Desktop@UCL Anywhere to log in to Myriad. 
It has a version of the Command Prompt called "SSH Command Prompt" that may set up some 
additional configuration for SSH usage - either should work.


