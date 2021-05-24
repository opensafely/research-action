#!/bin/bash
set -euo pipefail

if [[ "${CI:-}" != 'true' ]]; then
  if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    echo "Local tests should be run inside a virtualenv to avoid installing"
    echo "packages into the system Python"
    exit 1
  fi
  # The test repository we use is public so we don't actually need the token,
  # but the variable must be defined
  GITHUB_TOKEN="${GITHUB_TOKEN:-}"
  # The opensafely-cli uses the presence of this variable to customise some of
  # its behaviour when running inside Github Actions
  GITHUB_WORKFLOW="${GITHUB_WORKFLOW:-test_workflow}"
fi

action_path="$PWD/action.sh"
test -x "$action_path"

mkdir -p test-tmp
rm -rf test-tmp/*
cd test-tmp

# Test against a known good commmit of a test project
export GITHUB_REPOSITORY=opensafely/gh-testing-research
export GITHUB_SHA=822b04bc718488c4755acd6b6dce8f72f7a7d0d3

GITHUB_RUN_ID="test-$(head -c 128 /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)"

PUBLISHING_KEY=
if test -f ~/.ssh/github-action; then
    PUBLISHING_KEY=$(cat ~/.ssh/github-action)
fi
export GITHUB_TOKEN GITHUB_WORKFLOW GITHUB_RUN_ID PUBLISHING_KEY
exec "$action_path"
