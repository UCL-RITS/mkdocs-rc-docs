---
title: X-Forwarding
layout: docs
---

X is a system and protocol that lets remote computers push interactive windows to your local computer over a network. We use a method known as X-Forwarding, together with an SSH client, to direct the network messages for X over the same connection you use for the command-line.

The setup steps for getting this working on Windows, Linux, and macOS are each different, and we've put them below.

## Windows

Windows doesn't natively have the ability to receive X windows, so you need to install an X server separately.

There are a few choices; UCL has a site-wide license (covering UCL-owned and personal computers) for one called [Exceed](https://www.opentext.co.uk/products-and-solutions/products/specialty-technologies/connectivity/exceed), which is pretty reliable and seems to handle 3D content well, but there's also [Xming](http://www.straightrunning.com/XmingNotes/), which is free and open-source if that's a concern.

Exceed is installed on all UCL's centrally-managed Windows computers.

### Installing Exceed

Exceed comes in two parts: the main package, and the add-on that handles certain types of rendered 3D content.

You can download both parts from the [Exceed page in the UCL Software Database](http://swdb.ucl.ac.uk/package/view/id/150). First, install the main package, then the 3D package.

### Using PuTTY with Exceed

When you run the Exceed program, it will automatically wait in the background until you run a remote application, so you only have to configure PuTTY to pass the data through.

To do this, first fill in the details for your PuTTY connection as normal with the hostname and any other details you'd normally use to connect, and then, in the pane labelled "Category" on the left, click the "+" next to "SSH" and then select "X11".

The main pane should change to one labelled "Options controlling SSH X11 forwarding". Check the box labelled "Enable X11 Forwarding".

You can now click "Open" to start the connection, or you can return to the "Session" options to save this setup. 

## macOS

Like Windows, macOS doesn't come with an X server to receive X windows. The most commonly used X server for macOS is [XQuartz](https://www.xquartz.org/). If you download and install that, you can follow the Linux instructions below. When you connect with X-Forwarding enabled, the XQuartz server program should start automatically, ready to present remote windows.

## Linux

Almost all Linux versions that have a graphical desktop use an X server to provide it, so you don't have to install a separate one.

You still have to set up your SSH client's connection to "tunnel" the X windows from the remote computer, though. You can do this by simply adding the `-X` option to your `ssh` command line, so for example to connect to Myriad with X-Forwarding:

```
ssh -X ccaaxyz@myriad.rc.ucl.ac.uk
```

To use X-Forwarding from outside UCL, you must either use the VPN, or use the SSH Gateway system, with the appropriate flags for *both* `ssh` steps, for example:

```
[me@my_computer ~]$ ssh -X ccaaxyz@ssh-gateway.ucl.ac.uk
[...]
[ccaaxyz@ejp-gateway-01 ~]$ ssh -X ccaaxyz@myriad.rc.ucl.ac.uk
```

!!! note
    This assumes you use a Linux distribution that uses Xorg as its display server. If your distribution uses Wayland instead, and you aren't sure how to make this work, please [contact us](Contact_Us.md), letting us know what version of which distribution you're using.

## Checking your Setup

There are some simple programs on the system that use X, which can be used to check whether your setup is working correctly.

 - `xterm` is a terminal emulator -- it presents a terminal much like you would already be using.

 - `glxgears` is a small test/benchmark program for the 3D remote rendering capability. It presents a small set of animated gears.

If these work, you have a working X connection. If not, you should see an error when you try to run them that may look something like:

```
xterm: Xt error: Can't open display:
```

Or:

```
Error: couldn't open display (null)
```

If you see these, please check you have followed all the appropriate steps above, and if you still have problems, contact <rc-support@ucl.ac.uk> for assistance.
