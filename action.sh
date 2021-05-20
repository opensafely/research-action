#!/bin/bash
set -euo pipefail

# Repeat the character 80 times
long_line=$(printf '―%.0s' {1..80})
bold=$(echo -e "\033[1m")
reset=$(echo -e "\033[0m")

echo "$long_line"
echo "${bold}→ Preparing${reset}"
echo
echo "Checking out commit"
echo "https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
echo

if [[ -z "$GITHUB_TOKEN" ]]; then
  auth_header=''
else
  auth_header="authorization: Bearer $GITHUB_TOKEN"
fi
curl \
  --silent \
  --header "$auth_header" \
  -L https://api.github.com/repos/$GITHUB_REPOSITORY/tarball/$GITHUB_SHA \
  | \
  tar --strip-components=1 -xzf -

python3 -m pip install --quiet --quiet --upgrade opensafely
echo "Installing $(opensafely --version)"
echo

echo
echo "$long_line"
echo "${bold}→ Checking codelists${reset}"
echo "  opensafely codelists check"
echo
opensafely codelists check
echo

echo
echo "$long_line"
echo "${bold}→ Running all project actions${reset}"
echo "  opensafely run run_all --continue-on-error"
echo
opensafely run run_all --continue-on-error \
  --timestamps --format-output-for-github
