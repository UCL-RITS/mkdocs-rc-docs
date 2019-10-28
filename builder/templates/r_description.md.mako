<%namespace name="x_packages" file="x_packages.mako"/>
<%
  generated = p["generated"]
  uncat_pack = p["packages"]
  version = p["version"]
%>

# R Packages

We provide a collection of installed R packages for each release of R, as a [bundle module](module-packages.md). This page lists the packages for the current `recommended` R bundle.

This can be loaded using:

```
module load r/recommended
```

The version of R provided with this bundle is currently ${version}.

The following list was last updated at: ${generated}.

<%
  x_packages.expand_package_list(uncat_pack)
%>
