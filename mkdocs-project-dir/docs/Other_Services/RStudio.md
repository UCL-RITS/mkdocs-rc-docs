---
title: RStudio
categories:
 - RStudio Server
layout: docs
---

# RStudio

## Overview

The Research Computing team currently runs 2 supported and 1 unsupported instances of RStudio. The supported services can be accessed using the following addresses:

 - <https://rstudio.data-science.rc.ucl.ac.uk/>
 - <https://econ-myriad.rc.ucl.ac.uk/>

The latter of these is only available to members of the Economics department. The former is more general purpose, but may require permission to access.

The unsupported instance of RStudio has the URL:

 - <https://rstudio.myriad.rc.ucl.ac.uk/>

!!! warning
	This should be treated like an at risk service so do not do production level work or teaching using this service, as
	it runs on a very old piece of hardware that we are working towards decommissioning.

## Troubleshooting and problem pre-emption

For all of the services, please take care to either run `q()` in the R window or press the red logout button in the top right hand corner when you are done with the window, DO NOT just close the tab. This decreases the chance of there being stale sessions and future issues with logging in. If you cannot reach the landing page, then please first try getting there using private browsing and if that works then clear your cookies and cache. In most browsers you can do this for a certain time range, though look at the documentation for the browser you are using.

If this does not solve your logging-in problem then there are 2 courses of action for the 2 supported services:

 - For the Economics RStudio service, ssh into Myriad and change the name of or delete a folder located at:
    
    ```
    $HOME/.local/share/rstudio/sessions/
    ```

 - If it is one of the other services then please [get in touch with RC support](../Contact_Us.md).

Note that this route should only be taken if you are getting an ever-spinning loading screen.

