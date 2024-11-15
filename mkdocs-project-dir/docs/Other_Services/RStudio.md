---
title: RStudio
categories:
 - RStudio Server
layout: docs
---

# RStudio

## Overview

The Research Computing team currently runs 2 supported instances of RStudio:

### <https://rstudio.data-science.rc.ucl.ac.uk/>

This instance is for general teaching use and is part of the Data
Science Platform. It uses the central UNIX filestore for user data. Access is blocked by default due to licencing restrictions.

Staff who would like to use the service to deliver teaching should
email rc-support@ucl.ac.uk to request access (please include your UCL
username). To grant access to students, please pre-register the course
by emailing the above address and provide the SITS code of the
relevant module(s) and a pdf or link to the syllabus. Students who are
registered on those SITS modules will then be added automatically.

In addition we have a smalll number of Named Researcher licenses for
RStudio Pro which also run on this instance. Staff and Research
Postgraduates who would like to have access to one of these licenses
should email rc-support@ucl.ac.uk to request access explaining why
they need to use RStudio.

The Data Science Platform and all of its components are only
accessible from the UCL network. When off campus, you will need to
connect to the
[UCL VPN](https://ucl.ac.uk/isd/services/get-connected/ucl-virtual-private-network-vpn)
first.

**Please note:** The main aim of this service is to support teaching
  and the service should not be used for computationally intensive
  research. If your use starts to affect the experience of other
  users, we reserve the right to terminate sessions without
  notice. For computationally intensive
  research you should be using the [Myriad Cluster](https://www.rc.ucl.ac.uk/docs/Clusters/Myriad/).

### <https://econ-myriad.rc.ucl.ac.uk/>

This instance is for research use by members of the Economics
department. It uses the Myriad filesystem for user data.

## Installing R Packages

Users can install R packages in their home directories, but we recommend that if you are planning on teaching a course, you make sure the packages you want to use are pre-installed on the system. This saves time and reduces the load on the server.

The main version of R used by the RStudio server copies it's packages from the [Myriad Cluster](https://www.rc.ucl.ac.uk/docs/Clusters/Myriad/), so any package available there should be available in RStudio too. There's an automatically updated list here: [R packages](https://www.rc.ucl.ac.uk/docs/Installed_Software_Lists/r-packages/). Alternatively, check the list of available packages from within RStudio itself.

Requests to install packages can be sent to rc-support@ucl.ac.uk. Please give as much notice as possible when requesting packages as these requests will be handled on a best efforts basis by the research computing applications support team.

## Troubleshooting and problem pre-emption

For all of the services, please take care to either run `q()` in the R
window or press the red logout button in the top right hand corner
when you are done with the window, DO NOT just close the tab. This
decreases the chance of there being stale sessions and future issues
with logging in.

### Not being able to reach the landing (login) page

If you cannot reach the landing page, then please first try getting
there using private browsing and if that works then clear your cookies
and cache. In most browsers you can do this for a certain time range,
though look at the documentation for the browser you are using.

### R session not starting or RStudio Initialisation Error

If you get an error pop-up RStudio Initialisation Error: Unable to
connect to service or an ever-spinning loading screen you can try and
resolve the problem using one of the methods below or  [get in touch with RC support](../Contact_Us.md). 

There are 2 courses of action for the 2 supported services:

 - **Economics RStudio service**: ssh into Myriad and change the name of or delete a folder located at:
    
   ```
   ~/.local/share/rstudio/sessions/
   ```

 - **Data Science Platform RStudio Pro teaching service**: This service
 shares home directories with the central Unix services so you need to
 do:

    1. login to either Socrates (`socrates.ucl.ac.uk`) or Aristotle
(`aristotle.rc.ucl.ac.uk`) via SSH. If you don't know how to do this
there are instructions here - but make sure the system you are logging 
in to is Socrates or Aristotle not Myriad, because they use the same 
filesystem as the RStudio machines: 

     * [logging in via SSH](../Walkthroughs/Logging_In.md)
     * [Remote access](../Remote_Access.md)

    2. Change directory to ~/.local/share:

		```
		cd ~/.local/share
		```
		
   	3. delete the rstudio folder:

		```
		rm -rf rstudio
		```
		
	4. It is worth testing if you can login to RStudio after the last
       step. If you still cannot login, delete the folllowing directory as well:
	   
		```
		cd ~/.rstudio
		```
	   
		```
		rm -rf sessions
		```

	5. logout.

If doing this doesn't resolve your issues,  [get in touch with RC support](../Contact_Us.md) .

### Issues uploading files or failure during writing data

You may have run out of space on the Unix Filestore (T: drive).

Check your quota:

```
system("quota -s")
```

It will tell you the space you are using, your quota and the limit, then the number of files, 
the quota for that and the limit for that. If you are using too much space or too many files 
you won't be able to add more until you delete some.

If this is not the problem, please [get in touch with RC support](../Contact_Us.md) and tell 
us:

* How large are the files that are failing to upload?
* What browser are you using to do the upload to RStudio? Does it work better if you use 
  Firefox instead? (It is also available on Desktop@UCL).

There is a potential workaround when browser uploads are failing but you definitely have space.
You can try uploading your data using scp to Socrates or Aristotle and then accessing it from
RStudio once it is already there.

* [Transferring data onto a system](../howto.md#how-do-i-transfer-data-onto-the-system)
* [Transferring files with remote computers (Moodle)](https://moodle.ucl.ac.uk/course/section.php?id=852836)

Make sure the system you are transferring files to is Socrates or Aristotle, not Myriad.

