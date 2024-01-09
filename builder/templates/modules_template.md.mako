<%namespace name="x_packages" file="x_packages.mako"/>
<%
  m_pack = p["package_groups"]
  gen_time = p["generated"]
%>
# General Software Lists

Our clusters have a wide range of software installed, available by using the modules system.

The module files are organised by name, version, variant (where applicable) and, if relevant, the compiler version used to build the software. If no compiler version is given, either no compiler was required, or only the base system compiler (`/usr/bin/gcc`) and libraries were used.

When we install applications, we try to install them on all of our clusters, but sometimes licence restrictions prevent it. If something seems to be missing, it may be because we are not able to provide it. Please contact us for more information if this is hindering your work.

The lists below were last updated at ${gen_time}, and are generated from the software installed on the [Myriad](../Clusters/Myriad.md) cluster.

## Bundles

Some applications or tools depend on a lot of other modules, or have some awkward requirements. For these, we sometimes make a "bundle" module in this section, that loads all the dependencies.

For Python and R in particular, we also have `recommended` bundles that load the module for a recent version of Python or R, along with a collection of packages for it that have been requested by users, and the modules those packages require.

The lists of Python and R packages installed for those bundles are on separate pages:

 - [Python packages](python-packages.md)
 - [R packages](r-packages.md)

We'll sometimes include `/new` and `/old` versions of these bundles, if we've recently made a version switch or are intending to make one soon. We send out emails to the user lists about version changes, so if you use these bundles, you should look out for those.

<%
  x_packages.expand_md_list(m_pack["bundles"])
%>

## Applications

<%
 x_packages.expand_md_list(m_pack["applications"])
%>

## Libraries

Modules in this section set up your environment to use specific C, C++, or Fortran libraries. This can include being able to use them with other languages, like Python.

<%
 x_packages.expand_md_list(m_pack["libraries"])
%>

## Compilers

These modules set up your environment to be able to use specific versions of C, C++, Go, or Rust compilers.

<%
 x_packages.expand_md_list(m_pack["compilers"])
%>

## Development Tools

This section is for modules for programs that are used in software development, profiling, or troubleshooting.

It also contains language interpreters, like Python, Ruby, and Java.

<%
 x_packages.expand_md_list(m_pack["development"])
%>

## Core Modules

These modules refer to groups of system tools, rather than applications. They're intended to help you use the system, and some are loaded by default.

<%
 x_packages.expand_md_list(m_pack["core"])
%>

## Beta Modules

This section is for modules we're still trying out. They may or may not work with applications from other sections.

<%
 x_packages.expand_md_list(m_pack["beta"])
%>

## Workaround Modules

Sometimes we'll find a problem that can't be fixed properly, but can be worked-around by doing something that can be loaded as a module. That kind of module goes in this section.

<%
 x_packages.expand_md_list(m_pack["workarounds"])
%>

