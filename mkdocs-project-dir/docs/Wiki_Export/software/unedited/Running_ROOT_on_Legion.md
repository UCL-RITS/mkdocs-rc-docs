---
title: Running ROOT on Legion
categories:
 - Bash script pages
 - Legion

layout: docs
---
ROOT has been installed on Legion primarily because it is required by a
number of R add-on packages. It is also available for batch use in its
own right and for short interactive runs (less than 15 minutes execution
time) on the Login nodes. A number of versions are available including
5.34.14 and 5.34.09.

You need to load the following modules to use ROOT: ```

`module unload compilers/intel/11.1/072`  
`module unload mpi/qlogic/1.2.7/intel`  
`module unload mkl/10.2.5/035`  
`module add compilers/gnu/4.6.3`  
`module add fftw/3.3.1/double/gnu.4.6.3`  
`module load gsl/1.15/gnu.4.6.3`  
`module load root/5.34.14/gnu.4.6.3`

``` ROOT can now be run interactively using: ```

`root`

``` or in batch mode running a script: ```

`root -b -q myMacro.C > myMacro.out`

``` In the above example the ROOT script is read from file
*myMacro.C* and output saved to file *myMacro.out*. Type: ```

`man root`

``` for further details about the root command. Extensive
documentation is available on the [ROOT
website](http://root.cern.ch/drupal/).

[Category:Bash script pages](Category:Bash_script_pages "wikilink")
[Category:Legion](Category:Legion "wikilink")