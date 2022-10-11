---
title: RStudio
categories:
 - RStudio Server
layout: docs
---

# RStudio

## Overview

The Research Computing team currently runs 2 supported instances of RStudio:

 - <https://rstudio.data-science.rc.ucl.ac.uk/>
   This instance is for general teaching use but requires permission to access as part of the [Data Science Platform](https://www.ucl.ac.uk/isd/data-science-platform). It uses the central UNIX filestore for user data.

 - <https://econ-myriad.rc.ucl.ac.uk/>
   This instance is for research use by members of the Economics department. It uses the Myriad filesystem for user data.

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
there are istructions here: 
[l,ogging in via SSH](../Walkthroughs/Logging_In.md)
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


