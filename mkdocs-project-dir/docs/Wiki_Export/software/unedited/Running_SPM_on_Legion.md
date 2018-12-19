---
title: Running SPM on Legion
layout: docs
---
In order to run SPM on legion, you need to have the Matlab R2010a (v
7.13) module loaded and the SPM 8 module: ```

`module load matlab/runtime/r2010a/7.13`  
`module load spm/8/r4667`

``` You can then invoke SPM with the usual wrapper script
(run\_spm8.sh). You do not need to pass the location of the Matlab
runtime install to the script as it picks this up automatically from the
Matlab runtime module.

When constructing job scripts, remember to load the modules in the job
script (or your .bashrc).

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")