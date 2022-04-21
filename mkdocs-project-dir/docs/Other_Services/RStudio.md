---
title: RStudio
categories:
 - RStudio Server
layout: docs
---

# RStudio

## Overview

The research computing team currently has 2 supported and 1 unsupported instances of RStudio. The Supported ones can be accessed using the following urls,

 - https://econ-myriad.rc.ucl.ac.uk/
 - https://rstudio.data-science.rc.ucl.ac.uk

The former of these is only available to members of the economics department, the latter is more general purpose but may require permission to access. The unsupported instance of RStudio has the URL,

 - https://rstudio.myriad.rc.ucl.ac.uk/


!!! warning
	This should be treated like an at risk service so do not do production level work or teaching using this service as
	it runs on a very old piece of hardware that we are working towards decommisioning.

## Troubleshooting and problem pre-emption

For all of the servives please take care to either run `q()` in the R window or press the red logout button in the top right hand corner when you are done with the windowi, DO NOT just close the tab. This decreases the chance of there being stale sessions and future issues with logging in. If you cannot reach the landing page then please first try getting there using private browsing and if that works then clear your cookies and cache. In most browsers you can do this for a certain time range, though look at the documentation for the browser you are using.

If this does not solve your logging in problem then there are 2 courses of action for the 2 supported services, for the economics RStudio ssh into myriad and change the name of or delete a folder located at,

```
$HOME/.local/share/rstudio/sessions/
```

If it is one of the other machines then please get in touch with RC-support. Note that this route should only be taken if you are getting an ever spinning loading screen.


