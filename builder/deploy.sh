#!/bin/bash

# From: https://gist.github.com/domenic/ec8b0fc8ab45f39403dd

set -e # Exit with nonzero exit code if anything fails

function doCompile {
  bash builder/build.sh
}


##### Some parameters to alter behaviour

# Active CI system
# We don't want the CI systems to fight if more than one is trying to push to the same place
active_ci_system="github"

# We only want to push back the results if we built from this branch.
mainline_branch="master"
mainline_repo="UCL-ARC/mkdocs-rc-docs"

# And we want to use this as our deployment/push target repo URL and branch.
#deploy_target_url="" # fully specified target repo url to push results to # not currently used
deploy_target_branch="gh-pages"

# This is a URL we can GET to tell a remote server that an update to the results is available.
update_callback_url="https://wiki.rc.ucl.ac.uk/webhooks/update_docs.sh"

# Defaults
skip_deploy="false"
skip_update_callback="true"

# These are the other variables we want to have set up by the end of the bit that works out which CI service we're on.
ci_system="" # empty, gitlab, github, or travis
current_repo="" # owner/repo
current_branch="" # name of the branch we have checked out
event_type="" # empty, push, or pull_request
#pull_request_repo="" # empty if push, owner/repo if pull_request
#pull_request_branch="" # empty if push, branch if pull_request


# Travis Env Docs: https://docs.travis-ci.com/user/environment-variables/
# GitHub Actions Env Docs: https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables#default-environment-variables
# GitLab CI/CD Docs: https://docs.gitlab.com/ee/ci/variables/README.html#list-all-environment-variables

# Let's work out where we're running so we can set our default behaviour

if [[ "${CI:-false}" != "false" ]]; then
    # CI is set by GitHub Actions, Travis-CI, and GitLab CI/CD

    if [[ "${CI_SERVER_NAME:-}" == "GitLab" ]]; then
        # Then we're on the GitLab CI system.
        ci_system="gitlab"
        echo "Error: we haven't actually gotten as far as implementing this." >&2
        exit 1
        :
    elif [[ "${TRAVIS:-}" == "true" ]]; then
        # Then we're on Travis...
        ci_system="travis"
        
        if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
            event_type="push"
        else
            event_type="pull_request"
        fi

        current_branch="$TRAVIS_SOURCE_BRANCH"


        :
        current_repo="$TRAVIS_REPO_SLUG"
    elif [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
        # Then GitHub Actions...
        ci_system="github"

        event_type="$GITHUB_EVENT_NAME"

        current_repo="$GITHUB_REPOSITORY"

        current_branch="$GITHUB_REF"
        # Not sure about this one, might break if tags get involved --v
        current_branch="${current_branch#refs/heads/}"
        :
    else
        # ... Then I don't know where we are. Still a CI system, but not one we know about? (Bamboo????)
        echo "Error: unknown CI System."
        exit 1
    fi

else
    # We're not on a CI system, so probably just building on someone's machine.
    :
fi

# We only deploy if this was triggered by an update to the mainline.
printf "event type: %s, want: %s\ncurrent repo: %s, want %s\ncurrent branch: %s, want %s\nactive ci system: %s, want %s\n" "$event_type" "push" "$current_repo" "$mainline_repo" "$current_branch" "$mainline_branch" "$active_ci_system" "$ci_system"
if [[ "$event_type" == "push" ]] && \
    [[ "$current_repo" == "$mainline_repo" ]] && \
    [[ "$current_branch" == "$mainline_branch" ]] && \
    [[ "$active_ci_system" == "$ci_system" ]]
then
    skip_deploy="false"
else
    skip_deploy="true"
fi


if [[ "$skip_deploy" == "true" ]]; then
    echo "Skipping deploy; just doing a build."
    if doCompile; then
        exit 0
    else
        exit 1
    fi
fi

# Save some useful information from the repo itself
REPO="$(git config remote.origin.url)"
#SSH_REPO="${REPO/https:\/\/github.com\//git@github.com:}" # unused for now
SHA="$(git rev-parse --verify HEAD)"

# Clone the existing gh-pages (or equivalent) for this repo into out/
# Create a new empty branch if our gh-pages repo (or equivalent) doesn't exist yet (should only happen on first deply)
git clone "$REPO" out
cd out
git checkout "$deploy_target_branch" || git checkout --orphan "$deploy_target_branch"
cd ..

# Clean out existing contents
rm -rf out/**/* || exit 0

# Run our compile script
doCompile

# Build is done.
# Now reconfigure the cloned repo
cd out
git config user.name "${ci_system^} CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if [ -z "$(git diff --exit-code)" ]; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .
git commit -m "Deploy to GitHub Pages: ${SHA}"

[[ "$ci_system" == "travis" ]] && \
    decrypt_travis_ssh_key

# Now that we're all set up, we can push.
git push "${REPO/github.com/${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com}" "$deploy_target_branch"

# Clean up our ssh-agent process
[[ "$ci_system" == "travis" ]] && \
    killall ssh-agent

# Last thing: ping the hosting server to pull the updated docs
if [[ -n "$update_callback_url" ]] && [[ -z "$skip_update_callback" ]]; then
  curl "$update_callback_url" || echo 'Did not successfully call update pull hook url.' && exit 1
else
  echo "Skipping webhook deploy."
fi

function decrypt_travis_ssh_key() {
    # Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
    ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
    ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
    ENCRYPTED_KEY="${!ENCRYPTED_KEY_VAR}"
    ENCRYPTED_IV="${!ENCRYPTED_IV_VAR}"
    openssl aes-256-cbc -K "$ENCRYPTED_KEY" -iv "$ENCRYPTED_IV" -in ../deploy_key.enc -out deploy_key -d
    chmod 600 deploy_key
    eval "$(ssh-agent -s)"
    ssh-add deploy_key
}

