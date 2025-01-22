#!/usr/bin/env bash

set -o errexit \
    -o nounset \
    -o errtrace \
    -o pipefail

local_repo_dir="/data/content/rcps_mkdocs/docs"
remote_repo="UCL-ARC/mkdocs-rc-docs"

# We had to install jq in a non-standard location on the webserver because
#  we don't have any way to install packages >:(
function _jq() {
    if command -v jq >/dev/null 2>/dev/null; then
        jq "$@"
    else
        ~/bin/jq "$@"
    fi
}

function get_remote_update_time() {
    curl -sS https://api.github.com/repos/"$remote_repo"/branches/gh-pages \
        | _jq .commit.commit.committer.date \
        | tr -d '"'
}

function get_remote_update_timestamp() {
    local time
          time="$(get_remote_update_time)"
    date --date="$time" +%s
}

function get_local_update_timestamp() {
    cd "$local_repo_dir"
    local time
          time="$(git log -1 --format=%cd --date=rfc)"
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
    git pull --ff-only
}

function fix_permissions() {
    cd "$local_repo_dir"
    chmod -R a+rX .
}

function check_and_update() {
    local update_reason="none"

    if [[ "$force_update" == "yes" ]]; then
        update_reason="forced"
        echo "[$(date)] Forcing update, skipping check..."
    else 
        echo "[$(date)] Checking remote repository for updates..."
        if update_is_available; then
        update_reason="update_available"
        echo "[$(date)] Update available."
        else
        echo "[$(date)] No new update."
        fi
    fi

    if [[ "$update_reason" != "none" ]]; then
        echo "[$(date)] Pulling update from repository..."
        update_docs
        echo "[$(date)] Update pulled to local repository."
        echo "[$(date)] Setting/fixing permissions..."    
        fix_permissions
        echo "[$(date)] Permissions set."
    fi
}

function parse_args() {
    canonical_args="$(
        /usr/bin/getopt \
            -n "$0" \
            -l "help,force" \
            -o "hf" \
            -- \
            "$@"
    )"

    eval set -- "$canonical_args"

    # Defaults
    force_update="no"

    while true ; do
        case "$1" in
            -h|--help) show_help_and_exit; shift ;;
            -f|--force) force_update="yes"; shift ;;
            --) shift ; break ;;
            *) echo "Error: invalid argument '$1'" ; exit 1 ;;
        esac
    done
}

function show_help_and_exit() {
    printf "
    %s -- Checks a remote repository for updates against a local repository,
          and pulls updates if present.

     -h,--help  Shows this message
     -f,--force Attempts to pull updates even if none are detected
    " "$0"
    exit 1
}

parse_args "$@"
check_and_update
