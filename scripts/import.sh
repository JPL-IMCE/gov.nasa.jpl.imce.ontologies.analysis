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

#BRANCH="$(gitBranch $TOP)"
#PREV_URL="$(gitRemoteOriginURL $TOP)"

PREV_URL="https://github.jpl.nasa.gov/imce/gov.nasa.jpl.imce.caesar.workflows.europa"

echo "# Current branch $BRANCH"

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

#Take the first input branch in the list
#TODO: loop through the inputs array
BRANCH_ENCODED=$(echo $BRANCH | sed -e 's/\//%2F/g')
URL="https://imce-jenkins.jpl.nasa.gov/v1/workflow/europa/node/$BRANCH_ENCODED"
#PREV_BRANCH="$(curl -s $URL | jq -r '. | .Inputs[0].Branch')"
PREV_BRANCH="$1"

echo "# Previous branch $PREV_BRANCH"

PREV_REPO="$(basename $TOP)"
echo "# PREV_REPO: $PREV_REPO"

echo "# Start from the branch: $PREV_BRANCH of the $PREV_REPO repo"

gitCaesarClone $PREV_URL $PREV_BRANCH
PREV_TAG="$(gitTag $PREV_REPO)"
PREV_COMMIT="$(gitCommit $PREV_REPO)"

echo "# Checkout the branch: $BRANCH, creating it if it does not exist or merging it with $PREV_BRANCH otherwise."

gitCreateOrMergeBranch $PREV_REPO $BRANCH

