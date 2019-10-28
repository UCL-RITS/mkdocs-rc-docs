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
mkdir "$build_dir/sources/mkdocs-project-dir/lists"
cd "$build_dir/sources/mkdocs-project-dir/lists"
python3 "$build_dir/convert_lists.py"

# There only shouldn't be an out directory
#  if this is the first build, or a local build
echo "Building site..." >&2
mkdir -p out 
cd "$build_dir/sources/mkdocs-project-dir"
mkdocs build --site-dir "$owd/out"

# This disables Jekyll on GitHub Pages, so it just uses our built 
#  content instead of trying to run Jekyll on it
touch "$owd/out/.nojekyll"

rm -Rf -- "$build_dir"

echo "Finished." >&2
