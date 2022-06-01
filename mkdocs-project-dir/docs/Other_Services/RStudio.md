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

For all of the services, please take care to either run `q()` in the R window or press the red logout button in the top right hand corner when you are done with the window, DO NOT just close the tab. This decreases the chance of there being stale sessions and future issues with logging in. If you cannot reach the landing page, then please first try getting there using private browsing and if that works then clear your cookies and cache. In most browsers you can do this for a certain time range, though look at the documentation for the browser you are using.

If this does not solve your logging-in problem then there are 2 courses of action for the 2 supported services:

 - For the Economics RStudio service, ssh into Myriad and change the name of or delete a folder located at:
    
   ```
   $HOME/.local/share/rstudio/sessions/
   ```

 - If it is the Rstudio Pro teaching service please in the first instance [get in touch with RC support](../Contact_Us.md).  This service shares home directories with the central Unix services so it is possible to log into Socrates (`socrates.ucl.ac.uk`) [via SSH](../Walkthroughs/Logging_In.md) and delete the folder above which may resolve your issues.

Note that this route should only be taken if you are getting an ever-spinning loading screen.

