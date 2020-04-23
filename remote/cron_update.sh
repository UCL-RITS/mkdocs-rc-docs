#!/usr/bin/env bash

set -o errexit \
    -o nounset \
    -o pipefail

local_repo_dir="/data/rcps_mkdocs/docs"
remote_repo="UCL-RITS/mkdocs-rc-docs"

function get_remote_update_time() {
    curl -sS https://api.github.com/repos/"$remote_repo" \
        | sed -n -e 's/^[ ]*"updated_at": "\([^"]*\)",[ ]*$/\1/;T;s/Z$/+0000/;s/T/ /p'
}

function get_remote_update_timestamp() {
    local time="$(get_remote_update_time)"
    date --date="$time" +%s
}

function get_local_update_timestamp() {
    cd "$local_repo_dir"
    local time="$(git log -1 --format=%cd --date=rfc)"
    date --date="$time" +%s
}

function update_is_available() {
    local remote_update_timestamp
    local local_update_timestamp
    local_update_timestamp="$(get_local_update_timestamp)"
    remote_update_timestamp="$(get_remote_update_timestamp)"

    if [[ "$remote_update_timestamp" -gt "$local_update_timestamp" ]]; then
        return 0
    else
        return 1
    fi
}

function update_docs() {
    cd "$local_repo_dir"
    git pull
}

if update_is_available; then
    echo "[$(date)] Update available, pulling from repository..."
    update_docs
    echo "[$(date)] Update complete."
else
    echo "[$(date)] No update available."
fi
