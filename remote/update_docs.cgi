#!/bin/bash

REPO="https://github.com/UCL-ARC/mkdocs-rc-docs.git"
BRANCH="gh-pages"

echo "Content-type: text/plain"
echo ''

echo 'Grabbing docs...'
if [[ ! -d "/data/rcps_docs/.git" ]]; then
  (cd /data && git clone -b "$BRANCH" "$REPO" --depth 1 /data/rcps_docs 2>&1) && echo 'Done, first checkout.' || echo 'Error cloning repo! Please check the docs directory is writable by the apache user.'
else
  (cd /data/rcps_docs && git pull 2>&1) && echo 'Completed update pull.' || echo 'Error updating docs! Please check the docs directory is writable by the apache user.'
fi
echo 'Exiting...'
exit 0

