---
title: Installing Software
layout: docs
---

If you want to request that software be installed centrally, you can email us at 
rc-support@ucl.ac.uk or open a [GitHub issue in our buildscripts repository](https://github.com/UCL-RITS/rcps-buildscripts/issues). 
That is also where you can see all the software requests we are currently working on, 
and the progress on them. If something has already been requested, feel free to add a 
comment saying you also wish it to be installed. 

Our buildscripts are in the code section of that repository, so you can see how we 
built and installed all our central software stack.

You can install software yourself in your space on the cluster. Below are some tips for 
installing packages for languages such as Python or Perl as well as compiling software.

## No sudo!

You cannot install anything using `sudo` (and neither can we!). If the instructions tell you to do that, read further to see if they also have instructions for installing in user space, or for doing an install from source if they are RPMs.

Alternatively, just leave off the `sudo` from the command they tell you to run and look for an alternative way to give it an install location if it tries to install somewhere that isn't in your space (examples for some common build systems are below).


## Python

There are `python2/recommended` and `python3/recommended` module bundles you will see if you type 
`module avail python`. These use a virtualenv, have a lot of Python packages installed already, 
like numpy and scipy (see [the Python package list](../Installed_Software_Lists/python-packages.md)) 
and have `pip` set up for you.

### Load the GNU compiler

Our Python installs were built with GCC. You can run them without problems with the default Intel
compilers loaded because it also depends on the `gcc-libs/4.9.2` module. However, when you are 
*installing* your own Python packages you should make sure you have the GNU compiler module loaded.
This is to avoid the situation where you build your package with the Intel compiler and then try to
run it with our GNU-based Python. If it compiled any C code, it will be unable to find Intel-specific
instructions and give you errors.

Change your compiler module:
```
module unload compilers
module load compilers/gnu/4.9.2
```

If you get an error like this when trying to run something, you built a package with the Intel compiler.
```
undefined symbol: __intel_sse2_strrchr
```

### Install your own packages in the same virtualenv

This will use our central virtualenv and the packages we have already installed.

```
# for Python 2
pip install --user <python2pkg>
# for Python 3
pip3 install --user <python3pkg>
```
These will install into `.python2local` or `.python3local` in your home directory. 

If your own installed Python packages get into a mess, you can delete (or rename) the whole 
`.python3local` and start again.

### Using your own virtualenv

If you need different packages that are not compatible with the centrally installed versions (eg. 
what you are trying to install depends on a different version of something we have already installed)
then you can create a new virtualenv and only packages you are installing yourself will be in it.
```
# create the new virtualenv, with any name you want
virtualenv <DIR>
# activate it
source <DIR>/bin/activate
```
You only need to create it the first time.

Your bash prompt will change to show you that a different virtualenv is active.

### Installing via setup.py

If you need to install by downloading a package and using `setup.py`, you can use the `--user` 
flag and as long as one of our python module bundles are loaded, it will install into the same 
`.python2local` or `.python3local` as `pip` does and your packages will be found automatically.
```
python setup.py install --user
```

If you want to install to a different directory in your space to keep this package separate,
you can use `--prefix` instead. You'll need to add that location to your `$PYTHONPATH` and `$PATH`
as well so it can be found. Some install methods won't create the prefix directory you requested
for you automatically, so you would need to create it yourself first.

This type of install makes it easier for you to only have this package in your paths when you
want to use it, which is helpful if it conflicts with something else.
```
# add location to PYTHONPATH so Python can find it
export PYTHONPATH=/home/username/your/path/lib/python3.7/site-packages:$PYTHONPATH
# if necessary, create lib/pythonx.x/site-packages in your desired install location
mkdir -p /home/username/your/path/lib/python3.7/site-packages
# do the install
python setup.py install --prefix=/home/username/your/path
```
It will tend to tell you at install time if you need to change or create the `$PYTHONPATH` directory.

To use this package, you'll need to add it to your paths in your jobscript or `.bashrc`.
Check that the `PATH` is where your Python executables were installed.
```
export PYTHONPATH=/home/username/your/path/lib/python3.7/site-packages:$PYTHONPATH
export PATH=/home/username/your/path/bin:$PATH
```
It is very important that you keep the `:$PYTHONPATH` or `:$PATH` at the end of these - you
are putting your location at the front of the existing contents of the path. If you leave 
them out, then only your package location will be found and nothing else.


### Troubleshooting: remove your pip cache

If you built something and it went wrong, and are trying to reinstall it with `pip` and keep 
getting errors that you think you should have fixed, you may still be using a previous cached version. 
The cache is in `.cache/pip` in your home directory, and you can delete it.

You can prevent caching entirely by installing using `pip3 install --user --no-cache-dir <python3pkg>`

### Troubleshooting: Python script executable paths

If you have an executable Python script (eg. something you run using `pyutility` and not 
`python pyutility.py`) that begins like this: 
```
#!/usr/bin/python2.6
```
and fails because that Python doesn't exist in that location or isn't the one that has the 
additional packages installed, then you should change it so it uses the first Python found 
in your environment instead, which will be the one from the Python module you've loaded.
```
#!/usr/bin/env python
```



