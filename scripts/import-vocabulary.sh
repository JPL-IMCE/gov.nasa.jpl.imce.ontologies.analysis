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

PATH="$(pwd)/jq:$PATH"

#PREV_BRANCH="feature/IMCEIS-1715-create-temporary-branch-of-ontologie"
PREV_BRANCH=$2
echo "# Previous branch $PREV_BRANCH"

#PREV_REPO="gov.nasa.jpl.imce.ontologies.public"
PREV_REPO=$1
echo "# PREV_REPO: $PREV_REPO"

echo "# Start from the branch: $PREV_BRANCH of the $PREV_REPO repo"
PREV_URL="https://$GIT_USERNAME:$GIT_PASSWORD@github.com/JPL-IMCE/$PREV_REPO"

gitCaesarClone $PREV_URL $PREV_BRANCH
PREV_TAG="$(gitTag $PREV_REPO)"
PREV_COMMIT="$(gitCommit $PREV_REPO)"

echo "current path: $(pwd)"


