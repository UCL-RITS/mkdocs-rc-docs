#!/usr/bin/env bash

set \
  -o errexit \
  -o pipefail

# Make a virtualenv with mkdocs if there isn't one

if [[ ! -d "./venv" ]]; then
  virtualenv ./venv
  source ./venv/bin/activate
  pip install -r requirements.txt
fi


# run some legit tests
# probably mdl or something?
:


# build the site

mkdocs build --clean



