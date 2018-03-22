#!/usr/bin/env bash

FILE="$(basename $0)"
NAME="${FILE%.sh}"
SCRIPTS="$(cd $(dirname $0); pwd)"
TOP="$(dirname $SCRIPTS)"
echo "$TOP"

DATE="$(date)"

/bin/rm -rf "$TOP/target/$NAME"
mkdir -p "$TOP/target/$NAME"
cd "$TOP/target/$NAME"
HERE="$(pwd)"

. "$SCRIPTS/caesar-git-services.sh"

echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_PASSWORD: $GIT_PASSWORD"

#echo "# Current branch $BRANCH"

#if brew ls --versions jq > /dev/null; then
#  echo "js is installed; skipping installation"
#else
#  brew install jq
#fi

#if [[ ! -d "jq" ]]; then
#    echo "Download jq - json processor"
#    mkdir jq
#    cd jq
#    curl http://stedolan.github.io/jq/download/linux64/jq -s -o jq
#    chmod +x jq
#    cd ..
#fi

PATH="$(pwd)/jq:$PATH"

PREV_BRANCH="$2"
echo "# Previous branch $PREV_BRANCH"

PREV_REPO="$1"
echo "# PREV_REPO: $PREV_REPO"

echo "# Start from the branch: $PREV_BRANCH of the $PREV_REPO repo"
PREV_URL="https://$GIT_USERNAME:$GIT_PASSWORD@github.jpl.nasa.gov/imce/$PREV_REPO"

gitCaesarClone $PREV_URL $PREV_BRANCH
PREV_TAG="$(gitTag $PREV_REPO)"
PREV_COMMIT="$(gitCommit $PREV_REPO)"

echo "# prev_commit: $PREV_COMMIT"

echo "current path: $(pwd)"

#echo "# Checkout the branch: $BRANCH, creating it if it does not exist or merging it with $PREV_BRANCH otherwise."

#gitCreateOrMergeBranch $PREV_REPO $BRANCH

