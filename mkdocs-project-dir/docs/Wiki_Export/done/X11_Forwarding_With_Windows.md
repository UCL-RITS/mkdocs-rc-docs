---
title: X11 Forwarding With Windows
layout: docs
---
X forwarding allows users to interact via a GUI with a graphical program
running on a remote computer. To get this to work on Windows machines
with Legion you will need:

  - An SSH client; e.g., PuTTY
  - An X server program; e.g., Exceed

Other SSH clients and X servers are available, but the following
instructions will tell you how to set up X forwarding for Legion using
PuTTY and Exceed:

1.  Install both programs if you have not done so already. For Exceed
    you want a personal installation.
2.  Open Exceed - the exceed icon should appear on the task bar.
3.  Open PuTTY
4.  In PuTTY, set up the connection with Legion as usual with the
    following information:
    1.  Host name: legion.rc.ucl.ac.uk
    2.  Port: 22
    3.  Connection type: SSH
5.  Then, from the Category menu, select Connection\>SSH\>X11 for
    'Options controlling SSH X11 forwarding'
    1.  Make sure the box marked 'Enable X11 forwarding' is checked.
6.  Return to the session menu and save these setting with a new name
    such as 'Legion X' for reuse in future.
7.  Click 'Open' and login to Legion as usual
8.  To test that X-forwarding is working try one of these test
    applications:
    1.  xeyes: to bring up a set of eyes that track the mouse position
        on the screen
    2.  glxgears: to bring up an animated set of gears
    3.  xclock: a clock

If these work, you have succesfully enabled X forwarding for graphical
applications on Legion.