---
title: Accessing RC Systems
categories:
 - User Guide
 - Legion
 - Myriad
 - Grace
 - Aristotle
layout: docs
---
# Accessing RC Systems

After you have [applied for and been granted access to our services](Account_Services), you can log in using a terminal
application that supports the ssh access protocol.

Aristotle is a teaching machine accessible to everyone with a UCL user
ID and does not need to be applied for.

## Logging in from Linux or Mac OS X

Use the terminal and run the below command to ssh into the correct
machine. Replace `ccaaxyz` with your central UCL username.

### Legion

```
ssh ccaaxyz@legion.rc.ucl.ac.uk
```

### Myriad

```
ssh ccaaxyz@myriad.rc.ucl.ac.uk
```

### Grace

```
ssh ccaaxyz@grace.rc.ucl.ac.uk
```

### Aristotle

```
ssh ccaaxyz@aristotle.rc.ucl.ac.uk`
```

You will then be asked to enter your UCL password. This user ID and
password are those provided to you by [Information Services Division](http://ucl.ac.uk/isd).

If you will want to run graphical applications, read on to "Running
graphical applications using X-forwarding".

## Logging in from Windows

On Windows you need something that will give you a suitable terminal and
ssh - usually PuTTY, although you could also use Cygwin if you wanted a
full Linux-like environment.

### Using PuTTY

PuTTY is a common SSH client on Windows and is available on Desktop@UCL.
You can find it under Start \> All Programs \> Applications O-P \> PuTTY

You will need to create an entry for the host you are connecting to with
the settings below. If you want to save your settings, give them an
easily-identifiable name in the "Saved Sessions" box and press "Save".
Then you can select it and "Load" next time you use PuTTY.

Replace "legion" in the hostname with "myriad", "grace", or "aristotle"
as appropriate.

![Putty GUI](/img/putty_gui.png "Putty GUI")

You will then have a screen come up that asks you for your username and
password. Only enter your username, not "@legion.rc.ucl.ac.uk". The
password field will remain entirely blank when you enter it - it does
not show placeholders to indicate you have typed something.

## Login problems

If you experience difficulties with your login, please make sure that
you are typing your UCL user ID and your password correctly.

If you still cannot get access but can access other UCL services like
Socrates, please contact us on <rc-support@ucl.ac.uk>.

If you cannot access anything, please see [UCL MyAccount](https://myaccount.ucl.ac.uk) - you may need to request a
password reset from the Service Desk.

## Accessing services from outside UCL

If you wish to access any of our machines from outside UCL, you cannot
do so directly as they are behind UCL's firewall. To do so you will have
to either use ssh to connect to UCL's gateway first:

```
ssh ccaaxyz@socrates.ucl.ac.uk
```

and from there connect to the correct host as described above, or login
first to your departmental gateway (if you have one) and then login from
there.

### IS VPN Service

Alternatively, you can use the [IS VPN service](http://www.ucl.ac.uk/isd/staff/network/vpn) to connect to UCL
using a virtual private network. That way, once the connection has been
established, you can establish an ssh connection to the host machine
directly, for example:

```
ssh ccaaxyz@legion.rc.ucl.ac.uk
```

## Running graphical applications using X-forwarding

X-forwarding allows users to run a graphical program on a remote
computer and display the user interface on their own computer.

### X-forwarding on Linux

If you wish to have X-windows functionality enabled you have to make
sure that you add either the -X or -Y flags (see man ssh for details) on
all ssh commands you have to run to establish a connection to Legion.

For example, connecting from outside of UCL:

```
ssh -X ccaaxyz@socrates.ucl.ac.uk
```

and then

```
ssh -X ccaaxyz@legion.rc.ucl.ac.uk
```

### X-forwarding on Mac OS X

You will need to install XQuartz to provide an X-Window System for Mac
OS X. (Previously known as X11.app).

You can then follow the Linux instructions using Terminal.app.

### X-forwarding on Windows

You will need:

  - An SSH client; e.g., PuTTY
  - An X server program; e.g., Exceed, Xming

Exceed is available on Desktop@UCL machines and downloadable from the
[UCL software database](http://swdb.ucl.ac.uk/). Xming is open source
(and mentioned here without testing).

#### Exceed on Desktop@UCL

1.  Load Exceed. You can find it under Start \> All Programs \>
    Applications O-P \> Open Text Exceed 14 \> Exceed
2.  Open PuTTY (Applications O-P \> PuTTY)
3.  In PuTTY, set up the connection with the host machine as usual:
    1.  Host name: legion.rc.ucl.ac.uk (for example)
    2.  Port: 22
    3.  Connection type: SSH
4.  Then, from the Category menu, select Connection \> SSH \> X11 for
    'Options controlling SSH X11 forwarding'
    1.  Make sure the box marked 'Enable X11 forwarding' is checked.
5.  Return to the session menu and save these settings with a new
    identifiable name for reuse in future.
6.  Click 'Open' and login to the host as usual
7.  To test that X-forwarding is working try one of these test
    applications:
    1.  nedit: a text editor
    2.  xeyes: to bring up a set of eyes that track the mouse position
        on the screen
    3.  glxgears: to bring up an animated set of gears
    4.  xclock: a clock

If these work, you have successfully enabled X forwarding for graphical
applications. (Note they may not be available on all systems).

#### Installing Xming on your own computer

Xming is a popular open source X server for Windows. These are
instructions for using it alongside PuTTY. Other SSH clients and X
servers are available. We cannot verify how well it may be working.

1.  Install both PuTTY and Xming if you have not done so already. During
    Xming installation, choose not to install an SSH client.
2.  Open Xming - the Xming icon should appear on the task bar.
3.  Open PuTTY
4.  Set up PuTTY as shown in the Exceed section.

## Transferring files

Read on to [Managing data on RC systems](Managing_Data_on_RC_Systems).

