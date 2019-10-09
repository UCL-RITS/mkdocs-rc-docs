#!/bin/bash

set -o errexit \
    -o nounset

destination="/data/rcps_mkdocs/lists/"

echo "[$(date)] Updating package lists..." >&2

echo "[$(date)] Getting python list..." >&2 \
	&& ssh -i ~/.ssh/id_rsa__list_py_packages myriad.rc.ucl.ac.uk >/tmp/python-packages.json \
	&& mv -f /tmp/python-packages.json "${destination}"
echo "[$(date)] Getting R list..." >&2 \
	&& ssh -i ~/.ssh/id_rsa__list_r_packages myriad.rc.ucl.ac.uk >/tmp/r-packages.json \
	&& mv -f /tmp/r-packages.json "${destination}"

echo "[$(date)] Update script finished." >&2


