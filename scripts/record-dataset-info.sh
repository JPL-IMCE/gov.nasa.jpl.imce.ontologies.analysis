#!/bin/sh

## Records the integrated dataset information in query service db table for lookups.
## Input parameters: repository, branch

#FILE="$(basename $0)"
FILE="import"
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
cd $HOME/git

echo "# dataset: $JENA_DATASET"

PREV_REPO=$1
echo "# repo: $PREV_REPO"

PREV_BRANCH=$2
echo "# branch $PREV_BRANCH"

PREV_TAG="$(gitTag "$PREV_REPO")"
echo "# tag: $PREV_TAG"

PREV_COMMIT="$(echo $(cd "$PREV_REPO"; git rev-parse HEAD 2> /dev/null))"
echo "# commit: $PREV_COMMIT"

PREV_COMMENT="$(echo $(cd "$PREV_REPO"; git show -s --format=%s $PREV_COMMIT))"
echo "# comment: $PREV_COMMENT"

mysql -uimuser -p'imcedev' -h imce-infr-dev-01.jpl.nasa.gov queryservice_mgr << EOF
INSERT INTO AnalysisDataset (Version, DatasetName, Repository, Branch, Tag, Comment)
VALUES ('$PREV_COMMIT', '$JENA_DATASET', '$PREV_REPO', '$PREV_BRANCH', '$PREV_TAG', '$PREV_COMMENT');
EOF