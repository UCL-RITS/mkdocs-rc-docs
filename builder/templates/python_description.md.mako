<%namespace name="x_packages" file="x_packages.mako"/>
<%
  generated = p["generated"]
  uncat_pack = p["packages"]
  version = p["version"]
%>

# Python Packages

We provide a collection of installed Python packages for each minor version of Python, as a [bundle module](module-packages.md). This page lists the packages for the current `recommended` Python 3 bundle.

This can be loaded using:

```
module load python3/recommended
```

The version of Python 3 provided with this bundle is currently ${version}.


Note that some packages we do not provide this way, because they have complicated non-Python dependencies. These are usually provided using the normal application modules system. This includes **TensorFlow**.

The following list was last updated at ${generated}.

<%
  x_packages.expand_package_list(uncat_pack)
%>
