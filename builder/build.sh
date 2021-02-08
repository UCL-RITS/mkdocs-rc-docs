#!/usr/bin/env bash

set -o errexit \
    -o nounset \
    -o pipefail

build_dir="$(mktemp -d)"
echo "Building in: $build_dir" >&2

echo "Copying repo..." >&2
owd="$(pwd)"
mkdir -p "$build_dir/sources"
cp -r ./* "$build_dir/sources/"

## Trying Travis's pip support for now, otherwise use below:
#echo "Using pip to obtain local MkDocs install..." >&2
#virtualenv venv
#source ./venv/bin/activate
#pip install -r requirements.txt

echo "Generating package list pages..." >&2
mkdir "$build_dir/sources/mkdocs-project-dir/docs/Installed_Software_Lists"
cd "$build_dir/sources/mkdocs-project-dir/docs/Installed_Software_Lists"
export MAKO_TEMPLATE_DIR="$build_dir/sources/builder/templates"

# Sometimes connecting to the webserver to grab the lists times out.
# If this happens, it might be useful to try and grab some diagnostic
#  info and see if we can work out a future solution.
if ! python3 "$build_dir/sources/builder/convert_lists.py"; then
    echo "Getting network configuration info for diagnostics..." >&2
    set -v
    ip addr all
    route
    ping -c 1 1.1.1.1
    ping -c 1 www.rc.ucl.ac.uk
    curl -I www.rc.ucl.ac.uk
    curl -I https://www.rc.ucl.ac.uk
    set +v
    false # and then make the script fail
fi


# There only shouldn't be an out directory
#  if this is the first build, or a local build
echo "Building site..." >&2
mkdir -p "$owd/out" 
cd "$build_dir/sources/mkdocs-project-dir"
mkdocs build --site-dir "$owd/out"

# This disables Jekyll on GitHub Pages, so it just uses our built 
#  content instead of trying to run Jekyll on it
touch "$owd/out/.nojekyll"

rm -Rf -- "$build_dir"

echo "Finished." >&2
