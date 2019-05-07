#!/usr/bin/env bash

set -o errexit \
    -o nounset \
    -o pipefail

local_repo_dir="/data/rcps_mkdocs/docs"
remote_repo="UCL-RITS/mkdocs-rc-docs"

function get_remote_update_time() {
    curl -q https://api.github.com/repos/"$remote_repo" \
        | jq '.updated_at' \
        | tr 'TZ"' '   '
}

function get_remote_update_timestamp() {
    local time="$(get_remote_update_time)"
    date --date="$time" +%s
}

function get_local_update_timestamp() {
    cd "$local_repo_dir"
    git log -1 --format=%cd --date=raw \
        | cut -f 1 -d ' '
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
    git fetch
    git merge
}

if update_is_available; then
    update_docs
fi
